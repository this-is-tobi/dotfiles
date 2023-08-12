# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# History
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
HIST_STAMPS="yyyy-mm-dd"

# Preferred editor for local and remote sessions
export EDITOR='vim'

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
alias h='history'
alias hs='history | grep'
alias hsi='history | grep -i'
alias k="kubectl"
alias kd="kubectl describe"
alias kl="kubectl logs"
alias kns="kubens"
alias kctx="kubectx"
alias exa="exa -lag --git"
alias ldocker="lazydocker"
alias dsp="docker system prune -a -f"
alias bcu="brew outdated --cask --greedy | awk '{print $1}' | xargs brew reinstall --cask"

# Use homebrew packages instead of default system packages
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/.docker/bin:$PATH"

# golang
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN

# # tldr++
# TLDR_OS=osx # linux

# # volta
# VOLTA_HOME=$HOME/.volta
# export PATH="$VOLTA_HOME/bin:$PATH"

# # kubectl completion
# source <(kubectl completion zsh)

# # krew plugin for kubectl
# export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# # terrafom completion
# autoload -U +X bashcompinit && bashcompinit
# complete -o nospace -C /usr/local/bin/terraform terraform

# # scalingo completion
# source ~/.zsh/completion/scalingo_complete.zsh

# # minio completion
# complete -o nospace -C /usr/local/bin/mc mc
