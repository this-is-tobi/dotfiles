#!/bin/bash
# Shared apt helpers - sourced (not executed) by the Debian setup scripts.
#
# They call apt-get, whose interface is meant for scripts (apt's is not), with
# DEBIAN_FRONTEND=noninteractive: a package asking a debconf question takes the
# default answer instead of stopping an unattended run.

# shellcheck source=run.sh
. "$(dirname "${BASH_SOURCE[0]}")/run.sh"

# Fallbacks so this file is safe to source under `set -u` before the caller has
# defined its own palette.
red="${red:-\e[0;31m}"
no_color="${no_color:-\033[0m}"

# The package lists are refreshed once per run. The flag is exported, so the
# profiles (child processes of the setup script) know it was done already.
export DOTFILES_APT_UPDATED="${DOTFILES_APT_UPDATED:-}"

# apt_update: refresh the package lists, unless this run already did.
apt_update() {
  [ "$DOTFILES_APT_UPDATED" = "1" ] && return 0
  run sudo apt-get update || return 1
  DOTFILES_APT_UPDATED=1
}

# apt_sources_changed: call it after adding an apt repository, whose packages
# are only known after the next refresh.
apt_sources_changed() {
  DOTFILES_APT_UPDATED=""
}

# apt_install <package...>: install packages, retrying a few times.
#
# Debian mirrors occasionally fail a fetch mid-run (transient DNS, a mirror
# rotating out behind a round-robin, or a proxy hiccup in CI). A retry picks a
# fresh connection, and refreshes the lists in case they were the problem.
apt_install() {
  local attempt
  for attempt in 1 2 3 4 5; do
    if apt_update && run sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "$@"; then
      return 0
    fi
    apt_sources_changed
    printf "\n${red}[apt] =>${no_color} apt-get install failed (attempt %s/5), retrying in 10s...\n\n" "$attempt"
    sleep 10
  done
  return 1
}
