# Shell Customization

This document covers the shell customization provided by this dotfiles repository, including oh-my-zsh configuration, plugins, custom functions, and completions.

## Zsh & oh-my-zsh

### Default Shell

This setup uses **Zsh** as the default shell, configured with the [oh-my-zsh](https://ohmyz.sh/) framework for enhanced functionality and ease of customization.

### Custom Theme

A custom oh-my-zsh theme is included: [this-is-tobi.zsh-theme](../dotfiles/.oh-my-zsh/this-is-tobi.zsh-theme)

This theme combines:
- **gnzh theme** - Clean, minimal design with git information
- **kube-ps1 plugin** - Kubernetes context display in prompt

**Features:**
- Git branch and status indicators
- Current Kubernetes context and namespace
- Colored command status (success/failure)
- Username and hostname display
- Compact directory path

### oh-my-zsh Plugins

The following plugins are activated to enhance shell functionality:

#### Development Tools
- **[git](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git)** - Git aliases and functions
- **[gitignore](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/gitignore)** - gitignore.io from command line
- **[gh](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/gh)** - GitHub CLI completion
- **[docker](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/docker)** - Docker completion and aliases
- **[docker-compose](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/docker-compose)** - Docker Compose completion and aliases

#### Language-Specific
- **[golang](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/golang)** - Go completion and aliases
- **[node](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/node)** - Node.js documentation function
- **[npm](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/npm)** - npm completion and aliases
- **[bun](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/bun)** - Bun completion

#### DevOps & Cloud
- **[ansible](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/ansible)** - Ansible aliases
- **[helm](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/helm)** - Helm completion and aliases
- **[kubectl](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/kubectl)** - kubectl completion and aliases
- **[kubectx](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/kubectx)** - Kubernetes context display
- **[kind](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/kind)** - Kind completion
- **[minikube](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/minikube)** - Minikube completion
- **[microk8s](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/microk8s)** - MicroK8s completion and aliases
- **[oc](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/oc)** - OpenShift CLI completion
- **[terraform](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/terraform)** - Terraform completion, aliases, and prompt function
- **[scw](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/scw)** - Scaleway CLI completion

#### System Utilities
- **[aliases](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/aliases)** - List all available shortcuts
- **[brew](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/brew)** - Homebrew aliases
- **[colored-man-pages](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/colored-man-pages)** - Colorize man pages
- **[rsync](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/rsync)** - rsync aliases
- **[nmap](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/nmap)** - nmap aliases
- **[sudo](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/sudo)** - Press ESC twice to prefix command with sudo
- **[systemadmin](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/systemadmin)** - Sysadmin aliases and functions

## Custom Functions

Custom shell functions are defined in `.config/dotfiles/functions.sh` and provide powerful utilities.

### Available Functions

| Function     | Description                          | Usage                                |
| ------------ | ------------------------------------ | ------------------------------------ |
| `lsfn`       | List all functions with descriptions | `lsfn`                               |
| `b64d`       | Decode base64 string                 | `b64d "encoded_string"`              |
| `b64e`       | Encode string to base64              | `b64e "plain_text"`                  |
| `browser`    | Start Browsh terminal web browser    | `browser [url]`                      |
| `cheat_glow` | View cheat sheets with Glow          | `cheat_glow <cheatsheet>`            |
| `check_cert` | Check SSL certificate for domain     | `check_cert example.com`             |
| `dks`        | Decode Kubernetes secret             | `dks <secret_name> [namespace]`      |
| `kbp`        | Kill process on port                 | `kbp 8080`                           |
| `randompass` | Generate random password             | `randompass [length]`                |
| `tools`      | Execute remote utility scripts       | `tools [script_name] [args]`         |
| `timestampd` | Convert timestamp to date            | `timestampd 1234567890`              |
| `timestampe` | Convert date to timestamp            | `timestampe "2023-01-01"`            |
| `urld`       | URL decode string                    | `urld "encoded%20url"`               |
| `urle`       | URL encode string                    | `urle "plain url"`                   |
| `vault-cp`   | Copy Vault secret                    | `vault-cp <source_path> <dest_path>` |
| `weather`    | Check weather for location           | `weather [city]`                     |

### Function Examples

#### Base64 Encoding/Decoding
```sh
# Encode
$ b64e "Hello World"
SGVsbG8gV29ybGQ=

# Decode
$ b64d "SGVsbG8gV29ybGQ="
Hello World
```

#### URL Encoding/Decoding
```sh
# Encode
$ urle "hello world"
hello%20world

# Decode
$ urld "hello%20world"
hello world
```

#### Kubernetes Secret Decoding
```sh
# Decode secret in default namespace
$ dks my-secret

# Decode secret in specific namespace
$ dks my-secret production
```

#### Certificate Checking
```sh
$ check_cert example.com
# Shows certificate expiration, issuer, and other details
```

#### Port Management
```sh
# Kill process running on port 8080
$ kbp 8080
```

#### Password Generation
```sh
# Generate 16-character password (default)
$ randompass

# Generate 32-character password
$ randompass 32
```

#### Timestamp Conversion
```sh
# Timestamp to human-readable date
$ timestampd 1609459200
Fri Jan  1 00:00:00 UTC 2021

# Date to timestamp
$ timestampe "2021-01-01"
1609459200
```

### The `tools` Function

The `tools` function is special - it allows executing remote utility scripts from the [tools repository](https://github.com/this-is-tobi/tools/tree/main/shell) without installing them locally.

**Usage:**
```sh
# List all available scripts
$ tools

# View script help
$ tools <script_name> -h

# Execute script
$ tools <script_name> [arguments]
```

**Auto-completion:**
The `tools` function has tab-completion support. Type `tools` then press `<Tab>` to see available scripts.

**Examples:**
```sh
# List scripts
$ tools

# Get help for a specific script
$ tools clone-subdir -h

# Execute script
$ tools clone-subdir -u https://github.com/user/repo -s subdir -o output
```

## CLI Completions

CLI completions are managed via:
1. **[zsh-completions](https://github.com/zsh-users/zsh-completions)** - Community completions
2. **[completions.sh](../setup/helpers/completions.sh)** - Custom completion definitions

### Installed Completions

Completions are automatically installed for:
- kubectl and kubectl plugins
- docker and docker-compose
- helm
- terraform
- ansible
- npm, yarn, pnpm
- gh (GitHub CLI)
- All oh-my-zsh plugin tools

### Custom Completions

Custom completions are defined in `functions-completion.sh` for:
- `tools` function - Tab-complete script names
- Custom functions with arguments
- Project-specific commands

## Cheatsheets

### Installation

The [cheat](https://github.com/cheat/cheat) tool is installed with additional custom cheatsheets.

### Personal Cheatsheets

Extra cheatsheets from [this-is-tobi/cheatsheets](https://github.com/this-is-tobi/cheatsheets) are available.

**List personal cheatsheets:**
```sh
$ cheat -l -p personal
```

**View a cheatsheet:**
```sh
$ cheat <cheatsheet_name>
```

**Enhanced viewing with Glow:**
```sh
$ cheat_glow <cheatsheet_name>
# Renders cheatsheet with nice markdown formatting
```

### Creating Custom Cheatsheets

Create your own cheatsheets in `~/.config/cheat/cheatsheets/personal/`:

```sh
# Create new cheatsheet
$ vim ~/.config/cheat/cheatsheets/personal/mycmd

# Content example:
# To do something useful:
mycmd --flag value

# To do something else:
mycmd --other-flag
```

## Customization Tips

### Adding Custom Aliases

Edit `.zshrc` to add personal aliases:

```sh
# Add to ~/.zshrc
alias myalias="command --with-flags"
alias ll="eza -la"
alias k="kubectl"
```

### Adding More Plugins

Add oh-my-zsh plugins in `.zshrc`:

```sh
plugins=(
  git
  docker
  # ... existing plugins ...
  your-new-plugin
)
```

### Custom Functions

Add your own functions to `.config/dotfiles/functions.sh`:

```sh
# Add custom function
myfunction() {
  echo "This is my custom function"
  # Your code here
}
```

### Environment Variables

Use `.config/dotfiles/env.sh` for custom environment variables:

```sh
export MY_VAR="value"
export PATH="$HOME/my-bin:$PATH"
export CONTEXT7_API_KEY="your_key"
```

## Terminal Multiplexer Integration

While not included by default, these dotfiles work great with:
- **[tmux](https://github.com/tmux/tmux)** - Terminal multiplexer
- **[screen](https://www.gnu.org/software/screen/)** - Terminal multiplexer

Consider adding tmux for:
- Multiple terminal sessions
- Session persistence
- Split panes and windows

## Troubleshooting

### Slow Shell Startup

If shell startup is slow:

```sh
# Profile startup time
$ time zsh -i -c exit

# Disable plugins one by one to find the culprit
# Edit ~/.zshrc and comment out plugins
```

### Completion Not Working

Rebuild completion cache:

```sh
$ rm ~/.zcompdump*
$ exec zsh
```

### Function Not Found

Ensure functions are sourced:

```sh
$ source ~/.config/dotfiles/functions.sh
# Or restart shell
$ exec zsh
```

### Theme Issues

If theme doesn't display correctly:

```sh
# Ensure oh-my-zsh is installed
$ ls ~/.oh-my-zsh

# Verify theme file exists
$ ls ~/.oh-my-zsh/custom/themes/this-is-tobi.zsh-theme

# Check .zshrc theme setting
$ grep "ZSH_THEME" ~/.zshrc
```
