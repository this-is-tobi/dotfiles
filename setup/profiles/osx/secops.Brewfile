# Homebrew packages of the secops profile, installed by setup-secops.sh with
# `brew bundle --file`. Lite mode (-l, HOMEBREW_DOTFILES_LITE=1) skips the
# `unless lite` block. A formula from a third-party tap is named with its tap
# and marked trusted: true, which taps and trusts it.
lite = ENV["HOMEBREW_DOTFILES_LITE"] == "1"

brew "cosign"
brew "gitleaks"
brew "trivy"

unless lite
  brew "age"
  brew "dive"
  brew "kubescape"
  brew "kyverno"
  brew "sops"
  # homebrew/core stopped at vault 1.14.4, the last release before the license
  # change: HashiCorp's tap has the current ones
  brew "hashicorp/tap/vault", trusted: true
end
