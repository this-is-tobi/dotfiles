#!/bin/bash
# shellcheck source-path=SCRIPTDIR
set -euo pipefail

# Debian/Ubuntu entry point, with the same flags as backup.sh (see -h). The
# backup itself is backup.sh, shared with macOS. It runs in this shell, so
# "bash -x backup-debian.sh" traces it too.

# backup.sh sits next to the real file, also when this one is run through a symlink
src="${BASH_SOURCE[0]}"
while [ -L "$src" ]; do
  link="$(readlink "$src")"
  case "$link" in
    /*) src="$link";;
    *) src="$(dirname "$src")/$link";;
  esac
done

# Read by backup.sh
# shellcheck disable=SC2034
BACKUP_OS="debian"
# shellcheck source=backup.sh
. "$(dirname "$src")/backup.sh"
