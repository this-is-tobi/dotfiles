#!/bin/bash
set -euo pipefail

# A backup holds keys, tokens and history: everything it creates is private to the user
umask 077

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'
# Console step increment
i=1

# Get Date
NOW=$(date +'%Y-%m-%dT%H-%M-%S')

# Operating system. backup-osx.sh and backup-debian.sh set it; run on its own,
# the script picks it from uname. Only the home directories of -f and the Brave
# profile depend on it.
if [ -z "${BACKUP_OS:-}" ]; then
  case "$(uname -s)" in
    Darwin) BACKUP_OS="osx";;
    Linux) BACKUP_OS="debian";;
  esac
fi
case "${BACKUP_OS:-}" in
  osx)
    OS_NAME="macOS"
    FULL_HOME_DIRS=(Desktop dev Documents Downloads Movies Music Pictures)
    FULL_HOME_DIRS_TEXT="Desktop, Documents, Downloads, Movies, Music and Pictures"
    # Outside ~/.config on macOS, so it has a step of its own
    BRAVE_PROFILE="$HOME/Library/Application Support/BraveSoftware/Brave-Browser/Default"
    ;;
  debian)
    OS_NAME="Debian/Ubuntu"
    FULL_HOME_DIRS=(Desktop dev Documents Downloads Music Pictures Videos)
    FULL_HOME_DIRS_TEXT="Desktop, Documents, Downloads, Music, Pictures and Videos"
    # ~/.config/BraveSoftware, copied with the rest of ~/.config
    BRAVE_PROFILE=""
    ;;
  *)
    printf "${red}Error:${no_color} unsupported system '%s': set BACKUP_OS to osx or debian\n" "${BACKUP_OS:-$(uname -s)}" >&2
    exit 1;;
esac

# Default
BACKUP_DIR="$(pwd)/backup_$NOW"
BACKUP_FULL="false"
DRY_RUN="false"
EXCLUDE_FILE="${BACKUP_EXCLUDE_FILE:-}"

# Declare script helper
TEXT_HELPER="\nThis script aims to copy important files and directories before a reinstall ($OS_NAME).
Following flags are available:

  -f    (Optional) Also back up $FULL_HOME_DIRS_TEXT,
        not only ~/dev (for personal use).
        Default is '$BACKUP_FULL'.

  -n    (Optional) Dry run: show what would be copied without copying anything.
        Default is '$DRY_RUN'.

  -o    (Optional) Output directory.
        Default is '$(pwd)'.

  -x    (Optional) File of extra rclone exclude patterns, one per line (e.g. 'ci/act/docker/**'),
        applied to every directory copy. Keeps personal junk out of this script.
        Default is the BACKUP_EXCLUDE_FILE environment variable ('${EXCLUDE_FILE:-unset}').

  -h    Print script help.

Exit status: 0 when everything was copied, 2 when the backup was written but some
items failed (it is incomplete, they are listed at the end), 1 on a usage error.\n\n"

print_help() {
  printf '%b' "$TEXT_HELPER"
}

# Parse options
while getopts hfno:x: flag; do
  case "${flag}" in
    f)
      BACKUP_FULL="true";;
    n)
      DRY_RUN="true";;
    o)
      BACKUP_DIR="${OPTARG}/backup_$NOW";;
    x)
      EXCLUDE_FILE="${OPTARG}";;
    h)
      print_help
      exit 0;;
    *)
      print_help
      exit 1;;
  esac
done

BACKUP_DIR="${BACKUP_DIR%/}"

if [ -n "$EXCLUDE_FILE" ] && [ ! -f "$EXCLUDE_FILE" ]; then
  printf "${red}Error:${no_color} exclude file not found: %s\n" "$EXCLUDE_FILE" >&2
  exit 1
fi

# rclone args
RCLONE_ARGS=(
  --transfers 12
  --checkers 24
  --no-check-dest
  --copy-links
  --progress
)
[ "$DRY_RUN" = "true" ] && RCLONE_ARGS+=(--dry-run)

# mkdir that does nothing in a dry run, so -n leaves no empty directories behind
make_dir() {
  [ "$DRY_RUN" = "true" ] || mkdir -p "$1"
}

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

