# path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# history
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE="$HOME/.zsh_history"
export HIST_STAMPS="yyyy-mm-dd"

# locales
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# config directory
export XDG_CONFIG_HOME="$HOME/.config"

# preferred editor for local and remote sessions
export EDITOR='nvim'

# theme (https://github.com/ohmyzsh/ohmyzsh/wiki/Themes)
ZSH_THEME="this-is-tobi" # gnzh

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

# mise (before oh-my-zsh: it provides tools some plugins look for, such as direnv on Debian)
# `activate` puts tool versions on PATH and re-resolves them on every directory
# change. Globals installed via npm/go land in the active tool's bin and are
# exposed after `mise reshim`.
export PATH="$HOME/.local/bin:$PATH"
if type mise &>/dev/null; then
  eval "$(mise activate zsh)"
fi

# direnv plugin, only when direnv is installed (it warns at every start otherwise)
command -v direnv &>/dev/null && plugins+=(direnv)

source $ZSH/oh-my-zsh.sh

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

if [ "$(uname)" = "Darwin" ]; then
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
export GPG_TTY=$(tty)

# go
export GOBIN="$HOME/go/bin"
export PATH="$GOBIN:$PATH"

# tldr++
export TLDR_OS=$([ "$(uname)" = Darwin ] && echo osx || echo linux)

# krew plugin for kubectl
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# cheat
export CHEAT_USE_FZF=true
