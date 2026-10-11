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
# shellcheck source=helpers/apt.sh
. "$SCRIPT_PATH/helpers/apt.sh"
# shellcheck source=helpers/profiles.sh
. "$SCRIPT_PATH/helpers/profiles.sh"

# The profiles are the scripts of profiles/debian (see helpers/profiles.sh)
profiles_init "$SCRIPT_PATH/profiles/debian"

# Default
INSTALL_COMPLETIONS="false"
COPY_DOTFILES="false"
FULL_MODE_SETUP="true"
DRY_RUN="false"

print_help() {
  printf "\nThis script aims to install a full setup for debian.
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

export FULL_MODE_SETUP=$FULL_MODE_SETUP

# Tools installed by the profiles (mise shims, ~/.local/bin) must be visible to
# every later step, whichever profiles run.
export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$PATH"

# sudo is used throughout. A root shell on a minimal image (a container, a fresh
# VM) may not have it yet; anyone else has to install it first.
if ! command -v sudo >/dev/null 2>&1; then
  if [ "$(id -u)" -eq 0 ]; then
    run apt-get update && run env DEBIAN_FRONTEND=noninteractive apt-get install -y sudo
  else
    printf "Error: sudo is required but not installed. Install it as root first (apt install sudo).\n" >&2
    exit 1
  fi
fi

# Ask for the sudo password once, up front, then keep the credentials fresh in
# the background until the script exits: a long run (mise downloads, Docker)
# outlasts sudo's timestamp (15 minutes by default), and would otherwise stop at
# a password prompt halfway, or fail where nobody can answer it.
if [ "$(id -u)" -ne 0 ] && ! dry_run; then
  if ! sudo -v; then
    printf "Error: sudo could not validate your credentials. Run this script from an interactive terminal, or allow %s to use sudo without a password.\n" "${USER:-$(id -un)}" >&2
    exit 1
  fi
  # -n: the refresh never prompts, it stops when sudo would need the password again
  ( while sleep 60 && kill -0 "$$" 2>/dev/null; do sudo -n -v || exit 0; done ) > /dev/null 2>&1 &
  sudo_keepalive_pid=$!
  trap 'kill "$sudo_keepalive_pid" 2>/dev/null' EXIT
fi

# Install common
printf "\n${red}${i}.${no_color} Install commons\n\n"
i=$(($i + 1))
apt_install \
  build-essential \
  ca-certificates \
  curl \
  git \
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
run sudo sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen
run sudo locale-gen

# Install zsh
if [ ! -x "$(command -v zsh)" ]; then
  printf "\n${red}${i}.${no_color} Install zsh\n\n"
  apt_install zsh
fi

# Make zsh the default shell
if [[ ! "${SHELL:-}" =~ "zsh" ]]; then
  printf "\n${red}${i}.${no_color} Make zsh the default shell\n\n"
  run sudo chsh -s "$(command -v zsh || echo /usr/bin/zsh)" "${USER:-$(id -un)}"
fi

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


# Copy dotfiles (and the VS Code configuration of VS Code and code-server, when present)
if [[ "$COPY_DOTFILES" = "true" ]]; then
  printf "\n${red}${i}.${no_color} Copy dotfiles\n\n"
  i=$(($i + 1))

  "$SCRIPT_PATH/helpers/dotfiles.sh" \
    "code:$HOME/.config/Code/User" \
    "code-server:$HOME/.local/share/code-server/User"
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
