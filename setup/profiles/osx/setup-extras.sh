#!/bin/bash

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'


install_lite_setup() {
  # Install homebrew graphic app packages
  printf "\n\n${red}[extras] =>${no_color} Install homebrew packages (graphic)\n\n"
  brew update && brew install --cask \
    vlc
}

install_additional_setup() {
  # Install homebrew graphic app packages
  printf "\n\n${red}[extras] =>${no_color} Install homebrew packages (graphic)\n\n"
  brew update && brew install --cask \
    audacity \
    discord \
    raspberry-pi-imager \
    soulseek \
    transmission \
    vlc
}


# Install lite setup
install_lite_setup

# Install full setup
if [ "$FULL_MODE_SETUP" = "true" ]; then
  install_additional_setup
fi
