#!/bin/bash

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'


# Updating homebrew cache
printf "\n\n${red}[go] =>${no_color} Update homebrew\n\n"
brew update


# Install homebrew cli packages
printf "\n\n${red}[go] =>${no_color} Install go\n\n"
brew install --formula \
  go \
  kubebuilder \
  kustomize \
  operator-sdk


# Install go packages
printf "\n\n${red}[go] =>${no_color} Install go packages\n\n"
go install \
  github.com/spf13/cobra-cli@latest
