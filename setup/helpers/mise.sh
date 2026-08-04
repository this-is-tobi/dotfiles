#!/bin/bash
# Shared mise helpers - sourced (not executed) by the profile scripts.
#
# mise manages language runtimes on both platforms, and portable CLI binaries
# on Debian. Proxies need no configuration here: mise reads HTTP_PROXY,
# HTTPS_PROXY and ALL_PROXY straight from the environment.

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
# https://mise.run drops the mise binary itself.
export MISE_DATA_DIR="${MISE_DATA_DIR:-$HOME/.local/share/mise}"
case ":$PATH:" in
  *":$MISE_DATA_DIR/shims:"*) ;;
  *) export PATH="$MISE_DATA_DIR/shims:$HOME/.local/bin:$PATH" ;;
esac

# Install mise itself if it isn't on PATH yet. Every profile calls this so that
# a profile can be run standalone, without the base profile.
#
# Prefers Homebrew where it exists: on macOS brew is the package manager, and
# installing mise through it keeps upgrades inside `brew upgrade` rather than
# splitting them across two update paths.
ensure_mise() {
  if [ ! -x "$(command -v mise)" ]; then
    printf "\n\n${red}[mise] =>${no_color} Install mise\n\n"
    if [ -x "$(command -v brew)" ]; then
      brew install mise
    else
      curl -fsSL https://mise.run | sh
    fi
  fi
}

# Install tools globally and pin them in ~/.config/mise/config.toml.
#
# Retried because the aqua and ubi backends resolve versions through the GitHub
# API, which answers HTTP 403 once the unauthenticated hourly limit is hit.
# mise's own http_retries covers 429 and 5xx but treats 403 as permanent, so
# this loop is what rescues a rate-limited run. Export GITHUB_TOKEN to raise
# the limit in CI.
mise_use() {
  local attempt
  for attempt in 1 2 3 4 5; do
    if mise use --global "$@"; then
      # Regenerate shims so binaries added by this call are immediately
      # callable by the rest of the script (krew, go, npm, uv, ...).
      mise reshim
      return 0
    fi
    printf "\n${red}[mise] =>${no_color} mise use failed (attempt %s/5), retrying in 10s...\n\n" "$attempt"
    sleep 10
  done
  return 1
}
