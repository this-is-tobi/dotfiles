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
DRY_RUN="false"

# Declare script helper
TEXT_HELPER="\nThis script aims to copy importants files and directory before a restauration.
Following flags are available:

  -f    (Optional) Perform a full backup of the entire home directory (for personnal use).
        Default is '$BACKUP_FULL'.

  -n    (Optional) Dry run: show what would be copied without copying anything.
        Default is '$DRY_RUN'.

  -o    (Optional) Output directory.
        Default is '$(pwd)'.

  -h    Print script help.\n\n"

print_help() {
  printf '%s' "$TEXT_HELPER"
}

# Parse options
while getopts hfno: flag; do
  case "${flag}" in
    f)
      BACKUP_FULL="true";;
    n)
      DRY_RUN="true";;
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
[ "$DRY_RUN" = "true" ] && RCLONE_ARGS+=(--dry-run)

# Run an rclone command without letting a single failure (e.g. a stale
# symlink) abort the rest of the backup; failures are collected and reported
# in the final summary instead.
FAILED_ITEMS=()
safe_rclone() {
  if ! rclone "$@"; then
    FAILED_ITEMS+=("$*")
    printf "\n${red}Warning:${no_color} failed to back up (see above): %s\n\n" "$*" >&2
  fi
}

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
  -> full backup: ${red}${BACKUP_FULL}${no_color}
  -> dry run: ${red}${DRY_RUN}${no_color}\n"


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
  safe_rclone copyto "$src" "${BACKUP_DIR}/etc/$(basename "$src")" "${RCLONE_ARGS[@]}"
done


# Export gpg keys
printf "\n${red}${i}.${no_color} Export gpg keys\n\n"
((i++))

EMAIL="this-is-tobi@proton.me"
GPG_BACKUP_DIR="$HOME/.gnupg/backup"

KEY_ID=$(gpg --list-secret-keys --keyid-format=long "$EMAIL" 2>/dev/null | grep 'sec' | awk '{print $2}' | cut -d'/' -f2) || true

if [ -z "$KEY_ID" ]; then
  echo "No GPG key found for email: $EMAIL"
elif [ "$DRY_RUN" = "true" ]; then
  echo "Dry run: would export gpg key $KEY_ID to $GPG_BACKUP_DIR"
else
  mkdir -p "$GPG_BACKUP_DIR"
  chmod 700 "$GPG_BACKUP_DIR"

  gpg --export --armor "$KEY_ID" > "$GPG_BACKUP_DIR/public-key-$KEY_ID.asc"
  echo "Public gpg key saved to $GPG_BACKUP_DIR/public-key-$KEY_ID.asc"

  ( umask 077 && gpg --export-secret-keys --armor "$KEY_ID" > "$GPG_BACKUP_DIR/private-key-$KEY_ID.asc" )
  chmod 600 "$GPG_BACKUP_DIR/private-key-$KEY_ID.asc"
  echo "Private gpg key saved to $GPG_BACKUP_DIR/private-key-$KEY_ID.asc (mode 600)"

  echo "Backup completed for GPG key: $KEY_ID"
fi


# Backup dotfiles
printf "\n${red}${i}.${no_color} Backup dotfiles\n\n"
((i++))

