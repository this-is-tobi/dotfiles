#!/bin/bash
# Shared helpers for running remote scripts - sourced (not executed) by the
# setup scripts.

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
