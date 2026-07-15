#!/bin/bash
set -euo pipefail

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'

# WakeMeOps' mirror occasionally 404s on a package version that's listed in
# the Packages index but not yet synced to the CDN edge node serving the
# request; retrying (which re-fetches the index and may hit a different
# edge) typically clears it within a few tries.
apt_install() {
  local attempt
  for attempt in 1 2 3 4 5; do
    if sudo apt update && sudo apt install -y "$@"; then
      return 0
    fi
    printf "\n${red}[ai] =>${no_color} apt install failed (attempt %s/5), retrying in 10s...\n\n" "$attempt"
    sleep 10
  done
  return 1
}


install_lite_setup() {
  # Install direnv
  if [ ! -x "$(command -v direnv)" ]; then
    printf "\n\n${red}[ai] =>${no_color} Install direnv\n\n"
    apt_install direnv
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
