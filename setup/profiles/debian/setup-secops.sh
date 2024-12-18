#!/bin/bash

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'


# Add wakemeops debian repo
if [ -z "$(find /etc/apt/ -name *.list | xargs cat | grep  ^[[:space:]]*deb) | grep wakemeops" ]; then
  printf "\n\n${red}[secops] =>${no_color} Add wakemeops apt repository\n\n"
  curl -fsSL https://raw.githubusercontent.com/upciti/wakemeops/main/assets/install_repository | sudo bash
fi


# Updating apt cache
printf "\n\n${red}[secops] =>${no_color} Update apt cache\n\n"
sudo apt update


# Install apt packages
printf "\n\n${red}[secops] =>${no_color} Install apt packages\n\n"
sudo apt install -y \
  age \
  cosign \
  dive \
  sops \
  trivy \
  vault


# Install krew plugins
printf "\n\n${red}[secops] =>${no_color} Install krew plugins\n\n"
krew install \
  kubescape
