# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# History
HISTSIZE=1000
SAVEHIST=1000
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

# Plugins variables

# Aliases
alias bcu="brew outdated --cask --greedy | awk '{print $1}' | xargs brew reinstall --cask"
alias dsp="docker system prune -a -f"
alias exa="exa -lag --git"
alias f="fzf --preview 'bat --color=always {}' --preview-window='right:60%:nohidden'"
alias h="history"
alias hs="history | grep"
alias hsi="history | grep -i"
alias img="chafa"
alias k="kubectl"
alias kc="kubectx"
alias kd="kubectl describe"
alias ke="kubectl exec"
alias kg="kubectl get"
alias kl="kubectl logs"
alias kn="kubens"
alias ldocker="lazydocker"
alias lgit="lazygit"

# Use homebrew packages instead of default system packages
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/.docker/bin:$PATH"

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
