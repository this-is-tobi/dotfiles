#!/bin/bash

set -eo pipefail

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'

# Console step increment
i=1

# Get project directories
SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# Profiles, helpers and dotfiles are read from the repository next to this script
if [ ! -f "$SCRIPT_PATH/helpers/files.sh" ]; then
  printf "Error: this script needs the rest of the repository (helpers/, profiles/, dotfiles/). Clone it and run the script from the clone.\n" >&2
  exit 1
fi

# shellcheck source=helpers/files.sh
. "$SCRIPT_PATH/helpers/files.sh"
# shellcheck source=helpers/remote.sh
. "$SCRIPT_PATH/helpers/remote.sh"
# shellcheck source=helpers/profiles.sh
. "$SCRIPT_PATH/helpers/profiles.sh"

# The profiles are the scripts of profiles/osx (see helpers/profiles.sh)
profiles_init "$SCRIPT_PATH/profiles/osx"

# Default
INSTALL_COMPLETIONS="false"
COPY_DOTFILES="false"
FULL_MODE_SETUP="true"
DRY_RUN="false"

print_help() {
  printf "\nThis script aims to install a full setup for osx.
Following flags are available:

  -c    Install cli completions.

  -d    Copy dotfiles.

  -l    Run with lite mode, only major tools will be installed.

  -n    Dry run: print the resolved settings, then every command that would change
        the machine instead of running it (checks that only read it still run).

  -p    Install additional packages according to the given profile, available profiles are :
"
  profiles_help
  printf "        Default is no profile, this flag can be used with a CSV list (ex: -p \"base,js\").

  -r    Deprecated and ignored: temporary files are removed by the scripts that create them.

  -h    Print script help.\n\n"
}

# Parse options
while getopts hcdlnp:r flag; do
  case "${flag}" in
    c)
      INSTALL_COMPLETIONS="true";;
    d)
      COPY_DOTFILES="true";;
    l)
      FULL_MODE_SETUP="false";;
    n)
      DRY_RUN="true";;
    p)
      profiles_select "$OPTARG" || exit 1;;
    r)
      printf "Note: -r is deprecated and ignored, temporary files are always cleaned up.\n" >&2;;
    h | *)
      print_help
      exit 0;;
  esac
done


# Settings
printf "\nScript settings:
  -> install ${red}full setup${no_color}: ${red}$FULL_MODE_SETUP${no_color}\n"
profiles_settings
printf "  -> copy ${red}dotfiles${no_color}: ${red}$COPY_DOTFILES${no_color}
  -> install ${red}cli completions${no_color}: ${red}$INSTALL_COMPLETIONS${no_color}\n"

# A dry run goes through every step: the profiles and helpers it starts print
# the commands instead of running them (helpers/run.sh)
if [[ "$DRY_RUN" = "true" ]]; then
  export DOTFILES_DRY_RUN=1
  printf "\n${red}Dry run:${no_color} nothing is installed or changed, the commands are printed instead.\n"
fi


# utils
# Make an installed Homebrew usable in this shell: on Apple Silicon it is not
# on PATH right after its install, nor in a non-login shell.
load_brew() {
  local brew_bin
  for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [ -x "$brew_bin" ]; then
      eval "$("$brew_bin" shellenv)"
      return 0
    fi
  done
  return 1
}

# Ask before installing a prerequisite and exit unless the answer is yes. A
# prompt cannot be answered without a terminal, so fail with instructions then.
confirm_or_exit() {
  local what="$1" answer
  if [ ! -t 0 ]; then
    printf "Error: %s is required but not installed, and this shell is non-interactive so the install prompt can't be answered. Install it first or run this script from an interactive terminal.\n" "$what" >&2
    exit 1
  fi
  read -r -p "You need ${what} to run this script. Do you wish to install it? [y/N] " answer
  case "$answer" in
    [Yy]*) ;;
    *) exit 1;;
  esac
}

