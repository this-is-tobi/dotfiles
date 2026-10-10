# Dotfiles :wrench:

This project provides comprehensive dotfiles templates, automation scripts, and development environment configurations for macOS and Debian-based systems.
It offers profile-based installation, automated setup, backup and restore capabilities, custom shell utilities, and GitHub Copilot integration with MCP servers.

## Documentation

Comprehensive documentation is available:

1. [Introduction](./docs/01-readme.md) - Overview and key features
2. [Installation](./docs/02-installation.md) - Detailed installation guide
3. [Dotfiles Structure](./docs/03-dotfiles.md) - Configuration files explained
4. [Profiles](./docs/04-profiles.md) - Available installation profiles
5. [Shell Customization](./docs/05-shell-customization.md) - oh-my-zsh, plugins, and functions
6. [VS Code Configuration](./docs/06-vscode-config.md) - Editor setup and integration
7. [AI Assistants (Claude Code & Copilot) & MCP](./docs/07-ai.md) - AI-assisted development
8. [Tools & Packages](./docs/08-tools-packages.md) - Complete package reference
9. [Backup & Restore](./docs/09-backup-restore.md) - Configuration backup strategies
10. [Troubleshooting](./docs/10-troubleshooting.md) - Common issues and solutions

## Features

- **Profile-Based Installation** - Choose from Base, AI, DevOps, SecOps, Go, JavaScript, and Extras profiles
- **Automated Setup** - One script per platform installs your development environment from a clone of the repository
- **Backup & Restore** - Save and restore your configurations easily
- **Custom Utilities** - Powerful shell functions and tools integration
- **GitHub Copilot Integration** - AI-assisted development with best practice instructions
- **MCP Servers** - Model Context Protocol for enhanced AI capabilities

## Quick Start

The setup scripts read their profiles and dotfiles from the repository, so clone it first, then run the script for your platform with the flags you want.

```sh
git clone https://github.com/this-is-tobi/dotfiles.git
cd dotfiles
```

### macOS

```sh
./setup/setup-osx.sh -p base,devops -d -c
```

### Debian/Ubuntu

```sh
./setup/setup-debian.sh -p base,devops -d -c
```

The scripts cannot be piped into bash (`curl ... | bash`): they look for `setup/helpers/`, `setup/profiles/` and `dotfiles/` next to themselves and stop immediately when run that way.

### Installation Options

```sh
# Profiles, dotfiles (-d) and CLI completions (-c) in one run
./setup/setup-osx.sh -p 'devops,secops,js' -d -c

# Lite mode (minimal tools only)
./setup/setup-osx.sh -l

# Print the resolved settings and exit, nothing is installed
./setup/setup-osx.sh -n -p 'devops,secops,js'

# View all options
./setup/setup-osx.sh -h
```

Available flags: `-c` (completions), `-d` (copy dotfiles), `-l` (lite mode), `-n` (dry run), `-p` (profiles), `-h` (help). `-r` is deprecated and ignored.

Available profiles: `base`, `ai`, `devops`, `go`, `js`, `secops`, `extras` (macOS only)

Without `-p` only the common packages and oh-my-zsh are installed. For prerequisites (Command Line Tools and Homebrew on macOS, sudo on Debian), the order the steps run in and the environment overrides, see the [Installation Guide](./docs/02-installation.md) and the [Profiles Reference](./docs/04-profiles.md).

## Learning Resources

- [Arkade](https://github.com/alexellis/arkade) - Additional DevOps tools
- [Awesome Dotfiles](https://github.com/webpro/awesome-dotfiles) - Curated dotfiles list
- [oh-my-zsh Plugins](https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins) - Available plugins
- [Homebrew Packages](https://formulae.brew.sh/) - Browse Homebrew catalog

## Related Projects

- [tools](https://github.com/this-is-tobi/tools) - Shell scripts and GitHub Copilot instructions
- [cheatsheets](https://github.com/this-is-tobi/cheatsheets) - Personal cheat sheets collection

## Contributing

This is a personal dotfiles repository, but feel free to fork and adapt to your needs.
