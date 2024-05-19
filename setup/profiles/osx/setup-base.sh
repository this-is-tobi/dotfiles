#!/bin/bash

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'


# Updating homebrew cache
printf "\n\n${red}[base] =>${no_color} Update homebrew\n\n"
brew update


# Install homebrew cli packages
printf "\n\n${red}[base] =>${no_color} Install homebrew packages (cli)\n\n"
brew install --formula \
  age \
  bat \
  bat-extras \
  chafa \
  cheat \
  coreutils \
  eza \
  exiftool \
  fd \
  ffmpeg \
  fzf \
  gh \
  glab \
  gnupg \
  gsed \
  jq \
  lazydocker \
  lazygit \
  nmap \
  nvim \
  proto \
  ripgrep \
  rsync \
  isacikgoz/taps/tldr \
  sshs \
  tree \
  ttyd \
  vhs \
  vim \
  wget \
  yq


# Install homebrew graphic app packages
printf "\n\n${red}[base] =>${no_color} Install homebrew packages (graphic)\n\n"
brew install --cask \
  brave-browser \
  docker \
  firefox \
  insomnia \
  mattermost \
  openvpn-connect \
  visual-studio-code


# Install neovim fonts
printf "\n\n${red}[base] =>${no_color} Install neovim fonts\n\n"
mkdir ~/.fonts
wget -O /tmp/Ubuntu.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Ubuntu.zip && unzip /tmp/Ubuntu.zip -d ~/.fonts 
wget -O /tmp/NerdFontsSymbolsOnly.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.zip && unzip /tmp/NerdFontsSymbolsOnly.zip -d ~/.fonts
cp ~/.fonts/*.ttf ~/Library/Fonts/
fc-cache -fv
