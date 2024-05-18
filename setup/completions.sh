#!/bin/bash

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'


source $HOME/.zshrc


# Create completion directory if not exists
[ ! -d "$COMPLETION_DIR" ] && mkdir -p "$COMPLETION_DIR"


# Install kubectl completion
printf "\n\n${red}[completion] =>${no_color} Install kubectl completion\n\n"
[ -x "$(command -v kubectl)" ] && kubectl completion zsh > $COMPLETION_DIR/_kubectl


# Install cobra completion
printf "\n\n${red}[completion] =>${no_color} Install cobra completion\n\n"
[ -x "$(command -v cobra-cli)" ] && cobra-cli completion zsh > $COMPLETION_DIR/_cobra-cli


# Install vault completion
printf "\n\n${red}[completion] =>${no_color} Install vault completion\n\n"
[ -x "$(command -v vault)" ] && vault -autocomplete-install


# Install terrafom completion
printf "\n\n${red}[completion] =>${no_color} Install terraform completion\n\n"
[ -x "$(command -v terraform)" ] && terraform -install-autocomplete


# Install minio completion
printf "\n\n${red}[completion] =>${no_color} Install minio completion\n\n"
[ -x "$(command -v mc)" ] && mc --autocompletion


# Install scw completion
printf "\n\n${red}[completion] =>${no_color} Install scw completion\n\n"
[ -x "$(command -v scw)" ] && scw autocomplete install


# Install cheat completion
printf "\n\n${red}[completion] =>${no_color} Install cheat completion\n\n"
[ -x "$(command -v cheat)" ] && curl -sSL -o $COMPLETION_DIR/_cheat https://raw.githubusercontent.com/cheat/cheat/master/scripts/cheat.zsh
