#!/bin/bash

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'


# Install volta
if [ ! -x "$(command -v volta)" ]; then
  printf "\n\n${red}[js] =>${no_color} Install volta\n\n"
  curl https://get.volta.sh | bash -s -- --skip-setup
fi


# Install nodejs
printf "\n\n${red}[js] =>${no_color} Install nodejs\n\n"
volta install node


# Install npm packages
printf "\n\n${red}[js] =>${no_color} Install npm packages\n\n"
npm install --global \
  @antfu/ni \
  pnpm

