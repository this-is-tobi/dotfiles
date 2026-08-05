# Tools & Packages

This document provides a comprehensive reference of all tools and packages available through the installation profiles.

## Quick Reference

Use this guide to:
- Find specific tools and their installation source
- Understand what each tool does
- Determine which profile includes a tool
- Check if a tool is in lite mode

## Command Line Tools

### Core Utilities

Essential system utilities (always installed):

| Tool            | Description                         | Source       |
| --------------- | ----------------------------------- | ------------ |
| curl            | Data transfer tool (HTTP/HTTPS/FTP) | homebrew/apt |
| wget            | Non-interactive network downloader  | homebrew/apt |
| jq              | JSON processor and query tool       | homebrew/apt |
| sed             | Stream editor for text manipulation | homebrew/apt |
| gzip            | Data compression utility            | homebrew/apt |
| tar             | Archive creation and extraction     | apt          |
| unzip           | ZIP archive extraction              | homebrew/apt |
| gnupg           | GPG encryption and signing          | homebrew/apt |
| ca-certificates | SSL/TLS certificate authorities     | homebrew/apt |

### Enhanced CLI Tools

Modern replacements and enhancements (Base profile):

| Tool         | Replaces | Description                          | Source        |
| ------------ | -------- | ------------------------------------ | ------------- |
| bat          | cat      | Syntax highlighting, git integration | homebrew/mise |
| eza          | ls       | Colors, icons, git status            | homebrew/mise |
| fd           | find     | Simpler syntax, faster               | homebrew/mise |
| ripgrep (rg) | grep     | Faster recursive search              | homebrew/mise |
| fzf          | -        | Fuzzy finder for command line        | homebrew/mise |
| yq           | -        | YAML processor (jq for YAML)         | homebrew/mise |

### Git Tools

Git and platform CLIs (Base profile):

| Tool    | Description         | Extensions         | Source        |
| ------- | ------------------- | ------------------ | ------------- |
| lazygit | Terminal UI for git | -                  | homebrew/mise |
| gh      | GitHub CLI          | gh-dash, gh-notify | homebrew/mise |
| glab    | GitLab CLI          | -                  | homebrew/mise |

**GitHub CLI Extensions:**
```sh
# Install via gh
gh extension install dlvhdr/gh-dash    # Dashboard TUI
gh extension install meiji163/gh-notify  # Notifications TUI
```

### Container & Orchestration

Docker and Kubernetes tools (DevOps profile):

| Tool    | Purpose                    | Related Tools            | Source        |
| ------- | -------------------------- | ------------------------ | ------------- |
| docker  | Container runtime          | lazydocker               | apt/cask      |
| kubectl | Kubernetes CLI             | k9s, kubectx, stern      | homebrew/mise |
| helm    | Kubernetes package manager | chart-testing, helm-docs | homebrew/mise |
| kind    | Local Kubernetes           | -                        | homebrew/mise |
| k9s     | Kubernetes TUI             | -                        | homebrew/mise |

**kubectl Plugins (via Krew):**
```sh
kubectl krew install cert-manager  # cert-manager CLI
kubectl krew install cnpg          # CloudNativePG CLI
kubectl krew install df-pv         # PV disk usage
kubectl krew install ktop          # Kubernetes top
kubectl krew install neat          # Clean YAML output
kubectl krew install stern         # Multi-pod logs
kubectl krew install view-secret   # Decode secrets
```

### Infrastructure as Code

IaC and configuration management (DevOps profile):

| Tool         | Purpose                  | Config Files       | Source        |
| ------------ | ------------------------ | ------------------ | ------------- |
| terraform    | Infrastructure as code   | .tf                | homebrew/mise |
| ansible      | Configuration management | .yml playbooks     | homebrew/uv   |
| ansible-lint | Ansible linter           | -                  | homebrew/uv   |
| kustomize    | Kubernetes config        | kustomization.yaml | homebrew/mise |

### Cloud Platform CLIs

Cloud provider tools (DevOps profile):

