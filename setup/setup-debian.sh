#!/bin/bash

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'

# Console step increment
i=1

# Get project directories
SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# Default
INSTALL_BASE="false"
INSTALL_DEVOPS="false"
INSTALL_GO="false"
INSTALL_JS="false"
COPY_DOTFILES="false"

# Declare script helper
TEXT_HELPER="\nThis script aims to install a full setup for debian.
Following flags are available:

  -d    Copy dotfiles.

  -p    Install additional packages according to the given profile, available profiles are :
          -> 'base'
          -> 'devops'
          -> 'go'
          -> 'js'
        Default is no profile, this flag can be used with a CSV list (ex: -p "base,js").

  -h    Print script help.\n\n"

print_help() {
  printf "$TEXT_HELPER"
}

# Parse options
while getopts hdp: flag; do
  case "${flag}" in
    d)
      COPY_DOTFILES="true";;
    p)
      [[ "$OPTARG" =~ "base" ]] && INSTALL_BASE="true"
      [[ "$OPTARG" =~ "devops" ]] && INSTALL_DEVOPS="true"
      [[ "$OPTARG" =~ "go" ]] && INSTALL_GO="true"
      [[ "$OPTARG" =~ "js" ]] && INSTALL_JS="true";;
    h | *)
      print_help
      exit 0;;
  esac
done


# Settings
printf "\nScript settings:
  -> install ${red}[base]${no_color} profile: ${red}$INSTALL_BASE${no_color}
  -> install ${red}[devops]${no_color} profile: ${red}$INSTALL_DEVOPS${no_color}
  -> install ${red}[go]${no_color} profile: ${red}$INSTALL_GO${no_color}
  -> install ${red}[js]${no_color} profile: ${red}$INSTALL_JS${no_color}\n"


# Install common
printf "\n${red}${i}.${no_color} Install commons\n\n"
sudo apt update && sudo apt install -y \
  curl \
  jq \
  sed \
  wget

# Install zsh
if [ ! -x "$(command -v zsh)" ]; then
  printf "\n${red}${i}.${no_color} Install zsh\n\n"
  sudo apt install -y zsh
fi

# Make zsh the default shell
if [[ ! "$SHELL" =~ "zsh" ]]; then
  printf "\n${red}${i}.${no_color} Make zsh the default shell\n\n"
  sudo chsh -s $(which zsh) "$USER"
fi

# Install oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  printf "\n${red}${i}.${no_color} Install oh-my-zsh\n\n"
  i=$(($i + 1))

  wget -O /tmp/install-oh-my-zsh.sh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
  sh /tmp/install-oh-my-zsh.sh --skip-chsh --unattended
fi


# Install base profile
if [[ "$INSTALL_BASE" = "true" ]]; then
  printf "\n${red}${i}.${no_color} Install base profile\n\n"
  i=$(($i + 1))

  sh "$SCRIPT_PATH/profiles/debian/setup-base.sh"
fi


# Install devops profile
if [[ "$INSTALL_DEVOPS" = "true" ]]; then
  printf "\n${red}${i}.${no_color} Install devops profile\n\n"
  i=$(($i + 1))

  sh "$SCRIPT_PATH/profiles/debian/setup-devops.sh"
fi


# Install go profile
if [[ "$INSTALL_GO" = "true" ]]; then
  printf "\n${red}${i}.${no_color} Install go profile\n\n"
  i=$(($i + 1))

  sh "$SCRIPT_PATH/profiles/debian/setup-go.sh"
fi


# Install js profile
if [[ "$INSTALL_JS" = "true" ]]; then
  printf "\n${red}${i}.${no_color} Install javascript profile\n\n"
  i=$(($i + 1))

  sh "$SCRIPT_PATH/profiles/debian/setup-js.sh"
fi


# Copy dotfiles
if [[ "$COPY_DOTFILES" = "true" ]]; then
  printf "\n${red}${i}.${no_color} Copy dotfiles\n\n"
  i=$(($i + 1))

  mkdir -p "$HOME/.config"
  cp "$SCRIPT_PATH/../dotfiles/.zshrc" "$HOME/.zshrc" && sed -i 's/TLDR_OS=.*/TLDR_OS=linux/g' "$HOME/.zshrc"
  cp "$SCRIPT_PATH/../dotfiles/.gitconfig" "$HOME/.gitconfig"
  cp -R "$SCRIPT_PATH/../dotfiles/.config/nvim" "$HOME/.config"
  cp -R "$SCRIPT_PATH/../dotfiles/.config/lazygit" "$HOME/.config"
fi
