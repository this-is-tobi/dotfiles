#!/bin/bash
# Profile: Security tools (scanners, secret management, etc.)
# Order: 40
set -euo pipefail

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'

# Get current script path (this file lives in setup/profiles/osx/)
SCRIPT_PATH="$( cd -- "$(dirname "$0")/../.." >/dev/null 2>&1 && pwd -P )"

# shellcheck source=../../helpers/brew.sh
. "$SCRIPT_PATH/helpers/brew.sh"


# Install homebrew packages (secops.Brewfile, lite and full mode). vault comes
# from HashiCorp's tap in full mode, which needs a core vault out of the way.
printf "\n\n${red}[secops] =>${no_color} Install homebrew packages\n\n"
if [ "${FULL_MODE_SETUP:-true}" = "true" ]; then
  brew_leave_core vault
fi
brew_bundle "$SCRIPT_PATH/profiles/osx/secops.Brewfile"
