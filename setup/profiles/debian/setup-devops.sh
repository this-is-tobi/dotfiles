#!/bin/bash

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'


install_lite_setup() {
  # Install apt packages
  printf "\n\n${red}[devops] =>${no_color} Install apt packages\n\n"
  sudo apt update && sudo apt install -y \
    helm \
    helm-docs \
    krew \
    kubectl \
    kubectx \
    kubens \
    minio-client \
    sshpass \
    terraform


  # Install krew plugins
  printf "\n\n${red}[devops] =>${no_color} Install krew plugins\n\n"
  krew install \
    cert-manager \
    cnpg \
    df-pv \
    ktop \
    neat \
    stern \
    view-secret


  # Install proto packages
  printf "\n\n${red}[devops] =>${no_color} Install proto packages\n\n"
  PACKAGES=(
    uv
  )
  for pkg in ${PACKAGES[*]}; do
    proto install $pkg
  done


  # Install ansible
  if [ ! -x "$(command -v ansible)" ]; then
    printf "\n\n${red}[devops] =>${no_color} Install ansible\n\n"
    uv venv $HOME/.venv
    source $HOME/.venv/bin/activate
    uv pip install ansible
  fi
}

install_additional_setup() {
  # Install apt packages
  printf "\n\n${red}[devops] =>${no_color} Install apt packages\n\n"
  sudo apt update && sudo apt install -y \
    act \
    argo \
    argocd \
    awscli \
    k6 \
    k9s \
    kind \
    libonig-dev \
    oc \
    python3-dev \
    scw \
    velero \
    yamllint


  # Install coder
  if [ ! -x "$(command -v coder)" ]; then
    printf "\n\n${red}[devops] =>${no_color} Install coder\n\n"
    curl -fsSL https://coder.com/install.sh | sh
  fi


  # Install mkcert
  if [ ! -x "$(command -v mkcert)" ]; then
    printf "\n\n${red}[devops] =>${no_color} Install mkcert\n\n"
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


  # Install chart-testing
  if [ ! -x "$(command -v ct)" ]; then
    printf "\n\n${red}[devops] =>${no_color} Install chart-testing\n\n"
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


  # Install ansible-lint
  if [ ! -x "$(command -v ansible-lint)" ]; then
    printf "\n\n${red}[devops] =>${no_color} Install ansible-lint\n\n"
    uv venv $HOME/.venv
    source $HOME/.venv/bin/activate
    uv pip install ansible-dev-tools
  fi


  # Install teleport
  if [ ! -x "$(command -v tsh)" ]; then
    printf "\n\n${red}[devops] =>${no_color} Install tsh\n\n"
    # Default to v18 if not set
    TELEPORT_VERSION=${TELEPORT_VERSION:-v18}
    TELEPORT_CHANNEL=stable/${TELEPORT_VERSION?}
    sudo mkdir -p /etc/apt/keyrings
    sudo curl -fsSL https://apt.releases.teleport.dev/gpg -o /etc/apt/keyrings/teleport-archive-keyring.asc
    # Source os-release to get distribution ID and version codename
    . /etc/os-release
    echo "deb [signed-by=/etc/apt/keyrings/teleport-archive-keyring.asc] https://apt.releases.teleport.dev/${ID?} ${VERSION_CODENAME?} ${TELEPORT_CHANNEL?}" \
      | sudo tee /etc/apt/sources.list.d/teleport.list > /dev/null
    sudo apt update && sudo apt install -y teleport
  fi
}


# Add wakemeops debian repo
if [ -z "$(find /etc/apt/ -name *.list | xargs cat | grep  ^[[:space:]]*deb) | grep wakemeops" ]; then
  printf "\n\n${red}[devops] =>${no_color} Add wakemeops apt repository\n\n"
  curl -fsSL https://raw.githubusercontent.com/upciti/wakemeops/main/assets/install_repository | sudo bash
fi

# Install lite setup
install_lite_setup

# Install full setup
if [ "$FULL_MODE_SETUP" = "true" ]; then
  install_additional_setup
fi
