#!/bin/bash

set -eo pipefail

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'

# Console step increment
i=1

# Get project directories
SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# Profiles, helpers and dotfiles are read from the repository next to this script
if [ ! -f "$SCRIPT_PATH/helpers/files.sh" ]; then
  printf "Error: this script needs the rest of the repository (helpers/, profiles/, dotfiles/). Clone it and run the script from the clone.\n" >&2
  exit 1
fi

# shellcheck source=helpers/files.sh
. "$SCRIPT_PATH/helpers/files.sh"
# shellcheck source=helpers/remote.sh
. "$SCRIPT_PATH/helpers/remote.sh"
# shellcheck source=helpers/apt.sh
. "$SCRIPT_PATH/helpers/apt.sh"

# Default
INSTALL_AI="false"
INSTALL_BASE="false"
INSTALL_DEVOPS="false"
INSTALL_GO="false"
INSTALL_JS="false"
INSTALL_SECOPS="false"
INSTALL_COMPLETIONS="false"
COPY_DOTFILES="false"
FULL_MODE_SETUP="true"
DRY_RUN="false"

# Declare script helper
TEXT_HELPER="\nThis script aims to install a full setup for debian.
Following flags are available:

  -c    Install cli completions.

  -d    Copy dotfiles.

  -l    Run with lite mode, only major tools will be installed.

  -n    Dry run: print resolved settings and exit without installing anything.

  -p    Install additional packages according to the given profile, available profiles are :
          -> 'ai'
          -> 'base'
          -> 'devops'
          -> 'go'
          -> 'js'
          -> 'secops'
        Default is no profile, this flag can be used with a CSV list (ex: -p \"base,js\").

  -r    Deprecated and ignored: temporary files are removed by the scripts that create them.

  -h    Print script help.\n\n"

print_help() {
  printf "$TEXT_HELPER"
}

# Parse options
while getopts hcdlnp:r flag; do
  case "${flag}" in
    c)
      INSTALL_COMPLETIONS="true";;
    d)
      COPY_DOTFILES="true";;
    l)
      FULL_MODE_SETUP="false";;
    n)
      DRY_RUN="true";;
    p)
      IFS=',' read -ra PROFILES <<< "$OPTARG"
      for profile in "${PROFILES[@]}"; do
        case "$profile" in
          ai) INSTALL_AI="true";;
          base) INSTALL_BASE="true";;
          devops) INSTALL_DEVOPS="true";;
          go) INSTALL_GO="true";;
          js) INSTALL_JS="true";;
          secops) INSTALL_SECOPS="true";;
          *)
            printf "Error: unknown profile '%s'. Valid profiles: ai, base, devops, go, js, secops\n" "$profile" >&2
            exit 1;;
        esac
      done;;
    r)
      printf "Note: -r is deprecated and ignored, temporary files are always cleaned up.\n" >&2;;
    h | *)
      print_help
      exit 0;;
  esac
done


# Settings
printf "\nScript settings:
  -> install ${red}full setup${no_color}: ${red}$FULL_MODE_SETUP${no_color}
  -> install ${red}[ai]${no_color} profile: ${red}$INSTALL_AI${no_color}
  -> install ${red}[base]${no_color} profile: ${red}$INSTALL_BASE${no_color}
  -> install ${red}[devops]${no_color} profile: ${red}$INSTALL_DEVOPS${no_color}
  -> install ${red}[go]${no_color} profile: ${red}$INSTALL_GO${no_color}
  -> install ${red}[js]${no_color} profile: ${red}$INSTALL_JS${no_color}
  -> install ${red}[secops]${no_color} profile: ${red}$INSTALL_SECOPS${no_color}
  -> copy ${red}dotfiles${no_color}: ${red}$COPY_DOTFILES${no_color}
  -> install ${red}cli completions${no_color}: ${red}$INSTALL_COMPLETIONS${no_color}\n"

if [[ "$DRY_RUN" = "true" ]]; then
  printf "\n${red}Dry run:${no_color} exiting without installing anything.\n"
  exit 0
fi

export FULL_MODE_SETUP=$FULL_MODE_SETUP

