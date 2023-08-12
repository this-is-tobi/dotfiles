#!/bin/bash

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'


# Add wakemeops debian repo
if [ -z "$(find /etc/apt/ -name '*.list' | xargs cat | grep '^[[:space:]]*deb' | grep 'wakemeops')" ]; then
  printf "\n\n${red}[devops] =>${no_color} Add wakemeops apt repository\n\n"
  curl -sSL https://raw.githubusercontent.com/upciti/wakemeops/main/assets/install_repository | sudo bash
fi


# Updating apt cache
printf "\n\n${red}[base] =>${no_color} Update apt cache\n\n"
sudo apt update


# Install utils packages
printf "\n\n${red}[base] =>${no_color} Install apt packages\n\n"
sudo apt install -y \
  bat \
  chafa \
  exa \
  libimage-exiftool-perl \
  ffmpeg \
  fzf \
  github-cli \
  glab \
  gnupg \
  jq \
  lazydocker \
  nmap \
  ripgrep \
  rsync \
  tree \
  vim \
  wget \
  yq


# Install tldr++
if [ ! -x "$(command -v tldr)" ]; then
  printf "\n\n${red}[base] =>${no_color} Install tldr++\n\n"
  curl -L -o /tmp/tldr.tar.gz $(curl -s "https://api.github.com/repos/isacikgoz/tldr/releases/latest" \
      | jq -r --arg a $(dpkg --print-architecture) '.assets[] | select(.name | match("tldr_.*_linux_" + $a + "\\.tar\\.gz")) | .browser_download_url') \
    && tar -C /tmp -xzf /tmp/tldr.tar.gz \
    && sudo mv /tmp/tldr /usr/local/bin
fi


# Create symlink for bat : https://github.com/sharkdp/bat#on-ubuntu-using-apt
if [ ! -L ~/.local/bin/bat ]; then
  printf "\n\n${red}[base] =>${no_color} Create symlink for bat\n\n"
  mkdir -p ~/.local/bin
  ln -s /usr/bin/batcat ~/.local/bin/bat
fi


# Install bat-extras for additional bat commands
if [ ! -f /usr/local/bin/batman ]; then
  printf "\n\n${red}[base] =>${no_color} Install bat-extras\n\n"
  git clone -b "$(curl -s https://api.github.com/repos/eth-p/bat-extras/releases/latest | jq -r '.tag_name')" --depth 1 https://github.com/eth-p/bat-extras /tmp/bat-extras \
    && sudo /tmp/bat-extras/build.sh --install
fi


# Install docker
if [ ! -x "$(command -v docker)" ]; then
  printf "\n\n${red}[base] =>${no_color} Install docker\n\n"
  sudo apt install -y ca-certificates curl gnupg
  sudo mkdir -m 0755 -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
    "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo chmod a+r /etc/apt/keyrings/docker.gpg
  sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
fi

# Add group docker if missing
if [ ! -z $(grep -q -E "^docker:" /etc/group)]; then
  printf "\n\n${red}[base] =>${no_color} Add docker group\n\n"
  sudo groupadd docker
fi

# Add user in docker group is missing
if [ -z "$(groups $USER | grep 'docker')" ]; then
  printf "\n\n${red}[base] =>${no_color} Add user to docker group\n\n"
  sudo usermod -aG docker $USER
fi


# Install fzf-zsh-plugin
git clone --depth 1 https://github.com/unixorn/fzf-zsh-plugin.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-zsh-plugin
