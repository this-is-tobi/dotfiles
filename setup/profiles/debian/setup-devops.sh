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
  sshpass \
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


# Install coder
if [ ! -x "$(command -v coder)" ]; then
  curl -fsSL https://coder.com/install.sh | sh
fi


# Install ansible
if [ ! -x "$(command -v ansible)" ]; then
  python3 -m pip install --user ansible
fi



# Install aws
if [ ! -x "$(command -v aws)" ]; then
  if [ "$(uname -m)" = "aarch64" ]; then
    ARCH=aarch64
  else
    ARCH=x86_64
  fi
  curl "https://awscli.amazonaws.com/awscli-exe-linux-$ARCH.zip" -o "/tmp/awscliv2.zip"
  unzip "/tmp/awscliv2.zip"
  sudo /tmp/aws/install
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


# Install helm-docs
if [ ! -x "$(command -v helm-docs)" ]; then
  printf "\n\n${red}[base] =>${no_color} Install helm-docs\n\n"
  if [ "$(uname -m)" = "x86_64" ] || [ "$(uname -m)" = "amd64" ]; then
    ARCH=x86_64
  elif [ "$(uname -m)" = "arm64" ] || [ "$(uname -m)" = "aarch64" ]; then
    ARCH=arm64
  fi
  mkdir /tmp/helm-docs
  HELM_DOCS_VERSION=$(curl -s "https://api.github.com/repos/norwoodj/helm-docs/releases/latest" | jq -r '.tag_name' | sed 's/v//g')
  curl -sLo /tmp/helm-docs/helm-docs_${HELM_DOCS_VERSION}_Linux_${ARCH}.tar.gz "https://github.com/norwoodj/helm-docs/releases/latest/download/helm-docs_${HELM_DOCS_VERSION}_Linux_${ARCH}.tar.gz"
  tar xf /tmp/helm-docs/helm-docs_${HELM_DOCS_VERSION}_Linux_${ARCH}.tar.gz -C /tmp/helm-docs 
  sudo mv /tmp/helm-docs /usr/local/bin/helm-docs
fi


# Install vault autocompletion
printf "\n\n${red}[devops] =>${no_color} Install vault cli autocompletion\n\n"
vault -autocomplete-install
