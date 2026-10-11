#!/bin/bash
set -euo pipefail

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'

# Get current script path (this file lives in setup/profiles/osx/)
SCRIPT_PATH="$( cd -- "$(dirname "$0")/../.." >/dev/null 2>&1 && pwd -P )"

# shellcheck source=../../helpers/brew.sh
. "$SCRIPT_PATH/helpers/brew.sh"

# Optionally restrict which tool categories get installed, e.g. for a
# container image that only needs Kubernetes tooling:
#   DEVOPS_CATEGORIES=k8s ./setup-osx.sh -p devops -l
# Categories: k8s, iac, cloud, misc. Default 'all' installs everything,
# identical to the pre-existing behavior.
DEVOPS_CATEGORIES="${DEVOPS_CATEGORIES:-all}"

devops_wants() {
  [ "$DEVOPS_CATEGORIES" = "all" ] && return 0
  case ",$DEVOPS_CATEGORIES," in
    *",$1,"*) return 0 ;;
    *) return 1 ;;
  esac
}


install_k8s_lite() {
  printf "\n\n${red}[devops/k8s] =>${no_color} Install homebrew packages (cli)\n\n"
  brew install --formula \
    helm \
    norwoodj/tap/helm-docs \
    krew \
    kubectx \
    kubernetes-cli \
    openshift-cli

  printf "\n\n${red}[devops/k8s] =>${no_color} Install krew plugins\n\n"
  kubectl krew install \
    cert-manager \
    cnpg \
    df-pv \
    ktop \
    neat \
    stern \
    view-secret
}

install_iac_lite() {
  # homebrew/core stopped at terraform 1.5.7, the last release before the
  # license change: HashiCorp's tap has the current ones. Naming the formula
  # with its tap is what makes Homebrew add (and trust) the tap.
  printf "\n\n${red}[devops/iac] =>${no_color} Install homebrew packages (cli)\n\n"
  brew_leave_core terraform
  brew install --formula \
    ansible \
    hashicorp/tap/terraform
}

install_misc_lite() {
  printf "\n\n${red}[devops/misc] =>${no_color} Install homebrew packages (cli)\n\n"
  brew install --formula \
    sshpass
}

install_lite_setup() {
  devops_wants k8s && install_k8s_lite
  devops_wants iac && install_iac_lite
  devops_wants misc && install_misc_lite
  return 0
}


install_k8s_full() {
  printf "\n\n${red}[devops/k8s] =>${no_color} Install homebrew packages (cli)\n\n"
  brew install --formula \
    argo \
    argocd \
    chart-testing \
    k9s \
    kind \
    velero
}

install_iac_full() {
  printf "\n\n${red}[devops/iac] =>${no_color} Install homebrew packages (cli)\n\n"
  brew install --formula \
    ansible-lint
}

install_cloud_full() {
  printf "\n\n${red}[devops/cloud] =>${no_color} Install homebrew packages (cli)\n\n"
  brew install --formula \
    scw
}

install_misc_full() {
  printf "\n\n${red}[devops/misc] =>${no_color} Install homebrew packages (cli)\n\n"
  brew install --formula \
    act \
    actionlint \
    coder/coder/coder \
    k6 \
    mkcert \
    oras \
    teleport \
    yamllint
}

install_additional_setup() {
  devops_wants k8s && install_k8s_full
  devops_wants iac && install_iac_full
  devops_wants cloud && install_cloud_full
  devops_wants misc && install_misc_full
  return 0
}


# Install lite setup
install_lite_setup

# Install full setup (the default, -l of the setup script turns it off)
if [ "${FULL_MODE_SETUP:-true}" = "true" ]; then
  install_additional_setup
fi
