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
  argo \
  argocd \
  dive \
  helm \
  helm-docs \
  k6 \
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
  neat \
  stern


# Install openshift cli
if [ ! -x "$(command -v oc)" ]; then
  printf "\n\n${red}[base] =>${no_color} Install openshift cli\n\n"
  if [ "$(uname -m)" = "x86_64" ] || [ "$(uname -m)" = "amd64" ]; then
    ARCH=""
  elif [ "$(uname -m)" = "arm64" ] || [ "$(uname -m)" = "aarch64" ]; then
    ARCH="-arm64"
  fi
  mkdir /tmp/openshift-cli
  OC_VERSION=$(curl -s "https://api.github.com/repos/okd-project/okd/releases/latest " | jq -r '.tag_name' )
  curl -Lo /tmp/openshift-cli/oc.tar.gz "https://github.com/okd-project/okd/releases/download/${OC_VERSION}/openshift-client-linux${ARCH}-${OC_VERSION}.tar.gz"
  tar xf /tmp/openshift-cli/oc.tar.gz -C /tmp/openshift-cli
  sudo mv /tmp/openshift-cli/oc /usr/local/bin/oc
fi


# Install coder
if [ ! -x "$(command -v coder)" ]; then
  printf "\n\n${red}[devops] =>${no_color} Install coder\n\n"
  curl -fsSL https://coder.com/install.sh | sh
fi


# Install ansible
if [ ! -x "$(command -v ansible)" ]; then
  printf "\n\n${red}[devops] =>${no_color} Install ansible\n\n"
  python3 -m pip install --user ansible
fi


# Install aws
if [ ! -x "$(command -v aws)" ]; then
  if [ "$(uname -m)" = "arm64" ] || [ "$(uname -m)" = "aarch64" ]; then
    ARCH=aarch64
  else
    ARCH=x86_64
  fi
  curl "https://awscli.amazonaws.com/awscli-exe-linux-$ARCH.zip" -o "/tmp/awscliv2.zip"
  unzip "/tmp/awscliv2.zip"
  sudo /tmp/aws/install
fi


# Install mkcert
if [ ! -x "$(command -v mkcert)" ]; then
  printf "\n\n${red}[devops] =>${no_color} Install mkcert\n\n"
  if [ "$(uname -m)" = "x86_64" ] || [ "$(uname -m)" = "amd64" ]; then
    ARCH=amd64
  elif [ "$(uname -m)" = "arm64" ] || [ "$(uname -m)" = "aarch64" ]; then
    ARCH=arm64
  fi
  mkdir /tmp/mkcert
  MKCERT_VERSION=$(curl -s "https://api.github.com/repos/FiloSottile/mkcert/releases/latest" | jq -r '.tag_name' | sed 's/v//g')
  curl -sLo /tmp/mkcert/mkcert-v${MKCERT_VERSION}-linux-${ARCH} "https://github.com/FiloSottile/mkcert/releases/latest/download/mkcert-v${MKCERT_VERSION}-linux-${ARCH}"
  sudo mv /tmp/mkcert/mkcert-v${MKCERT_VERSION}-linux-${ARCH} /usr/local/bin/mkcert
fi
