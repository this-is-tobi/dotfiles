#!/bin/bash

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'


# Updating homebrew cache
printf "\n\n${red}[js] =>${no_color} Update homebrew\n\n"
brew update


# Install homebrew cli packages
printf "\n\n${red}[js] =>${no_color} Install homebrew packages (cli)\n\n"
FORMULAE=(
  node
  pnpm
  volta
)
for package in ${FORMULAE[@]}; do
  brew install --formulae $package
done


# Install homebrew graphic app packages
printf "\n\n${red}[js] =>${no_color} Install homebrew packages (graphic)\n\n"
CASK=(
  firefox
  insomnia
)
for package in ${CASK[@]}; do
  brew install --cask $package
done


# Install npm packages
printf "\n\n${red}[js] =>${no_color} Install npm packages\n\n"
NPM_PACKAGES=(
  @antfu/ni
)
for package in ${NPM_PACKAGES[@]}; do
  npm install --global $package
done
