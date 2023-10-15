#!/bin/bash

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'


# Install nodejs
sudo apt install -y ca-certificates curl gnupg 
sudo mkdir -p /etc/apt/keyrings 
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
  && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
sudo apt update && sudo apt install -y nodejs


# Install npm packages
printf "\n\n${red}[js] =>${no_color} Install npm packages\n\n"
sudo npm install --global \
  @antfu/ni \
  bun \
  pnpm
