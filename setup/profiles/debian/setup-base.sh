#!/bin/bash
set -euo pipefail

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'

# Get current script path (this file lives in setup/profiles/debian/)
SCRIPT_PATH="$( cd -- "$(dirname "$0")/../.." >/dev/null 2>&1 ; pwd -P )"

# shellcheck source=../../helpers/mise.sh
. "$SCRIPT_PATH/helpers/mise.sh"
# shellcheck source=../../helpers/remote.sh
. "$SCRIPT_PATH/helpers/remote.sh"
# shellcheck source=../../helpers/fonts.sh
. "$SCRIPT_PATH/helpers/fonts.sh"

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


install_bat_extras() (
  local build_dir
  build_dir="$(mktemp -d)"
  # sudo: the install step runs as root and leaves root-owned build files behind
  trap 'sudo rm -rf "$build_dir"' EXIT
  git clone -b "$(curl -fsSL https://api.github.com/repos/eth-p/bat-extras/releases/latest | jq -r '.tag_name')" --depth 1 https://github.com/eth-p/bat-extras "$build_dir"
  sudo "$build_dir/build.sh" --install
)

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
    # A private temporary directory: the build runs as root, so it must not be
    # a path another user could pre-create. bat-extras is a convenience, so a
    # failure (GitHub API rate limit, offline mirror) only warns.
    if ! install_bat_extras; then
      printf "Warning: bat-extras could not be installed, skipping it\n" >&2
    fi
  fi


  # Install docker
  if [ ! -x "$(command -v docker)" ]; then
    printf "\n\n${red}[base] =>${no_color} Install docker\n\n"
    # Docker publishes one apt repository per distribution
    docker_distro="$(. /etc/os-release && echo "$ID")"
    docker_codename="$(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")"
    case "$docker_distro" in
      debian | ubuntu) ;;
      *)
        printf "Error: the docker apt repository is only configured for debian and ubuntu, found '%s'\n" "$docker_distro" >&2
        exit 1;;
    esac
    sudo mkdir -m 0755 -p /etc/apt/keyrings
    curl -fsSL "https://download.docker.com/linux/${docker_distro}/gpg" | sudo gpg --dearmor --yes -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/${docker_distro} ${docker_codename} stable" \
      | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    apt_install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  fi

  if ! grep -q -E "^docker:" /etc/group; then
    printf "\n\n${red}[base] =>${no_color} Add docker group\n\n"
    sudo groupadd docker
  fi

  docker_user="${USER:-$(id -un)}"
  if ! id -nG "$docker_user" | grep -qw docker; then
    printf "\n\n${red}[base] =>${no_color} Add user to docker group\n\n"
    sudo usermod -aG docker "$docker_user"
  fi


  # Install addition cheatsheets
  run_remote bash "$TOOLS_RAW_BASE/shell/clone-subdir.sh" \
    -u "https://github.com/this-is-tobi/cheatsheets" -s "sheets" -o "$HOME/.config/cheat/cheatsheets/personal" -d
}

install_additional_setup() {
  # Install apt packages
  printf "\n\n${red}[base] =>${no_color} Install apt packages\n\n"
  apt_install \
    chafa \
    fontconfig \
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
    ttyd@latest \
    vhs@latest \
    github:isacikgoz/tldr@latest


  # Install gh extensions
  printf "\n\n${red}[base] =>${no_color} Install gh extensions\n\n"
  for extension in dlvhdr/gh-dash meiji163/gh-notify; do
    gh extension list | grep -q "$extension" || gh extension install "$extension"
  done


  # Install neovim fonts
  if [ ! -d "$HOME/.fonts" ]; then
    printf "\n\n${red}[base] =>${no_color} Install neovim fonts\n\n"
    install_nerd_fonts
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
