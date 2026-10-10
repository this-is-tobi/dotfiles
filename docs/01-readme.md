# Dotfiles :wrench:

This project provides comprehensive dotfiles templates, automation scripts, and development environment configurations for macOS and Debian-based systems.

## Overview

This project aims to:
- **Standardize development environments** across macOS and Debian-based systems
- **Automate installation** of common tools and packages
- **Provide backup solutions** to preserve your configuration
- **Enhance shell experience** with powerful plugins and custom functions
- **Support multiple development profiles** (DevOps, SecOps, AI, Go, JavaScript, etc.)

## What are Dotfiles?

Dotfiles are configuration files in Unix-like systems that start with a dot (`.`), making them hidden by default. They control the behavior of various programs and tools, including:
- Shell configuration (`.zshrc`)
- Git settings (`.gitconfig`)
- Editor preferences (`.vscode/settings.json`)
- Application configs (`.config/`)

## Key Features

### Profile-Based Installation
Choose from multiple installation profiles to match your workflow:
- **Base** - Essential development tools
- **AI** - AI coding assistants and their tooling (Claude Code, Copilot CLI, Ollama, rtk, direnv)
- **DevOps** - Container orchestration, CI/CD, infrastructure as code
- **SecOps** - Security scanning, secret management, compliance tools
- **Go** - Go language development environment
- **JavaScript** - Node.js, npm, Bun, pnpm, Yarn and modern JS tooling
- **Extras** - Personal productivity applications (macOS only)

### Automated Setup
- One script per platform installs your entire development environment from a clone of the repository
- Lite mode for minimal installations
- Dry run (`-n`) to preview the resolved settings without installing anything
- Profiles run in a fixed order, and those based on [mise](https://mise.jdx.dev) install it when it is missing
- Package installation from multiple sources (Homebrew, apt, mise, uv, npm, etc.)

### Backup & Restore
Dedicated backup scripts copy your dotfiles and configurations into a private local directory (`backup_<timestamp>`). The result is not encrypted, see [Backup & Restore](./09-backup-restore.md).

### Custom Utilities
- Shell functions for common tasks
- Integration with external tool repositories
- Auto-completion support
- GitHub Copilot instructions for better AI-assisted development

## Supported Platforms

- **macOS** - Full support with Homebrew integration
- **Debian/Ubuntu** - apt for system packages, [mise](https://mise.jdx.dev) for CLI tooling

Package sources differ per platform by design:

- **macOS** - Homebrew is the package manager for CLI tools and GUI apps.
- **Debian/Ubuntu** - apt covers system packages (shared libraries, daemons, man
  infrastructure); mise covers portable CLI binaries.
- **Both** - mise manages language runtimes (node, go, bun, pnpm, yarn).

## Project Structure

```
dotfiles/
├── backup/          # Backup scripts for different platforms
├── dotfiles/        # Template configuration files
├── setup/           # Installation scripts, helpers and profiles
└── docs/            # Documentation (you are here!)
```

## Quick Start

The setup scripts read their profiles and dotfiles from the repository, so clone it first, then run the script for your platform with the flags you want:

```sh
git clone https://github.com/this-is-tobi/dotfiles.git
cd dotfiles
```

For macOS:
```sh
./setup/setup-osx.sh -p base,devops -d -c
```

For Debian/Ubuntu:
```sh
./setup/setup-debian.sh -p base,devops -d -c
```

`-p` selects the profiles, `-d` copies the dotfiles and `-c` installs the CLI completions. The scripts cannot be piped into bash (`curl ... | bash`): they look for their helpers, profiles and dotfiles next to themselves and stop immediately otherwise. See the [Installation Guide](./02-installation.md) for prerequisites, every flag and the environment overrides.
