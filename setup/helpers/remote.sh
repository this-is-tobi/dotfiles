#!/bin/bash
# Shared helpers for running remote scripts - sourced (not executed) by the
# setup scripts.

# shellcheck source=run.sh
. "$(dirname "${BASH_SOURCE[0]}")/run.sh"

# Base URL of the author's tools repository. Override TOOLS_REF with a tag or a
# commit SHA to pin what the setup runs; it follows main by default because the
# repository publishes no single release tag.
# shellcheck disable=SC2034 # used by the scripts that source this file
TOOLS_RAW_BASE="https://raw.githubusercontent.com/this-is-tobi/tools/${TOOLS_REF:-main}"

# run_remote <interpreter> <url> [args...]: download a script, then run it.
#
# Unlike `curl | bash`, the script only runs once the whole download succeeded
# (-f also fails on HTTP errors), so a dropped connection can never execute a
# truncated script.
run_remote() {
  local interpreter="$1" url="$2" tmp status=0
  shift 2
  if dry_run; then
    printf "[dry-run] download %s, then run it: %s <script>" "$url" "$interpreter"
    [ $# -eq 0 ] || printf " %q" "$@"
    printf "\n"
    return 0
  fi
  tmp="$(mktemp)"
  if ! curl -fsSL "$url" -o "$tmp"; then
    rm -f "$tmp"
    printf "Error: could not download %s\n" "$url" >&2
    return 1
  fi
  "$interpreter" "$tmp" "$@" || status=$?
  rm -f "$tmp"
  return "$status"
}

# sha256_of <file>: print the sha256 of a file (sha256sum on Debian, shasum on macOS).
sha256_of() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | cut -d ' ' -f 1
  else
    shasum -a 256 "$1" | cut -d ' ' -f 1
  fi
}

# fetch_verified <url> <sha256> <file>: download url to file (mode 644), only
# when the download has the expected sha256. Otherwise file is left as it was.
#
# For files fetched from a pinned version: a moved tag or a rewritten file is
# refused instead of being installed.
fetch_verified() {
  local url="$1" expected="$2" file="$3" tmp actual
  tmp="$(mktemp "$(dirname "$file")/.$(basename "$file").XXXXXX")"
  if ! curl -fsSL "$url" -o "$tmp"; then
    rm -f "$tmp"
    printf "Error: could not download %s\n" "$url" >&2
    return 1
  fi
  actual="$(sha256_of "$tmp")"
  if [ "$actual" != "$expected" ]; then
    rm -f "$tmp"
    printf "Error: %s does not have the expected sha256 (expected %s, got %s)\n" "$url" "$expected" "$actual" >&2
    return 1
  fi
  chmod 644 "$tmp"
  mv -f "$tmp" "$file"
}
