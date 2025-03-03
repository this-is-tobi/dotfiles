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
  kind
  kubectl
  kubectx
  microk8s
  minikube
  nmap
  node
  npm
  oc
  rsync
  scw
  sudo
  systemadmin
  terraform
)

# brew settings
if type brew &>/dev/null; then
  # configure brew fpath
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  # aliases
  alias bcu="brew outdated --cask --greedy | awk '{print $1}' | xargs brew reinstall --cask"

  # use homebrew packages instead of default system packages
  export PATH="/usr/local/bin:$PATH"
  export PATH="$HOME/.docker/bin:$PATH"

  # lesspipe.sh
  export LESSOPEN="|/usr/local/bin/lesspipe.sh %s"
fi

# add common completion
export COMPLETION_DIR=$HOME/.oh-my-zsh/completions
# fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

source $ZSH/oh-my-zsh.sh

# aliases
alias cs="cheat_glow"
alias dsp="docker system prune -a -f"
alias eza="eza -lag --git"
alias f="fzf --preview 'bat --color=always {}' --preview-window='right:60%:nohidden'"
alias gs="git stash"
alias gsa="git stash apply"
alias gsp="git stash pop"
alias h="history | tail -r | fzf --preview 'bat --color=always {}' --preview-window='right:60%:hidden'"
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
alias kl="kubectl logs"
alias kn="kubens"
alias kneat="kubectl-neat"
alias lad="lazydocker"
alias lag="lazygit"
alias pubip="dig +short txt ch whoami.cloudflare @1.0.0.1 | tr -d '\"'"
# alias sed="gsed"

if [ "$(uname)" = "Darwin" ]; then
  # intel/arm switch aliases for osx
  alias arm="env /usr/bin/arch -arm64 /bin/zsh --login"
  alias intel="env /usr/bin/arch -x86_64 /bin/zsh --login"
fi

# utility functions
[ -f "$HOME/.config/dotfiles/functions.sh" ] && source "$HOME/.config/dotfiles/functions.sh"
[ -f "$HOME/.config/dotfiles/functions-completion.sh" ] && source "$HOME/.config/dotfiles/functions-completion.sh"

# gpg
export GPG_TTY=$(tty)

# go
export GOBIN="$HOME/go/bin"
export PATH="$GOBIN:$PATH"

# tldr++
TLDR_OS=osx # linux

# proto
export PROTO_HOME="$HOME/.proto"
export PATH="$PROTO_HOME/shims:$PROTO_HOME/bin:$PROTO_HOME/tools/node/globals/bin:$PATH"

# krew plugin for kubectl
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# cheat
export CHEAT_USE_FZF=true
