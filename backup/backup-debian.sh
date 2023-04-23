#!/bin/bash

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'
# Console step increment
i=1

# Get Date
NOW=$(date +'%Y-%m-%dT%H-%M-%S')

# Default
BACKUP_DIR="$(pwd)/backup_$NOW"
BACKUP_COMPRESSION="false"
BACKUP_FULL="false"

# Declare script helper
TEXT_HELPER="\nThis script aims to copy importants files and directory before a restauration.
Following flags are available:

  -c    (Optional) Use rsync compression during backup.
        Default is '$BACKUP_COMPRESSION'.

  -f    (Optional) Perform a full backup of the entire home directory (for personnal use).
        Default is '$BACKUP_FULL'.

  -o    (Optional) Output directory.
        Default is '$(pwd)'.

  -h    Print script help.\n\n"

print_help() {
  printf "$TEXT_HELPER"
}

# Parse options
while getopts hcfo: flag; do
  case "${flag}" in
    c)
      BACKUP_COMPRESSION="true";;
    f)
      BACKUP_FULL="true";;
    o)
      BACKUP_DIR="${OPTARG}/backup_$NOW";;
    h | *)
      print_help
      exit 0;;
  esac
done


# Settings
printf "\nScript settings:
  -> backup target dir: ${red}${BACKUP_DIR}${no_color}
  -> use compression: ${red}${BACKUP_COMPRESSION}${no_color}
  -> full backup: ${red}${BACKUP_FULL}${no_color}\n"


# Backup /etc files
printf "\n${red}${i}.${no_color} Backup /etc files\n\n"
i=$(($i + 1))

ETC_FILES=(
  /etc/hosts
  /etc/resolv.conf
)
mkdir -p "${BACKUP_DIR%/}/etc"
if [ "$BACKUP_COMPRESSION" = "true" ]; then
  rsync -ahW --compress --info=progress2 ${ETC_FILES[*]} "${BACKUP_DIR%/}/etc"
else
  rsync -ahW --no-compress --info=progress2 ${ETC_FILES[*]} "${BACKUP_DIR%/}/etc"
fi


# Backup dotfiles
printf "\n${red}${i}.${no_color} Backup dotfiles\n\n"
i=$(($i + 1))

DOT_FILES=(
  $HOME/.aws
  $HOME/.config
  $HOME/.docker/config.json
  $HOME/.docker/features.json
  $HOME/.gitconfig
  $HOME/.kube/config
  $HOME/.kube/config.d
  $HOME/.npmrc
  $HOME/.ssh
  $HOME/.zshrc
)
mkdir -p "${BACKUP_DIR%/}/dotfiles"
if [ "$BACKUP_COMPRESSION" = "true" ]; then
  rsync -ahW --compress --info=progress2 ${DOT_FILES[*]} "${BACKUP_DIR%/}/dotfiles"
else
  rsync -ahW --no-compress --info=progress2 ${DOT_FILES[*]} "${BACKUP_DIR%/}/dotfiles"
fi


# Backup home directory
printf "\n${red}${i}.${no_color} Backup home directory\n\n"
i=$(($i + 1))

mkdir "${BACKUP_DIR%/}/home"
if [ "$BACKUP_FULL" = "true" ]; then
  HOME_DIR="/home"
else 
  HOME_DIR="$HOME"
fi

if [ "$BACKUP_COMPRESSION" = "true" ]; then
  rsync -ahW --compress --info=progress2 "$HOME_DIR" "${BACKUP_DIR%/}/home"
else
  rsync -ahW --no-compress --info=progress2 "$HOME_DIR" "${BACKUP_DIR%/}/home"
fi