# Write a gpg export to a temp file and rename it once gpg succeeded: gpg fails
# when pinentry cannot ask for the passphrase (cron, launchd), and that must
# neither leave an empty key file that looks like a backup nor stop the run.
# The failure is collected like a failed copy.
GPG_TMP=""
trap '[ -z "$GPG_TMP" ] || rm -f -- "$GPG_TMP"' EXIT
gpg_export() {
  local label="$1" dest="$2"
  shift 2
  GPG_TMP=$(mktemp "${dest%/*}/.export.XXXXXX")
  if gpg "$@" > "$GPG_TMP" && [ -s "$GPG_TMP" ]; then
    mv -f -- "$GPG_TMP" "$dest"
    GPG_TMP=""
    echo "$label saved to $dest (mode 600)"
  else
    rm -f -- "$GPG_TMP"
    GPG_TMP=""
    FAILED_ITEMS+=("gpg $*")
    printf "\n${red}Warning:${no_color} failed to export (see above): gpg %s\n\n" "$*" >&2
  fi
}

# rclone filter args (directory copies only — rclone copyto does not accept filters)
RCLONE_FILTER_ARGS=(
  # OS metadata
  --exclude '.DS_Store'
  --exclude 'Thumbs.db'
  --exclude '*.tmp'
  --exclude '*.log'
  # earlier backups, and the one being written when it sits inside a source
  --exclude 'backup_*/**'
  # regenerable caches
  --exclude '.cache/**'
  --exclude '.local/share/mise/**'
  # JS / Node
  --exclude 'node_modules/**'
  --exclude '.turbo/**'
  --exclude '.angular/**'
  --exclude '.svelte-kit/**'
  --exclude '.output/**'
  # Python
  --exclude '__pycache__/**'
  --exclude '*.pyc'
  --exclude '.venv/**'
  --exclude 'venv/**'
  --exclude '.pytest_cache/**'
  --exclude '.mypy_cache/**'
  --exclude '.ruff_cache/**'
  --exclude '.tox/**'
  # Infrastructure as code (providers and modules come back with init)
  --exclude '.terraform/**'
  --exclude '.terragrunt-cache/**'
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
if [ -n "$EXCLUDE_FILE" ]; then
  RCLONE_FILTER_ARGS+=(--exclude-from "$EXCLUDE_FILE")
fi

# Settings
printf "\nScript settings:
  -> backup target dir: ${red}${BACKUP_DIR}${no_color}
  -> full backup: ${red}${BACKUP_FULL}${no_color}
  -> dry run: ${red}${DRY_RUN}${no_color}\n"
[ -z "$EXCLUDE_FILE" ] || printf "  -> extra excludes: ${red}${EXCLUDE_FILE}${no_color}\n"


# Backup /etc files
printf "\n${red}${i}.${no_color} Backup /etc files\n\n"
((i++))

ETC_FILES=(
  /etc/hosts
  /etc/resolv.conf
)
make_dir "${BACKUP_DIR}/etc"
for src in "${ETC_FILES[@]}"; do
  [ -e "$src" ] || continue
  safe_rclone copyto "$src" "${BACKUP_DIR}/etc/$(basename "$src")" "${RCLONE_ARGS[@]}"
done


# Export gpg keys
printf "\n${red}${i}.${no_color} Export gpg keys\n\n"
((i++))

# BACKUP_GPG_EMAIL picks the keys to export; it defaults to the git identity of this machine
EMAIL="${BACKUP_GPG_EMAIL:-$(git config --get user.email 2>/dev/null || true)}"
# Straight into the backup rather than ~/.gnupg: no extra copy of the private
# key stays on the machine, and each run writes its own files, so a failed
# export never touches the one an earlier backup holds
GPG_BACKUP_DIR="${BACKUP_DIR}/gpg"

if [ -z "$EMAIL" ]; then
  echo "No GPG key to export (no email: set BACKUP_GPG_EMAIL or git user.email)"
elif ! command -v gpg >/dev/null 2>&1; then
  echo "No GPG key to export (gpg is not installed)"
else
  # Long key IDs of the primary secret keys (field 5 of "sec" records). Every
  # match is exported: an older key kept to decrypt old data belongs in the
  # backup as much as the current one.
  KEY_IDS=()
  while IFS= read -r key_id; do
    if [ -n "$key_id" ]; then
      KEY_IDS+=("$key_id")
    fi
  done < <(gpg --list-secret-keys --with-colons -- "$EMAIL" 2>/dev/null | awk -F: '$1 == "sec" { print $5 }')

  if [ "${#KEY_IDS[@]}" -eq 0 ]; then
    echo "No GPG key to export (no secret key for: $EMAIL)"
  elif [ "$DRY_RUN" = "true" ]; then
    echo "Dry run: would export gpg key(s) ${KEY_IDS[*]} to $GPG_BACKUP_DIR"
  else
    if [ "${#KEY_IDS[@]}" -gt 1 ]; then
      echo "${#KEY_IDS[@]} secret keys match $EMAIL, exporting each of them"
    fi
    mkdir -p "$GPG_BACKUP_DIR"
    for key_id in "${KEY_IDS[@]}"; do
      gpg_export "Public gpg key" "$GPG_BACKUP_DIR/public-key-$key_id.asc" --export --armor "$key_id"
      gpg_export "Private gpg key" "$GPG_BACKUP_DIR/private-key-$key_id.asc" --export-secret-keys --armor "$key_id"
    done
  fi
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
make_dir "${BACKUP_DIR}/dotfiles"
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


# Backup rta secrets store (only the encrypted store: kv.age and who can open it)
RTA_DATA="${RTA_DATA_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/rta}"
if [ -f "$RTA_DATA/kv.age" ]; then
  printf "\n${red}${i}.${no_color} Backup rta secrets store\n\n"
  ((i++))

  make_dir "${BACKUP_DIR}/rta"
  for name in kv.age kv.recipients; do
    [ -e "$RTA_DATA/$name" ] || continue
    safe_rclone copyto "$RTA_DATA/$name" "${BACKUP_DIR}/rta/$name" "${RCLONE_ARGS[@]}"
  done
fi


# Backup home directory
printf "\n${red}${i}.${no_color} Backup home directory\n\n"
((i++))

make_dir "${BACKUP_DIR}/home"
if [ "$BACKUP_FULL" = "true" ]; then
  HOME_DIRS=("${FULL_HOME_DIRS[@]}")
else
  HOME_DIRS=(dev)
fi

for dir in "${HOME_DIRS[@]}"; do
  [ -e "$HOME/$dir" ] || continue
  safe_rclone copy "$HOME/$dir" "${BACKUP_DIR}/home/$dir" "${RCLONE_ARGS[@]}" "${RCLONE_FILTER_ARGS[@]}"
done


# Backup brave
if [ -n "$BRAVE_PROFILE" ] && [ -d "$BRAVE_PROFILE" ]; then
  printf "\n${red}${i}.${no_color} Backup brave files\n\n"
  ((i++))

  make_dir "${BACKUP_DIR}/brave"
  safe_rclone copy "$BRAVE_PROFILE" \
    "${BACKUP_DIR}/brave/Default" "${RCLONE_ARGS[@]}" "${RCLONE_FILTER_ARGS[@]}" \
    --exclude 'Cache/**' \
    --exclude 'Code Cache/**' \
    --exclude 'GPUCache/**' \
    --exclude 'DawnCache/**' \
    --exclude 'Crashpad/**' \
    --exclude 'Service Worker/CacheStorage/**' \
    --exclude 'Service Worker/ScriptCache/**'
fi

# Summary
if [ "$DRY_RUN" = "true" ]; then
  printf "\n${red}Dry run complete.${no_color} Nothing was copied.\n"
  printf "  -> would have targeted: %s\n" "${BACKUP_DIR}"
else
  chmod 700 "${BACKUP_DIR}"
  if [ "${#FAILED_ITEMS[@]}" -gt 0 ]; then
    printf "\n${red}Backup incomplete.${no_color}\n"
  else
    printf "\n${red}Backup complete.${no_color}\n"
  fi
  printf "  -> not encrypted: it holds keys and tokens, keep it private\n"
  printf "  -> location: %s\n" "${BACKUP_DIR}"
  printf "  -> size:     %s\n" "$(du -sh "${BACKUP_DIR}" | cut -f1)"
fi

if [ "${#FAILED_ITEMS[@]}" -gt 0 ]; then
  printf "\n${red}Warning:${no_color} %d item(s) failed to back up (see warnings above):\n" "${#FAILED_ITEMS[@]}"
  for item in "${FAILED_ITEMS[@]}"; do
    printf "  -> %s\n" "$item"
  done
  # Not 0, so that "backup && sync" does not push an incomplete backup, and not
  # 1, which is a usage error or a run that stopped
  exit 2
fi
