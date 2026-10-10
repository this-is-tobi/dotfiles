#!/bin/bash
# Shared font helper - sourced (not executed) by the base profiles.

# Install the nerd fonts neovim needs into ~/.fonts, downloading through a
# private temporary directory that is always removed afterwards.
install_nerd_fonts() (
  local tmp font
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  mkdir -p "$HOME/.fonts"
  for font in Hack NerdFontsSymbolsOnly; do
    curl -fsSL -o "$tmp/$font.zip" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$font.zip"
    # -o: force overwrite. Both zips ship a README.md/LICENSE, so the second
    # unzip always hits an overwrite prompt; on non-interactive stdin that
    # prompt reads EOF and unzip exits 1 (a "warning" exit code) even though
    # it correctly skips the file and continues - which set -e still aborts on.
    unzip -o "$tmp/$font.zip" -d "$HOME/.fonts"
  done
)
