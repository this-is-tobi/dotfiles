#!/bin/bash

# Create ~/.gitconfig.local, the per-machine part of the git configuration
# (identity and commit signing), if it does not exist. An existing file is never
# touched. Run it before ~/.gitconfig is replaced: values the old file holds are
# carried over, otherwise the identity is asked for (or left as a template when
# there is no terminal).

set -eo pipefail

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'

LOCAL_FILE="$HOME/.gitconfig.local"
CURRENT_FILE="$HOME/.gitconfig"

if [ -e "$LOCAL_FILE" ]; then
  exit 0
fi

# Settings that belong to one machine, carried over from the current ~/.gitconfig
KEYS=(
  user.name
  user.email
  user.signingkey
  commit.gpgsign
  gpg.format
  gpg.ssh.allowedSignersFile
)

migrated=0
if [ -f "$CURRENT_FILE" ] && ! git config --file "$CURRENT_FILE" --get-all include.path 2>/dev/null | grep -q "gitconfig.local"; then
  for key in "${KEYS[@]}"; do
    if value="$(git config --file "$CURRENT_FILE" --get "$key" 2>/dev/null)"; then
      git config --file "$LOCAL_FILE" "$key" "$value"
      migrated=1
    fi
  done
fi

if [ "$migrated" -eq 1 ]; then
  printf "\n${red}[gitconfig] =>${no_color} Moved your identity and signing settings to %s\n" "$LOCAL_FILE"
  exit 0
fi

if [ -t 0 ]; then
  read -r -p "Git user name: " name
  read -r -p "Git user email: " email
  [ -n "$name" ] && git config --file "$LOCAL_FILE" user.name "$name"
  [ -n "$email" ] && git config --file "$LOCAL_FILE" user.email "$email"
fi

if [ ! -e "$LOCAL_FILE" ]; then
  printf "\n${red}[gitconfig] =>${no_color} No terminal to ask for your identity, set it with:\n  git config --file %s user.name \"Your Name\"\n  git config --file %s user.email you@example.com\n" "$LOCAL_FILE" "$LOCAL_FILE"
fi
