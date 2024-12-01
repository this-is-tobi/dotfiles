#!/bin/bash

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'


# Updating homebrew cache
printf "\n\n${red}[extras] =>${no_color} Update homebrew\n\n"
brew update


# Install homebrew graphic app packages
printf "\n\n${red}[extras] =>${no_color} Install homebrew packages (graphic)\n\n"
brew install --cask \
  audacity \
  discord \
  raspberry-pi-imager \
  soulseek \
  transmission \
  vlc
