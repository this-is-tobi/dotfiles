#!/bin/bash

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'

# Get current script path
REPO_ROOT=$(git rev-parse --show-toplevel)

# Set completion directory
export COMPLETION_DIR=$HOME/.oh-my-zsh/completions


# Create completion directory if not exists
[ ! -d "$COMPLETION_DIR" ] && mkdir -p "$COMPLETION_DIR"


# Install argo completion
[ -x "$(command -v argo)" ] \
  && printf "\n${red}[completion] =>${no_color} Install argo completion\n" \
  && argo completion zsh > $COMPLETION_DIR/_argo


# Install argocd completion
[ -x "$(command -v argocd)" ] \
  && printf "\n${red}[completion] =>${no_color} Install argocd completion\n" \
  && argocd completion zsh > $COMPLETION_DIR/_argocd


# Install chart-testing completion
[ -x "$(command -v ct)" ] \
  && printf "\n${red}[completion] =>${no_color} Install chart-testing completion\n" \
  && ct completion zsh > $COMPLETION_DIR/_ct


# Install cheat completion
[ -x "$(command -v cheat)" ] \
  && printf "\n${red}[completion] =>${no_color} Install cheat completion\n" \
  && curl -fsSL -o $COMPLETION_DIR/_cheat https://raw.githubusercontent.com/cheat/cheat/master/scripts/cheat.zsh


# Install cobra completion
[ -x "$(command -v cobra-cli)" ] \
  && printf "\n${red}[completion] =>${no_color} Install cobra completion\n" \
  && cobra-cli completion zsh > $COMPLETION_DIR/_cobra-cli


# Install docker completion
[ -x "$(command -v docker)" ] \
  && printf "\n${red}[completion] =>${no_color} Install docker completion\n" \
  && docker completion zsh > $COMPLETION_DIR/_docker


# Install gitleaks completion
[ -x "$(command -v gitleaks)" ] \
  && printf "\n${red}[completion] =>${no_color} Install gitleaks completion\n" \
  && gitleaks completion zsh > $COMPLETION_DIR/_gitleaks


# Install glow completion
[ -x "$(command -v glow)" ] \
  && printf "\n${red}[completion] =>${no_color} Install glow completion\n" \
  && glow completion zsh > $COMPLETION_DIR/_glow


# Install helm completion
[ -x "$(command -v helm)" ] \
  && printf "\n${red}[completion] =>${no_color} Install helm completion\n" \
  && helm completion zsh > $COMPLETION_DIR/_helm


# Install kind completion
[ -x "$(command -v kind)" ] \
  && printf "\n${red}[completion] =>${no_color} Install kind completion\n" \
  && kind completion zsh > $COMPLETION_DIR/_kind


# Install kubebuilder completion
[ -x "$(command -v kubebuilder)" ] \
  && printf "\n${red}[completion] =>${no_color} Install kubebuilder completion\n" \
  && kubebuilder completion zsh > $COMPLETION_DIR/_kubebuilder


# Install kubectl completion
[ -x "$(command -v kubectl)" ] \
  && printf "\n${red}[completion] =>${no_color} Install kubectl completion\n" \
  && kubectl completion zsh > $COMPLETION_DIR/_kubectl


# Install kubectl-cnpg completion
[ -x "$(command -v kubectl-cnpg)" ] \
  && printf "\n${red}[completion] =>${no_color} Install kubectl-cnpg completion\n" \
  && kubectl-cnpg completion zsh > $COMPLETION_DIR/_kubectl-cnpg


# Install kubectl-kubescape completion
[ -x "$(command -v kubectl-kubescape)" ] \
  && printf "\n${red}[completion] =>${no_color} Install kubectl-kubescape completion\n" \
  && kubectl-kubescape completion zsh > $COMPLETION_DIR/_kubectl-kubescape


# Install kubectl-stern completion
[ -x "$(command -v kubectl-stern)" ] \
  && printf "\n${red}[completion] =>${no_color} Install kubectl-stern completion\n" \
  && kubectl-stern --completion zsh > $COMPLETION_DIR/_kubectl-stern


# Install kubectl-view_secret completion
[ -x "$(command -v kubectl-view_secret)" ] \
  && printf "\n${red}[completion] =>${no_color} Install kubectl-view_secret completion\n" \
  && cp $REPO_ROOT/dotfiles/.oh-my-zsh/completions/_kubectl-view_secret $COMPLETION_DIR/_kubectl-view_secret


