#!/bin/bash

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'


# Add wakemeops debian repo
if [ -z "$(find /etc/apt/ -name *.list | xargs cat | grep  ^[[:space:]]*deb) | grep wakemeops" ]; then
  curl -sSL https://raw.githubusercontent.com/upciti/wakemeops/main/assets/install_repository | sudo bash
fi


# Updating apt cache
printf "\n\n${red}[devops] =>${no_color} Update apt\n\n"
sudo apt update


# Install apt packages
printf "\n\n${red}[devops] =>${no_color} Install apt packages\n\n"
sudo apt install -y \
  act \
  argocd \
  helm \
  k9s \
  kind \
  krew \
  kubectx \
  kubectl \
  minio-client \
  scw \
  terraform \
  trivy \
  vault


# Install ansible
if [ ! -x "$(command -v ansible)" ]; then
  echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu focal main" > /etc/apt/sources.list.d/ansible.list
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
  sudo apt update && sudo apt install -y ansible
fi


# Install vault autocompletion
printf "\n\n${red}[devops] =>${no_color} Install vault cli autocompletion\n\n"
vault -autocomplete-install


# Install scalingo
if [ ! -x "$(command -v scalingo)" ]; then
  printf "\n\n${red}[devops] =>${no_color} Install scalingo cli\n\n"
  curl -O https://cli-dl.scalingo.com/install && bash install

  # Install scalingo autocompletion
  printf "\n\n${red}[devops] =>${no_color} Install scalingo cli autocompletion\n\n"
  mkdir -p ~/.zsh/completion
  curl "https://raw.githubusercontent.com/Scalingo/cli/master/cmd/autocomplete/scripts/scalingo_complete.zsh" > ~/.zsh/completion/scalingo_complete.zsh
fi
