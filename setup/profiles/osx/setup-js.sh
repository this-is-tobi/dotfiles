#!/bin/bash

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'


# Updating homebrew cache
printf "\n\n${red}[js] =>${no_color} Update homebrew\n\n"
brew update


# Install homebrew cli packages
printf "\n\n${red}[js] =>${no_color} Install homebrew packages (cli)\n\n"
brew tap oven-sh/bun
brew install --formula \
  bun \
  node \
  pnpm \
  volta


# Install npm packages
printf "\n\n${red}[js] =>${no_color} Install npm packages\n\n"
npm install --global \
  @antfu/ni
