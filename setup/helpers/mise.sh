#!/bin/bash
# Shared mise helpers - sourced (not executed) by the profile scripts.
#
# mise manages language runtimes on both platforms, and portable CLI binaries
# on Debian. Proxies need no configuration here: mise reads HTTP_PROXY,
# HTTPS_PROXY and ALL_PROXY straight from the environment.

# shellcheck source=remote.sh
. "$(dirname "${BASH_SOURCE[0]}")/remote.sh"
# shellcheck source=apt.sh
. "$(dirname "${BASH_SOURCE[0]}")/apt.sh"

# Fallbacks so this file is safe to source under `set -u` before the caller has
# defined its own palette.
red="${red:-\e[0;31m}"
no_color="${no_color:-\033[0m}"

# Never prompt: these scripts run unattended (CI, container builds, first boot).
export MISE_YES=1

# These mirror dotfiles/.config/mise/conf.d/00-settings.toml, and are exported
# rather than relied upon because the profiles run BEFORE the dotfiles copy
# step: on a first-ever run the conf.d file does not exist yet, so without them
# the initial install would use different settings from every later one. Keep
# the two in sync.
#
# asdf plugins are arbitrary shell scripts fetched from third-party repos; aqua
# and ubi resolve release assets with checksum verification instead.
export MISE_DISABLE_BACKENDS=asdf
# Record the exact resolved version rather than a fuzzy range.
export MISE_PIN=1

# Tools install into $MISE_DATA_DIR/installs and are exposed through shims.
# `mise activate` hooks an interactive shell prompt and is therefore unavailable
# here, so the shims directory goes on PATH explicitly. ~/.local/bin is where
# the https://mise.run installer put the mise binary on machines set up before
# the apt repository was used.
export MISE_DATA_DIR="${MISE_DATA_DIR:-$HOME/.local/share/mise}"
case ":$PATH:" in
  *":$MISE_DATA_DIR/shims:"*) ;;
  *) export PATH="$MISE_DATA_DIR/shims:$HOME/.local/bin:$PATH" ;;
esac

# mise's apt repository, and the fingerprint of the key that signs it as
# published in https://mise.jdx.dev/installing-mise.html
MISE_APT_KEY_URL="https://mise.jdx.dev/gpg-key.pub"
MISE_SIGNER_FINGERPRINT="24853EC9F655CE80B48E6C3A8B81C9D17413A06D"
MISE_APT_REPO="https://mise.jdx.dev/deb"

# Exit status of install_mise_apt when mise.jdx.dev cannot be used (blocked by
# a proxy, down, or answering with something that is not mise's key) as opposed
# to a failure that must stop the run. ensure_mise falls back to GitHub on it.
MISE_APT_UNAVAILABLE=3

# Install mise itself if it isn't on PATH yet. Every profile calls this so that
# a profile can be run standalone, without the base profile.
#
# Prefers Homebrew where it exists: on macOS brew is the package manager, and
# installing mise through it keeps upgrades inside `brew upgrade` rather than
# splitting them across two update paths. On Debian mise comes from its own apt
# repository for the same reason, `apt upgrade`, and because apt checks every
# package against the repository's signing key (an install script is not signed).
# Only when that repository cannot be reached, install_mise_github takes over.
ensure_mise() {
  local status=0
  if [ -x "$(command -v mise)" ]; then
    return 0
  fi
  printf "\n\n${red}[mise] =>${no_color} Install mise\n\n"
  if [ -x "$(command -v brew)" ]; then
    run brew install mise
  elif [ -x "$(command -v apt-get)" ]; then
    run install_mise_apt || status=$?
    if [ "$status" -eq "$MISE_APT_UNAVAILABLE" ]; then
      install_mise_github
    else
      return "$status"
    fi
  else
    printf "Error: mise is not installed and there is neither Homebrew nor apt-get to install it, see https://mise.jdx.dev/installing-mise.html\n" >&2
    return 1
  fi
}

