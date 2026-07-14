#!/bin/bash

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'


install_lite_setup() {
  # Install direnv
  if [ ! -x "$(command -v direnv)" ]; then
    printf "\n\n${red}[ai] =>${no_color} Install direnv\n\n"
    sudo apt update && sudo apt install -y direnv
  fi
}

install_additional_setup() {
  # Install claude-code cli
  if [ ! -x "$(command -v claude-code)" ]; then
    printf "\n\n${red}[ai] =>${no_color} Install claude-code CLI\n\n"
    curl -fsSL https://claude.ai/install.sh | bash
  fi

  # Install copilot cli
  if [ ! -x "$(command -v copilot)" ]; then
    printf "\n\n${red}[ai] =>${no_color} Install copilot CLI\n\n"
    curl -fsSL https://gh.io/copilot-install | bash
  fi

  # Install rtk cli
  if [ ! -x "$(command -v rtk)" ]; then
    printf "\n\n${red}[ai] =>${no_color} Install rtk CLI\n\n"
    curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/master/install.sh | sh
  fi

  # Install ollama
  if [ ! -x "$(command -v ollama)" ]; then
    printf "\n\n${red}[ai] =>${no_color} Install ollama\n\n"
    curl -fsSL https://ollama.com/install.sh | sh
  fi
}


# Install lite setup
install_lite_setup

# Install full setup
if [ "$FULL_MODE_SETUP" = "true" ]; then
  install_additional_setup
fi
