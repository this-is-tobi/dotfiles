#!/bin/bash
# Profile: Extra personal applications: media, chat, downloads (macOS only)
# Order: 20
set -euo pipefail

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'

# Get current script path (this file lives in setup/profiles/osx/)
SCRIPT_PATH="$( cd -- "$(dirname "$0")/../.." >/dev/null 2>&1 && pwd -P )"

# shellcheck source=../../helpers/brew.sh
. "$SCRIPT_PATH/helpers/brew.sh"


# Install homebrew packages (extras.Brewfile, lite and full mode)
printf "\n\n${red}[extras] =>${no_color} Install homebrew packages\n\n"
brew_bundle "$SCRIPT_PATH/profiles/osx/extras.Brewfile"
