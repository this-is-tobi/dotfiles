#!/bin/bash

# Install the zsh completion of every supported CLI found on PATH into
# ~/.oh-my-zsh/completions.
#
# zsh runs every file of that directory, so a completion is only replaced once
# its new content is complete: a command or download that fails keeps the
# previous file instead of leaving an empty or truncated one. The few scripts
# that are downloaded are pinned to a release or a revision and checked against
# a sha256.

set -euo pipefail

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'

# Get current script path (relative to this file, not $PWD - this script is
# invoked as an absolute path from a caller whose cwd may be the repo's
# parent directory rather than inside the repo, where `git rev-parse
# --show-toplevel` would fail)
REPO_ROOT="$( cd -- "$(dirname "$0")/../.." >/dev/null 2>&1 && pwd -P )"

# shellcheck source-path=SCRIPTDIR source=remote.sh
. "$REPO_ROOT/setup/helpers/remote.sh"

COMPLETION_DIR="$HOME/.oh-my-zsh/completions"

# Most tools below are mise-managed, so their shims must be resolvable when
# this runs standalone (e.g. `setup-debian.sh -c` without a profile).
export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$PATH"

# kubectx and kubens ship no completion command: their scripts live in the repository
KUBECTX_REF="v0.11.0"
# ollama turns cobra's completion command off (ollama/ollama#4690), so this
# community script is used, at the revision that was reviewed
OLLAMA_GIST_REVISION="5a6a44efc6a07b6f937dbc596d9d7385b297dda8"

mkdir -p "$COMPLETION_DIR"

failed=0

has() {
  command -v "$1" >/dev/null 2>&1
}

announce() {
  printf "\n${red}[completion] =>${no_color} Install %s completion\n" "$1"
}

warn() {
  printf "Warning: %s\n" "$1" >&2
  failed=$((failed + 1))
}

# from_command <file> <command...>: the completion a tool prints itself. The
# temporary file starts with a dot, so compinit never loads a leftover one.
from_command() {
  local file="$1" tmp
  shift
  has "$1" || return 0
  announce "$1"
  tmp="$(mktemp "$COMPLETION_DIR/.$file.XXXXXX")"
  if "$@" < /dev/null > "$tmp" && [ -s "$tmp" ]; then
    chmod 644 "$tmp"
    mv -f "$tmp" "$COMPLETION_DIR/$file"
  else
    rm -f "$tmp"
    warn "'$*' failed, $file was not updated"
  fi
}

# from_url <tool> <file> <url> <sha256>: a pinned download, for a tool that has
# no completion command.
from_url() {
  local tool="$1" file="$2" url="$3" sha256="$4"
  has "$tool" || return 0
  announce "$tool"
  fetch_verified "$url" "$sha256" "$COMPLETION_DIR/$file" || warn "$file was not updated"
}

# from_repository <tool> <file>: a completion kept in this repository.
from_repository() {
  local tool="$1" file="$2" tmp
  has "$tool" || return 0
  announce "$tool"
  tmp="$(mktemp "$COMPLETION_DIR/.$file.XXXXXX")"
  cp "$REPO_ROOT/dotfiles/.oh-my-zsh/completions/$file" "$tmp"
  chmod 644 "$tmp"
  mv -f "$tmp" "$COMPLETION_DIR/$file"
}


# <completion file> <command that prints it>; skipped when the command is not on PATH
while read -r -a words <&3; do
  [ "${#words[@]}" -eq 0 ] && continue
  from_command "${words[@]}"
done 3<<'EOF'
_argo              argo completion zsh
_argocd            argocd completion zsh
_ct                ct completion zsh
_cheat             cheat --completion zsh
_cobra-cli         cobra-cli completion zsh
_docker            docker completion zsh
_gitleaks          gitleaks completion zsh
_glow              glow completion zsh
_helm              helm completion zsh
_kind              kind completion zsh
_kubebuilder       kubebuilder completion zsh
_kubectl           kubectl completion zsh
_kubectl-cnpg      kubectl-cnpg completion zsh
_kubectl-kubescape kubectl-kubescape completion zsh
_kubectl-stern     kubectl-stern --completion zsh
_kustomize         kustomize completion zsh
_kyverno           kyverno completion zsh
_operator-sdk      operator-sdk completion zsh
_pnpm              pnpm completion zsh
_mise              mise completion zsh
_teleport          teleport --completion-script-zsh
_tbot              tbot --completion-script-zsh
_tctl              tctl --completion-script-zsh
_tsh               tsh --completion-script-zsh
_trivy             trivy completion zsh
_velero            velero completion zsh
_yq                yq completion zsh
EOF

from_repository kubectl-view_secret _kubectl-view_secret

from_url kubectx _kubectx \
  "https://raw.githubusercontent.com/ahmetb/kubectx/refs/tags/$KUBECTX_REF/completion/_kubectx.zsh" \
  410b5315f7a91b1c210cbc86c9cc4dda065f2ac180b490f3ebbf7e764ab6b470
from_url kubens _kubens \
  "https://raw.githubusercontent.com/ahmetb/kubectx/refs/tags/$KUBECTX_REF/completion/_kubens.zsh" \
  084c226035af951e582020b2bc055a6521929ee54d8942b4d19577e5d45fd8f7
from_url ollama _ollama \
  "https://gist.githubusercontent.com/obeone/9313811fd61a7cbb843e0001a4434c58/raw/$OLLAMA_GIST_REVISION/_ollama.zsh" \
  69feeb16c0481d741a679ab6335a9e994c85602a76d83c6449931fc7e33e9b90


# A completion that could not be refreshed is not worth failing the setup over:
# the previous file (if any) is still there, and a re-run retries it
if [ "$failed" -gt 0 ]; then
  printf "\n%s completion(s) could not be installed, see the warnings above\n" "$failed" >&2
fi
exit 0