# Add mise's apt repository, signed-by its key, then install mise from it. The
# key is only trusted when it is the one key with the published fingerprint.
#
# Exits MISE_APT_UNAVAILABLE when mise.jdx.dev cannot be used, and 1 when it
# answers with a key that is not the published one, which is never worked around.
install_mise_apt() (
  local fingerprints keyring=/etc/apt/keyrings/mise-archive-keyring.asc
  # Not local: bash 3.2 drops a function's locals before the EXIT trap of its
  # subshell runs, and the subshell keeps these variables to itself anyway.
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  # gpg is one of the commons, but a profile can run on its own
  command -v gpg >/dev/null 2>&1 || apt_install gnupg
  if ! curl -fsSL --connect-timeout 15 "$MISE_APT_KEY_URL" -o "$tmp/mise.asc"; then
    printf "Warning: could not download %s\n" "$MISE_APT_KEY_URL" >&2
    exit "$MISE_APT_UNAVAILABLE"
  fi
  # A throwaway GNUPGHOME: reading the key must not create or touch ~/.gnupg
  fingerprints="$(GNUPGHOME="$tmp" gpg --batch --show-keys --with-colons "$tmp/mise.asc" \
    | awk -F: '$1 == "pub" { primary = 1; next } $1 == "fpr" && primary { print $10; primary = 0 }')" || true
  if [ -z "$fingerprints" ]; then
    # Typically the block page of a proxy, served with a 200
    printf "Warning: %s does not serve a GPG key\n" "$MISE_APT_KEY_URL" >&2
    exit "$MISE_APT_UNAVAILABLE"
  fi
  if [ "$fingerprints" != "$MISE_SIGNER_FINGERPRINT" ]; then
    printf "Error: %s is not mise's signing key (expected the fingerprint %s, got: %s)\n" \
      "$MISE_APT_KEY_URL" "$MISE_SIGNER_FINGERPRINT" "$fingerprints" >&2
    exit 1
  fi
  sudo install -d -m 755 /etc/apt/keyrings
  sudo install -m 644 "$tmp/mise.asc" "$keyring"
  echo "deb [arch=$(dpkg --print-architecture) signed-by=$keyring] $MISE_APT_REPO stable main" \
    | sudo tee /etc/apt/sources.list.d/mise.list > /dev/null
  apt_sources_changed
  if ! apt_install mise; then
    # An unreachable repository would also make every later `apt-get update` fail
    sudo rm -f /etc/apt/sources.list.d/mise.list "$keyring"
    printf "Warning: could not install mise from %s\n" "$MISE_APT_REPO" >&2
    exit "$MISE_APT_UNAVAILABLE"
  fi
)

# Install mise from GitHub Releases, for when mise.jdx.dev cannot be reached.
#
# MISE_INSTALL_FROM_GITHUB makes the install script download the release archive
# from GitHub only, and verify it against the release checksums. It lands in
# ~/.local/bin, which is on PATH. mise-versions.jdx.dev sits behind the same
# domain, so mise is told not to ask it either: it lists versions from GitHub.
install_mise_github() {
  printf "\n${red}[mise] =>${no_color} mise.jdx.dev is not usable (blocked by a proxy or down), installing mise from GitHub Releases instead\n\n" >&2
  if ! MISE_INSTALL_FROM_GITHUB=1 run_remote bash https://mise.run; then
    printf "Error: mise could not be installed either from GitHub. Download the archive for this machine and its SHASUMS256.txt from https://github.com/jdx/mise/releases, check the checksum, and put the mise binary in ~/.local/bin.\n" >&2
    return 1
  fi
  export MISE_USE_VERSIONS_HOST=0 MISE_USE_VERSIONS_HOST_TRACK=0
  printf "\nmise now lists versions from GitHub rather than from mise-versions.jdx.dev for this run. To keep it that way, add MISE_USE_VERSIONS_HOST=0 and MISE_USE_VERSIONS_HOST_TRACK=0 to ~/.config/dotfiles/secrets.env.\n" >&2
  mise_rate_limit_hint
}

# mise_rate_limit_hint: say what to do about the GitHub API rate limit, unless a
# token is exported already. Called where mise now depends on the GitHub API.
mise_rate_limit_hint() {
  if [ -n "${MISE_GITHUB_TOKEN:-}${GITHUB_API_TOKEN:-}${GITHUB_TOKEN:-}" ]; then
    return 0
  fi
  printf "\n${red}[mise] =>${no_color} No GitHub token is set: unauthenticated GitHub API requests are limited to 60 an hour per IP address (shared by everyone behind the same proxy or NAT), and a tool install that hits the limit fails with HTTP 403.\n" >&2
  printf "Export MISE_GITHUB_TOKEN (or GITHUB_TOKEN) before running the setup again, or keep it in ~/.config/dotfiles/secrets.env. A token without any scope is enough. mise does not read GH_TOKEN.\n\n" >&2
}

# Install tools globally and pin them in ~/.config/mise/config.toml.
#
# Retried because the aqua and ubi backends resolve versions through the GitHub
# API, which answers HTTP 403 once the unauthenticated hourly limit is hit.
# mise's own http_retries covers 429 and 5xx but treats 403 as permanent, so
# this loop is what rescues a rate-limited run. Export MISE_GITHUB_TOKEN (or
# GITHUB_TOKEN) to raise the limit, mise_rate_limit_hint says so when it ran out.
mise_use() {
  local attempt
  for attempt in 1 2 3 4 5; do
    if run mise use --global "$@"; then
      # Regenerate shims so binaries added by this call are immediately
      # callable by the rest of the script (krew, go, npm, uv, ...).
      run mise reshim
      return 0
    fi
    printf "\n${red}[mise] =>${no_color} mise use failed (attempt %s/5), retrying in 10s...\n\n" "$attempt"
    sleep 10
  done
  mise_rate_limit_hint
  return 1
}
