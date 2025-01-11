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


  # Install glow
  if [ ! -x "$(command -v glow)" ]; then
    printf "\n\n${red}[base] =>${no_color} Install glow\n\n"
    if [ "$(uname -m)" = "x86_64" ] || [ "$(uname -m)" = "amd64" ]; then
      ARCH=x86_64
    elif [ "$(uname -m)" = "arm64" ] || [ "$(uname -m)" = "aarch64" ]; then
      ARCH=arm64
    fi
    mkdir /tmp/glow
    GLOW_VERSION=$(curl -fsSL "https://api.github.com/repos/charmbracelet/glow/releases/latest" | jq -r '.tag_name' | sed 's/v//g')
    curl -fsSL -o /tmp/glow.tar.gz "https://github.com/charmbracelet/glow/releases/latest/download/glow_${GLOW_VERSION}_Linux_${ARCH}.tar.gz"
    tar -xf /tmp/glow.tar.gz -C /tmp
    sudo mv /tmp/glow/glow /usr/local/bin
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
    nmap \
    ttyd


  # Install nvim
  if [ ! -x "$(command -v nvim)" ]; then
    printf "\n\n${red}[base] =>${no_color} Install neovim\n\n"
    mkdir /tmp/nvim
    curl -fsSL -o /tmp/nvim/nvim-linux64.tar.gz "https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz"
    tar -xf /tmp/nvim/nvim-linux64.tar.gz -C /tmp/nvim 
    sudo mv /tmp/nvim/nvim-linux64/bin/* /usr/local/bin 
    sudo mv /tmp/nvim/nvim-linux64/man/man1/* /usr/local/man/man1 
    sudo mv /tmp/nvim/nvim-linux64/share/* /usr/local/share 
    sudo mv /tmp/nvim/nvim-linux64/lib/* /usr/local/lib

    mkdir ~/.fonts
    curl -fsSL -o /tmp/Ubuntu.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Ubuntu.zip && unzip /tmp/Ubuntu.zip -d ~/.fonts 
    curl -fsSL -o /tmp/NerdFontsSymbolsOnly.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.zip && unzip /tmp/NerdFontsSymbolsOnly.zip -d ~/.fonts 
    fc-cache -fv
  fi


  # Install tldr++
  if [ ! -x "$(command -v tldr)" ]; then
    printf "\n\n${red}[base] =>${no_color} Install tldr++\n\n"
    curl -fsSL -o /tmp/tldr.tar.gz $(curl -s "https://api.github.com/repos/isacikgoz/tldr/releases/latest" \
        | jq -r --arg a $(dpkg --print-architecture) '.assets[] | select(.name | match("tldr_.*_linux_" + $a + "\\.tar\\.gz")) | .browser_download_url') \
      && tar -C /tmp -xzf /tmp/tldr.tar.gz \
      && sudo mv /tmp/tldr /usr/local/bin
  fi


  # Install lazygit
  if [ ! -x "$(command -v lazygit)" ]; then
    printf "\n\n${red}[base] =>${no_color} Install lazygit\n\n"
    if [ "$(uname -m)" = "x86_64" ] || [ "$(uname -m)" = "amd64" ]; then
      ARCH=x86_64
    elif [ "$(uname -m)" = "arm64" ] || [ "$(uname -m)" = "aarch64" ]; then
      ARCH=arm64
    fi
    mkdir /tmp/lazygit
    LAZYGIT_VERSION=$(curl -fsSL "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -fsSL -o /tmp/lazygit/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_${ARCH}.tar.gz"
    tar -xf /tmp/lazygit/lazygit.tar.gz -C /tmp/lazygit
    sudo install /tmp/lazygit/lazygit /usr/local/bin
  fi


  # Install vhs
  if [ ! -x "$(command -v vhs)" ]; then
    printf "\n\n${red}[base] =>${no_color} Install vhs\n\n"
    if [ "$(uname -m)" = "x86_64" ] || [ "$(uname -m)" = "amd64" ]; then
      ARCH=x86_64
    elif [ "$(uname -m)" = "arm64" ] || [ "$(uname -m)" = "aarch64" ]; then
      ARCH=arm64
    fi
    mkdir /tmp/vhs
    VHS_VERSION=$(curl -fsSL "https://api.github.com/repos/charmbracelet/vhs/releases/latest" | jq -r '.tag_name' | sed 's/v//g')
    curl -fsSL -o /tmp/vhs.tar.gz "https://github.com/charmbracelet/vhs/releases/latest/download/vhs_${VHS_VERSION}_Linux_${ARCH}.tar.gz"
    tar -xf /tmp/vhs.tar.gz -C /tmp
    sudo mv /tmp/vhs/vhs /usr/local/bin
  fi


  # Install teleport
  if [ ! -x "$(command -v tsh)" ]; then
    printf "\n\n${red}[base] =>${no_color} Install tsh\n\n"
    TELEPORT_EDITION="oss"
    TELEPORT_VERSION="$(curl -fsSL "https://api.github.com/repos/gravitational/teleport/releases/latest" | jq -r '.tag_name' | sed -E 's/v([0-9]+\.[0-9]+\.[0-9]+)/\1/g')"
    # install script will use apt package manager
    curl -fsSL https://goteleport.com/static/install.sh | bash -s ${TELEPORT_VERSION?} ${TELEPORT_EDITION?}
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
