#!/bin/bash
# Profile: Base packages and utilities (including Docker)
# Order: 10
set -euo pipefail

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'

# Get current script path (this file lives in setup/profiles/osx/)
SCRIPT_PATH="$( cd -- "$(dirname "$0")/../.." >/dev/null 2>&1 && pwd -P )"

# shellcheck source=../../helpers/remote.sh
. "$SCRIPT_PATH/helpers/remote.sh"
# shellcheck source=../../helpers/fonts.sh
. "$SCRIPT_PATH/helpers/fonts.sh"
# shellcheck source=../../helpers/brew.sh
. "$SCRIPT_PATH/helpers/brew.sh"

# The nerd fonts go to ~/.fonts like on Debian, and to ~/Library/Fonts for macOS
install_fonts() {
  install_nerd_fonts
  mkdir -p ~/Library/Fonts
  cp ~/.fonts/*.ttf ~/Library/Fonts/
  fc-cache -fv
}

install_lite_setup() {
  # Install addition cheatsheets
  run_remote bash "$TOOLS_RAW_BASE/shell/clone-subdir.sh" \
    -u "https://github.com/this-is-tobi/cheatsheets" -s "sheets" -o "$HOME/.config/cheat/cheatsheets/personal" -d
}

install_additional_setup() {
  # Install gh extensions
  printf "\n\n${red}[base] =>${no_color} Install gh extensions\n\n"
  for extension in dlvhdr/gh-dash meiji163/gh-notify; do
    gh extension list 2>/dev/null | grep -q "$extension" || run gh extension install "$extension"
  done


  # Install neovim fonts
  printf "\n\n${red}[base] =>${no_color} Install neovim fonts\n\n"
  run install_fonts
}


# Install homebrew packages (base.Brewfile, lite and full mode)
printf "\n\n${red}[base] =>${no_color} Install homebrew packages\n\n"
brew_bundle "$SCRIPT_PATH/profiles/osx/base.Brewfile"

# Install lite setup
install_lite_setup

# Install full setup (the default, -l of the setup script turns it off)
if [ "${FULL_MODE_SETUP:-true}" = "true" ]; then
  install_additional_setup
fi
