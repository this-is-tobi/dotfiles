#!/bin/bash
# Profile: DevOps tools (Kubernetes, Terraform, Ansible, cloud CLIs, etc.)
# Order: 30
set -euo pipefail

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'

# Get current script path (this file lives in setup/profiles/debian/)
SCRIPT_PATH="$( cd -- "$(dirname "$0")/../.." >/dev/null 2>&1 ; pwd -P )"

# shellcheck source=../../helpers/mise.sh
. "$SCRIPT_PATH/helpers/mise.sh"
# shellcheck source=../../helpers/apt.sh
. "$SCRIPT_PATH/helpers/apt.sh"

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
    cmctl@latest \
    helm-docs@latest \
    krew@latest \
    kubectl@latest \
    kubectx@latest \
    kubens@latest \
    oc@latest

  printf "\n\n${red}[devops/k8s] =>${no_color} Install krew plugins\n\n"
  run krew install \
    cnpg \
    df-pv \
    ktop \
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
# The `ansible` package is only a bundle: its own entry point is
# `ansible-community`, so the executables of the ansible-core it pulls in
# (ansible, ansible-playbook, ...) have to be requested explicitly, and the same
# goes for ansible-lint inside ansible-dev-tools.
ANSIBLE_PYTHON="${ANSIBLE_PYTHON:-3.13}"

install_iac_lite() {
  printf "\n\n${red}[devops/iac] =>${no_color} Install mise packages\n\n"
  mise_use \
    terraform@latest \
    uv@latest

  if [ ! -x "$(command -v ansible)" ]; then
    printf "\n\n${red}[devops/iac] =>${no_color} Install ansible\n\n"
    run uv tool install --python "$ANSIBLE_PYTHON" --with-executables-from ansible-core ansible
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
    run uv tool install --python "$ANSIBLE_PYTHON" --with-executables-from ansible-lint ansible-dev-tools
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
    actionlint@latest \
    coder@latest \
    k6@latest \
    oras@latest \
    yamllint@latest

  # Teleport stays on its own apt repository: tsh is one binary of a suite that
  # also ships teleport/tctl/tbot plus a systemd unit.
  if [ ! -x "$(command -v tsh)" ]; then
    printf "\n\n${red}[devops/misc] =>${no_color} Install tsh\n\n"
    # Default to v18 if not set
    TELEPORT_VERSION=${TELEPORT_VERSION:-v18}
    TELEPORT_CHANNEL=stable/${TELEPORT_VERSION?}
    run add_teleport_apt_repository "$TELEPORT_CHANNEL"
    apt_sources_changed
    apt_install teleport
  fi
}

add_teleport_apt_repository() {
  local channel="$1"
  sudo mkdir -p /etc/apt/keyrings
  sudo curl -fsSL https://apt.releases.teleport.dev/gpg -o /etc/apt/keyrings/teleport-archive-keyring.asc
  # Source os-release to get distribution ID and version codename
  . /etc/os-release
  echo "deb [signed-by=/etc/apt/keyrings/teleport-archive-keyring.asc] https://apt.releases.teleport.dev/${ID?} ${VERSION_CODENAME?} ${channel}" \
    | sudo tee /etc/apt/sources.list.d/teleport.list > /dev/null
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

# Install full setup (the default, -l of the setup script turns it off)
if [ "${FULL_MODE_SETUP:-true}" = "true" ]; then
  install_additional_setup
fi
