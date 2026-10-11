# Homebrew packages of the extras profile, installed by setup-extras.sh with
# `brew bundle --file`. Lite mode (-l, HOMEBREW_DOTFILES_LITE=1) skips the
# `unless lite` block.
lite = ENV["HOMEBREW_DOTFILES_LITE"] == "1"

cask "vlc"

unless lite
  cask "audacity"
  cask "discord"
  cask "raspberry-pi-imager"
  cask "soulseek"
  cask "transmission"
end
