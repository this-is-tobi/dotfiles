#!/bin/bash

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'


# Updating homebrew cache
printf "\n\n${red}[devops] =>${no_color} Update homebrew\n\n"
brew update


# Install homebrew cli packages
printf "\n\n${red}[devops] =>${no_color} Install homebrew packages (cli)\n\n"
brew install --formula \
  act \
  ansible \
  argocd \
  coder/coder/coder \
  helm \
  k9s \
  kind \
  krew \
  kubectx \
  kubernetes-cli \
  minio-mc \
  openshift-cli \
  scw \
  sops \
  terraform \
  trivy \
  vault \
  velero


# Install krew plugins
printf "\n\n${red}[devops] =>${no_color} Install krew plugins\n\n"
krew install \
  cert-manager \
  cnpg \
  df-pv \
  ktop \
  kubescape \
  kyverno \
  neat


# Install vault autocompletion
printf "\n\n${red}[devops] =>${no_color} Install vault cli autocompletion\n\n"
vault -autocomplete-install


# Install sshpass
if [ ! -x "$(command -v sshpass)" ]; then
  printf "\n\n${red}[devops] =>${no_color} Install sshpass\n\n"
  curl -L -o /tmp/sshpass.tar.gz https://sourceforge.net/projects/sshpass/files/latest/download
  tar zxvf /tmp/sshpass.tar.gz && rm /tmp/sshpass.tar.gz
  SSHPASS_DIR="$(ls /tmp | grep 'sshpass')"
  cd /tmp/$SSHPASS_DIR \
    && ./configure \
    && sudo make install \
    && cd -
fi
