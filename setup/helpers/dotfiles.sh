#!/bin/bash

# Copy the dotfiles of the repository into the home directory and configure the
# tools that use them: the -d step of the setup scripts.
#
# Usage: dotfiles.sh [<editor cli>:<editor user directory>]...
#   Each argument is a VS Code flavour to configure when its CLI is on PATH, e.g.
#   "code:$HOME/Library/Application Support/Code/User" on macOS, and
#   "code:$HOME/.config/Code/User" "code-server:$HOME/.local/share/code-server/User" on Linux.
#
# Whatever a copy would replace is saved under $DOTFILES_BACKUP_DIR first (see files.sh).

set -eo pipefail

HELPER_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 && pwd -P )"
DOTFILES_PATH="$(cd "$HELPER_PATH/../.." && pwd -P)/dotfiles"

# shellcheck source-path=SCRIPTDIR source=files.sh
. "$HELPER_PATH/files.sh"
# shellcheck source-path=SCRIPTDIR source=remote.sh
. "$HELPER_PATH/remote.sh"
# shellcheck source-path=SCRIPTDIR source=run.sh
. "$HELPER_PATH/run.sh"


install_file "$DOTFILES_PATH/.zshrc" "$HOME/.zshrc"
install_file "$DOTFILES_PATH/.oh-my-zsh/this-is-tobi.zsh-theme" "$HOME/.oh-my-zsh/custom/themes/this-is-tobi.zsh-theme"
# Keep the identity and signing settings of the current ~/.gitconfig in
# ~/.gitconfig.local before it is replaced
run "$HELPER_PATH/gitconfig.sh"
install_file "$DOTFILES_PATH/.gitconfig" "$HOME/.gitconfig"
install_tree "$DOTFILES_PATH/.continue" "$HOME/.continue"

# Create secrets.env before the copy below replaces env.sh, so that values a
# previous env.sh held are moved there instead of being lost.
run "$HELPER_PATH/secrets.sh"
# Copies .config/mise/conf.d/00-settings.toml among the rest. It is kept in
# conf.d/ rather than config.toml precisely so that re-running this step does
# not clobber the tool versions the profiles pinned via `mise use --global`.
install_tree "$DOTFILES_PATH/.config" "$HOME/.config"


# Install the eslint fallback config, used where a project has none. npm ci
# installs the exact versions of the committed package-lock.json, without
# running the install scripts of the dependencies. It is skipped when
# node_modules was installed from that same lockfile.
install_eslint_dependencies() (
  cd "$HOME/.config/eslint-fallback"
  npm ci --ignore-scripts --no-audit --no-fund --loglevel=error
  cp package-lock.json node_modules/.dotfiles-package-lock.json
)
install_file "$DOTFILES_PATH/eslint.config.mjs" "$HOME/eslint.config.mjs"
if [ -x "$(command -v npm)" ]; then
  eslint_dir="$HOME/.config/eslint-fallback"
  if ! cmp -s "$eslint_dir/package-lock.json" "$eslint_dir/node_modules/.dotfiles-package-lock.json"; then
    run install_eslint_dependencies
  fi
fi


# Install .vscode configs, for each editor given as argument that is installed.
# The settings are merged (vscode-settings.sh) and their __HOME__ placeholders
# point to this home directory.
for editor in "$@"; do
  cli="${editor%%:*}"
  user_dir="${editor#*:}"
  [ -x "$(command -v "$cli")" ] || continue
  vscode_settings="$(mktemp)"
  sed "s|__HOME__|$HOME|g" "$DOTFILES_PATH/.vscode/settings.json" > "$vscode_settings"
  "$HELPER_PATH/vscode-settings.sh" "$vscode_settings" "$user_dir/settings.json" "$DOTFILES_PATH/.vscode/settings-retired.json"
  rm -f "$vscode_settings"
  install_file "$DOTFILES_PATH/.vscode/mcp.json" "$user_dir/mcp.json"
  run "$HELPER_PATH/vscode-extensions.sh" "$cli" "$DOTFILES_PATH/.vscode/extensions.json"
done


# Install .claude config
run mkdir -p "$HOME/.claude"
# rtk writes RTK.md and its CLAUDE.md reference. --no-patch leaves settings.json
# alone: the repository's settings carry the rtk hook (a no-op without rtk), and
# the bare hook --auto-patch adds would be dropped by the merge below on every
# run, with a backup each time. Its stdout only repeats that hook as a manual step.
if [ -x "$(command -v rtk)" ]; then
  if dry_run; then
    run rtk init -g --no-patch
  else
    rtk init -g --no-patch > /dev/null
  fi
fi
# Merged, not copied: Claude Code and /plugin write into this file too. The repository
# owns hooks, attribution, plugins and the deny rules; the rest stays as it is.
"$HELPER_PATH/claude-settings.sh" "$DOTFILES_PATH/.claude/settings.json"


# Install AI agent instructions & skills (Copilot + Claude Code personal setup)
# -P installs Claude Code plugins at user scope (and registers them in the settings.json merged above).
run_remote bash "$TOOLS_RAW_BASE/shell/setup-ai-agent.sh" -t claude -g -P
run_remote bash "$TOOLS_RAW_BASE/shell/setup-ai-agent.sh" -t copilot -g -c


# Configure Claude Code MCP servers
if [ -x "$(command -v claude)" ]; then
  run "$HELPER_PATH/claude-mcp.sh"
fi
