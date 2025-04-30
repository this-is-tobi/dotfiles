#!/bin/bash

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'


install_lite_setup() {
  # Install apt packages
  printf "\n\n${red}[secops] =>${no_color} Install apt packages\n\n"
  sudo apt update && sudo apt install -y \
    cosign \
    trivy


  # Install gitleaks
  if [ ! -x "$(command -v gitleaks)" ]; then
    printf "\n\n${red}[base] =>${no_color} Install gitleaks\n\n"
    if [ "$(uname -m)" = "x86_64" ] || [ "$(uname -m)" = "amd64" ]; then
      ARCH=x64
    elif [ "$(uname -m)" = "arm64" ] || [ "$(uname -m)" = "aarch64" ]; then
      ARCH=arm64
    fi
    mkdir /tmp/gitleaks
    CT_VERSION=$(curl -fsSL "https://api.github.com/repos/gitleaks/gitleaks/releases/latest" | jq -r '.tag_name' | sed 's/v//g')
    curl -fsSL -o /tmp/gitleaks/gitleaks_${CT_VERSION}_linux_${ARCH}.tar.gz "https://github.com/gitleaks/gitleaks/releases/latest/download/gitleaks_${CT_VERSION}_linux_${ARCH}.tar.gz"
    tar -xf /tmp/gitleaks/gitleaks_${CT_VERSION}_linux_${ARCH}.tar.gz -C /tmp/gitleaks
    sudo mv /tmp/gitleaks/gitleaks /usr/local/bin/gitleaks
  fi
}

install_additional_setup() {
  # Install apt packages
  printf "\n\n${red}[secops] =>${no_color} Install apt packages\n\n"
  sudo apt update && sudo apt install -y \
    age \
    dive \
    kubescape \
    kyverno \
    sops \
    vault
}


# Add wakemeops debian repo
if [ -z "$(find /etc/apt/ -name *.list | xargs cat | grep  ^[[:space:]]*deb) | grep wakemeops" ]; then
  printf "\n\n${red}[secops] =>${no_color} Add wakemeops apt repository\n\n"
  curl -fsSL https://raw.githubusercontent.com/upciti/wakemeops/main/assets/install_repository | sudo bash
fi

# Install lite setup
install_lite_setup

# Install full setup
if [ "$FULL_MODE_SETUP" = "true" ]; then
  install_additional_setup
fi
