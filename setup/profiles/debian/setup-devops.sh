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
kubectl krew install \
  cert-manager \
  cnpg \
  df-pv \
  ktop \
  kubescape \
  kyverno \
  neat \
  stern


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
  K6_VERSION=$(curl -s "https://api.github.com/repos/FiloSottile/mkcert/releases/latest" | jq -r '.tag_name' | sed 's/v//g')
  curl -sLo /tmp/mkcert/mkcert-v${K6_VERSION}-linux-${ARCH} "https://github.com/FiloSottile/mkcert/releases/latest/download/mkcert-v${MKCERT_VERSION}-linux-${ARCH}"
  sudo mv /tmp/mkcert/mkcert-v${MKCERT_VERSION}-linux-${ARCH} /usr/local/bin/mkcert
fi


# Install k6
if [ ! -x "$(command -v k6)" ]; then
  printf "\n\n${red}[devops] =>${no_color} Install k6\n\n"
  if [ "$(uname -m)" = "x86_64" ] || [ "$(uname -m)" = "amd64" ]; then
    ARCH=amd64
  elif [ "$(uname -m)" = "arm64" ] || [ "$(uname -m)" = "aarch64" ]; then
    ARCH=arm64
  fi
  mkdir /tmp/k6
  K6_VERSION=$(curl -s "https://api.github.com/repos/grafana/k6/releases/latest" | jq -r '.tag_name' | sed 's/v//g')
  curl -sLo /tmp/k6/k6-v${K6_VERSION}-linux-${ARCH}.tar.gz "https://github.com/grafana/k6/releases/download/v${K6_VERSION}/k6-v${K6_VERSION}-linux-${ARCH}.tar.gz" \
  tar xf /tmp/k6/k6-v${K6_VERSION}-linux-${ARCH}.tar.gz -C /tmp/k6/k6
  sudo mv /tmp/k6/k6 /usr/local/bin/k6
fi