# Tools installed by the profiles (mise shims, ~/.local/bin) must be visible to
# every later step, whichever profiles run.
export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$PATH"

# sudo is used throughout. A root shell on a minimal image (a container, a fresh
# VM) may not have it yet; anyone else has to install it first.
if ! command -v sudo >/dev/null 2>&1; then
  if [ "$(id -u)" -eq 0 ]; then
    apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y sudo
  else
    printf "Error: sudo is required but not installed. Install it as root first (apt install sudo).\n" >&2
    exit 1
  fi
fi

# Install common
printf "\n${red}${i}.${no_color} Install commons\n\n"
i=$(($i + 1))
apt_install \
  build-essential \
  ca-certificates \
  curl \
  git \
  gzip \
  gnupg \
  jq \
  locales \
  sed \
  tar \
  unzip \
  wget \
  xz-utils

# Uncomment en_US.UTF-8 for inclusion in generation and generate locales
sudo sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen
sudo locale-gen

# Install zsh
if [ ! -x "$(command -v zsh)" ]; then
  printf "\n${red}${i}.${no_color} Install zsh\n\n"
  apt_install zsh
fi

# Make zsh the default shell
if [[ ! "${SHELL:-}" =~ "zsh" ]]; then
  printf "\n${red}${i}.${no_color} Make zsh the default shell\n\n"
  sudo chsh -s "$(command -v zsh)" "${USER:-$(id -un)}"
fi

# Install oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  printf "\n${red}${i}.${no_color} Install oh-my-zsh\n\n"
  i=$(($i + 1))

  # --unattended: the installer would otherwise switch the login shell and
  # `exec zsh`, which ends this script right there. KEEP_ZSHRC leaves an
  # existing ~/.zshrc alone (the dotfiles step replaces it, with a backup).
  KEEP_ZSHRC=yes run_remote sh "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/${OMZ_REF:-master}/tools/install.sh" --unattended
fi


# Install base profile
if [[ "$INSTALL_BASE" = "true" ]]; then
  printf "\n${red}${i}.${no_color} Install base profile\n\n"
  i=$(($i + 1))

  "$SCRIPT_PATH/profiles/debian/setup-base.sh"
fi


# Install devops profile
if [[ "$INSTALL_DEVOPS" = "true" ]]; then
  printf "\n${red}${i}.${no_color} Install devops profile\n\n"
  i=$(($i + 1))

  "$SCRIPT_PATH/profiles/debian/setup-devops.sh"
fi


# Install secops profile
if [[ "$INSTALL_SECOPS" = "true" ]]; then
  printf "\n${red}${i}.${no_color} Install secops profile\n\n"
  i=$(($i + 1))

  "$SCRIPT_PATH/profiles/debian/setup-secops.sh"
fi


# Install go profile
if [[ "$INSTALL_GO" = "true" ]]; then
  printf "\n${red}${i}.${no_color} Install go profile\n\n"
  i=$(($i + 1))

  "$SCRIPT_PATH/profiles/debian/setup-go.sh"
fi


# Install js profile
if [[ "$INSTALL_JS" = "true" ]]; then
  printf "\n${red}${i}.${no_color} Install javascript profile\n\n"
  i=$(($i + 1))

  "$SCRIPT_PATH/profiles/debian/setup-js.sh"
fi


# Install ai profile
if [[ "$INSTALL_AI" = "true" ]]; then
  printf "\n${red}${i}.${no_color} Install ai profile\n\n"
  i=$(($i + 1))

  "$SCRIPT_PATH/profiles/debian/setup-ai.sh"
fi


