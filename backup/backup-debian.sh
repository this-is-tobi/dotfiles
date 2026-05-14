#!/bin/bash
set -euo pipefail

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'
# Console step increment
i=1

# Get Date
NOW=$(date +'%Y-%m-%dT%H-%M-%S')

# Default
BACKUP_DIR="$(pwd)/backup_$NOW"
BACKUP_FULL="false"

# Declare script helper
TEXT_HELPER="\nThis script aims to copy importants files and directory before a restauration.
Following flags are available:

  -f    (Optional) Perform a full backup of the entire home directory (for personnal use).
        Default is '$BACKUP_FULL'.

  -o    (Optional) Output directory.
        Default is '$(pwd)'.

  -h    Print script help.\n\n"

print_help() {
  printf '%s' "$TEXT_HELPER"
}

# Parse options
while getopts hfo: flag; do
  case "${flag}" in
    f)
      BACKUP_FULL="true";;
    o)
      BACKUP_DIR="${OPTARG}/backup_$NOW";;
    h | *)
      print_help
      exit 0;;
  esac
done

BACKUP_DIR="${BACKUP_DIR%/}"

# rclone args
RCLONE_ARGS=(
  --transfers 12
  --checkers 24
  --buffer-size 64M
  --no-check-dest
  --copy-links
  --progress
)

# rclone filter args (directory copies only — rclone copyto does not accept filters)
RCLONE_FILTER_ARGS=(
  # OS metadata
  --exclude '.DS_Store'
  --exclude 'Thumbs.db'
  --exclude '*.tmp'
  --exclude '*.log'
  # JS / Node
  --exclude 'node_modules/**'
  # Python
  --exclude '__pycache__/**'
  --exclude '*.pyc'
  --exclude '.venv/**'
  --exclude 'venv/**'
  --exclude '.pytest_cache/**'
  # Build artifacts
  --exclude 'target/**'
  --exclude 'dist/**'
  --exclude 'build/**'
  --exclude '.next/**'
  --exclude '.nuxt/**'
  --exclude '.gradle/**'
  --exclude '.parcel-cache/**'
  --exclude 'coverage/**'
)

# Settings
printf "\nScript settings:
  -> backup target dir: ${red}${BACKUP_DIR}${no_color}
  -> full backup: ${red}${BACKUP_FULL}${no_color}\n"


# Backup /etc files
printf "\n${red}${i}.${no_color} Backup /etc files\n\n"
((i++))

ETC_FILES=(
  /etc/hosts
  /etc/resolv.conf
)
mkdir -p "${BACKUP_DIR}/etc"
for src in "${ETC_FILES[@]}"; do
  [ -e "$src" ] || continue
  rclone copyto "$src" "${BACKUP_DIR}/etc/$(basename "$src")" "${RCLONE_ARGS[@]}"
done


# Export gpg keys
printf "\n${red}${i}.${no_color} Export gpg keys\n\n"
((i++))

EMAIL="this-is-tobi@proton.me"
GPG_BACKUP_DIR="$HOME/.gnupg/backup"
mkdir -p "$GPG_BACKUP_DIR"

KEY_ID=$(gpg --list-secret-keys --keyid-format=long "$EMAIL" 2>/dev/null | grep 'sec' | awk '{print $2}' | cut -d'/' -f2) || true

if [ -z "$KEY_ID" ]; then
  echo "No GPG key found for email: $EMAIL"
else
  gpg --export --armor "$KEY_ID" > "$GPG_BACKUP_DIR/public-key-$KEY_ID.asc"
  echo "Public gpg key saved to $GPG_BACKUP_DIR/public-key-$KEY_ID.asc"

  gpg --export-secret-keys --armor "$KEY_ID" > "$GPG_BACKUP_DIR/private-key-$KEY_ID.asc"
  echo "Private gpg key saved to $GPG_BACKUP_DIR/private-key-$KEY_ID.asc"

  echo "Backup completed for GPG key: $KEY_ID"
fi


# Backup dotfiles
printf "\n${red}${i}.${no_color} Backup dotfiles\n\n"
((i++))

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
mkdir -p "${BACKUP_DIR}/dotfiles"
for src in "${DOT_FILES[@]}"; do
  [ -e "$src" ] || continue
  dest="${BACKUP_DIR}/dotfiles/$(basename "$src")"
  if [ -d "$src" ]; then
    case "$(basename "$src")" in
      .docker)
        rclone copy "$src" "$dest" "${RCLONE_ARGS[@]}" "${RCLONE_FILTER_ARGS[@]}" \
          --exclude 'scout/**' \
          --exclude 'sbom/**' \
          --exclude 'scan/**' \
          --exclude 'desktop/**' \
          --exclude 'buildx/**' \
          --exclude 'mutagen/**' \
          --exclude 'run/**'
        ;;
      .kube)
        rclone copy "$src" "$dest" "${RCLONE_ARGS[@]}" "${RCLONE_FILTER_ARGS[@]}" \
          --exclude 'cache/**' \
          --exclude 'http-cache/**'
        ;;
      .aws)
        rclone copy "$src" "$dest" "${RCLONE_ARGS[@]}" "${RCLONE_FILTER_ARGS[@]}" \
          --exclude 'cli/cache/**' \
          --exclude 'sso/cache/**'
        ;;
      .config)
        rclone copy "$src" "$dest" "${RCLONE_ARGS[@]}" "${RCLONE_FILTER_ARGS[@]}" \
          --exclude 'Cache/**' \
          --exclude 'Caches/**' \
          --exclude 'cache/**' \
          --exclude 'GPUCache/**' \
          --exclude 'Code Cache/**' \
          --exclude 'DawnCache/**' \
          --exclude 'logs/**' \
          --exclude 'Logs/**'
        ;;
      *)
        rclone copy "$src" "$dest" "${RCLONE_ARGS[@]}" "${RCLONE_FILTER_ARGS[@]}"
        ;;
    esac
  else
    rclone copyto "$src" "$dest" "${RCLONE_ARGS[@]}"
  fi
done


# Backup home directory
printf "\n${red}${i}.${no_color} Backup home directory\n\n"
((i++))

mkdir -p "${BACKUP_DIR}/home"
if [ "$BACKUP_FULL" = "true" ]; then
  HOME_DIRS=(
    $HOME
  )
else 
  HOME_DIRS=(
    $HOME/dev
  )
fi

for dir in "${HOME_DIRS[@]}"; do
  [ -e "$dir" ] || continue
  rclone copy "$dir" "${BACKUP_DIR}/home/$(basename "$dir")" "${RCLONE_ARGS[@]}" "${RCLONE_FILTER_ARGS[@]}"
done

# Summary
printf "\n${red}Backup complete.${no_color}\n"
printf "  -> location: %s\n" "${BACKUP_DIR}"
printf "  -> size:     %s\n" "$(du -sh "${BACKUP_DIR}" | cut -f1)"
