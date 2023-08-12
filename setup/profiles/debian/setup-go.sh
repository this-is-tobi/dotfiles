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
printf "\n\n${red}[go] =>${no_color} Update apt cache\n\n"
sudo apt update


# Install utils packages
printf "\n\n${red}[go] =>${no_color} Install go\n\n"
sudo apt install -y golang-go


# Install go packages
printf "\n\n${red}[go] =>${no_color} Install go packages\n\n"
GO_PACKAGES=(
  github.com/spf13/cobra-cli@latest
)
for package in ${GO_PACKAGES[@]}; do
  go install $package
done


# Install completion
printf "\n\n${red}[go] =>${no_color} Install go packages completion\n\n"
cobra-cli completion zsh > "${fpath[1]}/_cobra-cli"