| Tool | Platform      | Source        |
| ---- | ------------- | ------------- |
| scw  | Scaleway      | homebrew/mise |
| oc   | OpenShift/OKD | homebrew/mise |

### Security Tools

Scanning and secret management (SecOps profile):

| Tool      | Purpose               | Scans                 | Source        |
| --------- | --------------------- | --------------------- | ------------- |
| trivy     | Vulnerability scanner | containers, IaC, code | homebrew/mise |
| cosign    | Container signing     | images                | homebrew/mise |
| sops      | Secret encryption     | files                 | homebrew/mise |
| vault     | Secret management     | -                     | homebrew/mise |
| gitleaks  | Secret detection      | git repos             | homebrew/mise |
| age       | File encryption       | -                     | homebrew/mise |
| kubescape | Kubernetes security   | K8s configs           | homebrew/mise |
| kyverno   | Kubernetes policies   | K8s resources         | homebrew/mise |
| dive      | Image layer analysis  | Docker images         | homebrew/mise |

### Development Languages

Runtime and toolchain management:

#### JavaScript/TypeScript (JS profile)

| Tool      | Purpose                 | Managed By | Source |
| --------- | ----------------------- | ---------- | ------ |
| node      | JavaScript runtime      | mise       | mise   |
| npm       | Package manager         | node       | node   |
| pnpm      | Fast package manager    | mise       | mise   |
| yarn      | Package manager         | mise       | mise   |
| bun       | Fast runtime & toolkit  | mise       | mise   |
| @antfu/ni | Package manager wrapper | -          | npm    |

`npm` is not pinned separately: it ships inside the node release. Globals
installed with `npm install -g` land in the active node install and become
callable after `mise reshim`.

#### Go (Go profile)

| Tool         | Purpose                 | Source        |
| ------------ | ----------------------- | ------------- |
| go           | Go compiler             | mise          |
| cobra-cli    | CLI framework           | go install    |
| kubebuilder  | Kubernetes API SDK      | homebrew/mise |
| kustomize    | Kubernetes YAML overlay | homebrew/mise |
| operator-sdk | Kubernetes operator SDK | homebrew/mise |

#### Python (DevOps profile)

| Tool | Purpose               | Source |
| ---- | --------------------- | ------ |
| uv   | Fast Python installer | mise   |

On Debian, ansible and ansible-dev-tools are installed with
`uv tool install --python`, which pins an explicit self-contained interpreter
and exposes the entry points in `~/.local/bin`. They are **not** installed via
mise: its pipx backend uses whichever `python3` it finds on the machine, which
cannot be pinned and breaks when the distro or Homebrew moves that interpreter
(ansible-core requires Python >= 3.12). Override with `ANSIBLE_PYTHON`.
On macOS both come from Homebrew.

#### Version Manager

| Tool | Manages                                              | Source         |
| ---- | ---------------------------------------------------- | -------------- |
| mise | Language runtimes (both); CLI binaries (Debian only) | homebrew/shell |

mise manages language runtimes on both platforms, and portable CLI binaries on
Debian. On macOS, Homebrew is the package manager for CLI tools.

**Usage:**
```sh
# Install a tool globally and pin it
mise use --global node@22

# Install without pinning globally (current directory only)
mise use node@22

# List installed / available versions
mise ls
mise ls-remote node

# Tools not in the registry are addressed by backend
mise use --global aqua:helm/chart-testing@latest
mise use --global github:isacikgoz/tldr@latest

# Refresh shims after installing globals via npm/go
mise reshim
```

### Text & Document Tools

Editors and document processors (Base profile):

| Tool   | Type      | Purpose                      | Source         |
| ------ | --------- | ---------------------------- | -------------- |
| vim    | Editor    | Ubiquitous text editor       | homebrew/apt   |
| nvim   | Editor    | Extensible Vim               | homebrew/shell |
| pandoc | Converter | Universal document converter | homebrew/apt   |
| glow   | Viewer    | Markdown renderer            | homebrew/apt   |

### Networking & Remote Access

Network tools and SSH (Base/DevOps profiles):

