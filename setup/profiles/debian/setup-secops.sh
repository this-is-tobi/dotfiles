#!/bin/bash
set -euo pipefail

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'

# Get current script path (this file lives in setup/profiles/debian/)
SCRIPT_PATH="$( cd -- "$(dirname "$0")/../.." >/dev/null 2>&1 ; pwd -P )"

# shellcheck source=../../helpers/mise.sh
. "$SCRIPT_PATH/helpers/mise.sh"

# Every tool in this profile is a portable release binary, so this profile
# needs no apt packages.


install_lite_setup() {
  printf "\n\n${red}[secops] =>${no_color} Install mise packages\n\n"
  mise_use \
    cosign@latest \
    gitleaks@latest \
    trivy@latest
}

install_additional_setup() {
  # kubescape has no short name in mise's registry; aqua packages it under the
  # upstream repository name.
  printf "\n\n${red}[secops] =>${no_color} Install mise packages\n\n"
  mise_use \
    age@latest \
    dive@latest \
    kyverno@latest \
    sops@latest \
    vault@latest \
    aqua:kubescape/kubescape@latest
}


# Install mise
ensure_mise

# Install lite setup
install_lite_setup

# Install full setup
if [ "$FULL_MODE_SETUP" = "true" ]; then
  install_additional_setup
fi
