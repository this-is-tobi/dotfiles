#!/bin/bash

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'


install_additional_setup() {
  # Install homebrew graphic app packages
  printf "\n\n${red}[ai] =>${no_color} Install homebrew packages (graphic)\n\n"
  brew update && brew install --cask \
    ollama
}


# Install full setup
if [ "$FULL_MODE_SETUP" = "true" ]; then
  install_additional_setup
fi
