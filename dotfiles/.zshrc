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
ZSH_THEME="gnzh"

# plugins
plugins=(
  aliases
  ansible
  brew
  bun
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
  vault
  volta
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

source $ZSH/oh-my-zsh.sh

# aliases
alias cs="cheat_bat"
alias dsp="docker system prune -a -f"
alias eza="eza -lag --git"
alias f="fzf --preview 'bat --color=always {}' --preview-window='right:60%:nohidden'"
alias gs="git stash"
alias gsa="git stash apply"
alias gsp="git stash pop"
alias h="history | fzf --preview 'bat --color=always {}' --preview-window='right:60%:hidden'"
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

if [ "$(uname)" = "Darwin" ]; then
  # intel/arm switch aliases for osx
  alias arm="env /usr/bin/arch -arm64 /bin/zsh --login"
  alias intel="env /usr/bin/arch -x86_64 /bin/zsh --login"
fi

# utility functions
cheat_bat () {
  cheat "$@" | bat --language=md
}
dks () {
  if [ -z "$1" ] && [ -z "$2" ]; then
    echo "Decode kubernetes secret given its name and optionally its namespace as a second argument"
    return 0
  fi
  if [ -n "$2" ]; then
    kubectl -n "$2" get secret "$1" -oyaml | yq '.data | map_values(. | @base64d)'
  else
    kubectl get secret "$1" -oyaml | yq '.data | map_values(. | @base64d)'
  fi
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

# completion
export COMPLETION_DIR=$HOME/.oh-my-zsh/completions

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

# cheat
export CHEAT_USE_FZF=true