| Tool     | Purpose                  | Source         |
| -------- | ------------------------ | -------------- |
| nmap     | Port scanning            | homebrew/apt   |
| sshs     | Interactive SSH client   | homebrew/shell |
| sshpass  | Non-interactive SSH auth | homebrew/apt   |
| teleport | Modern SSH server        | homebrew/apt   |
| ttyd     | Terminal over web        | homebrew/apt   |

### Cloud Storage & Sync

File transfer and cloud storage (Base profile):

| Tool   | Purpose           | Providers                | Source       |
| ------ | ----------------- | ------------------------ | ------------ |
| rclone | Cloud storage CLI | AWS S3, GCS, Azure, etc. | homebrew/apt |

### Monitoring & Diagnostics

System and application monitoring:

| Tool       | Purpose        | What it monitors | Source       |
| ---------- | -------------- | ---------------- | ------------ |
| watch      | Repeat command | Command output   | homebrew/apt |
| k9s        | Kubernetes TUI | K8s resources    | homebrew/apt |
| lazydocker | Docker TUI     | Containers       | homebrew/apt |

### Documentation & Learning

Cheatsheets and help tools (Base profile):

| Tool   | Purpose                 | Source         |
| ------ | ----------------------- | -------------- |
| cheat  | Interactive cheatsheets | homebrew/apt   |
| tldr++ | Simplified man pages    | homebrew/shell |
| skate  | Key-value store         | homebrew/shell |

### Media & Graphics

Media manipulation (Base profile):

| Tool     | Purpose                | Formats             | Source       |
| -------- | ---------------------- | ------------------- | ------------ |
| ffmpeg   | Audio/video processing | mp4, mkv, mp3, etc. | homebrew/apt |
| chafa    | Terminal image viewer  | jpg, png, gif       | homebrew/apt |
| exiftool | Metadata reader/writer | all images          | homebrew/apt |

### CI/CD & Automation

Continuous integration tools (DevOps profile):

| Tool          | Purpose               | Platform   | Source         |
| ------------- | --------------------- | ---------- | -------------- |
| act           | Local GitHub Actions  | GitHub     | homebrew/apt   |
| actionlint    | Workflow file linting | GitHub     | homebrew/mise  |
| argo          | Argo Workflows CLI    | Kubernetes | homebrew/apt   |
| argocd        | Argo CD CLI           | Kubernetes | homebrew/apt   |
| chart-testing | Helm chart testing    | Helm       | homebrew/shell |
| k6            | Load testing          | -          | homebrew/apt   |

### Utilities

Miscellaneous utilities:

| Tool       | Purpose                               | Source         |
| ---------- | ------------------------------------- | -------------- |
| tree       | Directory tree viewer                 | homebrew/apt   |
| bat-extras | Bat utilities (batgrep, batman, etc.) | homebrew/shell |
| mkcert     | Local SSL certificates                | homebrew/shell |
| coder      | Remote development                    | homebrew/shell |
| velero     | Kubernetes backup                     | homebrew/apt   |
| vhs        | Terminal recorder                     | homebrew/apt   |
| yamllint   | YAML linting                          | homebrew/apt   |

## Desktop Applications (macOS)

### Base Profile

| App             | Purpose         | License |
| --------------- | --------------- | ------- |
| VS Code         | Code editor     | Free    |
| Brave           | Privacy browser | Free    |
| Firefox         | Privacy browser | Free    |
| Insomnia        | API client      | Free    |
| Mattermost      | Team chat       | Free    |
| OpenVPN Connect | VPN client      | Free    |
| Docker Desktop  | Container GUI   | Free    |

### AI Profile

| App    | Purpose          | License |
| ------ | ---------------- | ------- |
| Ollama | Local LLM runner | Free    |

### Extras Profile

| App                 | Purpose          | License |
| ------------------- | ---------------- | ------- |
| VLC                 | Media player     | Free    |
| Audacity            | Audio editor     | Free    |
| Discord             | Voice/chat       | Free    |
| Transmission        | BitTorrent       | Free    |
| Soulseek            | P2P file sharing | Free    |
| Raspberry Pi Imager | SD card flasher  | Free    |

