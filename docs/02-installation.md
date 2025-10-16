# Installation

This guide covers the installation process for both macOS and Debian-based systems.

## Prerequisites

### macOS
- macOS 10.15 (Catalina) or later
- Command Line Tools for Xcode (will be installed automatically)
- Internet connection

### Debian/Ubuntu
- Debian 11+ or Ubuntu 20.04+
- sudo privileges
- Internet connection

## Installation Methods

### Quick Install (Recommended)

The quickest way to get started is using the one-line installer:

**macOS:**
```sh
curl -fsSL https://raw.githubusercontent.com/this-is-tobi/dotfiles/main/setup/setup-osx.sh | bash
```

**Debian/Ubuntu:**
```sh
curl -fsSL https://raw.githubusercontent.com/this-is-tobi/dotfiles/main/setup/setup-debian.sh | bash
```

### Manual Installation

If you prefer to review the scripts before running them:

1. **Clone the repository:**
```sh
git clone https://github.com/this-is-tobi/dotfiles.git
cd dotfiles
```

2. **Run the setup script:**

For macOS:
```sh
./setup/setup-osx.sh
```

For Debian/Ubuntu:
```sh
./setup/setup-debian.sh
```

## Installation Options

### Profiles

Install additional profiles based on your needs using the `-p` flag:

```sh
# Single profile
./setup/setup-osx.sh -p devops

# Multiple profiles (comma-separated)
./setup/setup-osx.sh -p 'devops,secops,js'

# All profiles
./setup/setup-osx.sh -p 'base,ai,devops,go,js,secops'
```

Available profiles:
- `base` - Base packages and utilities
- `ai` - AI and machine learning tools
- `devops` - DevOps tools (Docker, Kubernetes, Terraform, etc.)
- `go` - Go development environment
- `js` - JavaScript/Node.js development environment
- `secops` - Security tools (scanners, secret management, etc.)
- `extras` - Extra personal packages (macOS only)

### Lite Mode

For minimal installations with only essential tools, use the `-l` flag:

```sh
./setup/setup-osx.sh -l
./setup/setup-osx.sh -l -p devops  # Lite mode with devops profile
```

Lite mode installs only packages marked with an "x" in the "Lite mode" column of the package tables.

### Help

Display all available options:

```sh
./setup/setup-osx.sh -h
./setup/setup-debian.sh -h
```

## What Gets Installed

### Core Components

Both platforms install:
- **oh-my-zsh** - Zsh configuration framework with plugins
- **CLI tools** - Essential command-line utilities (curl, wget, jq, etc.)
- **Git configuration** - Custom `.gitconfig` template
- **Shell functions** - Custom utility functions
- **Completions** - Auto-completion for various tools
- **GitHub Copilot instructions** - AI-assisted development guidelines

### Platform-Specific

**macOS:**
- Homebrew package manager
- Homebrew Cask applications
- macOS-specific configurations

**Debian/Ubuntu:**
- WakeMeOps repository for modern packages
- apt package management
- Debian-specific system configurations

## Post-Installation

### 1. Restart Your Shell

After installation, restart your shell or source the configuration:

```sh
exec zsh
# or
source ~/.zshrc
```

### 2. Configure Environment Variables

Edit the environment file to add your API keys and custom settings:

```sh
vim ~/.config/dotfiles/env.sh
```

Example configuration:
```sh
# Context7 API key for documentation access
export CONTEXT7_API_KEY="your_api_key_here"

# Add other custom environment variables
# export MY_VAR="value"
```

### 3. Review Installed Tools

List all custom functions:
```sh
lsfn
```

Check installed packages:
```sh
# macOS
brew list

# Debian
apt list --installed
```

### 4. Customize Dotfiles

The dotfiles are installed as templates. Customize them to your needs:

```sh
# Edit zsh configuration
vim ~/.zshrc

# Edit git configuration
vim ~/.gitconfig

# Edit VS Code settings
vim ~/.config/Code/User/settings.json
```

## Troubleshooting

### Permission Denied

If you encounter permission errors:

```sh
chmod +x setup/setup-*.sh
```

### Homebrew Issues (macOS)

If Homebrew installation fails:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### WakeMeOps Repository Issues (Debian)

If package installation fails, verify the repository:

```sh
curl https://raw.githubusercontent.com/upciti/wakemeops/main/assets/install_repository | bash
```

### oh-my-zsh Already Installed

If oh-my-zsh is already installed, the script will skip it. To reinstall:

```sh
rm -rf ~/.oh-my-zsh
# Run setup script again
```

## Uninstallation

To remove installed configurations:

```sh
# Backup first!
./backup/backup-osx.sh  # or backup-debian.sh

# Remove dotfiles
rm -rf ~/.zshrc ~/.gitconfig ~/.config/dotfiles

# Remove oh-my-zsh
rm -rf ~/.oh-my-zsh
```
