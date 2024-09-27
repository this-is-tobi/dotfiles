#!/bin/bash

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'


# Install proto packages
printf "\n\n${red}[js] =>${no_color} Install proto packages\n\n"
PACKAGES=(
  bun
  node
  pnpm
  yarn
)
for pkg in ${PACKAGES[*]}; do
  proto install $pkg
done


# Install npm packages
printf "\n\n${red}[js] =>${no_color} Install npm packages\n\n"
npm install --global \
  @antfu/ni