## Installation Quick Reference

### By Source

**Homebrew (macOS):**
```sh
brew install <package>          # CLI tools
brew install --cask <app>       # Applications
```

**apt (Debian/Ubuntu):**
```sh
sudo apt install <package>
```

**mise (CLI tools & language runtimes):**
```sh
mise use --global <tool>@<version>
```

**npm (Node Packages):**
```sh
npm install -g <package>
```

**go (Go Packages):**
```sh
go install <package>@latest
```

**pip (Python Packages):**
```sh
pip install <package>
```

**Shell Scripts:**
```sh
curl -fsSL <url> | bash
```

**GitHub CLI:**
```sh
gh extension install <org>/<repo>
```

**kubectl/Krew:**
```sh
kubectl krew install <plugin>
```

### By Profile

Quick installation commands:

```sh
# Core only (minimal)
./setup/setup-osx.sh

# Base tools
./setup/setup-osx.sh -p base

# DevOps full stack
./setup/setup-osx.sh -p 'devops,secops'

# Full-stack developer
./setup/setup-osx.sh -p 'base,js,go'

# Everything
./setup/setup-osx.sh -p 'base,ai,devops,go,js,secops,extras'

# Lite mode (only ✓ marked tools)
./setup/setup-osx.sh -l -p 'devops,js'
```

## Package Managers

Understanding the sources:

| Manager  | Platform      | Purpose                                   | Auto-Installed |
| -------- | ------------- | ----------------------------------------- | -------------- |
| Homebrew | macOS         | CLI tools, system packages & GUI apps     | ✓              |
| apt      | Debian/Ubuntu | System packages                           | ✓              |
| mise     | All           | Language runtimes; CLI binaries on Debian | ✓              |
| npm      | All           | Node.js packages                          | via mise       |
| uv       | All           | Python packages (ansible)                 | via mise       |
| go       | All           | Go packages                               | via mise       |
| Krew     | All           | kubectl plugins                           | via kubectl    |
| gh       | All           | GitHub CLI extensions                     | via gh         |

## Verifying Installation

Check installed tools:

```sh
# Check specific tool
which kubectl
kubectl version

# List all Homebrew packages (macOS)
brew list

# List apt packages (Debian)
apt list --installed

# Check mise tools
mise ls

# Check npm global packages
npm list -g --depth=0

# Check kubectl plugins
kubectl plugin list
```

## Updating Packages

Keep tools up to date:

```sh
# Homebrew (macOS)
brew update && brew upgrade

# apt (Debian/Ubuntu)
sudo apt update && sudo apt upgrade

# mise tools - --bump is required, see below
mise upgrade --bump

# npm packages
npm update -g

# kubectl plugins
kubectl krew upgrade
```

### Why `mise upgrade` needs `--bump`

`~/.config/mise/conf.d/00-settings.toml` sets `pin = true`, so `mise use`
records an exact version (`kubectl = "1.34.2"`) rather than a range. A plain
`mise upgrade` only upgrades *within* the recorded constraint, and an exact
version is always already satisfied — so it reports "All tools are up to date"
and changes nothing, however old the tools are.

`--bump` is what rewrites the pin to the current latest and installs it:

```sh
# See what is actually behind (plain `mise outdated` has the same blind spot)
mise outdated --bump

# Upgrade everything and rewrite the pins
mise upgrade --bump

# Upgrade a single tool
mise upgrade --bump kubectl
```

Re-running a setup profile has the same effect, since each one installs its
tools with `@latest`.

Upgrading mise itself follows whichever way it was installed: `brew upgrade
mise` on macOS, `mise self-update` on Debian.

## Further Resources

- [Homebrew Packages](https://formulae.brew.sh/)
- [mise Documentation](https://mise.jdx.dev/)
- [mise Registry](https://mise.jdx.dev/registry.html)
- [aqua Registry](https://github.com/aquaproj/aqua-registry)
- [Krew Plugins](https://krew.sigs.k8s.io/plugins/)
- [GitHub CLI Extensions](https://github.com/topics/gh-extension)
