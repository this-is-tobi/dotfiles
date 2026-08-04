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
  #
  # npm is not installed as a separate tool: it ships inside the node release.
  # Pinning a standalone npm on top would shadow the bundled one.
  printf "\n\n${red}[js] =>${no_color} Install mise packages\n\n"
  mise_use \
    node@latest
}

install_additional_setup() {
  # Install mise packages
  printf "\n\n${red}[js] =>${no_color} Install mise packages\n\n"
  mise_use \
    bun@latest \
    pnpm@latest \
    yarn@latest

  # Install npm packages
  # Globals land in the active node install's bin directory; `mise reshim`
  # publishes them as shims so `ni` resolves on PATH.
  printf "\n\n${red}[js] =>${no_color} Install npm packages\n\n"
  npm install --global \
    @antfu/ni
  mise reshim
}


# Install mise
ensure_mise

# Install lite setup
install_lite_setup

# Install full setup
if [ "$FULL_MODE_SETUP" = "true" ]; then
  install_additional_setup
fi
