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
  gsed \
  glow \
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
  watch \
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


# Install addition cheatsheets
curl -fsSL https://raw.githubusercontent.com/this-is-tobi/tools/main/shell/clone-subdir.sh | bash -s -- \
  -u "https://github.com/this-is-tobi/cheatsheets" -s "sheets" -o "$HOME/.config/cheat/cheatsheets/personal" -d


# Install neovim fonts
printf "\n\n${red}[base] =>${no_color} Install neovim fonts\n\n"
mkdir ~/.fonts
curl -fsSL -o /tmp/Ubuntu.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Ubuntu.zip && unzip /tmp/Ubuntu.zip -d ~/.fonts 
curl -fsSL -o /tmp/NerdFontsSymbolsOnly.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.zip && unzip /tmp/NerdFontsSymbolsOnly.zip -d ~/.fonts
cp ~/.fonts/*.ttf ~/Library/Fonts/
fc-cache -fv
