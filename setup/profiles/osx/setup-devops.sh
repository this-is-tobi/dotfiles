#!/bin/bash
# Profile: DevOps tools (Kubernetes, Terraform, Ansible, cloud CLIs, etc.)
# Order: 30
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
# identical to the pre-existing behavior. devops.Brewfile reads the same list.
DEVOPS_CATEGORIES="${DEVOPS_CATEGORIES:-all}"

devops_wants() {
  [ "$DEVOPS_CATEGORIES" = "all" ] && return 0
  case ",$DEVOPS_CATEGORIES," in
    *",$1,"*) return 0 ;;
    *) return 1 ;;
  esac
}


# Install homebrew packages (devops.Brewfile, lite and full mode, per category).
# terraform comes from HashiCorp's tap, which needs a core terraform out of the way.
printf "\n\n${red}[devops] =>${no_color} Install homebrew packages\n\n"
if devops_wants iac; then
  brew_leave_core terraform
fi
brew_bundle "$SCRIPT_PATH/profiles/osx/devops.Brewfile" HOMEBREW_DOTFILES_DEVOPS_CATEGORIES="$DEVOPS_CATEGORIES"

# Install krew plugins (lite and full mode)
if devops_wants k8s; then
  printf "\n\n${red}[devops/k8s] =>${no_color} Install krew plugins\n\n"
  run kubectl krew install \
    cert-manager \
    cnpg \
    df-pv \
    ktop \
    neat \
    stern \
    view-secret
fi
