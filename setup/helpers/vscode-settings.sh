#!/bin/bash

# Merge the repository's VS Code settings into the user's settings.json.
#
# Usage: vscode-settings.sh <repository settings.json> <settings.json to update> [retired settings.json]
#
# VS Code writes into that file too: every "always allow" for a command or a URL,
# the models picked in the chat, the trusted JSON schema domains. Copying the
# repository file over it would drop all of that, so the two are merged instead:
#   - a key the repository sets wins, and objects are merged key by key (the rules
#     of an auto-approve list you added stay next to the repository's).
#   - every other key of the file is kept as it is.
#   - the optional third file lists settings to delete first, as JSONC paths such as
#     [["chat.tools.terminal.autoApprove", "timeout"], ["some.removed.setting"]]. It
#     retires what the repository no longer wants (a removed setting, an approval
#     that was too broad): a key that is only dropped from the repository would
#     otherwise stay in every user's file for good.
# The file is left untouched when the merge changes nothing. When it does change,
# the previous file is saved by install_file and the result is plain JSON: the
# comments of the repository file stay in the repository.

set -eo pipefail

HELPER_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 && pwd -P )"
# shellcheck source-path=SCRIPTDIR source=files.sh
. "$HELPER_PATH/files.sh"
# shellcheck source-path=SCRIPTDIR source=jsonc.sh
. "$HELPER_PATH/jsonc.sh"

REPO_SETTINGS="${1:?usage: vscode-settings.sh <repository settings.json> <settings.json to update>}"
LIVE_SETTINGS="${2:?usage: vscode-settings.sh <repository settings.json> <settings.json to update>}"
RETIRED_SETTINGS="${3:-}"

if [ ! -s "$LIVE_SETTINGS" ]; then
  install_file "$REPO_SETTINGS" "$LIVE_SETTINGS"
  exit 0
fi

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

# A file that cannot be read as JSONC is replaced (and saved first) instead of merged
if ! jsonc_to_json "$LIVE_SETTINGS" | jq -e 'type == "object"' >/dev/null 2>&1; then
  printf "  %s is not valid JSONC, replacing it with the repository settings\n" "$LIVE_SETTINGS" >&2
  install_file "$REPO_SETTINGS" "$LIVE_SETTINGS"
  exit 0
fi

jsonc_to_json "$LIVE_SETTINGS" > "$work/live.json"
jsonc_to_json "$REPO_SETTINGS" > "$work/repo.json"
if [ -n "$RETIRED_SETTINGS" ] && [ -s "$RETIRED_SETTINGS" ]; then
  jsonc_to_json "$RETIRED_SETTINGS" > "$work/retired.json"
  jq --slurpfile retired "$work/retired.json" 'delpaths($retired[0])' "$work/live.json" > "$work/live-kept.json"
else
  cp "$work/live.json" "$work/live-kept.json"
fi
jq -s --indent 2 '.[0] * .[1]' "$work/live-kept.json" "$work/repo.json" > "$work/merged.json"

# Same content as the current file (comments aside): leave it, and its comments, alone
if [ "$(jq -S . "$work/live.json")" = "$(jq -S . "$work/merged.json")" ]; then
  exit 0
fi

install_file "$work/merged.json" "$LIVE_SETTINGS"
