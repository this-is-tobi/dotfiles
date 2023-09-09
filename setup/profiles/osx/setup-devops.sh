#!/bin/bash

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'


# Updating homebrew cache
printf "\n\n${red}[devops] =>${no_color} Update homebrew\n\n"
brew update


# Install homebrew cli packages
printf "\n\n${red}[devops] =>${no_color} Install homebrew packages (cli)\n\n"
FORMULAE=(
  act
  ansible
  argocd
  helm
  k9s
  kind
  krew
  kubectx
  kubernetes-cli
  minio-mc
  openshift-cli
  scw
  terraform
  trivy
  vault
)
for package in ${FORMULAE[@]}; do
  brew install --formulae $package
done


# Install krew plugins
printf "\n\n${red}[devops] =>${no_color} Install krew plugins\n\n"
KREW_PLUGINS=(
  cert-manager
  cnpg
  ktop
  kubescape
  kyverno
)
for plugin in ${KREW_PLUGINS[@]}; do
  kubectl krew install $plugin
done


# Install vault autocompletion
printf "\n\n${red}[devops] =>${no_color} Install vault cli autocompletion\n\n"
vault -autocomplete-install
