# Homebrew packages of the devops profile, installed by setup-devops.sh with
# `brew bundle --file`. Lite mode (-l, HOMEBREW_DOTFILES_LITE=1) skips the
# `unless lite` blocks, and HOMEBREW_DOTFILES_DEVOPS_CATEGORIES (from
# DEVOPS_CATEGORIES) limits the categories: k8s, iac, cloud, misc or all. A
# formula from a third-party tap is named with its tap and marked trusted: true,
# which taps and trusts it.
lite = ENV["HOMEBREW_DOTFILES_LITE"] == "1"
categories = ENV.fetch("HOMEBREW_DOTFILES_DEVOPS_CATEGORIES", "all").split(",")
all = categories.include?("all")

if all || categories.include?("k8s")
  brew "helm"
  brew "cmctl"
  brew "norwoodj/tap/helm-docs", trusted: true
  brew "krew"
  brew "kubectx"
  brew "kubernetes-cli"
  brew "openshift-cli"

  unless lite
    brew "argo"
    brew "argocd"
    brew "chart-testing"
    brew "k9s"
    brew "kind"
    brew "velero"
  end
end

if all || categories.include?("iac")
  brew "ansible"
  # homebrew/core stopped at terraform 1.5.7, the last release before the
  # license change: HashiCorp's tap has the current ones
  brew "hashicorp/tap/terraform", trusted: true

  brew "ansible-lint" unless lite
end

if (all || categories.include?("cloud")) && !lite
  brew "scw"
end

if all || categories.include?("misc")
  brew "sshpass"

  unless lite
    brew "act"
    brew "actionlint"
    brew "coder/coder/coder", trusted: true
    brew "k6"
    brew "mkcert"
    brew "oras"
    brew "teleport"
    brew "yamllint"
  end
end
