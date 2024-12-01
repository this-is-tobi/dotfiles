#!/bin/bash

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'


# Updating homebrew cache
printf "\n\n${red}[secops] =>${no_color} Update homebrew\n\n"
brew update


# Install homebrew cli packages
printf "\n\n${red}[secops] =>${no_color} Install homebrew packages (cli)\n\n"
brew install --formula \
  age \
  cosign \
  dive \
  sops \
  trivy \
  vault


# Install krew plugins
printf "\n\n${red}[secops] =>${no_color} Install krew plugins\n\n"
kubectl krew install \
  kubescape \
  kyverno 