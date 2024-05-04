# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# History
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE="$HOME/.zsh_history"
export HIST_STAMPS="yyyy-mm-dd"

# Locales
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# Config directory
export XDG_CONFIG_HOME="$HOME/.config"

# Preferred editor for local and remote sessions
export EDITOR='nvim'

# Theme (https://github.com/ohmyzsh/ohmyzsh/wiki/Themes)
ZSH_THEME="gnzh"

# Plugins
plugins=(
  aliases
  ansible
  docker
  docker-compose
  gh
  git
  gitignore
  golang
  helm
  kubectl
  kubectx
  microk8s
  minikube
  nmap
  node
  npm
  oc
  scw
  sudo
  systemadmin
  terraform
  vault
  volta
)

source $ZSH/oh-my-zsh.sh

# Aliases
alias bcu="brew outdated --cask --greedy | awk '{print $1}' | xargs brew reinstall --cask"
alias dsp="docker system prune -a -f"
alias eza="eza -lag --git"
alias f="fzf --preview 'bat --color=always {}' --preview-window='right:60%:nohidden'"
alias h="history"
alias hs="history | grep"
alias hsi="history | grep -i"
alias img="chafa"
alias k="kubectl"
alias kc="kubectx"
alias kd="kubectl delete"
alias kdesc="kubectl describe"
alias ke="kubectl exec"
alias kexp="kubectl explain"
alias kg="kubectl get"
alias kl="kubectl logs"
alias kn="kubens"
alias lad="lazydocker"
alias lag="lazygit"
# alias sed="gsed"

# Utility functions
dks () {
  echo "$1" | yq '.data | map_values(. | @base64d)'
}
dec () {
  echo "$1" | base64 -d
}
enc () {
  echo -n "$1" | base64
}
kbp () {
  echo "Killing process running on port $1 ..."
  kill -9 $(lsof -i :$1 | tail -n +2 | awk '{print $2}')
}


# Use homebrew packages instead of default system packages
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/.docker/bin:$PATH"

# gpg
export GPG_TTY=$(tty)

# golang
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN

# tldr++
TLDR_OS=osx # linux

# volta
VOLTA_HOME=$HOME/.volta
export PATH="$VOLTA_HOME/bin:$PATH"

# krew plugin for kubectl
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# kubectl completion
source <(kubectl completion zsh)

# terrafom completion
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform

# minio completion
complete -o nospace -C /usr/local/bin/mc mc

# Scaleway CLI autocomplete initialization.
eval "$(scw autocomplete script shell=zsh)"
