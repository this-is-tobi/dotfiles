# Homebrew packages of the base profile, installed by setup-base.sh with
# `brew bundle --file`. Lite mode (-l, HOMEBREW_DOTFILES_LITE=1) skips the
# `unless lite` block. A formula from a third-party tap is named with its tap
# and marked trusted: true, which taps and trusts it.
lite = ENV["HOMEBREW_DOTFILES_LITE"] == "1"

brew "bat"
brew "bat-extras"
brew "cheat"
brew "eza"
brew "fd"
brew "fzf"
brew "glow"
brew "mise"
brew "rclone"
brew "ripgrep"
brew "sshs"
brew "tree"
brew "vim"
brew "watch"
brew "yq"

cask "docker"

unless lite
  brew "chafa"
  brew "exiftool"
  brew "ffmpeg"
  brew "gh"
  brew "glab"
  brew "lazydocker"
  brew "lazygit"
  brew "nmap"
  brew "nvim"
  brew "pandoc"
  brew "isacikgoz/taps/tldr", trusted: true
  brew "ttyd"
  brew "vhs"

  cask "brave-browser"
  cask "firefox"
  cask "insomnia"
  cask "mattermost"
  cask "openvpn-connect"
  cask "visual-studio-code"
end
