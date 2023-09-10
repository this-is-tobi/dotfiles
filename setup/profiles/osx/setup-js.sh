#!/bin/bash

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'


# Updating homebrew cache
printf "\n\n${red}[js] =>${no_color} Update homebrew\n\n"
brew update


# Install homebrew cli packages
printf "\n\n${red}[js] =>${no_color} Install homebrew packages (cli)\n\n"
brew install --formulae \
  node \
  pnpm \
  volta


# Install homebrew graphic app packages
printf "\n\n${red}[js] =>${no_color} Install homebrew packages (graphic)\n\n"
brew install --cask \
  firefox \
  insomnia


# Install npm packages
printf "\n\n${red}[js] =>${no_color} Install npm packages\n\n"
npm install --global \
  @antfu/ni
