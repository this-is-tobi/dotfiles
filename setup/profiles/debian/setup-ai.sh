#!/bin/bash

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'


install_additional_setup() {
  # Install copilot cli
  if [ ! -x "$(command -v copilot)" ]; then
    printf "\n\n${red}[ai] =>${no_color} Install copilot CLI\n\n"
    curl -fsSL https://gh.io/copilot-install | bash
  fi

  # Install ollama
  if [ ! -x "$(command -v ollama)" ]; then
    printf "\n\n${red}[ai] =>${no_color} Install ollama\n\n"
    curl -fsSL https://ollama.com/install.sh | sh
  fi
}


# Install full setup
if [ "$FULL_MODE_SETUP" = "true" ]; then
  install_additional_setup
fi
