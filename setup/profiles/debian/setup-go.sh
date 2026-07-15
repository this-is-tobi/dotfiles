#!/bin/bash
set -euo pipefail

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'

# WakeMeOps' mirror occasionally 404s on a package version that's listed in
# the Packages index but not yet synced to the CDN edge node serving the
# request; retrying (which re-fetches the index and may hit a different
# edge) typically clears it within a few tries.
apt_install() {
  local attempt
  for attempt in 1 2 3 4 5; do
    if sudo apt update && sudo apt install -y "$@"; then
      return 0
    fi
    printf "\n${red}[go] =>${no_color} apt install failed (attempt %s/5), retrying in 10s...\n\n" "$attempt"
    sleep 10
  done
  return 1
}


export PROTO_AUTO_INSTALL=true
export PROTO_AUTO_CLEAN=true

install_lite_setup() {
  # Install proto packages
  printf "\n\n${red}[go] =>${no_color} Install proto packages\n\n"
  PACKAGES=(
    go
  )
  for pkg in ${PACKAGES[*]}; do
    proto install $pkg --pin global
  done
}

install_additional_setup() {
  # Install apt packages
  printf "\n\n${red}[go] =>${no_color} Install apt packages\n\n"
  apt_install \
    kubebuilder \
    kustomize \
    operator-sdk


  # Install go packages
  printf "\n\n${red}[go] =>${no_color} Install go packages\n\n"
  go install \
    github.com/spf13/cobra-cli@latest
}


# Add wakemeops debian repo
if [ -z "$(find /etc/apt/ -name '*.list' | xargs cat | grep '^[[:space:]]*deb' | grep 'wakemeops')" ]; then
  printf "\n\n${red}[go] =>${no_color} Add wakemeops apt repository\n\n"
  curl -fsSL https://raw.githubusercontent.com/upciti/wakemeops/main/assets/install_repository | sudo bash
fi

# Install lite setup
install_lite_setup

# Install full setup
if [ "$FULL_MODE_SETUP" = "true" ]; then
  install_additional_setup
fi