DOT_FILES=(
  "$HOME/.aws"
  "$HOME/.claude"
  "$HOME/.config"
  "$HOME/.copilot"
  "$HOME/.docker"
  "$HOME/.gitconfig"
  "$HOME/.gnupg"
  "$HOME/.kube"
  "$HOME/.mc"
  "$HOME/.npmrc"
  "$HOME/.ssh"
  "$HOME/.tsh"
  "$HOME/.zshrc"
)
mkdir -p "${BACKUP_DIR}/dotfiles"
for src in "${DOT_FILES[@]}"; do
  [ -e "$src" ] || continue
  dest="${BACKUP_DIR}/dotfiles/$(basename "$src")"
  if [ -d "$src" ]; then
    case "$(basename "$src")" in
      .docker)
        safe_rclone copy "$src" "$dest" "${RCLONE_ARGS[@]}" "${RCLONE_FILTER_ARGS[@]}" \
          --exclude 'scout/**' \
          --exclude 'sbom/**' \
          --exclude 'scan/**' \
          --exclude 'desktop/**' \
          --exclude 'buildx/**' \
          --exclude 'mutagen/**' \
          --exclude 'run/**'
        ;;
      .kube)
        safe_rclone copy "$src" "$dest" "${RCLONE_ARGS[@]}" "${RCLONE_FILTER_ARGS[@]}" \
          --exclude 'cache/**' \
          --exclude 'http-cache/**'
        ;;
      .aws)
        safe_rclone copy "$src" "$dest" "${RCLONE_ARGS[@]}" "${RCLONE_FILTER_ARGS[@]}" \
          --exclude 'cli/cache/**' \
          --exclude 'sso/cache/**'
        ;;
      .claude)
        # keep settings, instructions, agents, skills, memory & conversation
        # history (projects/); drop caches, plugin installs, and other
        # regenerable/ephemeral state
        safe_rclone copy "$src" "$dest" "${RCLONE_ARGS[@]}" "${RCLONE_FILTER_ARGS[@]}" \
          --exclude 'cache/**' \
          --exclude 'shell-snapshots/**' \
          --exclude 'file-history/**' \
          --exclude 'backups/**' \
          --exclude 'ide/**' \
          --exclude 'plugins/**' \
          --exclude 'sessions/**'
        ;;
      .copilot)
        # pkg/ is copilot's own downloaded binaries/packages, not config
        safe_rclone copy "$src" "$dest" "${RCLONE_ARGS[@]}" "${RCLONE_FILTER_ARGS[@]}" \
          --exclude 'pkg/**' \
          --exclude 'ide/**' \
          --exclude 'session-state/**'
        ;;
      .config)
        safe_rclone copy "$src" "$dest" "${RCLONE_ARGS[@]}" "${RCLONE_FILTER_ARGS[@]}" \
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
        safe_rclone copy "$src" "$dest" "${RCLONE_ARGS[@]}" "${RCLONE_FILTER_ARGS[@]}"
        ;;
    esac
  else
    safe_rclone copyto "$src" "$dest" "${RCLONE_ARGS[@]}"
  fi
done


# Backup home directory
printf "\n${red}${i}.${no_color} Backup home directory\n\n"
((i++))

mkdir -p "${BACKUP_DIR}/home"
if [ "$BACKUP_FULL" = "true" ]; then
  HOME_DIRS=(
    "$HOME"
  )
else
  HOME_DIRS=(
    "$HOME/dev"
  )
fi

for dir in "${HOME_DIRS[@]}"; do
  [ -e "$dir" ] || continue
  safe_rclone copy "$dir" "${BACKUP_DIR}/home/$(basename "$dir")" "${RCLONE_ARGS[@]}" "${RCLONE_FILTER_ARGS[@]}"
done

# Summary
if [ "$DRY_RUN" = "true" ]; then
  printf "\n${red}Dry run complete.${no_color} Nothing was copied.\n"
  printf "  -> would have targeted: %s\n" "${BACKUP_DIR}"
else
  printf "\n${red}Backup complete.${no_color}\n"
  printf "  -> location: %s\n" "${BACKUP_DIR}"
  printf "  -> size:     %s\n" "$(du -sh "${BACKUP_DIR}" | cut -f1)"
fi

if [ "${#FAILED_ITEMS[@]}" -gt 0 ]; then
  printf "\n${red}Warning:${no_color} %d item(s) failed to back up (see warnings above):\n" "${#FAILED_ITEMS[@]}"
  for item in "${FAILED_ITEMS[@]}"; do
    printf "  -> %s\n" "$item"
  done
fi
