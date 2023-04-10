#!/bin/bash

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'

# Console step increment
i=1

# Get project directories
PROJECT_DIR="$(git rev-parse --show-toplevel)"

# Default
INSTALL_DEVOPS="false"
INSTALL_JS="false"

# Declare script helper
TEXT_HELPER="\nThis script aims to install a full setup for debian.
Following flags are available:

  -p    Install additional packages according to the given profile, available profiles are :
          -> 'devops'
          -> 'js'
        Default is no additional profile, this flag can be used multiple times.

  -h    Print script help.\n\n"

print_help() {
  printf "$TEXT_HELPER"
}

# Parse options
while getopts hp: flag; do
  case "${flag}" in
    p)
      [[ "$OPTARG" =~ "extras" ]] && INSTALL_EXTRAS="true"
      [[ "$OPTARG" =~ "devops" ]] && INSTALL_DEVOPS="true"
      [[ "$OPTARG" =~ "js" ]] && INSTALL_JS="true";;
    h | *)
      print_help
      exit 0;;
  esac
done


# Settings
printf "\nScript settings:
  -> install ${red}[base]${no_color} profile: ${red}true${no_color}
  -> install ${red}[devops]${no_color} profile: ${red}$INSTALL_DEVOPS${no_color}
  -> install ${red}[js]${no_color} profile: ${red}$INSTALL_JS${no_color}\n"


# Install zsh
if [ ! -x "$(command -v zsh)" ]; then
  sudo apt update && sudo apt install -y zsh

  # Make zsh the default shell
  sudo chsh -s $(which zsh)
fi



# Install oh-my-zsh
printf "\n${red}${i}.${no_color} Install oh-my-zsh\n\n"
i=$(($i + 1))

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  wget -O /tmp/install-oh-my-zsh.sh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
  sed -i 's/exec zsh -l/#exec zsh -l/' /tmp/install-oh-my-zsh.sh
  sh install-oh-my-zsh.sh
fi

# Add wakemeops debian repo
if [ -z "$(find /etc/apt/ -name *.list | xargs cat | grep  ^[[:space:]]*deb | grep wakemeops)" ]; then
  curl -sSL https://raw.githubusercontent.com/upciti/wakemeops/main/assets/install_repository | sudo bash
fi


# Install base profile
printf "\n${red}${i}.${no_color} Install base profile\n\n"
i=$(($i + 1))

sh "$PROJECT_DIR/setup/profiles/debian/setup-base.sh"


# Install devops profile
if [[ "$INSTALL_DEVOPS" = "true" ]]; then
  printf "\n${red}${i}.${no_color} Install extras profile\n\n"
  i=$(($i + 1))

  sh "$PROJECT_DIR/setup/profiles/debian/setup-devops.sh"
fi


# Install js profile
if [[ "$INSTALL_JS" = "true" ]]; then
  printf "\n${red}${i}.${no_color} Install extras profile\n\n"
  i=$(($i + 1))

  sh "$PROJECT_DIR/setup/profiles/debian/setup-js.sh"
fi


# Copy dotfiles
printf "\n${red}${i}.${no_color} Copy dotfiles\n\n"
i=$(($i + 1))

cp "$PROJECT_DIR/dotfiles/.zshrc" "$HOME/.zshrc" && sed -i 's/TLDR_OS/TLDR_OS=linux' "$HOME/.zshrc"
cp "$PROJECT_DIR/dotfiles/.gitconfig" "$HOME/.gitconfig"
