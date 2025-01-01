#!/bin/bash

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'


install_lite_setup() {
  # Install homebrew cli packages
  printf "\n\n${red}[base] =>${no_color} Install homebrew packages (cli)\n\n"
  brew update && brew install --formula \
    bat \
    bat-extras \
    cheat \
    eza \
    fd \
    fzf \
    glow \
    nmap \
    proto \
    ripgrep \
    rsync \
    sshs \
    tree \
    vim \
    watch \
    yq


  # Install homebrew graphic app packages
  printf "\n\n${red}[base] =>${no_color} Install homebrew packages (graphic)\n\n"
  brew install --cask \
    docker \


  # Install addition cheatsheets
  curl -fsSL https://raw.githubusercontent.com/this-is-tobi/tools/main/shell/clone-subdir.sh | bash -s -- \
    -u "https://github.com/this-is-tobi/cheatsheets" -s "sheets" -o "$HOME/.config/cheat/cheatsheets/personal" -d
}

install_additional_setup() {
  # Install homebrew cli packages
  printf "\n\n${red}[base] =>${no_color} Install homebrew packages (cli)\n\n"
  brew update && brew install --formula \
    chafa \
    exiftool \
    ffmpeg \
    gh \
    glab \
    lazydocker \
    lazygit \
    nvim \
    isacikgoz/taps/tldr \
    ttyd \
    vhs


  # Install homebrew graphic app packages
  printf "\n\n${red}[base] =>${no_color} Install homebrew packages (graphic)\n\n"
  brew install --cask \
    brave-browser \
    firefox \
    insomnia \
    mattermost \
    openvpn-connect \
    visual-studio-code


  # Install neovim fonts
  printf "\n\n${red}[base] =>${no_color} Install neovim fonts\n\n"
  mkdir ~/.fonts
  curl -fsSL -o /tmp/Ubuntu.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Ubuntu.zip && unzip /tmp/Ubuntu.zip -d ~/.fonts 
  curl -fsSL -o /tmp/NerdFontsSymbolsOnly.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.zip && unzip /tmp/NerdFontsSymbolsOnly.zip -d ~/.fonts
  cp ~/.fonts/*.ttf ~/Library/Fonts/
  fc-cache -fv
}


# Install lite setup
install_lite_setup

# Install full setup
if [ "$FULL_MODE_SETUP" = "true" ]; then
  install_additional_setup
fi
