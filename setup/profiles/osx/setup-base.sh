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
  chafa
  exa
  exiftool
  ffmpeg
  fzf
  gh
  glab
  gnupg
  jq
  lazydocker
  lazygit
  nmap
  nvim
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


# Install neovim fonts
printf "\n\n${red}[base] =>${no_color} Install neovim fonts\n\n"
wget -o /tmp/Ubuntu.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Ubuntu.zip && unzip /tmp/Ubuntu.zip -d ~/.fonts 
wget -o /tmp/NerdFontsSymbolsOnly.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/NerdFontsSymbolsOnly.zip && unzip /tmp/NerdFontsSymbolsOnly.zip -d ~/.fonts 
fc-cache -fv
