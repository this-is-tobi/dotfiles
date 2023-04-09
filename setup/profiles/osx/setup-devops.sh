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
  argocd
  ansible
  helm
  k9s
  kind
  krew
  kubectx
  kubernetes-cli
  terraform
  trivy
  vault
)
for package in ${FORMULAE[@]}; do
  brew install --formulae $package
done


# Install vault autocompletion
printf "\n\n${red}[devops] =>${no_color} Install vault cli autocompletion\n\n"
vault -autocomplete-install


# Install scalingo
printf "\n\n${red}[devops] =>${no_color} Install scalingo cli\n\n"
curl -O https://cli-dl.scalingo.com/install && bash install


# Install scalingo autocompletion
printf "\n\n${red}[devops] =>${no_color} Install scalingo cli autocompletion\n\n"
mkdir -p ~/.zsh/completion
curl "https://raw.githubusercontent.com/Scalingo/cli/master/cmd/autocomplete/scripts/scalingo_complete.zsh" > ~/.zsh/completion/scalingo_complete.zsh
