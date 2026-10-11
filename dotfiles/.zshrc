# path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# one copy of each entry: a nested shell (or the arm/intel aliases) runs this file
# again on top of the PATH it inherited. The scalars are flagged too, so that
# `export PATH="...:$PATH"` also drops the duplicates.
typeset -U PATH path FPATH fpath

# history (shell variables, not exported: bash would write its history to HISTFILE)
HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$HOME/.zsh_history"
HIST_STAMPS="yyyy-mm-dd"
# a command typed with a leading space is not saved
setopt hist_ignore_space
# nor a line that assigns or passes a credential (TOKEN=..., --password ..., Bearer ...),
# each name in upper, lower and capitalized case. HISTORY_IGNORE applies when the
# history file is written: the line stays in this session's history only.
secret_names=()
for secret_name in token secret password passwd passphrase api_key api-key apikey access_key private_key; do
  secret_names+=("${(U)secret_name}" "$secret_name" "${(C)secret_name}")
done
HISTORY_IGNORE="(*(${(j:|:)secret_names})[=:]*|*--(token|secret|password|passphrase|api-key)[= ]*|*[Aa]uthorization:*|*[Bb]earer *)"
unset secret_name secret_names

# locale: LANG is the default of every LC_* category. LC_ALL would override them all,
# including the ones set on purpose, and ssh forwards it to remote hosts (SendEnv LC_*).
export LANG=en_US.UTF-8

# config directory
export XDG_CONFIG_HOME="$HOME/.config"

# preferred editor for local and remote sessions
export EDITOR='nvim'

# theme (https://github.com/ohmyzsh/ohmyzsh/wiki/Themes)
ZSH_THEME="this-is-tobi" # gnzh, with kube-ps1

# plugins
plugins=(
  aliases
  ansible
  argocd
  brew
  bun
  colored-man-pages
  docker
  docker-compose
  gh
  git
  gitignore
  golang
  helm
  k9s
  kind
  kubectl
  kubectx
  nmap
  node
  npm
  oc
  rclone
  scw
  ssh
  sudo
  systemadmin
  terraform
)

# homebrew: make brew available in this shell on Apple Silicon and Intel (it is
# not on PATH in a fresh login shell). shellenv also puts brew's bin on PATH
# and its zsh site-functions on FPATH.
for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  if [ -x "$brew_bin" ]; then
    eval "$("$brew_bin" shellenv)"
    break
  fi
done
unset brew_bin

# brew settings
if [ -n "$HOMEBREW_PREFIX" ]; then
  # aliases
  alias bcu='brew outdated --cask --greedy | awk "{print \$1}" | xargs brew reinstall --cask'

  # docker desktop cli
  export PATH="$HOME/.docker/bin:$PATH"

  # lesspipe.sh, when installed
  [ -x "$HOMEBREW_PREFIX/bin/lesspipe.sh" ] && export LESSOPEN="|$HOMEBREW_PREFIX/bin/lesspipe.sh %s"
fi

# add common completion
export COMPLETION_DIR=$HOME/.oh-my-zsh/completions
# zsh-completions, cloned by the setup when it installs the completions
zsh_completions_dir="${ZSH_CUSTOM:-$ZSH/custom}/plugins/zsh-completions/src"
[ -d "$zsh_completions_dir" ] && fpath+=("$zsh_completions_dir")
unset zsh_completions_dir

# go: `go install` puts binaries in ~/go/bin, which does not change with the go
# version. Set before mise, which otherwise points GOBIN to the bin of the active go.
export GOBIN="$HOME/go/bin"
export PATH="$GOBIN:$PATH"

# mise (before oh-my-zsh: it provides tools some plugins look for, such as direnv on Debian)
# `activate` puts tool versions on PATH and re-resolves them on every directory
# change. npm globals land in the bin of the active node.
export PATH="$HOME/.local/bin:$PATH"
if type mise &>/dev/null; then
  eval "$(mise activate zsh)"
fi

# direnv plugin, only when direnv is installed (it warns at every start otherwise)
command -v direnv &>/dev/null && plugins+=(direnv)

source $ZSH/oh-my-zsh.sh

