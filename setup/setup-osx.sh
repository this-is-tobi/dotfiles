#!/bin/bash

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'

# Console step increment
i=1

# Get project directories
PROJECT_DIR="$(git rev-parse --show-toplevel)"
# SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# Default
INSTALL_DEVOPS="false"
INSTALL_EXTRAS="false"
INSTALL_JS="false"
COPY_DOTFILES="false"

# Declare script helper
TEXT_HELPER="\nThis script aims to install a full setup for osx.
Following flags are available:

  -d    Copy dotfiles.

  -p    Install additional packages according to the given profile, available profiles are :
          -> 'devops'
          -> 'js'
          -> 'extras' (for personnal use)
        Default is no additional profile, this flag can be used multiple times.

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
      [[ "$OPTARG" =~ "extras" ]] && INSTALL_EXTRAS="true"
      [[ "$OPTARG" =~ "devops" ]] && INSTALL_DEVOPS="true"
      [[ "$OPTARG" =~ "js" ]] && INSTALL_JS="true";;
    h | *)
      print_help
      exit 0;;
  esac
done


# utils
install_clt() {
  printf "\n${red}Optional.${no_color} Installs Command Line Tools for Xcode from softwareupdate...\n\n"
  # This temporary file prompts the 'softwareupdate' utility to list the Command Line Tools
  touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
  PROD=$(softwareupdate -l | grep "\*.*Command Line" | tail -n 1 | sed 's/^[^C]* //')
  softwareupdate -i "$PROD" --verbose;
  printf "\Command Line Tools version installed :\n$PROD\n\n"
}

install_homebrew() {
  printf "\n${red}Optional.${no_color} Installs homebrew...\n\n"
  export NONINTERACTIVE=1 
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  printf "\nhomebrew version installed :\n$(homebrew --version)\n\n"
}

if [ -z "$(xcode-select -p)" ]; then
  while true; do
    read -p "\nYou need Command Line Tools to run this script. Do you wish to install Command Line Tools?\n" yn
    case $yn in
      [Yy]*)
        install_clt;;
      [Nn]*)
        exit;;
      *)
        echo "\nPlease answer yes or no.\n";;
    esac
  done
fi

if [ -z "$(brew --version)" ]; then
  while true; do
    read -p "\nYou need homebrew to run this script. Do you wish to install homebrew?\n" yn
    case $yn in
      [Yy]*)
        install_homebrew;;
      [Nn]*)
        exit;;
      *)
        echo "\nPlease answer yes or no.\n";;
    esac
  done
fi


# Settings
printf "\nScript settings:
  -> install ${red}[base]${no_color} profile: ${red}true${no_color}
  -> install ${red}[extras]${no_color} profile: ${red}$INSTALL_EXTRAS${no_color}
  -> install ${red}[devops]${no_color} profile: ${red}$INSTALL_DEVOPS${no_color}
  -> install ${red}[js]${no_color} profile: ${red}$INSTALL_JS${no_color}\n"


# Install oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  printf "\n${red}${i}.${no_color} Install oh-my-zsh\n\n"
  i=$(($i + 1))

  wget -O /tmp/install-oh-my-zsh.sh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
  sed -i 's/exec zsh -l/#exec zsh -l/' /tmp/install-oh-my-zsh.sh
  sh /tmp/install-oh-my-zsh.sh
fi


# Install base profile
printf "\n${red}${i}.${no_color} Install base profile\n\n"
i=$(($i + 1))

sh "$PROJECT_DIR/setup/profiles/osx/setup-base.sh"


# Install extras profile
if [[ "$INSTALL_EXTRAS" = "true" ]]; then
  printf "\n${red}${i}.${no_color} Install extras profile\n\n"
  i=$(($i + 1))

  sh "$PROJECT_DIR/setup/profiles/osx/setup-extras.sh"
fi


# Install devops profile
if [[ "$INSTALL_DEVOPS" = "true" ]]; then
  printf "\n${red}${i}.${no_color} Install devops profile\n\n"
  i=$(($i + 1))

  sh "$PROJECT_DIR/setup/profiles/osx/setup-devops.sh"
fi


# Install js profile
if [[ "$INSTALL_JS" = "true" ]]; then
  printf "\n${red}${i}.${no_color} Install javascript profile\n\n"
  i=$(($i + 1))

  sh "$PROJECT_DIR/setup/profiles/osx/setup-js.sh"
fi


# Copy dotfiles
if [[ "$COPY_DOTFILES" = "true" ]]; then
  printf "\n${red}${i}.${no_color} Copy dotfiles\n\n"
  i=$(($i + 1))

  cp "$PROJECT_DIR/dotfiles/.zshrc" "$HOME/.zshrc"
  cp "$PROJECT_DIR/dotfiles/.gitconfig" "$HOME/.gitconfig"
  cp "$PROJECT_DIR/dotfiles/.vscode/settings.json" "$HOME/Library/Application\ Support/Code/User/settings.json"


  # Install .vscode extensions
  VSCODE_EXTENSIONS=($(cat "$PROJECT_DIR/dotfiles/.vscode/extensions.json" \
    | grep -v '//' \
    | grep -E '\S' \
    | jq -r '.recommendations[]'))
  for extension in $VSCODE_EXTensionENSIONS[@]; do
    echo "$extension" | xargs -L 1 code --install-extension
  done
fi
