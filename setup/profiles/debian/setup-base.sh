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
    printf "\n${red}[base] =>${no_color} apt install failed (attempt %s/5), retrying in 10s...\n\n" "$attempt"
    sleep 10
  done
  return 1
}


install_lite_setup() {
  # Install apt packages
  printf "\n\n${red}[base] =>${no_color} Install apt packages\n\n"
  apt_install \
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
    rclone \
    ripgrep \
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


  # Install docker
  if [ ! -x "$(command -v docker)" ]; then
    printf "\n\n${red}[base] =>${no_color} Install docker\n\n"
    sudo mkdir -m 0755 -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
      "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    apt_install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  fi

  if ! grep -q -E "^docker:" /etc/group; then
    printf "\n\n${red}[base] =>${no_color} Add docker group\n\n"
    sudo groupadd docker
  fi

  if [ -z "$(groups $USER | grep 'docker')" ]; then
    printf "\n\n${red}[base] =>${no_color} Add user to docker group\n\n"
    sudo usermod -aG docker $USER
  fi


  # Install addition cheatsheets
  curl -fsSL https://raw.githubusercontent.com/this-is-tobi/tools/main/shell/clone-subdir.sh | bash -s -- \
    -u "https://github.com/this-is-tobi/cheatsheets" -s "sheets" -o "$HOME/.config/cheat/cheatsheets/personal" -d
}

install_additional_setup() {
  # Install apt packages
  apt_install \
    chafa \
    libimage-exiftool-perl \
    ffmpeg \
    github-cli \
    lazydocker \
    lazygit \
    nmap \
    pandoc \
    ttyd \
    vhs


  # Install glab
  # (installed from GitLab's own release packages rather than WakeMeOps:
  # WakeMeOps' Packages index has repeatedly advertised a glab version whose
  # .deb 404s on their mirror, e.g. this-is-tobi/tools#actions run 29404306736)
  if [ ! -x "$(command -v glab)" ]; then
    printf "\n\n${red}[base] =>${no_color} Install glab\n\n"
    if [ "$(uname -m)" = "x86_64" ] || [ "$(uname -m)" = "amd64" ]; then
      ARCH=amd64
    elif [ "$(uname -m)" = "arm64" ] || [ "$(uname -m)" = "aarch64" ]; then
      ARCH=arm64
    fi
    GLAB_VERSION=$(curl -fsSL "https://gitlab.com/api/v4/projects/gitlab-org%2Fcli/releases" | jq -r '.[0].tag_name' | sed 's/v//g')
    curl -fsSL -o /tmp/glab.deb "https://gitlab.com/gitlab-org/cli/-/releases/v${GLAB_VERSION}/downloads/glab_${GLAB_VERSION}_linux_${ARCH}.deb"
    sudo apt install -y /tmp/glab.deb
    rm /tmp/glab.deb
  fi


  # Install gh extensions
  printf "\n\n${red}[base] =>${no_color} Install gh extensions\n\n"
  gh extension install \
    dlvhdr/gh-dash \
    meiji163/gh-notify


  # Install nvim
  if [ ! -x "$(command -v nvim)" ]; then
    printf "\n\n${red}[base] =>${no_color} Install neovim\n\n"
    if [ "$(uname -m)" = "x86_64" ] || [ "$(uname -m)" = "amd64" ]; then
      ARCH=x86_64
    elif [ "$(uname -m)" = "arm64" ] || [ "$(uname -m)" = "aarch64" ]; then
      ARCH=arm64
    fi
    mkdir -p /tmp/nvim
    curl -fsSL -o /tmp/nvim/nvim-linux-${ARCH}.tar.gz "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${ARCH}.tar.gz"
    tar -xf /tmp/nvim/nvim-linux-${ARCH}.tar.gz -C /tmp/nvim
    # cp -a merges into existing directories (e.g. /usr/local/share/man,
    # already created non-empty by bat-extras' man pages); a plain
    # `mv .../share/* /usr/local/share` fails with "Directory not empty"
    # since mv can't atomically rename a dir over an existing non-empty one.
    sudo cp -a /tmp/nvim/nvim-linux-${ARCH}/bin/. /usr/local/bin/
    sudo cp -a /tmp/nvim/nvim-linux-${ARCH}/share/. /usr/local/share/
    sudo cp -a /tmp/nvim/nvim-linux-${ARCH}/lib/. /usr/local/lib/

    mkdir -p ~/.fonts
    # -o: force overwrite. Both zips ship a README.md/LICENSE, so the second
    # unzip always hits an overwrite prompt; on non-interactive stdin that
    # prompt reads EOF and unzip exits 1 (a "warning" exit code) even though
    # it correctly skips the file and continues - which set -e still aborts on.
    curl -fsSL -o /tmp/Hack.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip && unzip -o /tmp/Hack.zip -d ~/.fonts
    curl -fsSL -o /tmp/NerdFontsSymbolsOnly.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.zip && unzip -o /tmp/NerdFontsSymbolsOnly.zip -d ~/.fonts
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
    mkdir -p /tmp/skate
    SKATE_VERSION=$(curl -fsSL "https://api.github.com/repos/charmbracelet/skate/releases/latest" | jq -r '.tag_name' | sed 's/v//g')
    curl -fsSL -o /tmp/skate/skate_${SKATE_VERSION}_Linux_${ARCH}.tar.gz "https://github.com/charmbracelet/skate/releases/latest/download/skate_${SKATE_VERSION}_Linux_${ARCH}.tar.gz" \
      && tar -xf /tmp/skate/skate_${SKATE_VERSION}_Linux_${ARCH}.tar.gz -C /tmp/skate \
      && sudo mv /tmp/skate/skate_${SKATE_VERSION}_Linux_${ARCH}/skate /usr/local/bin/skate
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
