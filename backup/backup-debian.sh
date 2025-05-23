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
BACKUP_COMPRESSION_ARGS="--no-compress"
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
      BACKUP_COMPRESSION="true"
      BACKUP_COMPRESSION_ARGS="--compress";;
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
rsync -ahW $BACKUP_COMPRESSION_ARGS --info=progress2 ${ETC_FILES[*]} "${BACKUP_DIR%/}/etc"


# Backup dotfiles
printf "\n${red}${i}.${no_color} Backup dotfiles\n\n"
i=$(($i + 1))

DOT_FILES=(
  $HOME/.aws
  $HOME/.config
  $HOME/.docker
  $HOME/.gitconfig
  $HOME/.gnupg
  $HOME/.kube
  $HOME/.mc
  $HOME/.npmrc
  $HOME/.ssh
  $HOME/.tsh
  $HOME/.zshrc
)
mkdir -p "${BACKUP_DIR%/}/dotfiles"
rsync -ahW $BACKUP_COMPRESSION_ARGS --info=progress2 ${DOT_FILES[*]} "${BACKUP_DIR%/}/dotfiles"


# Export gpg keys
printf "\n${red}${i}.${no_color} Export gpg keys\n\n"
i=$(($i + 1))

EMAIL="this-is-tobi@proton.me"
BACKUP_DIR="$HOME/.gnupg/backup"
mkdir -p "$BACKUP_DIR"

KEY_ID=$(gpg --list-secret-keys --keyid-format=long "$EMAIL" | grep 'sec' | awk '{print $2}' | cut -d'/' -f2)

if [ -z "$KEY_ID" ]; then
  echo "No GPG key found for email: $EMAIL"
else
  gpg --export --armor "$KEY_ID" > "$BACKUP_DIR/public-key-$KEY_ID.asc"
  echo "Public gpg key saved to $BACKUP_DIR/public-key-$KEY_ID.asc"

  gpg --export-secret-keys --armor "$KEY_ID" > "$BACKUP_DIR/private-key-$KEY_ID.asc"
  echo "Private gpg key saved to $BACKUP_DIR/private-key-$KEY_ID.asc"

  echo "Backup completed for GPG key: $KEY_ID"
fi


# Backup home directory
printf "\n${red}${i}.${no_color} Backup home directory\n\n"
i=$(($i + 1))

mkdir "${BACKUP_DIR%/}/home"
if [ "$BACKUP_FULL" = "true" ]; then
  HOME_DIR=(
    $HOME
  )
else 
  HOME_DIR=(
    $HOME/dev
  )
fi

rsync -ahW $BACKUP_COMPRESSION_ARGS --info=progress2 --exclude '**/node_modules' ${HOME_DIRS[*]} "${BACKUP_DIR%/}/home"
