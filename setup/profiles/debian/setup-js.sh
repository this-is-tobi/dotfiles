#!/bin/bash

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'


export PROTO_AUTO_INSTALL=true
export PROTO_AUTO_CLEAN=true

install_lite_setup() {
  # Install proto packages
  printf "\n\n${red}[js] =>${no_color} Install proto packages\n\n"
  PACKAGES=(
    node
    npm
  )
  for pkg in ${PACKAGES[*]}; do
    proto install $pkg
  done
}

install_additional_setup() {
  # Install proto packages
  printf "\n\n${red}[js] =>${no_color} Install proto packages\n\n"
  PACKAGES=(
    bun
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
}


# Install lite setup
install_lite_setup

# Install full setup
if [ "$FULL_MODE_SETUP" = "true" ]; then
  install_additional_setup
fi
