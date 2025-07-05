#!/bin/bash

set -e

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'

# Console step increment
i=1

# Get project directories
SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# Default
INSTALL_AI="false"
INSTALL_BASE="false"
INSTALL_DEVOPS="false"
INSTALL_GO="false"
INSTALL_JS="false"
INSTALL_SECOPS="false"
INSTALL_COMPLETIONS="false"
COPY_DOTFILES="false"
REMOVE_TMP_CONTENT="false"
FULL_MODE_SETUP="true"

# Declare script helper
TEXT_HELPER="\nThis script aims to install a full setup for debian.
Following flags are available:

  -c    Install cli completions.

  -d    Copy dotfiles.

  -l    Run with lite mode, only major tools will be installed.

  -p    Install additional packages according to the given profile, available profiles are :
          -> 'ai'
          -> 'base'
          -> 'devops'
          -> 'go'
          -> 'js'
          -> 'secops'
        Default is no profile, this flag can be used with a CSV list (ex: -p "base,js").

  -r    Remove all tmp files after installation.

  -h    Print script help.\n\n"

print_help() {
  printf "$TEXT_HELPER"
}

# Parse options
while getopts hcdlp:r flag; do
  case "${flag}" in
    c)
      INSTALL_COMPLETIONS="true";;
    d)
      COPY_DOTFILES="true";;
    l)
      FULL_MODE_SETUP="false";;
    p)
      [[ "$OPTARG" =~ "ai" ]] && INSTALL_AI="true"
      [[ "$OPTARG" =~ "base" ]] && INSTALL_BASE="true"
      [[ "$OPTARG" =~ "devops" ]] && INSTALL_DEVOPS="true"
      [[ "$OPTARG" =~ "go" ]] && INSTALL_GO="true"
      [[ "$OPTARG" =~ "js" ]] && INSTALL_JS="true"
      [[ "$OPTARG" =~ "secops" ]] && INSTALL_SECOPS="true";;
    r)
      REMOVE_TMP_CONTENT="true";;
    h | *)
      print_help
      exit 0;;
  esac
done


# Settings
printf "\nScript settings:
  -> install ${red}full setup${no_color}: ${red}$FULL_MODE_SETUP${no_color}
  -> install ${red}[ai]${no_color} profile: ${red}$INSTALL_AI${no_color}
  -> install ${red}[base]${no_color} profile: ${red}$INSTALL_BASE${no_color}
  -> install ${red}[devops]${no_color} profile: ${red}$INSTALL_DEVOPS${no_color}
  -> install ${red}[go]${no_color} profile: ${red}$INSTALL_GO${no_color}
  -> install ${red}[js]${no_color} profile: ${red}$INSTALL_JS${no_color}
  -> install ${red}[secops]${no_color} profile: ${red}$INSTALL_SECOPS${no_color}\n"

export FULL_MODE_SETUP=$FULL_MODE_SETUP

# Install common
printf "\n${red}${i}.${no_color} Install commons\n\n"
sudo apt update && sudo apt install -y \
  build-essential \
  ca-certificates \
  curl \
  gzip \
  gnupg \
  jq \
  locales \
  sed \
  tar \
  unzip \
  wget \
  xz-utils

# Uncomment en_US.UTF-8 for inclusion in generation and generate locales
sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen && locale-gen

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

  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi


# Install base profile
if [[ "$INSTALL_BASE" = "true" ]]; then
  printf "\n${red}${i}.${no_color} Install base profile\n\n"
  i=$(($i + 1))

  $SCRIPT_PATH/profiles/debian/setup-base.sh
  export PROTO_HOME="$HOME/.proto"
  export PATH="$PROTO_HOME/shims:$PROTO_HOME/bin:$PATH"
fi


# Install devops profile
if [[ "$INSTALL_DEVOPS" = "true" ]]; then
  printf "\n${red}${i}.${no_color} Install devops profile\n\n"
  i=$(($i + 1))

  $SCRIPT_PATH/profiles/debian/setup-devops.sh
fi


