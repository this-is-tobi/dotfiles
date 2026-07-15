#!/bin/bash
set -euo pipefail

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'

# WakeMeOps' mirror occasionally 404s on a package version that's listed in
# the Packages index but not yet synced to the CDN edge node serving the
# request; retrying (which re-fetches the index and may hit a different
# edge) typically clears it within a few tries.
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
  printf "\n\n${red}[devops/k8s] =>${no_color} Install apt packages\n\n"
  apt_install \
    helm \
    helm-docs \
    krew \
    kubectl \
    kubectx \
    kubens \
    oc

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

install_iac_lite() {
  printf "\n\n${red}[devops/iac] =>${no_color} Install apt packages\n\n"
  apt_install \
    terraform

  printf "\n\n${red}[devops/iac] =>${no_color} Install proto packages\n\n"
  PACKAGES=(
    uv
  )
  for pkg in ${PACKAGES[*]}; do
    proto install $pkg --pin global
  done

  if [ ! -x "$(command -v ansible)" ]; then
    printf "\n\n${red}[devops/iac] =>${no_color} Install ansible\n\n"
    uv venv $HOME/.venv
    source $HOME/.venv/bin/activate
    uv pip install ansible
  fi
}

install_misc_lite() {
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
  printf "\n\n${red}[devops/k8s] =>${no_color} Install apt packages\n\n"
  apt_install \
    argo \
    argocd \
    k9s \
    kind \
    velero

  if [ ! -x "$(command -v ct)" ]; then
    printf "\n\n${red}[devops/k8s] =>${no_color} Install chart-testing\n\n"
    if [ "$(uname -m)" = "x86_64" ] || [ "$(uname -m)" = "amd64" ]; then
      ARCH=amd64
    elif [ "$(uname -m)" = "arm64" ] || [ "$(uname -m)" = "aarch64" ]; then
      ARCH=arm64
    fi
    mkdir /tmp/chart-testing
    CT_VERSION=$(curl -fsSL "https://api.github.com/repos/helm/chart-testing/releases/latest" | jq -r '.tag_name' | sed 's/v//g')
    curl -fsSL -o /tmp/chart-testing/chart-testing_${CT_VERSION}_linux_${ARCH}.tar.gz "https://github.com/helm/chart-testing/releases/latest/download/chart-testing_${CT_VERSION}_linux_${ARCH}.tar.gz"
    tar -xf /tmp/chart-testing/chart-testing_${CT_VERSION}_linux_${ARCH}.tar.gz -C /tmp/chart-testing
    sudo mv /tmp/chart-testing/ct /usr/local/bin/ct
  fi
}

install_iac_full() {
  printf "\n\n${red}[devops/iac] =>${no_color} Install apt packages\n\n"
  apt_install \
    libonig-dev \
    python3-dev

  if [ ! -x "$(command -v ansible-lint)" ]; then
    printf "\n\n${red}[devops/iac] =>${no_color} Install ansible-lint\n\n"
    uv venv $HOME/.venv
    source $HOME/.venv/bin/activate
    uv pip install ansible-dev-tools
  fi
}

install_cloud_full() {
  printf "\n\n${red}[devops/cloud] =>${no_color} Install apt packages\n\n"
  apt_install \
    scw

  if [ ! -x "$(command -v aws)" ]; then
    printf "\n\n${red}[devops/cloud] =>${no_color} Install awscli\n\n"
    if [ "$(uname -m)" = "x86_64" ] || [ "$(uname -m)" = "amd64" ]; then
      ARCH=x86_64
    elif [ "$(uname -m)" = "arm64" ] || [ "$(uname -m)" = "aarch64" ]; then
      ARCH=aarch64
    fi
    mkdir -p /tmp/awscli
    curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-${ARCH}.zip" -o /tmp/awscli/awscliv2.zip
    cd /tmp/awscli && unzip -q awscliv2.zip
    sudo /tmp/awscli/aws/install
    rm -rf /tmp/awscli
  fi
}

install_misc_full() {
  printf "\n\n${red}[devops/misc] =>${no_color} Install apt packages\n\n"
  apt_install \
    act \
    k6 \
    yamllint

  if [ ! -x "$(command -v coder)" ]; then
    printf "\n\n${red}[devops/misc] =>${no_color} Install coder\n\n"
    curl -fsSL https://coder.com/install.sh | sh
  fi

  if [ ! -x "$(command -v mkcert)" ]; then
    printf "\n\n${red}[devops/misc] =>${no_color} Install mkcert\n\n"
    if [ "$(uname -m)" = "x86_64" ] || [ "$(uname -m)" = "amd64" ]; then
      ARCH=amd64
    elif [ "$(uname -m)" = "arm64" ] || [ "$(uname -m)" = "aarch64" ]; then
      ARCH=arm64
    fi
    mkdir /tmp/mkcert
    MKCERT_VERSION=$(curl -fsSL "https://api.github.com/repos/FiloSottile/mkcert/releases/latest" | jq -r '.tag_name' | sed 's/v//g')
    curl -fsSL -o /tmp/mkcert/mkcert-v${MKCERT_VERSION}-linux-${ARCH} "https://github.com/FiloSottile/mkcert/releases/latest/download/mkcert-v${MKCERT_VERSION}-linux-${ARCH}"
    chmod 755 /tmp/mkcert/mkcert-v${MKCERT_VERSION}-linux-${ARCH}
    sudo mv /tmp/mkcert/mkcert-v${MKCERT_VERSION}-linux-${ARCH} /usr/local/bin/mkcert
  fi

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


# Add wakemeops debian repo
if [ -z "$(find /etc/apt/ -name '*.list' | xargs cat | grep '^[[:space:]]*deb' | grep 'wakemeops')" ]; then
  printf "\n\n${red}[devops] =>${no_color} Add wakemeops apt repository\n\n"
  curl -fsSL https://raw.githubusercontent.com/upciti/wakemeops/main/assets/install_repository | sudo bash
fi

# Install lite setup
install_lite_setup

# Install full setup
if [ "$FULL_MODE_SETUP" = "true" ]; then
  install_additional_setup
fi