# Install kubens completion
[ -x "$(command -v kubens)" ] \
  && printf "\n${red}[completion] =>${no_color} Install kubens completion\n" \
  && curl -fsSL https://raw.githubusercontent.com/ahmetb/kubectx/refs/heads/master/completion/_kubens.zsh > $COMPLETION_DIR/_kubens


# Install kubens completion
[ -x "$(command -v kubectx)" ] \
  && printf "\n${red}[completion] =>${no_color} Install kubectx completion\n" \
  && curl -fsSL https://raw.githubusercontent.com/ahmetb/kubectx/refs/heads/master/completion/_kubectx.zsh > $COMPLETION_DIR/_kubectx


# Install kustomize completion
[ -x "$(command -v kustomize)" ] \
  && printf "\n${red}[completion] =>${no_color} Install kustomize completion\n" \
  && kustomize completion zsh > $COMPLETION_DIR/_kustomize


# Install kyverno completion
[ -x "$(command -v kyverno)" ] \
  && printf "\n${red}[completion] =>${no_color} Install kyverno completion\n" \
  && kyverno completion zsh > $COMPLETION_DIR/_kyverno


# Install minio completion
[ -x "$(command -v mc)" ] \
  && printf "\n${red}[completion] =>${no_color} Install minio completion\n" \
  && mc --autocompletion


# Install ollama completion
[ -x "$(command -v ollama)" ] \
  && printf "\n${red}[completion] =>${no_color} Install ollama completion\n" \
  && curl -fsSL -o $COMPLETION_DIR/_ollama https://gist.githubusercontent.com/obeone/9313811fd61a7cbb843e0001a4434c58/raw/_ollama.zsh


# Install operator-sdk completion
[ -x "$(command -v operator-sdk)" ] \
  && printf "\n${red}[completion] =>${no_color} Install operator-sdk completion\n" \
  && operator-sdk completion zsh > $COMPLETION_DIR/_operator-sdk


# Install pnpm completion
[ -x "$(command -v pnpm)" ] \
  && printf "\n${red}[completion] =>${no_color} Install pnpm completion\n" \
  && pnpm completion zsh > $COMPLETION_DIR/_pnpm


# Install proto completion
[ -x "$(command -v proto)" ] \
  && printf "\n${red}[completion] =>${no_color} Install proto completion\n" \
  && proto completions --shell zsh > $COMPLETION_DIR/_proto


# Install scw completion
[ -x "$(command -v scw)" ] \
  && printf "\n${red}[completion] =>${no_color} Install scw completion\n" \
  && scw autocomplete install shell=zsh


# Install skate completion
[ -x "$(command -v skate)" ] \
  && printf "\n${red}[completion] =>${no_color} Install skate completion\n" \
  && skate completion zsh > $COMPLETION_DIR/_skate


# Install teleport completion
[ -x "$(command -v teleport)" ] \
  && printf "\n${red}[completion] =>${no_color} Install teleport completion\n" \
  && teleport --completion-script-zsh > $COMPLETION_DIR/_teleport
[ -x "$(command -v tbot)" ] \
  && printf "\n${red}[completion] =>${no_color} Install tbot completion\n" \
  && tbot --completion-script-zsh > $COMPLETION_DIR/_tbot
[ -x "$(command -v tctl)" ] \
  && printf "\n${red}[completion] =>${no_color} Install tctl completion\n" \
  && tctl --completion-script-zsh > $COMPLETION_DIR/_tctl
[ -x "$(command -v tsh)" ] \
  && printf "\n${red}[completion] =>${no_color} Install tsh completion\n" \
  && tsh --completion-script-zsh > $COMPLETION_DIR/_tsh


# Install terraform completion
[ -x "$(command -v terraform)" ] \
  && printf "\n${red}[completion] =>${no_color} Install terraform completion\n" \
  && terraform -install-autocomplete


# Install trivy completion
[ -x "$(command -v trivy)" ] \
  && printf "\n${red}[completion] =>${no_color} Install trivy completion\n" \
  && trivy completion zsh > $COMPLETION_DIR/_trivy


# Install vault completion
[ -x "$(command -v vault)" ] \
  && printf "\n${red}[completion] =>${no_color} Install vault completion\n" \
  && vault -autocomplete-install


# Install velero completion
[ -x "$(command -v velero)" ] \
  && printf "\n${red}[completion] =>${no_color} Install velero completion\n" \
  && velero completion zsh > $COMPLETION_DIR/_velero


# Install yq completion
[ -x "$(command -v yq)" ] \
  && printf "\n${red}[completion] =>${no_color} Install yq completion\n" \
  && yq completion zsh > $COMPLETION_DIR/_yq