# Install secops profile
if [[ "$INSTALL_SECOPS" = "true" ]]; then
  printf "\n${red}${i}.${no_color} Install secops profile\n\n"
  i=$(($i + 1))

  $SCRIPT_PATH/profiles/debian/setup-secops.sh
fi


# Install go profile
if [[ "$INSTALL_GO" = "true" ]]; then
  printf "\n${red}${i}.${no_color} Install go profile\n\n"
  i=$(($i + 1))

  $SCRIPT_PATH/profiles/debian/setup-go.sh
fi


# Install js profile
if [[ "$INSTALL_JS" = "true" ]]; then
  printf "\n${red}${i}.${no_color} Install javascript profile\n\n"
  i=$(($i + 1))

  $SCRIPT_PATH/profiles/debian/setup-js.sh
fi


# Install ai profile
if [[ "$INSTALL_AI" = "true" ]]; then
  printf "\n${red}${i}.${no_color} Install ai profile\n\n"
  i=$(($i + 1))

  $SCRIPT_PATH/profiles/debian/setup-ai.sh
fi


# Copy dotfiles
if [[ "$COPY_DOTFILES" = "true" ]]; then
  printf "\n${red}${i}.${no_color} Copy dotfiles\n\n"
  i=$(($i + 1))

  mkdir -p "$HOME/.config"
  cp "$SCRIPT_PATH/../dotfiles/.zshrc" "$HOME/.zshrc" && sed -i 's/TLDR_OS=.*/TLDR_OS=linux/g' "$HOME/.zshrc"
  cp "$SCRIPT_PATH/../dotfiles/.oh-my-zsh/this-is-tobi.zsh-theme" "$HOME/.oh-my-zsh/custom/themes/this-is-tobi.zsh-theme"
  cp "$SCRIPT_PATH/../dotfiles/.prototools" "$HOME/.proto/.prototools"
  cp "$SCRIPT_PATH/../dotfiles/.gitconfig" "$HOME/.gitconfig"
  cp -R $SCRIPT_PATH/../dotfiles/.continue/* "$HOME/.continue"
  cp -R $SCRIPT_PATH/../dotfiles/.config/* "$HOME/.config"


  # Install .vscode configs
  if [ -x "$(command -v code)" ]; then
    mkdir -p "$HOME/.config/Code/User"
    cp "$SCRIPT_PATH/../dotfiles/.vscode/settings.json" "$HOME/.config/Code/User/settings.json"
    VSCODE_EXTENSIONS=($(cat "$SCRIPT_PATH/../dotfiles/.vscode/extensions.json" \
      | grep -v '//' \
      | grep -E '\S' \
      | jq -r '.recommendations[]'))
    for extension in ${VSCODE_EXTENSIONS[@]}; do
      echo "$extension" | xargs -L 1 code --install-extension
    done
  fi
  if [ -x "$(command -v code-server)" ]; then
    mkdir -p "$HOME/.local/share/code-server/User"
    cp "$SCRIPT_PATH/../dotfiles/.vscode/settings.json" "$HOME/.local/share/code-server/User/settings.json"
    VSCODE_EXTENSIONS=($(cat "$SCRIPT_PATH/../dotfiles/.vscode/extensions.json" \
      | grep -v '//' \
      | grep -E '\S' \
      | jq -r '.recommendations[]'))
    for extension in ${VSCODE_EXTENSIONS[@]}; do
      echo "$extension" | xargs -L 1 code-server --install-extension
    done
  fi
fi


# Install cli completions
if [[ "$INSTALL_COMPLETIONS" = "true" ]]; then
  printf "\n${red}${i}.${no_color} Install cli completions\n\n"
  i=$(($i + 1))

  $SCRIPT_PATH/completions.sh
  git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions && sed -i 's|^# fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src|fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src|g' "$HOME/.zshrc"
fi


if [[ "$REMOVE_TMP_CONTENT" = "true" ]]; then
  printf "\n${red}${i}.${no_color} Remove tmp files\n\n"
  i=$(($i + 1))

  rm -rf /tmp/*
fi
