#!/bin/bash
set -euo pipefail

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'

# Get current script path (this file lives in setup/profiles/debian/)
SCRIPT_PATH="$( cd -- "$(dirname "$0")/../.." >/dev/null 2>&1 ; pwd -P )"

# shellcheck source=../../helpers/mise.sh
. "$SCRIPT_PATH/helpers/mise.sh"

# Debian mirrors occasionally fail a fetch mid-run (transient DNS, a mirror
# rotating out behind a round-robin, or a proxy hiccup in CI); retrying picks a
# fresh connection and usually clears it.
apt_install() {
  local attempt
  for attempt in 1 2 3 4 5; do
    if sudo apt update && sudo apt install -y "$@"; then
      return 0
    fi
    printf "\n${red}[devops] =>${no_color} apt install failed (attempt %s/5), retrying in 10s...\n\n" "$attempt"
    sleep 10
  done
  return 1
}

# Optionally restrict which tool categories get installed, e.g. for a
# container image that only needs Kubernetes tooling:
#   DEVOPS_CATEGORIES=k8s ./setup-debian.sh -p devops -l
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
  # kubens is its own mise tool (aqua:ahmetb/kubectx/kubens), installed
  # alongside kubectx rather than bundled with it.
  printf "\n\n${red}[devops/k8s] =>${no_color} Install mise packages\n\n"
  mise_use \
    helm@latest \
    helm-docs@latest \
    krew@latest \
    kubectl@latest \
    kubectx@latest \
    kubens@latest \
    oc@latest

  printf "\n\n${red}[devops/k8s] =>${no_color} Install krew plugins\n\n"
  krew install \
    cert-manager \
    cnpg \
    df-pv \
    ktop \
    neat \
    stern \
    view-secret
}

# ansible is installed by uv rather than mise. mise's pipx backend picks
# whichever python3 it finds on the machine - Homebrew's on macOS, the distro's
# on Debian - which is both unpinnable (no mise setting controls it) and
# fragile: ansible-core requires >= 3.12, so a distro shipping 3.11 cannot
# satisfy it, and a brew python upgrade orphans the venv it was built against.
# `uv tool install --python` pins an explicit, self-contained interpreter that
# neither apt nor brew can move, and puts the entry points in ~/.local/bin
# (already on PATH) instead of a venv that has to be activated first.
ANSIBLE_PYTHON="${ANSIBLE_PYTHON:-3.13}"

install_iac_lite() {
  printf "\n\n${red}[devops/iac] =>${no_color} Install mise packages\n\n"
  mise_use \
    terraform@latest \
    uv@latest

  if [ ! -x "$(command -v ansible)" ]; then
    printf "\n\n${red}[devops/iac] =>${no_color} Install ansible\n\n"
    uv tool install --python "$ANSIBLE_PYTHON" ansible
  fi
}

install_misc_lite() {
  # sshpass stays on apt: it is a setuid-adjacent helper that pokes at the
  # controlling tty, not a portable release binary.
  printf "\n\n${red}[devops/misc] =>${no_color} Install apt packages\n\n"
  apt_install \
    sshpass
}

install_lite_setup() {
  devops_wants k8s && install_k8s_lite
  devops_wants iac && install_iac_lite
  devops_wants misc && install_misc_lite
  return 0
}


install_k8s_full() {
  # chart-testing has no short name in mise's registry, so it is addressed
  # through its aqua package directly. It provides the `ct` binary.
  printf "\n\n${red}[devops/k8s] =>${no_color} Install mise packages\n\n"
  mise_use \
    argo@latest \
    argocd@latest \
    k9s@latest \
    kind@latest \
    velero@latest \
    aqua:helm/chart-testing@latest
}

install_iac_full() {
  printf "\n\n${red}[devops/iac] =>${no_color} Install apt packages\n\n"
  apt_install \
    libonig-dev \
    python3-dev

  if [ ! -x "$(command -v ansible-lint)" ]; then
    printf "\n\n${red}[devops/iac] =>${no_color} Install ansible-dev-tools\n\n"
    # Same interpreter as ansible above so both toolchains agree.
    uv tool install --python "$ANSIBLE_PYTHON" ansible-dev-tools
  fi
}

install_cloud_full() {
  # scw has no short name in mise's registry; aqua packages it under the
  # upstream repository name.
  printf "\n\n${red}[devops/cloud] =>${no_color} Install mise packages\n\n"
  mise_use \
    aqua:scaleway/scaleway-cli@latest
}

install_misc_full() {
  # yamllint resolves through mise's pipx backend, which provisions its own
  # Python if none is present.
  printf "\n\n${red}[devops/misc] =>${no_color} Install mise packages\n\n"
  mise_use \
    act@latest \
    coder@latest \
    k6@latest \
    mkcert@latest \
    yamllint@latest

  # Teleport stays on its own apt repository: tsh is one binary of a suite that
  # also ships teleport/tctl/tbot plus a systemd unit.
  if [ ! -x "$(command -v tsh)" ]; then
    printf "\n\n${red}[devops/misc] =>${no_color} Install tsh\n\n"
    # Default to v18 if not set
    TELEPORT_VERSION=${TELEPORT_VERSION:-v18}
    TELEPORT_CHANNEL=stable/${TELEPORT_VERSION?}
    sudo mkdir -p /etc/apt/keyrings
    sudo curl -fsSL https://apt.releases.teleport.dev/gpg -o /etc/apt/keyrings/teleport-archive-keyring.asc
    # Source os-release to get distribution ID and version codename
    . /etc/os-release
    echo "deb [signed-by=/etc/apt/keyrings/teleport-archive-keyring.asc] https://apt.releases.teleport.dev/${ID?} ${VERSION_CODENAME?} ${TELEPORT_CHANNEL?}" \
      | sudo tee /etc/apt/sources.list.d/teleport.list > /dev/null
    apt_install teleport
  fi
}

install_additional_setup() {
  devops_wants k8s && install_k8s_full
  devops_wants iac && install_iac_full
  devops_wants cloud && install_cloud_full
  devops_wants misc && install_misc_full
  return 0
}


# Install mise
ensure_mise

# Install lite setup
install_lite_setup

# Install full setup
if [ "$FULL_MODE_SETUP" = "true" ]; then
  install_additional_setup
fi
