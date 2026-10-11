#!/bin/bash

# Install the extensions listed in extensions.json that the editor does not have yet.
#
# Usage: vscode-extensions.sh <editor cli (code, code-server)> <path to extensions.json>
#
# The editor is asked for its installed extensions once, so a re-run does not start
# the CLI for every extension that is already there. One that fails to install prints
# a warning and the next one is tried.

set -eo pipefail

HELPER_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 && pwd -P )"
# shellcheck source-path=SCRIPTDIR source=jsonc.sh
. "$HELPER_PATH/jsonc.sh"

CLI="${1:?usage: vscode-extensions.sh <editor cli> <extensions.json>}"
EXTENSIONS_FILE="${2:?usage: vscode-extensions.sh <editor cli> <extensions.json>}"

# Extension ids are case-insensitive
installed="$("$CLI" --list-extensions 2>/dev/null | tr '[:upper:]' '[:lower:]' || true)"

added=0
present=0

while IFS= read -r extension; do
  if printf '%s\n' "$installed" | grep -qxF -- "$(printf '%s' "$extension" | tr '[:upper:]' '[:lower:]')"; then
    present=$((present + 1))
    continue
  fi
  if "$CLI" --install-extension "$extension" < /dev/null; then
    added=$((added + 1))
  else
    printf "Warning: could not install the %s extension %s\n" "$(basename "$CLI")" "$extension" >&2
  fi
done < <(jsonc_to_json "$EXTENSIONS_FILE" | jq -r '.recommendations[]')

printf "%s extensions: %d installed, %d already present\n" "$(basename "$CLI")" "$added" "$present"
