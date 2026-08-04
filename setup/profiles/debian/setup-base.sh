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
    printf "\n${red}[base] =>${no_color} apt install failed (attempt %s/5), retrying in 10s...\n\n" "$attempt"
    sleep 10
  done
  return 1
}


install_lite_setup() {
  # Install apt packages
  # Only packages that genuinely belong to the system live here: shared
  # libraries, man infrastructure and anything with a daemon or setuid bit.
  # Portable single-binary tools come from mise below.
  printf "\n\n${red}[base] =>${no_color} Install apt packages\n\n"
  apt_install \
    coreutils \
    man \
    man-db \
    manpages-dev \
    tree \
    vim \
    watch


  # Install mise packages
  # These ship under their upstream binary names (bat, fd), unlike Debian's
  # batcat/fdfind, so no symlinks are needed.
  printf "\n\n${red}[base] =>${no_color} Install mise packages\n\n"
  mise_use \
    bat@latest \
    cheat@latest \
    eza@latest \
    fd@latest \
    fzf@latest \
    glow@latest \
    rclone@latest \
    ripgrep@latest \
    yq@latest \
    aqua:quantumsheep/sshs@latest


  # Install bat-extras for additional bat commands
  if [ ! -f /usr/local/bin/batman ]; then
    printf "\n\n${red}[base] =>${no_color} Install bat-extras\n\n"
    git clone -b "$(curl -fsSL https://api.github.com/repos/eth-p/bat-extras/releases/latest | jq -r '.tag_name')" --depth 1 https://github.com/eth-p/bat-extras /tmp/bat-extras \
      && sudo /tmp/bat-extras/build.sh --install
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
  printf "\n\n${red}[base] =>${no_color} Install apt packages\n\n"
  apt_install \
    chafa \
    libimage-exiftool-perl \
    ffmpeg \
    nmap \
    pandoc


  # Install mise packages
  # tldr goes through the github backend rather than the registry: isacikgoz's
  # fork is not registered there, and it publishes linux assets only - which is
  # why macOS installs it from the isacikgoz/taps Homebrew tap instead.
  # neovim is addressed through aqua explicitly: its registry entry lists a
  # vfox plugin first, and aqua verifies checksums on the upstream release
  # assets instead of running a third-party plugin script.
  printf "\n\n${red}[base] =>${no_color} Install mise packages\n\n"
  mise_use \
    github-cli@latest \
    glab@latest \
    lazydocker@latest \
    lazygit@latest \
    aqua:neovim/neovim@latest \
    skate@latest \
    ttyd@latest \
    vhs@latest \
    github:isacikgoz/tldr@latest


  # Install gh extensions
  printf "\n\n${red}[base] =>${no_color} Install gh extensions\n\n"
  gh extension install \
    dlvhdr/gh-dash \
    meiji163/gh-notify


  # Install neovim fonts
  if [ ! -d "$HOME/.fonts" ]; then
    printf "\n\n${red}[base] =>${no_color} Install neovim fonts\n\n"
    mkdir -p ~/.fonts
    # -o: force overwrite. Both zips ship a README.md/LICENSE, so the second
    # unzip always hits an overwrite prompt; on non-interactive stdin that
    # prompt reads EOF and unzip exits 1 (a "warning" exit code) even though
    # it correctly skips the file and continues - which set -e still aborts on.
    curl -fsSL -o /tmp/Hack.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip && unzip -o /tmp/Hack.zip -d ~/.fonts
    curl -fsSL -o /tmp/NerdFontsSymbolsOnly.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.zip && unzip -o /tmp/NerdFontsSymbolsOnly.zip -d ~/.fonts
    fc-cache -fv
  fi
}


# Install mise
ensure_mise

# Install lite setup
install_lite_setup

# Install full setup
if [ "$FULL_MODE_SETUP" = "true" ]; then
  install_additional_setup
fi
