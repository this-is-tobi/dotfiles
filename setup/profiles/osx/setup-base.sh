#!/bin/bash

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'


# Updating homebrew cache
printf "\n\n${red}[base] =>${no_color} Update homebrew\n\n"
brew update


# Install homebrew cli packages
printf "\n\n${red}[base] =>${no_color} Install homebrew packages (cli)\n\n"
FORMULAE=(
  bat
  bat-extras
  exa
  ffmpeg
  gh
  glab
  go
  gnupg
  jq
  nmap
  ripgrep
  rsync
  isacikgoz/taps/tldr
  tree
  vim
  wget
  yq
)
for package in ${FORMULAE[@]}; do
  brew install --formulae $package
done


# Install homebrew graphic app packages
printf "\n\n${red}[base] =>${no_color} Install homebrew packages (graphic)\n\n"
CASK=(
  brave-browser
  docker
  mattermost
  openvpn-connect
  visual-studio-code
)
for package in ${CASK[@]}; do
  brew install --cask $package
done
