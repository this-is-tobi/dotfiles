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
  argo \
  argocd \
  awscli \
  coder/coder/coder \
  helm \
  norwoodj/tap/helm-docs \
  k6 \
  k9s \
  kind \
  krew \
  kubectx \
  kubernetes-cli \
  minio-mc \
  mkcert \
  openshift-cli \
  scw \
  sshpass \
  teleport \
  terraform \
  velero


# Install krew plugins
printf "\n\n${red}[devops] =>${no_color} Install krew plugins\n\n"
kubectl krew install \
  cert-manager \
  cnpg \
  df-pv \
  ktop \
  neat \
  stern
