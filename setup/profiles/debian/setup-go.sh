#!/bin/bash

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'


# Updating apt cache
printf "\n\n${red}[go] =>${no_color} Update apt cache\n\n"
sudo apt update


# Install utils packages
printf "\n\n${red}[go] =>${no_color} Install go\n\n"
# sudo apt install -y golang-go
if [ "$(uname -m)" = "x86_64" ] || [ "$(uname -m)" = "amd64" ]; then
  ARCH=amd64
elif [ "$(uname -m)" = "arm64" ] || [ "$(uname -m)" = "aarch64" ]; then
  ARCH=arm64
fi
GO_VERSION="$(curl -s https://go.dev/dl/?mode=json | jq -r '.[0].version')"
curl -Lo /tmp/go${GO_VERSION}.linux-${ARCH}.tar.gz https://go.dev/dl/${GO_VERSION}.linux-${ARCH}.tar.gz
tar xf /tmp/go${GO_VERSION}.linux-${ARCH}.tar.gz -C $HOME


# Install go packages
printf "\n\n${red}[go] =>${no_color} Install go packages\n\n"
go install \
  github.com/spf13/cobra-cli@latest


# Install completion
printf "\n\n${red}[go] =>${no_color} Install go packages completion\n\n"
cobra-cli completion zsh > "${fpath[1]}/_cobra-cli"