# A subshell, so that its EXIT trap removes the flag file however the install
# ends: left behind, it keeps softwareupdate offering the Command Line Tools.
install_clt() (
  local prod
  # Not local: bash 3.2 drops a function's locals before the EXIT trap of its
  # subshell runs, and the subshell keeps these variables to itself anyway.
  flag_file="/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress"
  printf "\n\n${red}Optional.${no_color} Installs Command Line Tools for Xcode from softwareupdate...\n\n"
  # This temporary file prompts the 'softwareupdate' utility to list the Command Line Tools
  touch "$flag_file"
  trap 'rm -f "$flag_file"' EXIT
  prod="$(softwareupdate -l | grep "\*.*Command Line" | tail -n 1 | sed 's/^[^C]* //')" || true
  if [ -z "$prod" ]; then
    printf "Error: softwareupdate lists no Command Line Tools to install. Install them with 'xcode-select --install', then run this script again.\n" >&2
    exit 1
  fi
  sudo softwareupdate -i "$prod" --verbose
  printf "\nCommand Line Tools version installed :\n%s\n\n" "$prod"
)

install_homebrew() {
  printf "\n\n${red}Optional.${no_color} Installs homebrew...\n\n"
  export NONINTERACTIVE=1
  run_remote /bin/bash "https://raw.githubusercontent.com/Homebrew/install/${HOMEBREW_INSTALL_REF:-HEAD}/install.sh"
  load_brew
  printf "\nhomebrew version installed :\n%s\n\n" "$(brew --version)"
}

if ! xcode-select -p >/dev/null 2>&1; then
  if dry_run; then
    printf "[dry-run] ask to install the Command Line Tools, then install them with softwareupdate\n"
  else
    confirm_or_exit "Command Line Tools"
    install_clt
  fi
fi

if ! command -v brew >/dev/null 2>&1; then
  if ! load_brew; then
    if dry_run; then
      printf "[dry-run] ask to install Homebrew, then install it with its install script\n"
    else
      confirm_or_exit "Homebrew"
      install_homebrew
    fi
  fi
fi


export FULL_MODE_SETUP=$FULL_MODE_SETUP

# Recent Homebrew versions ask "Do you want to proceed? [y/n]" before every install, which
# stops an unattended run. The profile flags already say what to install, so skip the
# question unless HOMEBREW_NO_ASK was set by the caller.
export HOMEBREW_NO_ASK="${HOMEBREW_NO_ASK-1}"

# Tools installed by the profiles (mise shims, ~/.local/bin) must be visible to
# every later step, whichever profiles run.
export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$PATH"

# Install common
printf "\n${red}${i}.${no_color} Install commons\n\n"
i=$(($i + 1))
run brew update || printf "brew update failed, continuing with the local formulae index\n"
run brew install --formula \
  ca-certificates \
  curl \
  gnupg \
  gsed \
  gzip \
  jq \
  unzip \
  wget \
  xz

# Install oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  printf "\n${red}${i}.${no_color} Install oh-my-zsh\n\n"
  i=$(($i + 1))

  # --unattended: the installer would otherwise switch the login shell and
  # `exec zsh`, which ends this script right there. KEEP_ZSHRC leaves an
  # existing ~/.zshrc alone (the dotfiles step replaces it, with a backup).
  KEEP_ZSHRC=yes run_remote sh "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/${OMZ_REF:-master}/tools/install.sh" --unattended
fi


# Install the selected profiles, in their order
profiles_run


# Copy dotfiles
if [[ "$COPY_DOTFILES" = "true" ]]; then
  printf "\n${red}${i}.${no_color} Copy dotfiles\n\n"
  i=$(($i + 1))

  "$SCRIPT_PATH/helpers/dotfiles.sh" "code:$HOME/Library/Application Support/Code/User"
fi


# Install cli completions
if [[ "$INSTALL_COMPLETIONS" = "true" ]]; then
  printf "\n${red}${i}.${no_color} Install cli completions\n\n"
  i=$(($i + 1))

  run "$SCRIPT_PATH/helpers/completions.sh"
  # .zshrc adds this directory to fpath once it exists
  ZSH_COMPLETIONS_DIR="${ZSH_CUSTOM:-${ZSH:-$HOME/.oh-my-zsh}/custom}/plugins/zsh-completions"
  if [ ! -d "$ZSH_COMPLETIONS_DIR" ]; then
    run git clone https://github.com/zsh-users/zsh-completions.git "$ZSH_COMPLETIONS_DIR"
  fi
fi
