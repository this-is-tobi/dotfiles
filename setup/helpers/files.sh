#!/bin/bash
# Shared file helpers - sourced (not executed) by the setup scripts.
#
# Copies never silently destroy what is already on the machine: a destination
# whose content differs from the source is first saved under
# $DOTFILES_BACKUP_DIR (one private directory per run, created on first use),
# mirroring its path relative to $HOME. Identical files are left untouched, so
# re-running the setup creates no backups.

# Exported: the helpers that run as child processes (vscode-settings.sh,
# claude-settings.sh) source this file too, and must back up into the same
# directory instead of creating one of their own.
export DOTFILES_BACKUP_DIR="${DOTFILES_BACKUP_DIR:-$HOME/.dotfiles-backup/$(date +%Y%m%d%H%M%S)}"

# Save a file under the backup directory, keeping its path relative to $HOME.
backup_file() {
  local file="$1" rel
  [ -e "$file" ] || return 0
  rel="${file#"$HOME"/}"
  rel="${rel#/}"
  (umask 077 && mkdir -p "$DOTFILES_BACKUP_DIR/$(dirname "$rel")")
  cp -p "$file" "$DOTFILES_BACKUP_DIR/$rel"
}

# lines_lost <old> <new>: how many distinct lines of the text file <old> the file
# <new> does not have. Binary files count as 0.
lines_lost() {
  local old="$1" new="$2"
  grep -Iq . "$old" 2>/dev/null || { echo 0; return 0; }
  LC_ALL=C comm -23 \
    <(LC_ALL=C sort -u "$old" | grep -vE '^[[:space:]]*$' || true) \
    <(LC_ALL=C sort -u "$new" | grep -vE '^[[:space:]]*$' || true) | wc -l | tr -d ' '
}

# install_file <src> <dst>: copy src over dst, backing dst up first if it differs.
# A dst that already is src (a symlink into the repository) or has the same
# content is left alone.
#
# The copy is written to a temporary file next to dst, then renamed over it: dst
# is never half-written, and a dst that is a symlink is replaced by the file
# instead of being written through (the file it points to is left as it was,
# and its content is what gets backed up). An existing dst keeps its mode.
install_file() {
  local src="$1" dst="$2" dir tmp lost
  dir="$(dirname "$dst")"
  mkdir -p "$dir"
  if [ "$src" -ef "$dst" ]; then
    return 0
  fi
  if [ -d "$dst" ]; then
    printf "Error: %s is a directory, not replacing it with %s\n" "$dst" "$src" >&2
    return 1
  fi
  if [ -e "$dst" ]; then
    cmp -s "$src" "$dst" && return 0
    lost="$(lines_lost "$dst" "$src")"
    backup_file "$dst"
    if [ "$lost" -gt 0 ]; then
      printf "  backed up %s to %s (%s lines it had are not in the new file)\n" "$dst" "$DOTFILES_BACKUP_DIR" "$lost"
    else
      printf "  backed up %s to %s\n" "$dst" "$DOTFILES_BACKUP_DIR"
    fi
    if [ -L "$dst" ]; then
      printf "  %s was a symlink to %s: it becomes a regular file, the file it pointed to is not changed\n" "$dst" "$(readlink "$dst")"
    fi
  fi
  tmp="$(mktemp "$dir/.$(basename "$dst").XXXXXX")" || return 1
  # cp -p gives the temporary file the mode of dst (or of src for a new file),
  # then cat puts the content of src in it
  if [ -e "$dst" ]; then
    cp -p "$dst" "$tmp" && cat "$src" > "$tmp"
  else
    cp -p "$src" "$tmp"
  fi && mv -f "$tmp" "$dst" || {
    rm -f "$tmp"
    printf "Error: could not install %s\n" "$dst" >&2
    return 1
  }
}

# install_tree <src_dir> <dst_dir>: install_file for every file under src_dir.
# The directory is created even when it is empty, and node_modules is skipped.
install_tree() {
  local src_dir="$1" dst_dir="$2" file
  mkdir -p "$dst_dir"
  while IFS= read -r -d '' file; do
    file="${file#./}"
    install_file "$src_dir/$file" "$dst_dir/$file"
  done < <(cd "$src_dir" && find . -type f -not -path '*/node_modules/*' -print0)
}
