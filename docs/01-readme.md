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
- **AI** - Machine learning and AI tools
- **DevOps** - Container orchestration, CI/CD, infrastructure as code
- **SecOps** - Security scanning, secret management, compliance tools
- **Go** - Go language development environment
- **JavaScript** - Node.js, npm, and modern JS tooling
- **Extras** - Personal productivity applications (macOS only)

### Automated Setup
- One-command installation for your entire development environment
- Lite mode for minimal installations
- Automatic dependency resolution
- Package installation from multiple sources (Homebrew, apt, npm, pip, etc.)

### Backup & Restore
Dedicated backup scripts to save your dotfiles and configurations to local or remote locations.

### Custom Utilities
- Shell functions for common tasks
- Integration with external tool repositories
- Auto-completion support
- GitHub Copilot instructions for better AI-assisted development

## Supported Platforms

- **macOS** - Full support with Homebrew integration
- **Debian/Ubuntu** - Complete apt-based installation with WakeMeOps repository

## Project Structure

```
dotfiles/
├── backup/          # Backup scripts for different platforms
├── dotfiles/        # Template configuration files
├── setup/           # Installation scripts and profiles
└── docs/            # Documentation (you are here!)
```

## Quick Start

For macOS:
```sh
curl -fsSL https://raw.githubusercontent.com/this-is-tobi/dotfiles/main/setup/setup-osx.sh | bash
```

For Debian/Ubuntu:
```sh
curl -fsSL https://raw.githubusercontent.com/this-is-tobi/dotfiles/main/setup/setup-debian.sh | bash
```
