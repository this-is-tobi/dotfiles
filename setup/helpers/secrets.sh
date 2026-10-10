#!/bin/bash

# Create ~/.config/dotfiles/secrets.env from its template if it does not exist.
# An existing file is never overwritten, it only gets its permissions tightened.
# Run it before the dotfiles are copied: a legacy env.sh that held secrets is
# moved into secrets.env here, before the copy replaces it.

set -eo pipefail

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'

HELPER_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
TEMPLATE="$HELPER_PATH/../../dotfiles/.config/dotfiles/secrets.env.example"
CONFIG_DIR="$HOME/.config/dotfiles"
SECRETS_FILE="$CONFIG_DIR/secrets.env"
LEGACY_ENV_FILE="$CONFIG_DIR/env.sh"

mkdir -p "$CONFIG_DIR"

if [ -e "$SECRETS_FILE" ]; then
  chmod 600 "$SECRETS_FILE"
  exit 0
fi

# Anything besides comments and the old empty template line means the user put values in env.sh
if [ -f "$LEGACY_ENV_FILE" ] \
  && ! grep -q "secrets.env" "$LEGACY_ENV_FILE" \
  && grep -Ev '^[[:space:]]*(#|$)|^export CONTEXT7_API_KEY=""$' "$LEGACY_ENV_FILE" | grep -q .; then
  (umask 077 && cp "$LEGACY_ENV_FILE" "$SECRETS_FILE")
  printf "\n${red}[secrets] =>${no_color} Moved your values from env.sh to %s\n" "$SECRETS_FILE"
  exit 0
fi

(umask 077 && cp "$TEMPLATE" "$SECRETS_FILE")
printf "\n${red}[secrets] =>${no_color} Created %s, uncomment and fill in the keys you use\n" "$SECRETS_FILE"
