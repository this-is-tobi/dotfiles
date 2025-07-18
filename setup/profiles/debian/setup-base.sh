#!/bin/bash

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'


install_lite_setup() {
  # Install apt packages
  printf "\n\n${red}[base] =>${no_color} Install apt packages\n\n"
  sudo apt update && sudo apt install -y \
    bat \
    cheat \
    coreutils \
    eza \
    fd-find \
    fzf \
    glow \
    man \
    man-db \
    manpages-dev \
    ripgrep \
    rsync \
    tree \
    vim \
    watch \
    yq


  # Create symlink for bat : https://github.com/sharkdp/bat#on-ubuntu-using-apt
  if [ ! -L ~/.local/bin/bat ]; then
    printf "\n\n${red}[base] =>${no_color} Create symlink for bat\n\n"
    mkdir -p ~/.local/bin
    ln -s /usr/bin/batcat ~/.local/bin/bat
  fi


  # Install bat-extras for additional bat commands
  if [ ! -f /usr/local/bin/batman ]; then
    printf "\n\n${red}[base] =>${no_color} Install bat-extras\n\n"
    git clone -b "$(curl -fsSL https://api.github.com/repos/eth-p/bat-extras/releases/latest | jq -r '.tag_name')" --depth 1 https://github.com/eth-p/bat-extras /tmp/bat-extras \
      && sudo /tmp/bat-extras/build.sh --install
  fi


  # Install proto
  if [ ! -x "$(command -v proto)" ]; then
    printf "\n\n${red}[base] =>${no_color} Install proto\n\n"
    curl -fsSL https://moonrepo.dev/install/proto.sh | bash -s -- --yes
  fi


  # Install sshs
  if [ ! -x "$(command -v sshs)" ]; then
    printf "\n\n${red}[base] =>${no_color} Install sshs\n\n"
    if [ "$(uname -m)" = "arm64" ] || [ "$(uname -m)" = "aarch64" ]; then
      ARCH=arm64
    else
      ARCH=amd64
    fi
    curl -fsSL -o "/tmp/sshs-linux-$ARCH" "https://github.com/quantumsheep/sshs/releases/latest/download/sshs-linux-$ARCH"
    sudo install -m 555 "/tmp/sshs-linux-$ARCH" /usr/local/bin/sshs
    rm "/tmp/sshs-linux-$ARCH"
  fi
}

install_additional_setup() {
  # Install apt packages
  sudo apt update && sudo apt install -y \
    chafa \
    libimage-exiftool-perl \
    ffmpeg \
    github-cli \
    glab \
    lazydocker \
    lazygit \
    nmap \
    pandoc \
    rclone \
    ttyd \
    vhs


  # Install nvim
  if [ ! -x "$(command -v nvim)" ]; then
    printf "\n\n${red}[base] =>${no_color} Install neovim\n\n"
    if [ "$(uname -m)" = "x86_64" ] || [ "$(uname -m)" = "amd64" ]; then
      ARCH=x86_64
    elif [ "$(uname -m)" = "arm64" ] || [ "$(uname -m)" = "aarch64" ]; then
      ARCH=arm64
    fi
    mkdir /tmp/nvim
    curl -fsSL -o /tmp/nvim/nvim-linux-${ARCH}.tar.gz "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${ARCH}.tar.gz"
    tar -xf /tmp/nvim/nvim-linux-${ARCH}.tar.gz -C /tmp/nvim 
    sudo mv /tmp/nvim/nvim-linux-${ARCH}/bin/* /usr/local/bin 
    sudo mv /tmp/nvim/nvim-linux-${ARCH}/share/* /usr/local/share 
    sudo mv /tmp/nvim/nvim-linux-${ARCH}/lib/* /usr/local/lib

    mkdir ~/.fonts
    curl -fsSL -o /tmp/Ubuntu.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Ubuntu.zip && unzip /tmp/Ubuntu.zip -d ~/.fonts 
    curl -fsSL -o /tmp/NerdFontsSymbolsOnly.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.zip && unzip /tmp/NerdFontsSymbolsOnly.zip -d ~/.fonts 
    fc-cache -fv
  fi


  # Install skate
  if [ ! -x "$(command -v skate)" ]; then
    printf "\n\n${red}[base] =>${no_color} Install skate\n\n"
    if [ "$(uname -m)" = "x86_64" ] || [ "$(uname -m)" = "amd64" ]; then
      ARCH=x86_64
    elif [ "$(uname -m)" = "arm64" ] || [ "$(uname -m)" = "aarch64" ]; then
      ARCH=arm64
    fi
    mkdir /tmp/skate
    SKATE_VERSION=$(curl -fsSL "https://api.github.com/repos/charmbracelet/skate/releases/latest" | jq -r '.tag_name' | sed 's/v//g')
    curl -fsSL -o /tmp/skate/skate_${SKATE_VERSION}_Linux_${ARCH}.tar.gz "https://github.com/charmbracelet/skate/releases/latest/download/skate_${SKATE_VERSION}_Linux_${ARCH}.tar.gz"
    tar -xf /tmp/skate/skate_${SKATE_VERSION}_Linux_${ARCH}.tar.gz -C /tmp/skate
    sudo mv /tmp/skate/skate_${SKATE_VERSION}_Linux_${ARCH}/skate_1.0.1_Linux_arm64 /usr/local/bin/skate
  fi


  # Install tldr++
  if [ ! -x "$(command -v tldr)" ]; then
    printf "\n\n${red}[base] =>${no_color} Install tldr++\n\n"
    curl -fsSL -o /tmp/tldr.tar.gz $(curl -s "https://api.github.com/repos/isacikgoz/tldr/releases/latest" \
      | jq -r --arg a $(dpkg --print-architecture) '.assets[] | select(.name | match("tldr_.*_linux_" + $a + "\\.tar\\.gz")) | .browser_download_url') \
      && tar -C /tmp -xzf /tmp/tldr.tar.gz \
      && sudo mv /tmp/tldr /usr/local/bin
  fi
}


# Add wakemeops debian repo
if [ -z "$(find /etc/apt/ -name '*.list' | xargs cat | grep '^[[:space:]]*deb' | grep 'wakemeops')" ]; then
  printf "\n\n${red}[base] =>${no_color} Add wakemeops apt repository\n\n"
  curl -fsSL https://raw.githubusercontent.com/upciti/wakemeops/main/assets/install_repository | sudo bash
fi

# Install lite setup
install_lite_setup

# Install full setup
if [ "$FULL_MODE_SETUP" = "true" ]; then
  install_additional_setup
fi
