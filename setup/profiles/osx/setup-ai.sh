#!/bin/bash
set -euo pipefail

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'


install_lite_setup() {
  # Install homebrew cli packages
  printf "\n\n${red}[ai] =>${no_color} Install homebrew packages (cli)\n\n"
  brew install --formula \
    direnv
}

install_additional_setup() {
  # Install homebrew cli packages
  printf "\n\n${red}[ai] =>${no_color} Install homebrew packages (cli)\n\n"
  brew install --formula \
    rtk-ai/tap/rtk

  # Install homebrew cask packages
  # claude-code and copilot-cli are CLIs, but Homebrew only ships them as casks
  printf "\n\n${red}[ai] =>${no_color} Install homebrew packages (cask)\n\n"
  brew install --cask \
    claude-code \
    copilot-cli \
    ollama
}


# Install lite setup
install_lite_setup

# Install full setup
if [ "$FULL_MODE_SETUP" = "true" ]; then
  install_additional_setup
fi
