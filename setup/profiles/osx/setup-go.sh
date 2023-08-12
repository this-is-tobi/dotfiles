#!/bin/bash

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'


# Updating homebrew cache
printf "\n\n${red}[go] =>${no_color} Update homebrew\n\n"
brew update


# Install homebrew cli packages
printf "\n\n${red}[go] =>${no_color} Install go\n\n"
brew install --formulae go


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
cobra-cli completion zsh > /usr/local/share/zsh/site-functions/_cobra-cli
