#!/bin/bash

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'


# Updating homebrew cache
printf "\n\n${red}[go] =>${no_color} Update homebrew\n\n"
brew update


# Install proto packages
printf "\n\n${red}[js] =>${no_color} Install proto packages\n\n"
PACKAGES=(
  go
)
for pkg in ${PACKAGES[*]}; do
  proto install $pkg
done


# Install homebrew cli packages
printf "\n\n${red}[go] =>${no_color} Install go\n\n"
brew install --formula \
  kubebuilder \
  kustomize \
  operator-sdk


# Install go packages
printf "\n\n${red}[go] =>${no_color} Install go packages\n\n"
go install \
  github.com/spf13/cobra-cli@latest
