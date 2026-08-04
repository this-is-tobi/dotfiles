#!/bin/bash
set -euo pipefail

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'


# Get current script path (this file lives in setup/profiles/osx/)
SCRIPT_PATH="$( cd -- "$(dirname "$0")/../.." >/dev/null 2>&1 ; pwd -P )"

# shellcheck source=../../helpers/mise.sh
. "$SCRIPT_PATH/helpers/mise.sh"

install_lite_setup() {
  # Install mise packages
  # On macOS mise covers language runtimes only; Homebrew is the package
  # manager for everything else.
  printf "\n\n${red}[go] =>${no_color} Install mise packages\n\n"
  mise_use \
    go@latest
}

install_additional_setup() {
  # Install homebrew cli packages
  printf "\n\n${red}[go] =>${no_color} Install go\n\n"
  brew update && brew install --formula \
    kubebuilder \
    kustomize \
    operator-sdk


  # Install go packages
  printf "\n\n${red}[go] =>${no_color} Install go packages\n\n"
  go install \
    github.com/spf13/cobra-cli@latest
}


# Install mise
ensure_mise

# Install lite setup
install_lite_setup

# Install full setup
if [ "$FULL_MODE_SETUP" = "true" ]; then
  install_additional_setup
fi
