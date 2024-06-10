#!/bin/bash

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'


source $HOME/.zshrc


# Create completion directory if not exists
[ ! -d "$COMPLETION_DIR" ] && mkdir -p "$COMPLETION_DIR"


# Install argo completion
printf "\n${red}[completion] =>${no_color} Install argo completion\n"
[ -x "$(command -v argo)" ] && argo completion zsh > $COMPLETION_DIR/_argo


# Install argocd completion
printf "\n${red}[completion] =>${no_color} Install argocd completion\n"
[ -x "$(command -v argocd)" ] && argocd completion zsh > $COMPLETION_DIR/_argocd


# Install cheat completion
printf "\n${red}[completion] =>${no_color} Install cheat completion\n"
[ -x "$(command -v cheat)" ] && curl -sSL -o $COMPLETION_DIR/_cheat https://raw.githubusercontent.com/cheat/cheat/master/scripts/cheat.zsh


# Install cobra completion
printf "\n${red}[completion] =>${no_color} Install cobra completion\n"
[ -x "$(command -v cobra-cli)" ] && cobra-cli completion zsh > $COMPLETION_DIR/_cobra-cli


# Install docker completion
printf "\n${red}[completion] =>${no_color} Install docker completion\n"
[ -x "$(command -v docker)" ] && docker completion zsh > $COMPLETION_DIR/_docker


# Install helm completion
printf "\n${red}[completion] =>${no_color} Install helm completion\n"
[ -x "$(command -v helm)" ] && helm completion zsh > $COMPLETION_DIR/_helm


# Install kind completion
printf "\n${red}[completion] =>${no_color} Install kind completion\n"
[ -x "$(command -v kind)" ] && kind completion zsh > $COMPLETION_DIR/_kind


# Install kubectl completion
printf "\n${red}[completion] =>${no_color} Install kubectl completion\n"
[ -x "$(command -v kubectl)" ] && kubectl completion zsh > $COMPLETION_DIR/_kubectl


# Install minio completion
printf "\n${red}[completion] =>${no_color} Install minio completion\n"
[ -x "$(command -v mc)" ] && mc --autocompletion


# Install pnpm completion
printf "\n${red}[completion] =>${no_color} Install pnpm completion\n"
[ -x "$(command -v pnpm)" ] && pnpm completion zsh > $COMPLETION_DIR/_pnpm


# Install proto completion
printf "\n${red}[completion] =>${no_color} Install proto completion\n"
[ -x "$(command -v proto)" ] && proto completions --shell zsh > $COMPLETION_DIR/_proto


# Install scw completion
printf "\n${red}[completion] =>${no_color} Install scw completion\n"
[ -x "$(command -v scw)" ] && scw autocomplete install


# Install teleport completion
printf "\n${red}[completion] =>${no_color} Install teleport completion\n"
[ -x "$(command -v teleport)" ] && teleport --completion-script-zsh > $COMPLETION_DIR/_teleport
[ -x "$(command -v tbot)" ] && tbot --completion-script-zsh > $COMPLETION_DIR/_tbot
[ -x "$(command -v tctl)" ] && tctl --completion-script-zsh > $COMPLETION_DIR/_tctl
[ -x "$(command -v tsh)" ] && tsh --completion-script-zsh > $COMPLETION_DIR/_tsh


# Install terrafom completion
printf "\n${red}[completion] =>${no_color} Install terraform completion\n"
[ -x "$(command -v terraform)" ] && terraform -install-autocomplete


# Install vault completion
printf "\n${red}[completion] =>${no_color} Install vault completion\n"
[ -x "$(command -v vault)" ] && vault -autocomplete-install


# Install yq completion
printf "\n${red}[completion] =>${no_color} Install yq completion\n"
[ -x "$(command -v yq)" ] && yq completion zsh > $COMPLETION_DIR/_yq
