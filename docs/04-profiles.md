# Installation Profiles

This document provides detailed information about each installation profile and the packages they include.

## Profile Overview

Profiles allow you to install groups of related tools based on your workflow. Each profile can be installed independently or combined with others.

```sh
# Install multiple profiles
./setup/setup-osx.sh -p 'devops,secops,js'
```

## Core Profile

The **Core** profile is always installed and provides essential system utilities.

### Command Line Interfaces

| Package                                                               | Description                                       | Lite | macOS    | Debian |
| --------------------------------------------------------------------- | ------------------------------------------------- | ---- | -------- | ------ |
| [build-essential](https://packages.debian.org/en/sid/build-essential) | Essential packages for building debian packages   | ✓    | -        | apt    |
| [ca-certificates](https://packages.debian.org/en/sid/ca-certificates) | Common CA certificates                            | ✓    | homebrew | apt    |
| [coreutils](https://www.gnu.org/software/coreutils)                   | Basic file, shell and text manipulation utilities | ✓    | -        | apt    |
| [curl](https://curl.se/)                                              | Command line tool for transferring data with URLs | ✓    | homebrew | apt    |
| [gnupg](https://gnupg.org)                                            | Encryption tool (GPG)                             | ✓    | homebrew | apt    |
| [gzip](https://www.gnu.org/software/gzip)                             | Data compression program                          | ✓    | homebrew | apt    |
| [jq](https://stedolan.github.io/jq)                                   | JSON processor tool                               | ✓    | homebrew | apt    |
| [locales](https://packages.debian.org/en/sid/locales)                 | Tools to generate locale definitions              | ✓    | -        | apt    |
| [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)                       | Zsh configuration manager                         | ✓    | shell    | shell  |
| [sed](https://www.gnu.org/software/sed)                               | Non-interactive command-line text editor          | ✓    | homebrew | apt    |
| [tar](https://www.gnu.org/software/tar)                               | Create and manipulate tar archives                | ✓    | -        | apt    |
| [unzip](https://packages.debian.org/en/sid/unzip)                     | De-archiver for zip files                         | ✓    | homebrew | apt    |
| [wget](https://www.gnu.org/software/wget)                             | Retrieve files using HTTP, HTTPS, FTP and FTPS    | ✓    | homebrew | apt    |
| [xz-utils](https://packages.debian.org/en/sid/xz-utils)               | XZ format compression utilities                   | ✓    | homebrew | apt    |

---

## Base Profile

The **Base** profile provides enhanced CLI tools and common applications for daily development work.

### Command Line Interfaces

| Package                                                   | Description                                           | Lite | macOS    | Debian |
| --------------------------------------------------------- | ----------------------------------------------------- | ---- | -------- | ------ |
| [bat](https://github.com/sharkdp/bat)                     | Cat command with syntax highlighting                  | ✓    | homebrew | apt    |
| [bat-extras](https://github.com/eth-p/bat-extras)         | Bat combo with other commands (batgrep, batman, etc.) | ✓    | homebrew | shell  |
| [chafa](https://hpjansson.org/chafa)                      | Image viewer in terminal                              | -    | homebrew | apt    |
| [cheat](https://github.com/cheat/cheat)                   | Create and view interactive cheat sheets              | ✓    | homebrew | apt    |
| [exiftool](https://exiftool.org)                          | Metadata writer and reader tool                       | -    | homebrew | apt    |
| [eza](https://eza.rocks)                                  | Modern ls replacement with colors and icons           | ✓    | homebrew | apt    |
| [fd](https://github.com/sharkdp/fd)                       | Simple, fast alternative to 'find'                    | ✓    | homebrew | apt    |
| [ffmpeg](https://ffmpeg.org)                              | Audio video manipulation tool                         | -    | homebrew | apt    |
| [fzf](https://github.com/junegunn/fzf)                    | Command-line fuzzy finder                             | ✓    | homebrew | apt    |
| [gh](https://cli.github.com)                              | GitHub official CLI                                   | -    | homebrew | apt    |
| [glab](https://gitlab.com/gitlab-org/cli)                 | GitLab official CLI                                   | -    | homebrew | apt    |
| [glow](https://github.com/charmbracelet/glow)             | Render markdown in the CLI with pizzazz               | ✓    | homebrew | apt    |
| [lazydocker](https://github.com/jesseduffield/lazydocker) | Simple terminal UI for docker commands                | -    | homebrew | apt    |
| [lazygit](https://github.com/jesseduffield/lazygit)       | Simple terminal UI for git commands                   | -    | homebrew | apt    |
| [nmap](https://nmap.org)                                  | Network port scanning utility                         | -    | homebrew | apt    |
| [nvim](https://neovim.io)                                 | Hyperextensible Vim-based text editor                 | -    | homebrew | shell  |
| [pandoc](https://pandoc.org)                              | Universal markup converter                            | -    | homebrew | apt    |
| [proto](https://moonrepo.dev/proto)                       | Pluggable multi-language version manager              | ✓    | homebrew | shell  |
| [ripgrep](https://github.com/BurntSushi/ripgrep)          | Recursively search directories for regex patterns     | ✓    | homebrew | apt    |
| [rclone](https://rclone.org)                              | Swiss army knife of cloud storage                     | -    | homebrew | apt    |
| [rsync](https://rsync.samba.org)                          | Fast incremental file transfer tool                   | ✓    | homebrew | apt    |
| [skate](https://github.com/charmbracelet/skate)           | Personal key-value store                              | -    | homebrew | shell  |
| [sshs](https://github.com/quantumsheep/sshs)              | Interactive SSH client                                | ✓    | homebrew | shell  |
| [tldr++](https://github.com/isacikgoz/tldr)               | Interactive cheatsheet tool                           | -    | homebrew | shell  |
| [tree](https://mama.indstate.edu/users/ice/tree)          | Display filesystem as tree                            | ✓    | homebrew | apt    |
| [ttyd](https://github.com/tsl0922/ttyd)                   | Share terminal over the web                           | -    | homebrew | apt    |
| [vhs](https://github.com/charmbracelet/vhs)               | CLI home video recorder (terminal recordings)         | -    | homebrew | apt    |
| [vim](https://www.vim.org)                                | Ubiquitous text editor                                | ✓    | homebrew | apt    |
| [watch](https://en.wikipedia.org/wiki/Watch_(command))    | Execute a program periodically                        | ✓    | homebrew | apt    |
| [yq](https://github.com/mikefarah/yq)                     | YAML processor (like jq for YAML)                     | ✓    | homebrew | apt    |

### GitHub CLI Extensions

| Extension                                          | Description                      | Lite | macOS | Debian |
| -------------------------------------------------- | -------------------------------- | ---- | ----- | ------ |
| [gh-dash](https://github.com/dlvhdr/gh-dash)       | GitHub dashboard in terminal     | -    | gh    | gh     |
| [gh-notify](https://github.com/meiji163/gh-notify) | GitHub notifications in terminal | -    | gh    | gh     |

### Applications (macOS only)

| Application                                                          | Description                 | Lite | Installation  |
| -------------------------------------------------------------------- | --------------------------- | ---- | ------------- |
| [Brave](https://brave.com/fr)                                        | Privacy-focused web browser | -    | homebrew cask |
| [Firefox](https://www.mozilla.org/firefox)                           | Privacy-focused web browser | -    | homebrew cask |
| [Insomnia](https://insomnia.rest)                                    | HTTP and GraphQL client     | -    | homebrew cask |
| [Mattermost](https://mattermost.com)                                 | Team collaboration platform | -    | homebrew cask |
| [OpenVPN Connect](https://openvpn.net/client-connect-vpn-for-mac-os) | VPN client                  | -    | homebrew cask |
| [VS Code](https://code.visualstudio.com)                             | Code editor and IDE         | -    | homebrew cask |

---

## DevOps Profile

The **DevOps** profile provides container orchestration, infrastructure as code, and cloud platform tools.

### Command Line Interfaces

| Package                                                      | Description                            | Lite | macOS    | Debian |
| ------------------------------------------------------------ | -------------------------------------- | ---- | -------- | ------ |
| [act](https://github.com/nektos/act)                         | Run GitHub Actions locally             | -    | homebrew | apt    |
| [ansible](https://docs.ansible.com)                          | IT automation tool                     | ✓    | homebrew | pip    |
| [ansible-lint](https://ansible.readthedocs.io/projects/lint) | Linter for Ansible playbooks           | -    | homebrew | pip    |
| [argo](https://argo-cd.readthedocs.io)                       | Argo Workflows CLI                     | -    | homebrew | apt    |
| [argocd](https://argo-cd.readthedocs.io)                     | Argo CD CLI for GitOps                 | -    | homebrew | apt    |
| [aws](https://aws.amazon.com/cli)                            | AWS command line interface             | -    | homebrew | apt    |
| [chart-testing](https://github.com/helm/chart-testing)       | Helm chart linting and testing         | -    | homebrew | shell  |
| [coder](https://coder.com)                                   | Coder remote development CLI           | -    | homebrew | shell  |
| [docker](https://www.docker.com)                             | Container runtime (Debian only)        | ✓    | -        | shell  |
| [helm](https://helm.sh)                                      | Kubernetes package manager             | ✓    | homebrew | apt    |
| [helm-docs](https://github.com/norwoodj/helm-docs)           | Auto-generate Helm chart documentation | ✓    | homebrew | apt    |
| [k6](https://k6.io)                                          | Modern load testing tool               | -    | homebrew | apt    |
| [k9s](https://k9scli.io)                                     | Kubernetes TUI                         | -    | homebrew | apt    |
| [kind](https://kind.sigs.k8s.io)                             | Kubernetes in Docker                   | -    | homebrew | apt    |
| [krew](https://sigs.k8s.io/krew)                             | kubectl plugin manager                 | ✓    | homebrew | apt    |
| [kubectl](https://kubernetes.io/docs/reference/kubectl)      | Kubernetes command-line tool           | ✓    | homebrew | apt    |
| [kubectx](https://github.com/ahmetb/kubectx)                 | Kubernetes context/namespace switcher  | ✓    | homebrew | apt    |
| [mc](https://github.com/minio/mc)                            | MinIO client for object storage        | ✓    | homebrew | apt    |
| [mkcert](https://github.com/FiloSottile/mkcert)              | Make locally trusted certificates      | -    | homebrew | shell  |
| [oc](https://www.openshift.com)                              | OpenShift CLI                          | -    | homebrew | apt    |
| [scw](https://github.com/scaleway/scaleway-cli)              | Scaleway CLI                           | -    | homebrew | apt    |
| [sshpass](https://sourceforge.net/projects/sshpass)          | Non-interactive SSH password auth      | ✓    | homebrew | apt    |
| [teleport](https://goteleport.com)                           | Modern SSH server for clusters         | -    | homebrew | apt    |
| [terraform](https://www.terraform.io)                        | Infrastructure as code tool            | ✓    | homebrew | apt    |
| [velero](https://velero.io)                                  | Kubernetes backup and migration        | -    | homebrew | apt    |
| [yamllint](https://yamllint.readthedocs.io)                  | Linter for YAML files                  | -    | homebrew | apt    |

### Applications (macOS only)

| Application                                                      | Description              | Lite | Installation  |
| ---------------------------------------------------------------- | ------------------------ | ---- | ------------- |
| [Docker Desktop](https://www.docker.com/products/docker-desktop) | Container management GUI | ✓    | homebrew cask |

### kubectl Plugins (via Krew)

| Plugin                                                        | Description                          | Lite | Installation |
| ------------------------------------------------------------- | ------------------------------------ | ---- | ------------ |
| [cert-manager](https://cert-manager.io)                       | cert-manager CLI (cmctl)             | ✓    | krew         |
| [cnpg](https://github.com/cloudnative-pg/cloudnative-pg)      | CloudNativePG operator CLI           | ✓    | krew         |
| [df-pv](https://github.com/yashbhutwala/kubectl-df-pv)        | Show disk usage of PersistentVolumes | ✓    | krew         |
| [ktop](https://github.com/vladimirvivien/ktop)                | Top-like tool for Kubernetes         | ✓    | krew         |
| [neat](https://github.com/itaysk/kubectl-neat)                | Clean up Kubernetes YAML output      | ✓    | krew         |
| [stern](https://github.com/stern/stern)                       | Multi-pod log tailing                | ✓    | krew         |
| [view-secret](https://github.com/elsesiy/kubectl-view-secret) | Decode Kubernetes secrets easily     | ✓    | krew         |

---

## SecOps Profile

The **SecOps** profile provides security scanning, secret management, and compliance tools.

### Command Line Interfaces

| Package                                             | Description                        | Lite | macOS    | Debian |
| --------------------------------------------------- | ---------------------------------- | ---- | -------- | ------ |
| [age](https://github.com/FiloSottile/age)           | Simple, modern file encryption     | -    | homebrew | apt    |
| [cosign](https://docs.sigstore.dev)                 | Container signing and verification | ✓    | homebrew | apt    |
| [dive](https://github.com/wagoodman/dive)           | Docker image layer explorer        | -    | homebrew | apt    |
| [gitleaks](https://github.com/gitleaks/gitleaks)    | Secret scanner for git repos       | -    | homebrew | shell  |
| [kubescape](https://github.com/kubescape/kubescape) | Kubernetes security scanner        | -    | homebrew | apt    |
| [kyverno](https://github.com/kyverno/kyverno)       | Kubernetes policy engine CLI       | -    | homebrew | apt    |
| [sops](https://github.com/getsops/sops)             | Encrypted file editor              | -    | homebrew | apt    |
| [trivy](https://aquasecurity.github.io/trivy)       | Vulnerability scanner              | ✓    | homebrew | apt    |
| [vault](https://vaultproject.io)                    | HashiCorp Vault CLI                | -    | homebrew | apt    |

---

## JavaScript Profile

The **JavaScript** profile provides Node.js runtime and package managers.

### Command Line Interfaces

| Package                                  | Description                          | Lite | macOS | Debian |
| ---------------------------------------- | ------------------------------------ | ---- | ----- | ------ |
| [@antfu/ni](https://github.com/antfu/ni) | Package manager wrapper              | ✓    | npm   | npm    |
| [bun](https://bun.sh)                    | Fast JavaScript runtime              | -    | proto | proto  |
| [node](https://nodejs.org)               | JavaScript runtime                   | ✓    | proto | proto  |
| [npm](https://github.com/npm/cli)        | Node package manager                 | ✓    | proto | proto  |
| [pnpm](https://pnpm.io)                  | Fast, disk-efficient package manager | -    | proto | proto  |
| [yarn](https://yarnpkg.com)              | Package manager and project manager  | -    | proto | proto  |

---

## Go Profile

The **Go** profile provides Go language development tools and Kubernetes operator SDKs.

### Command Line Interfaces

| Package                                                       | Description                      | Lite | macOS    | Debian |
| ------------------------------------------------------------- | -------------------------------- | ---- | -------- | ------ |
| [cobra-cli](https://github.com/spf13/cobra)                   | CLI application builder          | -    | go       | go     |
| [go](https://go.dev)                                          | Go programming language          | ✓    | proto    | proto  |
| [kubebuilder](https://github.com/kubernetes-sigs/kubebuilder) | SDK for building Kubernetes APIs | -    | homebrew | apt    |
| [kustomize](https://github.com/kubernetes-sigs/kustomize)     | Kubernetes YAML customization    | -    | homebrew | apt    |
| [operator-sdk](https://sdk.operatorframework.io)              | Kubernetes operator SDK          | -    | homebrew | apt    |

---

## AI Profile

The **AI** profile provides tools for running large language models locally.

### Applications

| Application                  | Description      | Lite | macOS         | Debian |
| ---------------------------- | ---------------- | ---- | ------------- | ------ |
| [Ollama](https://ollama.com) | Run LLMs locally | -    | homebrew cask | shell  |

---

## Extras Profile (macOS Only)

The **Extras** profile provides personal productivity and media applications.

### Applications

| Application                                                  | Description             | Lite | Installation  |
| ------------------------------------------------------------ | ----------------------- | ---- | ------------- |
| [Audacity](https://www.audacityteam.org)                     | Audio editing software  | -    | homebrew cask |
| [Discord](https://discord.com)                               | Voice and chat platform | -    | homebrew cask |
| [Raspberry Pi Imager](https://www.raspberrypi.org/downloads) | OS image flasher        | -    | homebrew cask |
| [Soulseek](https://slsknet.org)                              | P2P file sharing        | -    | homebrew cask |
| [Transmission](https://transmissionbt.com)                   | BitTorrent client       | -    | homebrew cask |
| [VLC](https://videolan.org)                                  | Media player            | ✓    | homebrew cask |

---

## Installation Tips

### Combining Profiles

Profiles can be mixed and matched:

```sh
# Minimal full-stack developer
./setup/setup-osx.sh -l -p 'base,js'

# DevOps with security tools
./setup/setup-osx.sh -p 'devops,secops'

# Everything except extras
./setup/setup-osx.sh -p 'base,ai,devops,go,js,secops'
```

### Lite Mode Strategy

Use lite mode (`-l`) to install only essential tools, then add specific tools manually:

```sh
./setup/setup-osx.sh -l -p 'devops,js'
brew install <additional-tool>
```

### Package Sources

- **homebrew** - macOS package manager
- **apt** - Debian package manager (with WakeMeOps repo)
- **shell** - Shell script installation
- **proto** - Proto version manager
- **npm** - Node package manager
- **pip** - Python package manager
- **go** - Go package manager
- **gh** - GitHub CLI extension
- **krew** - kubectl plugin manager
