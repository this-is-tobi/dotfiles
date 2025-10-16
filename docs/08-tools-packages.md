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

| Tool         | Replaces | Description                          | Source       |
| ------------ | -------- | ------------------------------------ | ------------ |
| bat          | cat      | Syntax highlighting, git integration | homebrew/apt |
| eza          | ls       | Colors, icons, git status            | homebrew/apt |
| fd           | find     | Simpler syntax, faster               | homebrew/apt |
| ripgrep (rg) | grep     | Faster recursive search              | homebrew/apt |
| fzf          | -        | Fuzzy finder for command line        | homebrew/apt |
| yq           | -        | YAML processor (jq for YAML)         | homebrew/apt |

### Git Tools

Git and platform CLIs (Base profile):

| Tool    | Description         | Extensions         | Source       |
| ------- | ------------------- | ------------------ | ------------ |
| lazygit | Terminal UI for git | -                  | homebrew/apt |
| gh      | GitHub CLI          | gh-dash, gh-notify | homebrew/apt |
| glab    | GitLab CLI          | -                  | homebrew/apt |

**GitHub CLI Extensions:**
```sh
# Install via gh
gh extension install dlvhdr/gh-dash    # Dashboard TUI
gh extension install meiji163/gh-notify  # Notifications TUI
```

### Container & Orchestration

Docker and Kubernetes tools (DevOps profile):

| Tool    | Purpose                    | Related Tools            | Source       |
| ------- | -------------------------- | ------------------------ | ------------ |
| docker  | Container runtime          | lazydocker               | shell/cask   |
| kubectl | Kubernetes CLI             | k9s, kubectx, stern      | homebrew/apt |
| helm    | Kubernetes package manager | chart-testing, helm-docs | homebrew/apt |
| kind    | Local Kubernetes           | -                        | homebrew/apt |
| k9s     | Kubernetes TUI             | -                        | homebrew/apt |

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

| Tool         | Purpose                  | Config Files       | Source       |
| ------------ | ------------------------ | ------------------ | ------------ |
| terraform    | Infrastructure as code   | .tf                | homebrew/apt |
| ansible      | Configuration management | .yml playbooks     | homebrew/pip |
| ansible-lint | Ansible linter           | -                  | homebrew/pip |
| kustomize    | Kubernetes config        | kustomization.yaml | homebrew/apt |

### Cloud Platform CLIs

Cloud provider tools (DevOps profile):

| Tool | Platform            | Source       |
| ---- | ------------------- | ------------ |
| aws  | Amazon Web Services | homebrew/apt |
| scw  | Scaleway            | homebrew/apt |
| oc   | OpenShift/OKD       | homebrew/apt |

### Security Tools

Scanning and secret management (SecOps profile):

| Tool      | Purpose               | Scans                 | Source         |
| --------- | --------------------- | --------------------- | -------------- |
| trivy     | Vulnerability scanner | containers, IaC, code | homebrew/apt   |
| cosign    | Container signing     | images                | homebrew/apt   |
| sops      | Secret encryption     | files                 | homebrew/apt   |
| vault     | Secret management     | -                     | homebrew/apt   |
| gitleaks  | Secret detection      | git repos             | homebrew/shell |
| age       | File encryption       | -                     | homebrew/apt   |
| kubescape | Kubernetes security   | K8s configs           | homebrew/apt   |
| kyverno   | Kubernetes policies   | K8s resources         | homebrew/apt   |
| dive      | Image layer analysis  | Docker images         | homebrew/apt   |

### Development Languages

Runtime and toolchain management:

#### JavaScript/TypeScript (JS profile)

| Tool      | Purpose                 | Managed By | Source |
| --------- | ----------------------- | ---------- | ------ |
| node      | JavaScript runtime      | proto      | proto  |
| npm       | Package manager         | proto      | proto  |
| pnpm      | Fast package manager    | proto      | proto  |
| yarn      | Package manager         | proto      | proto  |
| bun       | Fast runtime & toolkit  | proto      | proto  |
| @antfu/ni | Package manager wrapper | -          | npm    |

#### Go (Go profile)

| Tool         | Purpose                 | Source       |
| ------------ | ----------------------- | ------------ |
| go           | Go compiler             | proto        |
| cobra-cli    | CLI framework           | go install   |
| kubebuilder  | Kubernetes API SDK      | homebrew/apt |
| operator-sdk | Kubernetes operator SDK | homebrew/apt |

#### Version Manager

| Tool  | Languages              | Purpose                   | Source         |
| ----- | ---------------------- | ------------------------- | -------------- |
| proto | Node, Go, Python, etc. | Universal version manager | homebrew/shell |

**Usage:**
```sh
# Install Node.js version
proto install node 20

# Use specific version
proto use node 20

# Pin version for project
proto pin node 20
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

| Tool   | Purpose               | Providers                | Source       |
| ------ | --------------------- | ------------------------ | ------------ |
| rclone | Cloud storage CLI     | AWS S3, GCS, Azure, etc. | homebrew/apt |
| rsync  | Incremental file sync | -                        | homebrew/apt |
| mc     | MinIO/S3 client       | S3-compatible            | homebrew/apt |

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

| Tool          | Purpose              | Platform   | Source         |
| ------------- | -------------------- | ---------- | -------------- |
| act           | Local GitHub Actions | GitHub     | homebrew/apt   |
| argo          | Argo Workflows CLI   | Kubernetes | homebrew/apt   |
| argocd        | Argo CD CLI          | Kubernetes | homebrew/apt   |
| chart-testing | Helm chart testing   | Helm       | homebrew/shell |
| k6            | Load testing         | -          | homebrew/apt   |

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

**Proto (Version Manager):**
```sh
proto install <tool> <version>
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

| Manager  | Platform      | Purpose                   | Auto-Installed |
| -------- | ------------- | ------------------------- | -------------- |
| Homebrew | macOS         | System packages & apps    | ✓              |
| apt      | Debian/Ubuntu | System packages           | ✓              |
| Proto    | All           | Language runtime versions | ✓              |
| npm      | All           | Node.js packages          | via Proto      |
| pip      | All           | Python packages           | System         |
| go       | All           | Go packages               | via Proto      |
| Krew     | All           | kubectl plugins           | via kubectl    |
| gh       | All           | GitHub CLI extensions     | via gh         |

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

# Check Proto tools
proto list

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

# Proto tools
proto upgrade

# npm packages
npm update -g

# kubectl plugins
kubectl krew upgrade
```

## Further Resources

- [Homebrew Packages](https://formulae.brew.sh/)
- [WakeMeOps Repository](https://docs.wakemeops.com/)
- [Proto Plugins](https://moonrepo.dev/proto/tools)
- [Krew Plugins](https://krew.sigs.k8s.io/plugins/)
- [GitHub CLI Extensions](https://github.com/topics/gh-extension)
