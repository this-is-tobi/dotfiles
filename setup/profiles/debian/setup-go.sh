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
  printf "\n\n${red}[go] =>${no_color} Install mise packages\n\n"
  mise_use \
    go@latest
}

install_additional_setup() {
  printf "\n\n${red}[go] =>${no_color} Install mise packages\n\n"
  mise_use \
    kubebuilder@latest \
    kustomize@latest \
    operator-sdk@latest


  # Install go packages
  # Installs into $GOBIN (~/go/bin), which .zshrc already puts on PATH - go's
  # own package installs stay outside mise.
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
