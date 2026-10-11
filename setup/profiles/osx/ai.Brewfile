# Homebrew packages of the ai profile, installed by setup-ai.sh with
# `brew bundle --file`. Lite mode (-l, HOMEBREW_DOTFILES_LITE=1) skips the
# `unless lite` block. A formula from a third-party tap is named with its tap
# and marked trusted: true, which taps and trusts it.
lite = ENV["HOMEBREW_DOTFILES_LITE"] == "1"

brew "direnv"

unless lite
  brew "rtk-ai/tap/rtk", trusted: true

  # claude-code and copilot-cli are CLIs, but Homebrew only ships them as casks
  cask "claude-code"
  cask "copilot-cli"
  cask "ollama"
end
