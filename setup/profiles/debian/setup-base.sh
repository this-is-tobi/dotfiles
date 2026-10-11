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
# shellcheck source=../../helpers/apt.sh
. "$SCRIPT_PATH/helpers/apt.sh"


# bat-extras is a set of bash scripts. Its release zip carries them already
# built, so nothing of it runs during the install, and the zip must have the
# sha256 of the reviewed release. The scripts go to ~/.local/bin (on PATH) and
# their man pages to ~/.local/share/man, without root.
BAT_EXTRAS_VERSION="2024.08.24"
BAT_EXTRAS_SHA256="d79c085b9d0af7f56c3f69d766a83fe26405faac999c4ed7cdfc27417d2c736f"

# Each step is checked: set -e does not apply to a function called from an `if`
install_bat_extras() (
  local tmp
  tmp="$(mktemp -d)" || exit 1
  trap 'rm -rf "$tmp"' EXIT
  fetch_verified "https://github.com/eth-p/bat-extras/releases/download/v$BAT_EXTRAS_VERSION/bat-extras-$BAT_EXTRAS_VERSION.zip" \
    "$BAT_EXTRAS_SHA256" "$tmp/bat-extras.zip" || exit 1
  unzip -q "$tmp/bat-extras.zip" -d "$tmp/bat-extras" || exit 1
  mkdir -p "$HOME/.local/bin" "$HOME/.local/share/man/man1" || exit 1
  install -m 755 "$tmp"/bat-extras/bin/* "$HOME/.local/bin/" || exit 1
  install -m 644 "$tmp"/bat-extras/man/*.1 "$HOME/.local/share/man/man1/"
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


  # Install bat-extras for additional bat commands, unless this version is there.
  # Its scripts carry their version, which is what the check reads.
  if ! grep -qsF "\"$BAT_EXTRAS_VERSION\"" "$HOME/.local/bin/batman"; then
    printf "\n\n${red}[base] =>${no_color} Install bat-extras %s\n\n" "$BAT_EXTRAS_VERSION"
    # bat-extras is a convenience, so a failure (offline, a checksum mismatch)
    # only warns.
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
    apt_sources_changed
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