# Copy dotfiles
if [[ "$COPY_DOTFILES" = "true" ]]; then
  printf "\n${red}${i}.${no_color} Copy dotfiles\n\n"
  i=$(($i + 1))

  DOTFILES_PATH="$(cd "$SCRIPT_PATH/.." && pwd -P)/dotfiles"

  # Whatever a copy below would replace is saved under $DOTFILES_BACKUP_DIR first
  install_file "$DOTFILES_PATH/.zshrc" "$HOME/.zshrc"
  install_file "$DOTFILES_PATH/.oh-my-zsh/this-is-tobi.zsh-theme" "$HOME/.oh-my-zsh/custom/themes/this-is-tobi.zsh-theme"
  # Keep the identity and signing settings of the current ~/.gitconfig in
  # ~/.gitconfig.local before it is replaced
  "$SCRIPT_PATH/helpers/gitconfig.sh"
  install_file "$DOTFILES_PATH/.gitconfig" "$HOME/.gitconfig"
  install_tree "$DOTFILES_PATH/.continue" "$HOME/.continue"

  # Create secrets.env before the copy below replaces env.sh, so that values a
  # previous env.sh held are moved there instead of being lost.
  "$SCRIPT_PATH/helpers/secrets.sh"
  # Copies .config/mise/conf.d/00-settings.toml among the rest. It is kept in
  # conf.d/ rather than config.toml precisely so that re-running this step does
  # not clobber the tool versions the profiles pinned via `mise use --global`.
  install_tree "$DOTFILES_PATH/.config" "$HOME/.config"


  # Install the eslint fallback config, used where a project has none
  install_file "$DOTFILES_PATH/eslint.config.mjs" "$HOME/eslint.config.mjs"
  if [ -x "$(command -v npm)" ]; then
    (cd "$HOME/.config/eslint-fallback" && npm install --no-audit --no-fund --loglevel=error)
  fi


  # Install .vscode configs (VS Code, and code-server when present)
  install_vscode_config() {
    local user_dir="$1" cli="$2" settings
    settings="$(mktemp)"
    sed "s|__HOME__|$HOME|g" "$DOTFILES_PATH/.vscode/settings.json" > "$settings"
    "$SCRIPT_PATH/helpers/vscode-settings.sh" "$settings" "$user_dir/settings.json" "$DOTFILES_PATH/.vscode/settings-retired.json"
    rm -f "$settings"
    install_file "$DOTFILES_PATH/.vscode/mcp.json" "$user_dir/mcp.json"
    "$SCRIPT_PATH/helpers/vscode-extensions.sh" "$cli" "$DOTFILES_PATH/.vscode/extensions.json"
  }
  if [ -x "$(command -v code)" ]; then
    install_vscode_config "$HOME/.config/Code/User" code
  fi
  if [ -x "$(command -v code-server)" ]; then
    install_vscode_config "$HOME/.local/share/code-server/User" code-server
  fi


  # Install .claude config
  mkdir -p "$HOME/.claude"
  if [ -x "$(command -v rtk)" ]; then
    rtk init -g --auto-patch
  fi
  # Merged, not copied: Claude Code and /plugin write into this file too. The repository
  # owns hooks, attribution, plugins and the deny rules; the rest stays as it is.
  "$SCRIPT_PATH/helpers/claude-settings.sh" "$DOTFILES_PATH/.claude/settings.json"


  # Install AI agent instructions & skills (Copilot + Claude Code personal setup)
  # -P installs Claude Code plugins at user scope (and registers them in the settings.json merged above).
  run_remote bash "$TOOLS_RAW_BASE/shell/setup-ai-agent.sh" -t claude -g -P
  run_remote bash "$TOOLS_RAW_BASE/shell/setup-ai-agent.sh" -t copilot -g -c


  # Configure Claude Code MCP servers
  if [ -x "$(command -v claude)" ]; then
    "$SCRIPT_PATH/helpers/claude-mcp.sh"
  fi
fi


# Install cli completions
if [[ "$INSTALL_COMPLETIONS" = "true" ]]; then
  printf "\n${red}${i}.${no_color} Install cli completions\n\n"
  i=$(($i + 1))

  "$SCRIPT_PATH/helpers/completions.sh"
  # .zshrc adds this directory to fpath once it exists
  ZSH_COMPLETIONS_DIR="${ZSH_CUSTOM:-${ZSH:-$HOME/.oh-my-zsh}/custom}/plugins/zsh-completions"
  if [ ! -d "$ZSH_COMPLETIONS_DIR" ]; then
    git clone https://github.com/zsh-users/zsh-completions.git "$ZSH_COMPLETIONS_DIR"
  fi
fi