# terraform and vault complete through their own binary. Their -install-autocomplete
# flags append these lines to ~/.zshrc, so they are kept here instead.
if (( $+commands[terraform] || $+commands[vault] )); then
  autoload -U +X bashcompinit && bashcompinit
  (( $+commands[terraform] )) && complete -o nospace -C terraform terraform
  (( $+commands[vault] )) && complete -o nospace -C vault vault
fi

# make completion: only show targets, hide variables and files
zstyle ':completion:*:make:*:targets' call-command true
zstyle ':completion:*:make:*' tag-order targets
zstyle ':completion:*:make:*:variables' command false

# aliases
alias cs="cheat_glow"
alias dsp="docker system prune -a -f"
alias eza="eza -lag --git"
alias f="fzf --preview 'bat --color=always {}' --preview-window='right:60%:nohidden'"
alias gs="git stash"
alias gsa="git stash apply"
alias gsp="git stash pop"
alias h="history | { tac 2>/dev/null || tail -r; } | fzf --preview 'bat --color=always {}' --preview-window='right:60%:hidden'"
alias hs="history | grep"
alias hsi="history | grep -i"
alias img="chafa"
alias k="kubectl"
alias kc="kubectx"
alias kcert="kubectl-cert_manager"
alias kcnpg="kubectl-cnpg"
alias kd="kubectl delete"
alias kdesc="kubectl describe"
alias kdfpv="kubectl-df_pv"
alias ke="kubectl exec"
alias kexp="kubectl explain"
alias kescape="kubectl-kubescape"
alias kg="kubectl get"
alias kga="kubectl get deploy,sts,ds,po,svc,ing,cm,vaultstaticsecrets,secret,cluster,scheduledbackups,pvc,hpa,job,cronjob,sa,networkpolicy"
alias kgpw="watch 'kubectl get pod'"
alias kgr="kubectl get pod -o custom-columns='NAME:.metadata.name,CPU_REQ:spec.containers[].resources.requests.cpu,CPU_LIM:spec.containers[].resources.limits.cpu,MEM_REQ:spec.containers[].resources.requests.memory,MEM_LIM:spec.containers[].resources.limits.memory'"
alias kkrew="kubectl-krew"
alias kktop="kubectl-ktop"
alias kkyverno="kubectl-kyverno"
alias kl="kubectl logs"
alias kn="kubens"
alias kneat="kubectl-neat"
alias kstern="kubectl-stern"
alias kvs="kubectl-view_secret"
alias lad="lazydocker"
alias lag="lazygit"
alias pubip="dig +short txt ch whoami.cloudflare @1.0.0.1 | tr -d '\"'"
# GNU sed where it is installed (macOS ships BSD sed)
command -v gsed &>/dev/null && alias sed="gsed"

if [[ $OSTYPE == darwin* ]]; then
  # intel/arm switch aliases for osx
  alias arm="env /usr/bin/arch -arm64 /bin/zsh --login"
  alias intel="env /usr/bin/arch -x86_64 /bin/zsh --login"
fi

# load custom env vars
[ -f "$HOME/.config/dotfiles/env.sh" ] && source "$HOME/.config/dotfiles/env.sh"

# utility functions
[ -f "$HOME/.config/dotfiles/functions.sh" ] && source "$HOME/.config/dotfiles/functions.sh"
[ -f "$HOME/.config/dotfiles/functions-completion.sh" ] && source "$HOME/.config/dotfiles/functions-completion.sh"
[ -f "$HOME/.config/dotfiles/functions-dso.sh" ] && source "$HOME/.config/dotfiles/functions-dso.sh"

# gpg
export GPG_TTY="$TTY"

# tldr++
if [[ $OSTYPE == darwin* ]]; then
  export TLDR_OS=osx
else
  export TLDR_OS=linux
fi

# krew plugin for kubectl
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# cheat
export CHEAT_USE_FZF=true

# pnpm: where `pnpm add -g` links its binaries (`pnpm setup` would append this to ~/.zshrc)
if [[ $OSTYPE == darwin* ]]; then
  export PNPM_HOME="$HOME/Library/pnpm"
else
  export PNPM_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/pnpm"
fi
export PATH="$PNPM_HOME:$PATH"

# machine-specific shell config: not part of the repository, so a setup run keeps it
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
