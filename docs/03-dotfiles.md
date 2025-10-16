# Dotfiles Structure

This document describes the dotfiles templates provided by this repository and how to use them.

## Overview

The `dotfiles/` directory contains template configuration files for various applications and tools. These files are designed to be copied to your home directory during installation.

## Directory Structure

```sh
./dotfiles
├── .config/
│   ├── cheat/           # Cheat sheet configuration
│   ├── dotfiles/        # Custom functions and completions
│   ├── gh-dash/         # GitHub Dashboard configuration
│   ├── lazygit/         # Lazygit TUI configuration
│   └── nvim/            # Neovim configuration
├── .continue/           # Continue.dev AI configuration
├── .mattermost/         # Mattermost theme configuration
├── .oh-my-zsh/          # Custom oh-my-zsh theme
├── .vscode/             # VS Code workspace settings
│   ├── extensions.json  # Recommended extensions
│   ├── mcp.json         # Model Context Protocol servers
│   └── settings.json    # VS Code settings
├── .gitconfig           # Git configuration template
├── .prototools          # Proto version manager configuration
└── .zshrc               # Zsh shell configuration
```

## Key Configuration Files

### Shell Configuration

#### `.zshrc`
The main Zsh configuration file that:
- Loads oh-my-zsh framework
- Activates plugins for various tools
- Sources custom functions
- Sets up PATH and environment variables
- Configures prompt appearance

**Customization Notes:**
- Some lines may be commented out - uncomment based on your profile needs
- PATH modifications may need adjustment for your system
- Plugin list can be customized

#### `.config/dotfiles/env.sh`
Custom environment variables file for:
- API keys (e.g., `CONTEXT7_API_KEY`)
- Custom PATH additions
- Project-specific variables
- Credentials that shouldn't be in version control

**Important:** This file is sourced by `.zshrc` and should be created after installation.

#### `.config/dotfiles/functions.sh`
Custom utility functions including:
- Base64 encoding/decoding (`b64e`, `b64d`)
- URL encoding/decoding (`urle`, `urld`)
- Timestamp conversion (`timestampe`, `timestampd`)
- Certificate checking (`check_cert`)
- Kubernetes secret decoding (`dks`)
- Password generation (`randompass`)

#### `.config/dotfiles/functions-completion.sh`
Auto-completion definitions for custom functions, particularly for the `tools` function.

### Git Configuration

#### `.gitconfig`
Git configuration template with:
- User identity placeholders
- Useful aliases
- Default branch settings
- Merge and diff tool configurations
- Color schemes

**Customization Required:**
```ini
[user]
    name = Your Name
    email = your.email@example.com
```

### VS Code Configuration

#### `.vscode/settings.json`
Workspace-level VS Code settings for:
- GitHub Copilot instruction references
- Editor formatting preferences
- Language-specific settings
- Extension configurations
- Auto-approve settings for safe terminal commands

#### `.vscode/mcp.json`
Model Context Protocol server configurations:
- **GitHub MCP** - GitHub API integration
- **Context7 MCP** - Documentation access (requires API key)
- **Kubernetes MCP** - Kubernetes cluster management
- **GitKraken MCP** - Git workflow enhancements

#### `.vscode/extensions.json`
Recommended VS Code extensions for this environment.

### Application Configurations

#### `.config/cheat/conf.yml`
Configuration for the [cheat](https://github.com/cheat/cheat) command:
- Cheatsheet paths
- Syntax highlighting
- Editor preferences

#### `.config/gh-dash/config.yml`
GitHub Dashboard TUI configuration:
- PR and issue views
- Filters and sorting
- Key bindings

#### `.config/lazygit/config.yml`
Lazygit TUI configuration:
- Git command preferences
- UI customization
- Key bindings

#### `.config/nvim/`
Neovim configuration with:
- Plugin management (via `lua/plugins/`)
- Editor settings (via `lua/config/`)
- Custom key mappings
- LSP configurations

#### `.continue/config.yaml`
Configuration for Continue.dev AI assistant:
- Model settings
- Context preferences
- Custom commands

#### `.mattermost/theme-config.json`
Mattermost application theme settings.

#### `.oh-my-zsh/this-is-tobi.zsh-theme`
Custom oh-my-zsh theme that combines:
- gnzh theme styling
- kube-ps1 plugin for Kubernetes context display
- Git status information
- Custom prompt format

#### `.prototools`
Proto version manager configuration for:
- Node.js version pinning
- Go version management
- Other language runtime versions

## Using These Dotfiles

### Manual Copy

You can manually copy individual dotfiles:

```sh
# Copy zsh configuration
cp dotfiles/.zshrc ~/.zshrc

# Copy VS Code settings
cp -r dotfiles/.vscode ~/.vscode

# Copy all dotfiles
cp -r dotfiles/. ~
```

### Selective Installation

During setup, you can choose which files to install by modifying the setup scripts or copying files individually.

### Backing Up Existing Dotfiles

Before installation, the setup scripts automatically backup existing dotfiles:

```sh
# Manual backup
./backup/backup-osx.sh
# or
./backup/backup-debian.sh
```

## Customization Guidelines

### DO Customize
- User-specific settings (name, email, paths)
- API keys and credentials (in `env.sh`)
- Color schemes and themes
- Plugin selections
- Key bindings

### DON'T Modify (or be careful)
- Core function definitions (may break dependencies)
- Plugin loading order
- PATH structure (may cause tool unavailability)
- Version manager configurations (may affect project compatibility)

## Template Variables

Some dotfiles contain placeholders that need to be replaced:

| Placeholder              | Description      | File         |
| ------------------------ | ---------------- | ------------ |
| `Your Name`              | Your full name   | `.gitconfig` |
| `your.email@example.com` | Your email       | `.gitconfig` |
| `your_api_key_here`      | Context7 API key | `env.sh`     |

## Advanced: Symlinking

Instead of copying files, you can symlink them to keep them in sync with the repository:

```sh
# Backup existing file
mv ~/.zshrc ~/.zshrc.backup

# Create symlink
ln -s ~/dotfiles/dotfiles/.zshrc ~/.zshrc
```

**Pros:**
- Changes in repo are immediately reflected
- Easy to track changes with git

**Cons:**
- Requires keeping the repo directory
- Personal secrets shouldn't be committed

## File Permissions

Some dotfiles need specific permissions:

```sh
# Make scripts executable
chmod +x ~/.config/dotfiles/functions.sh

# Protect sensitive files
chmod 600 ~/.config/dotfiles/env.sh
```
