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
| [curl](https://curl.se/)                                              | Command line tool for transferring data with URLs | ✓    | homebrew | apt    |
| [git](https://git-scm.com)                                            | Distributed version control system                | ✓    | -        | apt    |
| [gnupg](https://gnupg.org)                                            | Encryption tool (GPG)                             | ✓    | homebrew | apt    |
| [gsed](https://www.gnu.org/software/sed)                              | GNU sed, installed under the name gsed            | ✓    | homebrew | -      |
| [gzip](https://www.gnu.org/software/gzip)                             | Data compression program                          | ✓    | homebrew | apt    |
| [jq](https://stedolan.github.io/jq)                                   | JSON processor tool                               | ✓    | homebrew | apt    |
| [locales](https://packages.debian.org/en/sid/locales)                 | Tools to generate locale definitions              | ✓    | -        | apt    |
| [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)                       | Zsh configuration manager                         | ✓    | shell    | shell  |
| [sed](https://www.gnu.org/software/sed)                               | Non-interactive command-line text editor          | ✓    | -        | apt    |
| [tar](https://www.gnu.org/software/tar)                               | Create and manipulate tar archives                | ✓    | -        | apt    |
| [unzip](https://packages.debian.org/en/sid/unzip)                     | De-archiver for zip files                         | ✓    | homebrew | apt    |
| [wget](https://www.gnu.org/software/wget)                             | Retrieve files using HTTP, HTTPS, FTP and FTPS    | ✓    | homebrew | apt    |
| [xz-utils](https://packages.debian.org/en/sid/xz-utils)               | XZ format compression utilities                   | ✓    | homebrew | apt    |
| [zsh](https://www.zsh.org)                                            | Z shell, made the default login shell             | ✓    | -        | apt    |

On macOS the system tools stay in place: git comes with the Command Line Tools, zsh ships with macOS and the BSD `sed` is not replaced. GNU sed is installed as `gsed`, and `.zshrc` aliases `sed` to it when `gsed` is present. On Debian, `coreutils` is installed by the Base profile (see below).

---

## Base Profile

The **Base** profile provides enhanced CLI tools and common applications for daily development work.

### Command Line Interfaces

| Package                                                            | Description                                                                                                | Lite | macOS    | Debian |
| ------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------- | ---- | -------- | ------ |
| [bat](https://github.com/sharkdp/bat)                              | Cat command with syntax highlighting                                                                       | ✓    | homebrew | mise   |
| [bat-extras](https://github.com/eth-p/bat-extras)                  | Bat combo with other commands (batgrep, batman, etc.)                                                      | ✓    | homebrew | shell  |
| [chafa](https://hpjansson.org/chafa)                               | Image viewer in terminal                                                                                   | -    | homebrew | apt    |
| [cheat](https://github.com/cheat/cheat)                            | Create and view interactive cheat sheets                                                                   | ✓    | homebrew | mise   |
| [coreutils](https://www.gnu.org/software/coreutils)                | Basic file, shell and text manipulation utilities (Debian)                                                 | ✓    | -        | apt    |
| [docker](https://www.docker.com)                                   | Container runtime (Debian: CLI/engine via apt; macOS: bundled with Docker Desktop, see Applications below) | ✓    | -        | apt    |
| [exiftool](https://exiftool.org)                                   | Metadata writer and reader tool                                                                            | -    | homebrew | apt    |
| [eza](https://eza.rocks)                                           | Modern ls replacement with colors and icons                                                                | ✓    | homebrew | mise   |
| [fd](https://github.com/sharkdp/fd)                                | Simple, fast alternative to 'find'                                                                         | ✓    | homebrew | mise   |
| [ffmpeg](https://ffmpeg.org)                                       | Audio video manipulation tool                                                                              | -    | homebrew | apt    |
| [fontconfig](https://www.freedesktop.org/wiki/Software/fontconfig) | Font configuration library, provides fc-cache (Debian)                                                     | -    | -        | apt    |
| [fzf](https://github.com/junegunn/fzf)                             | Command-line fuzzy finder                                                                                  | ✓    | homebrew | mise   |
| [gh](https://cli.github.com)                                       | GitHub official CLI                                                                                        | -    | homebrew | mise   |
| [glab](https://gitlab.com/gitlab-org/cli)                          | GitLab official CLI                                                                                        | -    | homebrew | mise   |
| [glow](https://github.com/charmbracelet/glow)                      | Render markdown in the CLI with pizzazz                                                                    | ✓    | homebrew | mise   |
| [lazydocker](https://github.com/jesseduffield/lazydocker)          | Simple terminal UI for docker commands                                                                     | -    | homebrew | mise   |
| [lazygit](https://github.com/jesseduffield/lazygit)                | Simple terminal UI for git commands                                                                        | -    | homebrew | mise   |
| [man](https://www.nongnu.org/man-db)                               | Manual page viewer (Debian)                                                                                | ✓    | -        | apt    |
| [man-db](https://www.nongnu.org/man-db)                            | Manual page database and tools (Debian)                                                                    | ✓    | -        | apt    |
| [manpages-dev](https://packages.debian.org/en/sid/manpages-dev)    | Manual pages about using GNU/Linux for development                                                         | ✓    | -        | apt    |
| [mise](https://mise.jdx.dev)                                       | Version manager: language runtimes on both platforms, plus CLI binaries on Debian                          | ✓    | homebrew | apt    |
| [nerd-fonts](https://github.com/ryanoasis/nerd-fonts)              | Hack and Symbols Only fonts for neovim (copied to ~/.fonts, on macOS also ~/Library/Fonts)                 | -    | shell    | shell  |
| [nmap](https://nmap.org)                                           | Network port scanning utility                                                                              | -    | homebrew | apt    |
| [nvim](https://neovim.io)                                          | Hyperextensible Vim-based text editor                                                                      | -    | homebrew | mise   |
| [pandoc](https://pandoc.org)                                       | Universal markup converter                                                                                 | -    | homebrew | apt    |
| [rclone](https://rclone.org)                                       | Swiss army knife of cloud storage                                                                          | ✓    | homebrew | mise   |
| [ripgrep](https://github.com/BurntSushi/ripgrep)                   | Recursively search directories for regex patterns                                                          | ✓    | homebrew | mise   |
| [sshs](https://github.com/quantumsheep/sshs)                       | Interactive SSH client                                                                                     | ✓    | homebrew | mise   |
| [tldr++](https://github.com/isacikgoz/tldr)                        | Interactive cheatsheet tool                                                                                | -    | homebrew | mise   |
| [tree](https://mama.indstate.edu/users/ice/tree)                   | Display filesystem as tree                                                                                 | ✓    | homebrew | apt    |
| [ttyd](https://github.com/tsl0922/ttyd)                            | Share terminal over the web                                                                                | -    | homebrew | mise   |
| [vhs](https://github.com/charmbracelet/vhs)                        | CLI home video recorder (terminal recordings)                                                              | -    | homebrew | mise   |
| [vim](https://www.vim.org)                                         | Ubiquitous text editor                                                                                     | ✓    | homebrew | apt    |
| [watch](https://en.wikipedia.org/wiki/Watch_(command))             | Execute a program periodically                                                                             | ✓    | homebrew | apt    |
| [yq](https://github.com/mikefarah/yq)                              | YAML processor (like jq for YAML)                                                                          | ✓    | homebrew | mise   |

On Debian, mise comes from its own apt repository (`https://mise.jdx.dev/deb`), added with `signed-by` and a key that is only trusted when its fingerprint is the one mise publishes (`24853EC9F655CE80B48E6C3A8B81C9D17413A06D`); `apt upgrade` then keeps it current. A mise installed earlier with the `mise.run` script (in `~/.local/bin`) is kept as it is.

On Debian, bat-extras is installed from its release zip, pinned to one version and checked against its sha256, into `~/.local/bin` (man pages in `~/.local/share/man`), without root and without running its build script. A copy that an older version of the setup built into `/usr/local/bin` stays there unused, since `~/.local/bin` comes first in `PATH`; remove it with `sudo rm /usr/local/bin/{batdiff,batgrep,batman,batpipe,batwatch,bat-modules,prettybat}`.

### GitHub CLI Extensions

| Extension                                          | Description                      | Lite | macOS | Debian |
| -------------------------------------------------- | -------------------------------- | ---- | ----- | ------ |
| [gh-dash](https://github.com/dlvhdr/gh-dash)       | GitHub dashboard in terminal     | -    | gh    | gh     |
| [gh-notify](https://github.com/meiji163/gh-notify) | GitHub notifications in terminal | -    | gh    | gh     |

### Applications (macOS only)

| Application                                                          | Description                    | Lite | Installation  |
| -------------------------------------------------------------------- | ------------------------------ | ---- | ------------- |
| [Brave](https://brave.com/fr)                                        | Privacy-focused web browser    | -    | homebrew cask |
| [Docker Desktop](https://www.docker.com/products/docker-desktop)     | Container management GUI + CLI | ✓    | homebrew cask |
| [Firefox](https://www.mozilla.org/firefox)                           | Privacy-focused web browser    | -    | homebrew cask |
| [Insomnia](https://insomnia.rest)                                    | HTTP and GraphQL client        | -    | homebrew cask |
| [Mattermost](https://mattermost.com)                                 | Team collaboration platform    | -    | homebrew cask |
| [OpenVPN Connect](https://openvpn.net/client-connect-vpn-for-mac-os) | VPN client                     | -    | homebrew cask |
| [VS Code](https://code.visualstudio.com)                             | Code editor and IDE            | -    | homebrew cask |

---

## DevOps Profile

The **DevOps** profile provides container orchestration, infrastructure as code, and cloud platform tools.

Within this profile, tools are further grouped into categories (`k8s`, `iac`, `cloud`, `misc`). By default all categories are installed; set `DEVOPS_CATEGORIES` to a comma-separated subset to install only what you need, e.g. for a container image that's only used for Kubernetes debugging:

```sh
DEVOPS_CATEGORIES=k8s ./setup/setup-debian.sh -p devops -l
```

### Command Line Interfaces

The **Category** column corresponds to the `DEVOPS_CATEGORIES` values described above.

| Package                                                       | Description                                                                                            | Category | Lite | macOS    | Debian |
| ------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------ | -------- | ---- | -------- | ------ |
| [act](https://github.com/nektos/act)                          | Run GitHub Actions locally                                                                             | misc     | -    | homebrew | mise   |
| [actionlint](https://rhysd.github.io/actionlint)              | Static checker for GitHub Actions workflows                                                            | misc     | -    | homebrew | mise   |
| [ansible](https://docs.ansible.com)                           | IT automation tool                                                                                     | iac      | ✓    | homebrew | uv     |
| [ansible-lint](https://ansible.readthedocs.io/projects/lint)  | Linter for Ansible playbooks (via ansible-dev-tools)                                                   | iac      | -    | homebrew | uv     |
| [argo](https://argo-cd.readthedocs.io)                        | Argo Workflows CLI                                                                                     | k8s      | -    | homebrew | mise   |
| [argocd](https://argo-cd.readthedocs.io)                      | Argo CD CLI for GitOps                                                                                 | k8s      | -    | homebrew | mise   |
| [chart-testing](https://github.com/helm/chart-testing)        | Helm chart linting and testing                                                                         | k8s      | -    | homebrew | mise   |
| [coder](https://coder.com)                                    | Coder remote development CLI                                                                           | misc     | -    | homebrew | mise   |
| [helm](https://helm.sh)                                       | Kubernetes package manager                                                                             | k8s      | ✓    | homebrew | mise   |
| [helm-docs](https://github.com/norwoodj/helm-docs)            | Auto-generate Helm chart documentation                                                                 | k8s      | ✓    | homebrew | mise   |
| [k6](https://k6.io)                                           | Modern load testing tool                                                                               | misc     | -    | homebrew | mise   |
| [k9s](https://k9scli.io)                                      | Kubernetes TUI                                                                                         | k8s      | -    | homebrew | mise   |
| [kind](https://kind.sigs.k8s.io)                              | Kubernetes in Docker                                                                                   | k8s      | -    | homebrew | mise   |
| [krew](https://sigs.k8s.io/krew)                              | kubectl plugin manager                                                                                 | k8s      | ✓    | homebrew | mise   |
| [kubectl](https://kubernetes.io/docs/reference/kubectl)       | Kubernetes command-line tool                                                                           | k8s      | ✓    | homebrew | mise   |
| [kubectx](https://github.com/ahmetb/kubectx)                  | Kubernetes context switcher                                                                            | k8s      | ✓    | homebrew | mise   |
| [kubens](https://github.com/ahmetb/kubectx)                   | Kubernetes namespace switcher (shipped with the kubectx formula on macOS; its own mise tool on Debian) | k8s      | ✓    | homebrew | mise   |
| [libonig-dev](https://packages.debian.org/en/sid/libonig-dev) | Oniguruma regex library, development files (installed before ansible-dev-tools)                        | iac      | -    | -        | apt    |
| [mkcert](https://github.com/FiloSottile/mkcert)               | Make locally trusted certificates                                                                      | misc     | -    | homebrew | mise   |
| [oc](https://www.openshift.com)                               | OpenShift CLI                                                                                          | k8s      | ✓    | homebrew | mise   |
| [oras](https://github.com/oras-project/oras)                  | OCI Registry As Storage CLI                                                                            | misc     | -    | homebrew | mise   |
| [python3-dev](https://packages.debian.org/en/sid/python3-dev) | Python development files (installed before ansible-dev-tools)                                          | iac      | -    | -        | apt    |
| [scw](https://github.com/scaleway/scaleway-cli)               | Scaleway CLI                                                                                           | cloud    | -    | homebrew | mise   |
| [sshpass](https://sourceforge.net/projects/sshpass)           | Non-interactive SSH password auth                                                                      | misc     | ✓    | homebrew | apt    |
| [teleport](https://goteleport.com)                            | Modern SSH server for clusters                                                                         | misc     | -    | homebrew | apt    |
| [terraform](https://www.terraform.io)                         | Infrastructure as code tool                                                                            | iac      | ✓    | homebrew | mise   |
| [uv](https://github.com/astral-sh/uv)                         | Python package installer (installs ansible on Debian)                                                  | iac      | ✓    | -        | mise   |
| [velero](https://velero.io)                                   | Kubernetes backup and migration                                                                        | k8s      | -    | homebrew | mise   |
| [yamllint](https://yamllint.readthedocs.io)                   | Linter for YAML files                                                                                  | misc     | -    | homebrew | mise   |

On macOS, terraform comes from HashiCorp's tap (`hashicorp/tap/terraform`): homebrew/core stopped at 1.5.7, the last release before the license change. A terraform installed earlier from homebrew/core is uninstalled first, because Homebrew cannot install the tap formula next to it.

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
| [age](https://github.com/FiloSottile/age)           | Simple, modern file encryption     | -    | homebrew | mise   |
| [cosign](https://docs.sigstore.dev)                 | Container signing and verification | ✓    | homebrew | mise   |
| [dive](https://github.com/wagoodman/dive)           | Docker image layer explorer        | -    | homebrew | mise   |
| [gitleaks](https://github.com/gitleaks/gitleaks)    | Secret scanner for git repos       | ✓    | homebrew | mise   |
| [kubescape](https://github.com/kubescape/kubescape) | Kubernetes security scanner        | -    | homebrew | mise   |
| [kyverno](https://github.com/kyverno/kyverno)       | Kubernetes policy engine CLI       | -    | homebrew | mise   |
| [sops](https://github.com/getsops/sops)             | Encrypted file editor              | -    | homebrew | mise   |
| [trivy](https://aquasecurity.github.io/trivy)       | Vulnerability scanner              | ✓    | homebrew | mise   |
| [vault](https://vaultproject.io)                    | HashiCorp Vault CLI                | -    | homebrew | mise   |

On macOS, vault comes from HashiCorp's tap (`hashicorp/tap/vault`) for the same reason as terraform: homebrew/core stopped at 1.14.4. A vault from homebrew/core is uninstalled first.

---

## JavaScript Profile

The **JavaScript** profile provides Node.js runtime and package managers.

### Command Line Interfaces

| Package                                  | Description                            | Lite | macOS | Debian |
| ---------------------------------------- | -------------------------------------- | ---- | ----- | ------ |
| [@antfu/ni](https://github.com/antfu/ni) | Package manager wrapper                | -    | npm   | npm    |
| [bun](https://bun.sh)                    | Fast JavaScript runtime                | -    | mise  | mise   |
| [node](https://nodejs.org)               | JavaScript runtime                     | ✓    | mise  | mise   |
| [npm](https://github.com/npm/cli)        | Node package manager (ships with node) | ✓    | node  | node   |
| [pnpm](https://pnpm.io)                  | Fast, disk-efficient package manager   | -    | mise  | mise   |
| [yarn](https://yarnpkg.com)              | Package manager and project manager    | -    | mise  | mise   |

---

## Go Profile

The **Go** profile provides Go language development tools and Kubernetes operator SDKs.

### Command Line Interfaces

| Package                                                       | Description                      | Lite | macOS    | Debian |
| ------------------------------------------------------------- | -------------------------------- | ---- | -------- | ------ |
| [cobra-cli](https://github.com/spf13/cobra)                   | CLI application builder          | -    | go       | go     |
| [go](https://go.dev)                                          | Go programming language          | ✓    | mise     | mise   |
| [kubebuilder](https://github.com/kubernetes-sigs/kubebuilder) | SDK for building Kubernetes APIs | -    | homebrew | mise   |
| [kustomize](https://github.com/kubernetes-sigs/kustomize)     | Kubernetes YAML customization    | -    | homebrew | mise   |
| [operator-sdk](https://sdk.operatorframework.io)              | Kubernetes operator SDK          | -    | homebrew | mise   |

---

## AI Profile

The **AI** profile provides tools for running AI coding agents and large language models locally.

### Command Line Interfaces

| Package                                                  | Description                                     | Lite | macOS         | Debian |
| -------------------------------------------------------- | ----------------------------------------------- | ---- | ------------- | ------ |
| [claude-code](https://github.com/anthropics/claude-code) | Claude Code CLI                                 | -    | homebrew cask | shell  |
| [copilot-cli](https://github.com/github/copilot-cli)     | GitHub Copilot CLI                              | -    | homebrew cask | shell  |
| [direnv](https://direnv.net)                             | Per-directory env loader (scoped agent secrets) | ✓    | homebrew      | mise   |
| [rtk](https://github.com/rtk-ai/rtk)                     | CLI proxy that reduces LLM token usage          | -    | homebrew      | shell  |

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

### Running One Profile on Its Own

A profile script can also be run directly, without the commons and oh-my-zsh steps of the setup script. It installs mise first when the profile needs it, and runs in full mode unless `FULL_MODE_SETUP=false` asks for lite mode:

```sh
./setup/profiles/osx/setup-devops.sh
FULL_MODE_SETUP=false DEVOPS_CATEGORIES=k8s ./setup/profiles/debian/setup-devops.sh
```

### Adding a Profile

The setup scripts find the profiles in `setup/profiles/<os>/`: every `setup-<name>.sh` there is a profile, listed by `-h`, accepted by `-p <name>` and run in its turn. Two header lines describe it:

```sh
#!/bin/bash
# Profile: One-line description shown by -h
# Order: 45
```

Profiles run by increasing `Order` (base is 10, ai 70). Nothing else needs to be edited. On macOS, the Homebrew packages of a profile live in `setup/profiles/osx/<name>.Brewfile`, installed by the profile script with `brew bundle --file` (only what is missing or outdated is installed). A Brewfile reads `HOMEBREW_DOTFILES_LITE` (`1` with `-l`) to leave its `unless lite` block out, the devops one also `HOMEBREW_DOTFILES_DEVOPS_CATEGORIES`, and formulae from third-party taps are written `tap/formula` with `trusted: true`. What is not a Homebrew package (mise tools, krew plugins, fonts, gh extensions) stays in the profile script, and goes through `run` so that `-n` prints it.

### Package Sources

- **homebrew** - macOS package manager (CLI tools, via formulae)
- **homebrew cask** - Homebrew casks: macOS GUI apps, plus the CLIs that Homebrew only ships as casks (claude-code, copilot-cli)
- **apt** - Debian package manager (system packages)
- **mise** - Language runtimes on both platforms; portable CLI binaries on Debian
- **shell** - Shell script installation
- **npm** - Node package manager (`npm install --global`)
- **uv** - Python tool installer (`uv tool install`; ansible and ansible-lint on Debian)
- **go** - Go package manager (`go install`)
- **gh** - GitHub CLI extension
- **krew** - kubectl plugin manager
