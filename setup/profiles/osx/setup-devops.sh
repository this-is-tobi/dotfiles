#!/bin/bash

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'


# Updating homebrew cache
printf "\n\n${red}[devops] =>${no_color} Update homebrew\n\n"
brew update


# Install homebrew cli packages
printf "\n\n${red}[devops] =>${no_color} Install homebrew packages (cli)\n\n"
brew install --formula \
  act \
  ansible \
  argocd \
  helm \
  k9s \
  kind \
  krew \
  kubectx \
  kubernetes-cli \
  minio-mc \
  openshift-cli \
  scw \
  sops \
  terraform \
  trivy \
  vault



# Install krew plugins
printf "\n\n${red}[devops] =>${no_color} Install krew plugins\n\n"
krew install \
  cert-manager \
  cnpg \
  ktop \
  kubescape \
  kyverno \
  neat


# Install vault autocompletion
printf "\n\n${red}[devops] =>${no_color} Install vault cli autocompletion\n\n"
vault -autocomplete-install
