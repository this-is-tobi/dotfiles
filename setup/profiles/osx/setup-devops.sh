#!/bin/bash

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'


install_lite_setup() {
  # Install homebrew cli packages
  printf "\n\n${red}[devops] =>${no_color} Install homebrew packages (cli)\n\n"
  brew update && brew install --formula \
    ansible \
    helm \
    norwoodj/tap/helm-docs \
    krew \
    kubectx \
    kubernetes-cli \
    minio-mc \
    sshpass \
    terraform


  # Install krew plugins
  printf "\n\n${red}[devops] =>${no_color} Install krew plugins\n\n"
  kubectl krew install \
    cert-manager \
    cnpg \
    df-pv \
    ktop \
    neat \
    stern \
    view-secret
}

install_additional_setup() {
  printf "\n\n${red}[devops] =>${no_color} Install homebrew packages (cli)\n\n"
  brew install --formula \
    act \
    ansible-lint \
    argo \
    argocd \
    awscli \
    chart-testing \
    coder/coder/coder \
    k6 \
    k9s \
    kind \
    mkcert \
    openshift-cli \
    scw \
    teleport \
    velero \
    yamllint
}



# Install lite setup
install_lite_setup

# Install full setup
if [ "$FULL_MODE_SETUP" = "true" ]; then
  install_additional_setup
fi
