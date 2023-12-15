#!/bin/bash

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'


# Add wakemeops debian repo
if [ -z "$(find /etc/apt/ -name *.list | xargs cat | grep  ^[[:space:]]*deb) | grep wakemeops" ]; then
  printf "\n\n${red}[devops] =>${no_color} Add wakemeops apt repository\n\n"
  curl -sSL https://raw.githubusercontent.com/upciti/wakemeops/main/assets/install_repository | sudo bash
fi


# Updating apt cache
printf "\n\n${red}[devops] =>${no_color} Update apt cache\n\n"
sudo apt update


# Install apt packages
printf "\n\n${red}[devops] =>${no_color} Install apt packages\n\n"
sudo apt install -y \
  act \
  helm \
  k9s \
  kind \
  krew \
  kubectx \
  kubectl \
  minio-client \
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
  ktop \
  kubescape \
  kyverno \
  neat


# Install ansible
if [ ! -x "$(command -v ansible)" ]; then
  python3 -m pip install --user ansible
fi


# Install argocd
if [ ! -x "$(command -v argocd)" ]; then
  printf "\n\n${red}[devops] =>${no_color} Install argocd\n\n"
  if [ "$(uname -m)" = "aarch64" ]; then
    ARCH=arm64
  else
    ARCH=amd64
  fi
  curl -sSL -o "/tmp/argocd-linux-$ARCH" "https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-$ARCH"
  sudo install -m 555 "/tmp/argocd-linux-$ARCH" /usr/local/bin/argocd
  rm "/tmp/argocd-linux-$ARCH"
fi


# Install vault autocompletion
printf "\n\n${red}[devops] =>${no_color} Install vault cli autocompletion\n\n"
vault -autocomplete-install
