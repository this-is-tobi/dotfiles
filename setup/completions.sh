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


# Install glow completion
printf "\n${red}[completion] =>${no_color} Install glow completion\n"
[ -x "$(command -v glow)" ] && glow completion zsh > $COMPLETION_DIR/_glow


# Install helm completion
printf "\n${red}[completion] =>${no_color} Install helm completion\n"
[ -x "$(command -v helm)" ] && helm completion zsh > $COMPLETION_DIR/_helm


# Install kind completion
printf "\n${red}[completion] =>${no_color} Install kind completion\n"
[ -x "$(command -v kind)" ] && kind completion zsh > $COMPLETION_DIR/_kind


# Install kubebuilder completion
printf "\n${red}[completion] =>${no_color} Install kubebuilder completion\n"
[ -x "$(command -v kubebuilder)" ] && kubebuilder completion zsh > $COMPLETION_DIR/_kubebuilder


# Install kubectl completion
printf "\n${red}[completion] =>${no_color} Install kubectl completion\n"
[ -x "$(command -v kubectl)" ] && kubectl completion zsh > $COMPLETION_DIR/_kubectl


# Install kubectl-cnpg completion
printf "\n${red}[completion] =>${no_color} Install kubectl-cnpg completion\n"
[ -x "$(command -v kubectl-cnpg)" ] && kubectl-cnpg completion zsh > $COMPLETION_DIR/_kubectl-cnpg


# Install kubectl-kubescape completion
printf "\n${red}[completion] =>${no_color} Install kubectl-kubescape completion\n"
[ -x "$(command -v kubectl-kubescape)" ] && kubectl-kubescape completion zsh > $COMPLETION_DIR/_kubectl-kubescape


# Install kubectl-kyverno completion
printf "\n${red}[completion] =>${no_color} Install kubectl-kyverno completion\n"
[ -x "$(command -v kubectl-kyverno)" ] && kubectl-kyverno completion zsh > $COMPLETION_DIR/_kubectl-kyverno


# Install kustomize completion
printf "\n${red}[completion] =>${no_color} Install kustomize completion\n"
[ -x "$(command -v kustomize)" ] && kustomize completion zsh > $COMPLETION_DIR/_kustomize


# Install minio completion
printf "\n${red}[completion] =>${no_color} Install minio completion\n"
[ -x "$(command -v mc)" ] && mc --autocompletion


# Install operator-sdk completion
printf "\n${red}[completion] =>${no_color} Install operator-sdk completion\n"
[ -x "$(command -v operator-sdk)" ] && operator-sdk completion zsh > $COMPLETION_DIR/_operator-sdk


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


# Install terraform completion
printf "\n${red}[completion] =>${no_color} Install terraform completion\n"
[ -x "$(command -v terraform)" ] && terraform -install-autocomplete


# Install trivy completion
printf "\n${red}[completion] =>${no_color} Install trivy completion\n"
[ -x "$(command -v trivy)" ] && trivy completion zsh > $COMPLETION_DIR/_trivy


# Install vault completion
printf "\n${red}[completion] =>${no_color} Install vault completion\n"
[ -x "$(command -v vault)" ] && vault -autocomplete-install


# Install velero completion
printf "\n${red}[completion] =>${no_color} Install velero completion\n"
[ -x "$(command -v velero)" ] && velero completion zsh > $COMPLETION_DIR/_velero


# Install yq completion
printf "\n${red}[completion] =>${no_color} Install yq completion\n"
[ -x "$(command -v yq)" ] && yq completion zsh > $COMPLETION_DIR/_yq
