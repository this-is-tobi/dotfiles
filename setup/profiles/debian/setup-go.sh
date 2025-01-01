#!/bin/bash

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'


export PROTO_AUTO_INSTALL=true
export PROTO_AUTO_CLEAN=true

install_lite_setup() {
  # Install proto packages
  printf "\n\n${red}[js] =>${no_color} Install proto packages\n\n"
  PACKAGES=(
    go
  )
  for pkg in ${PACKAGES[*]}; do
    proto install $pkg
  done
}

install_additional_setup() {
  # Install apt packages
  printf "\n\n${red}[go] =>${no_color} Install apt packages\n\n"
  sudo apt update && sudo apt install -y \
    kubebuilder \
    kustomize \
    operator-sdk


  # Install go packages
  printf "\n\n${red}[go] =>${no_color} Install go packages\n\n"
  go install \
    github.com/spf13/cobra-cli@latest
}


# Add wakemeops debian repo
if [ -z "$(find /etc/apt/ -name *.list | xargs cat | grep  ^[[:space:]]*deb) | grep wakemeops" ]; then
  printf "\n\n${red}[devops] =>${no_color} Add wakemeops apt repository\n\n"
  curl -fsSL https://raw.githubusercontent.com/upciti/wakemeops/main/assets/install_repository | sudo bash
fi

# Install lite setup
install_lite_setup

# Install full setup
if [ "$FULL_MODE_SETUP" = "true" ]; then
  install_additional_setup
fi
