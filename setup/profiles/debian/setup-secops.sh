#!/bin/bash

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'


install_lite_setup() {
  # Install apt packages
  printf "\n\n${red}[secops] =>${no_color} Install apt packages\n\n"
  sudo apt update && sudo apt install -y \
    cosign \
    trivy
}

install_additional_setup() {
  # Install apt packages
  printf "\n\n${red}[secops] =>${no_color} Install apt packages\n\n"
  sudo apt update && sudo apt install -y \
    age \
    dive \
    sops \
    vault


  # Install krew plugins
  printf "\n\n${red}[secops] =>${no_color} Install krew plugins\n\n"
  krew install \
    kubescape
}


# Add wakemeops debian repo
if [ -z "$(find /etc/apt/ -name *.list | xargs cat | grep  ^[[:space:]]*deb) | grep wakemeops" ]; then
  printf "\n\n${red}[secops] =>${no_color} Add wakemeops apt repository\n\n"
  curl -fsSL https://raw.githubusercontent.com/upciti/wakemeops/main/assets/install_repository | sudo bash
fi

# Install lite setup
install_lite_setup

# Install full setup
if [ "$FULL_MODE_SETUP" = "true" ]; then
  install_additional_setup
fi
