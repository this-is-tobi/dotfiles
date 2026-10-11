#!/bin/bash

# Merge the repository's Claude Code settings into ~/.claude/settings.json.
#
# Usage: claude-settings.sh <path to dotfiles/.claude/settings.json>
#
# Claude Code and its commands (/config, /model, /plugin, rtk init, ...) write
# into that file too, so it is merged instead of overwritten:
#   - policy keys come from the repository and win: hooks, attribution,
#     extraKnownMarketplaces, enabledPlugins and permissions. Their lists are
#     unioned with what is already there, so rules and hooks added locally stay.
#   - every other key (effortLevel, ...) is only a default: it is applied when
#     the file does not set it, so a personal choice is never reset.
# A file that is not a JSON object is replaced by the repository's. Either way the
# result goes through install_file, which backs the previous file up when it
# changes anything.

set -eo pipefail

HELPER_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 && pwd -P )"
# shellcheck source-path=SCRIPTDIR source=files.sh
. "$HELPER_PATH/files.sh"

REPO_SETTINGS="${1:?usage: claude-settings.sh <repository settings.json>}"
LIVE_SETTINGS="$HOME/.claude/settings.json"

if [ ! -s "$LIVE_SETTINGS" ]; then
  install_file "$REPO_SETTINGS" "$LIVE_SETTINGS"
  exit 0
fi

# A file jq cannot read would stop the merge, and the setup with it: replace it (it is saved first)
if ! jq -e 'type == "object"' "$LIVE_SETTINGS" >/dev/null 2>&1; then
  printf "  %s is not a valid JSON object, replacing it with the repository settings\n" "$LIVE_SETTINGS" >&2
  install_file "$REPO_SETTINGS" "$LIVE_SETTINGS"
  exit 0
fi

merged="$(mktemp)"
trap 'rm -f "$merged"' EXIT

jq -s '
  def dedupe: reduce .[] as $item ([]; if index([$item]) then . else . + [$item] end);
  def list: if type == "array" then . else [] end;

  .[0] as $live
  | .[1] as $repo
  | ($repo | with_entries(select(.key | IN("hooks", "attribution", "extraKnownMarketplaces", "enabledPlugins", "permissions")))) as $policy
  | ($repo | with_entries(select(.key | IN("hooks", "attribution", "extraKnownMarketplaces", "enabledPlugins", "permissions") | not))) as $defaults
  | $defaults * $live * $policy
  | if $policy.permissions.deny
      then .permissions.deny = (((($live.permissions?.deny? // []) | list) + $policy.permissions.deny) | dedupe)
      else . end
  | if $policy.hooks.PreToolUse
      then .hooks.PreToolUse = (((($live.hooks?.PreToolUse? // []) | list) + $policy.hooks.PreToolUse) | dedupe)
      else . end
' "$LIVE_SETTINGS" "$REPO_SETTINGS" > "$merged"

install_file "$merged" "$LIVE_SETTINGS"
