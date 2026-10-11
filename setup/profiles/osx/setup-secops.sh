#!/bin/bash
set -euo pipefail

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'

# Get current script path (this file lives in setup/profiles/osx/)
SCRIPT_PATH="$( cd -- "$(dirname "$0")/../.." >/dev/null 2>&1 && pwd -P )"

# shellcheck source=../../helpers/brew.sh
. "$SCRIPT_PATH/helpers/brew.sh"


install_lite_setup() {
  # Install homebrew cli packages
  printf "\n\n${red}[secops] =>${no_color} Install homebrew packages (cli)\n\n"
  brew install --formula \
    cosign \
    gitleaks \
    trivy
}

install_additional_setup() {
  # Install homebrew cli packages
  # homebrew/core stopped at vault 1.14.4, the last release before the license
  # change: HashiCorp's tap has the current ones (see terraform in devops).
  printf "\n\n${red}[secops] =>${no_color} Install homebrew packages (cli)\n\n"
  brew_leave_core vault
  brew install --formula \
    age \
    dive \
    kubescape \
    kyverno \
    sops \
    hashicorp/tap/vault
}


# Install lite setup
install_lite_setup

# Install full setup
if [ "$FULL_MODE_SETUP" = "true" ]; then
  install_additional_setup
fi
