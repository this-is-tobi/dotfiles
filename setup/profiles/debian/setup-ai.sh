#!/bin/bash
set -euo pipefail

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'

# Get current script path (this file lives in setup/profiles/debian/)
SCRIPT_PATH="$( cd -- "$(dirname "$0")/../.." >/dev/null 2>&1 ; pwd -P )"

# shellcheck source=../../helpers/mise.sh
. "$SCRIPT_PATH/helpers/mise.sh"


install_lite_setup() {
  printf "\n\n${red}[ai] =>${no_color} Install mise packages\n\n"
  mise_use \
    direnv@latest
}

install_additional_setup() {
  # These four ship their own installers that also handle updates and, for
  # ollama, a systemd unit - they stay outside mise.

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


# Install mise
ensure_mise

# Install lite setup
install_lite_setup

# Install full setup
if [ "$FULL_MODE_SETUP" = "true" ]; then
  install_additional_setup
fi
