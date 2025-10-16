# Dotfiles :wrench:

This project provides comprehensive dotfiles templates, automation scripts, and development environment configurations for macOS and Debian-based systems.
It offers profile-based installation, automated setup, backup and restore capabilities, custom shell utilities, and GitHub Copilot integration with MCP servers.

## Documentation## Documentation

Comprehensive documentation is available:

1. [Introduction](./docs/01-introduction.md) - Overview and key features
2. [Installation](./docs/02-installation.md) - Detailed installation guide
3. [Dotfiles Structure](./docs/03-dotfiles.md) - Configuration files explained
4. [Profiles](./docs/04-profiles.md) - Available installation profiles
5. [Shell Customization](./docs/05-shell-customization.md) - oh-my-zsh, plugins, and functions
6. [VS Code Configuration](./docs/06-vscode-config.md) - Editor setup and integration
7. [GitHub Copilot & MCP](./docs/07-copilot-mcp.md) - AI-assisted development
8. [Tools & Packages](./docs/08-tools-packages.md) - Complete package reference
9. [Backup & Restore](./docs/09-backup-restore.md) - Configuration backup strategies
10. [Troubleshooting](./docs/10-troubleshooting.md) - Common issues and solutions

## Features

- **Profile-Based Installation** - Choose from Base, AI, DevOps, SecOps, Go, JavaScript, and Extras profiles
- **Automated Setup** - One-command installation for your entire development environment
- **Backup & Restore** - Save and restore your configurations easily
- **Custom Utilities** - Powerful shell functions and tools integration
- **GitHub Copilot Integration** - AI-assisted development with best practice instructions
- **MCP Servers** - Model Context Protocol for enhanced AI capabilities

## Quick Start

### macOS

```sh
curl -fsSL https://raw.githubusercontent.com/this-is-tobi/dotfiles/main/setup/setup-osx.sh | bashcurl -fsSL https://raw.githubusercontent.com/this-is-tobi/dotfiles/main/setup/setup-osx.sh | bash
```

### Debian/Ubuntu

```sh
curl -fsSL https://raw.githubusercontent.com/this-is-tobi/dotfiles/main/setup/setup-debian.sh | bashcurl -fsSL https://raw.githubusercontent.com/this-is-tobi/dotfiles/main/setup/setup-debian.sh | bash
```

### Installation Options

```sh
# Install with specific profiles
./setup/setup-osx.sh -p 'devops,secops,js'

# Lite mode (minimal tools only)
./setup/setup-osx.sh -l

# View all options
./setup/setup-osx.sh -h
```

Available profiles: `base`, `ai`, `devops`, `go`, `js`, `secops`, `extras` (macOS only)

For detailed installation instructions and profile descriptions, see the [Installation Guide](./docs/02-installation.md) and [Profiles Reference](./docs/04-profiles.md).

## Learning Resources

- [Arkade](https://github.com/alexellis/arkade) - Additional DevOps tools
- [Awesome Dotfiles](https://github.com/webpro/awesome-dotfiles) - Curated dotfiles list
- [oh-my-zsh Plugins](https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins) - Available plugins
- [Homebrew Packages](https://formulae.brew.sh/) - Browse Homebrew catalog

## Related Project

- [tools](https://github.com/this-is-tobi/tools) - Shell scripts and GitHub Copilot instructions
- [cheatsheets](https://github.com/this-is-tobi/cheatsheets) - Personal cheat sheets collection

## Contributing

This is a personal dotfiles repository, but feel free to fork and adapt to your needs.

## License

This project is open source and available for personal use.

## Related Projects

- [tools](https://github.com/this-is-tobi/tools) - Shell scripts and GitHub Copilot instructions
- [cheatsheets](https://github.com/this-is-tobi/cheatsheets) - Personal cheat sheets collection

## Contributing

This is a personal dotfiles repository, but feel free to fork and adapt to your needs.

## License

This project is open source and available for personal use.
