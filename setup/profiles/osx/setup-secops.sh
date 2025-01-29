#!/bin/bash

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'


install_lite_setup() {
  # Install homebrew cli packages
  printf "\n\n${red}[secops] =>${no_color} Install homebrew packages (cli)\n\n"
  brew update && brew install --formula \
    cosign \
    trivy
}

install_additional_setup() {
  # Install homebrew cli packages
  printf "\n\n${red}[secops] =>${no_color} Install homebrew packages (cli)\n\n"
  brew update && brew install --formula \
    age \
    dive \
    kubescape \
    kyverno \
    sops \
    vault
}


# Install lite setup
install_lite_setup

# Install full setup
if [ "$FULL_MODE_SETUP" = "true" ]; then
  install_additional_setup
fi
