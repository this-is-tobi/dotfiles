# Installation

This guide covers the installation process for both macOS and Debian-based systems.

## Prerequisites

### macOS
- A macOS release supported by Homebrew
- An administrator account (the Command Line Tools and Homebrew installers use `sudo`)
- Command Line Tools for Xcode, which also provide `git` to clone the repository
- [Homebrew](https://brew.sh)
- Internet connection

The setup does not install the Command Line Tools and Homebrew silently. When one of them is missing, an interactive terminal is asked whether to install it (`y`/`N`; any other answer stops the script). Without a terminal (CI, `ssh host cmd`, a pipe) the script exits with status 1 and an error telling you to install it first, so install them beforehand for unattended runs. Once Homebrew is installed, or found in `/opt/homebrew` or `/usr/local`, it is put on `PATH` for the rest of the run, on both Apple Silicon and Intel. The `-n` dry run exits before these checks, so it never prompts.

### Debian/Ubuntu
- Debian or Ubuntu: Docker's apt repository is chosen from `/etc/os-release` (`debian` or `ubuntu`), and the base profile stops with an error when it has to install Docker on any other distribution
- `sudo` privileges: apt, locale generation, `chsh` and the Docker, Teleport and mise repositories all go through `sudo`
- `git`, to clone the repository (the commons step also installs it)
- Internet connection

Running as `root`, as on a minimal image or in a container, is supported: when `sudo` is missing the script installs it first, and an unset `$USER` falls back to `id -un`. As any other user, `sudo` must already be installed, otherwise the script exits with an error asking you to install it as root (`apt install sudo`). The script then asks for your sudo password once, at the start, and keeps the credentials fresh in the background until it ends, so a long run does not stop at a second prompt halfway. When sudo cannot ask (no terminal) and needs a password, the script stops right away with an error. The script also makes zsh the login shell (`chsh`, run through `sudo`) unless `$SHELL` already is zsh; the change applies to your next login.

## Installation Methods

### Clone and Run

The setup scripts read `setup/helpers/`, `setup/profiles/` and `dotfiles/` relative to their own location, so they must run from a clone of the repository. This also lets you review them before running them.

1. **Clone the repository:**
```sh
git clone https://github.com/this-is-tobi/dotfiles.git
cd dotfiles
```

2. **Run the setup script with the flags you want:**

For macOS:
```sh
./setup/setup-osx.sh -p base,devops -d -c
```

For Debian/Ubuntu:
```sh
./setup/setup-debian.sh -p base,devops -d -c
```

Without `-p`, only the common packages and oh-my-zsh are installed; `-d` and `-c` add the dotfiles and the completions. Run with `-n` first to see the resolved settings, and with `-h` for the list of flags.

### Why Not `curl | bash`?

Piping a setup script into bash (`curl -fsSL .../setup/setup-osx.sh | bash`) does not work. The script is then running as `bash`, with no `setup/` or `dotfiles/` directory next to it: it stops right away with an error saying it needs the rest of the repository (and `-p` and `-d` could not work anyway). The scripts do download other scripts themselves (Homebrew, oh-my-zsh, the AI CLI installers and the helpers of the [tools](https://github.com/this-is-tobi/tools) repository), but they save each one to a temporary file first and only run it once the download succeeded, never piped straight into a shell. mise comes from Homebrew on macOS and from its signed apt repository on Debian, and the other files fetched from a fixed version (bat-extras, a few completions) are checked against a sha256 before they are installed.

## Installation Options

### Flags

| Flag       | Description                                                                                            |
| ---------- | ------------------------------------------------------------------------------------------------------ |
| `-c`       | Install CLI completions (into `~/.oh-my-zsh/completions`) and clone zsh-completions                    |
| `-d`       | Copy the dotfiles and configure the tools (see [Copying Dotfiles](#copying-dotfiles))                  |
| `-l`       | Lite mode: only the major tools are installed                                                          |
| `-n`       | Dry run: print the resolved settings and exit, without side effects                                    |
| `-p <csv>` | Profiles to install, comma-separated (`ai`, `base`, `devops`, `extras` on macOS, `go`, `js`, `secops`) |
| `-r`       | Deprecated and ignored: the scripts now remove their own temporary files (it no longer cleans `/tmp`)  |
| `-h`       | Print the help                                                                                         |

### Order of the Steps

Whatever the order of the flags, the steps always run in this order:

1. **Commons** - Homebrew formulae on macOS, apt packages on Debian (the Core table in [Profiles](04-profiles.md)). Debian also generates the `en_US.UTF-8` locale, installs zsh and makes it the login shell.
2. **oh-my-zsh** - skipped when `~/.oh-my-zsh` already exists. The installer runs with `--unattended`, so it neither switches the login shell nor starts zsh (which would end the setup), and it keeps an existing `~/.zshrc`.
3. **Profiles** - those selected with `-p`, in the order given below.
4. **Dotfiles** (`-d`)
5. **Completions** (`-c`)

### Example

```sh
# macOS: base and devops profiles, then the dotfiles, then the completions
./setup/setup-osx.sh -p base,devops -d -c

# Debian/Ubuntu: lite mode, same steps
./setup/setup-debian.sh -l -p base,devops -d -c
```

### Profiles

Install additional profiles based on your needs using the `-p` flag:

```sh
# Single profile
./setup/setup-osx.sh -p devops

# Multiple profiles (comma-separated)
./setup/setup-osx.sh -p 'devops,secops,js'

# All profiles (macOS; Debian has no extras profile)
./setup/setup-osx.sh -p 'base,ai,devops,extras,go,js,secops'
```

The profiles run in a fixed order whatever the order given to `-p`: `base`, `extras`, `devops`, `secops`, `go`, `js`, `ai`.

Available profiles:
- `base` - Base packages and utilities (including Docker)
- `ai` - AI coding assistants and their tooling (Claude Code, Copilot CLI, Ollama, rtk, direnv)
- `devops` - DevOps tools (Kubernetes, Terraform, Ansible, cloud CLIs, etc.)
- `go` - Go development environment
- `js` - JavaScript/Node.js development environment
- `secops` - Security tools (scanners, secret management, etc.)
- `extras` - Extra personal packages (macOS only, rejected as an unknown profile on Debian)

Without `-p`, no profile is installed. An unknown profile name (e.g. a typo) is rejected immediately with an error listing the valid profiles (exit status 1), rather than being silently ignored.

### Lite Mode

For minimal installations with only essential tools, use the `-l` flag:

```sh
./setup/setup-osx.sh -l
./setup/setup-osx.sh -l -p devops  # Lite mode with devops profile
```

Lite mode installs only the packages marked with a ✓ in the "Lite" column of the package tables in [Profiles](04-profiles.md).

### Dry Run

To preview which profiles and options would be applied without installing anything, use the `-n` flag:

```sh
./setup/setup-osx.sh -n -p 'devops,secops,js'
./setup/setup-debian.sh -n -p 'devops,secops,js'
```

This prints the resolved settings and exits before any package installation, dotfile copying, or interactive prompts.

### Help

Display all available options:

```sh
./setup/setup-osx.sh -h
./setup/setup-debian.sh -h
```

### Environment Variables

These variables are read from the environment, so set them in front of the command (`TOOLS_REF=<tag> ./setup/setup-osx.sh -p base`) or in a Dockerfile `ENV`:

| Variable               | Default                          | Effect                                                                                                                           |
| ---------------------- | -------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| `TOOLS_REF`            | `main`                           | Tag or commit SHA of the [tools](https://github.com/this-is-tobi/tools) repository, which provides the downloaded helper scripts |
| `OMZ_REF`              | `master`                         | Git ref of the oh-my-zsh installer                                                                                               |
| `HOMEBREW_INSTALL_REF` | `HEAD`                           | Git ref of the Homebrew installer (macOS)                                                                                        |
| `HOMEBREW_NO_ASK`      | `1`                              | Skips the confirmation Homebrew asks before each install, so a run needs no input (macOS). A value you set is kept               |
| `DEVOPS_CATEGORIES`    | `all`                            | Devops categories to install, comma-separated (`k8s`, `iac`, `cloud`, `misc`)                                                    |
| `ANSIBLE_PYTHON`       | `3.13`                           | Python that `uv` pins for ansible and ansible-lint (Debian)                                                                      |
| `TELEPORT_VERSION`     | `v18`                            | Teleport release channel (Debian, see below)                                                                                     |
| `MISE_GITHUB_TOKEN`    | unset                            | GitHub token mise uses for its API calls, see [mise Issues](#mise-issues)                                                        |
| `DOTFILES_BACKUP_DIR`  | `~/.dotfiles-backup/<timestamp>` | Where `-d` saves the files it replaces                                                                                           |

Pin `TOOLS_REF`, `OMZ_REF` and `HOMEBREW_INSTALL_REF` to a tag or a commit SHA when you need a reproducible run: they follow the default branch otherwise. See [DevOps Profile](04-profiles.md#devops-profile) for what each `DEVOPS_CATEGORIES` category installs.

### Non-Interactive Mode

Apart from the prompts below, the setup scripts run unattended, which makes them usable for automation and CI/CD pipelines. Without a terminal the script never waits for an answer:

- **macOS**: a missing Command Line Tools or Homebrew install is confirmed with a `y`/`N` question. Without a terminal the script exits with status 1 and an error instead of asking.
- **Debian**: the sudo password is asked once at the start (as `root`, sudo is not used). Without a terminal, sudo has to work without a password, as on most CI runners, otherwise the script exits with status 1 and an error before installing anything.
- **`-d`**: when `~/.gitconfig.local` does not exist yet and no identity can be carried over from an existing `~/.gitconfig`, the script asks for your Git name and email. Without a terminal it prints the `git config --file ~/.gitconfig.local ...` commands to run and carries on.

oh-my-zsh is installed with `--unattended` and, on Debian, the packages with `apt-get install -y` and `DEBIAN_FRONTEND=noninteractive` (a package that asks a configuration question takes the default answer). The package lists are refreshed once per run, and again after a profile adds an apt repository (Docker, Teleport, mise).

#### Teleport Version (DevOps Profile)

Teleport is part of the `misc` [category](04-profiles.md#devops-profile) of the DevOps profile and is a **full-mode-only** install: it is installed by `install_additional_setup`, which `-l`/lite mode skips entirely. It is installed on both platforms, from the `teleport` Homebrew formula on macOS and from Teleport's own apt repository on Debian/Ubuntu. `TELEPORT_VERSION` only selects the channel of the apt repository and defaults to **v18**:

```sh
# Uses default v18
./setup/setup-debian.sh -p devops

# Override with specific version
TELEPORT_VERSION=v17 ./setup/setup-debian.sh -p devops
```

`-l` (lite mode) or `DEVOPS_CATEGORIES` set to anything excluding `misc` (e.g. `DEVOPS_CATEGORIES=k8s`) will skip Teleport entirely — in either case, `TELEPORT_VERSION` has no effect since the install step never runs.

#### Use Cases

Non-interactive mode is particularly useful for:
- **CI/CD pipelines** - Automated environment setup
- **Docker builds** - Installing dotfiles in containers
- **Configuration management** - Ansible, Terraform provisioning
- **Scripted deployments** - Batch server setup

#### Example: Docker

```dockerfile
FROM debian:bookworm

# Optional: override default Teleport version (only takes effect in full
# mode, i.e. without -l — see the note above)
ENV TELEPORT_VERSION=v17

# git is only needed to fetch the repository. The build runs as root, so the
# script installs sudo and the other commons itself.
RUN apt-get update && apt-get install -y git ca-certificates && \
    git clone https://github.com/this-is-tobi/dotfiles.git /root/dotfiles && \
    cd /root/dotfiles && \
    ./setup/setup-debian.sh -p devops
```

To copy the dotfiles during the build as well, add `-d`: there is no terminal then, so it prints the commands that set the Git identity instead of asking for it (see [Non-Interactive Mode](#non-interactive-mode)).

For a leaner image that only needs Kubernetes tooling (skipping Teleport, Terraform, Ansible, cloud CLIs, etc. entirely), combine `-l` with `DEVOPS_CATEGORIES` instead — see [DevOps Profile](04-profiles.md#devops-profile):

```dockerfile
RUN ... && DEVOPS_CATEGORIES=k8s ./setup/setup-debian.sh -l -p devops
```

### Copying Dotfiles

`-d` copies the repository's `dotfiles/` into your home directory and configures the tools that use them, once the profiles are installed. It also needs the cloned repository. In this order:

- `~/.zshrc`, the oh-my-zsh theme, `~/.gitconfig`, `~/.continue/` and everything under `~/.config/` (cheat, dotfiles, eslint-fallback, gh-dash, lazygit, mise, nvim)
- `~/.gitconfig.local`, created once and never overwritten: it carries `user.name`, `user.email` and the signing settings over from an existing `~/.gitconfig`, otherwise it asks for them (terminal only)
- `~/.config/dotfiles/secrets.env`, created once from `secrets.env.example` (mode `600`) and never overwritten
- `~/eslint.config.mjs`, the home-level ESLint fallback, then `npm ci --ignore-scripts` in `~/.config/eslint-fallback`, which only runs when `npm` is on `PATH` (the `js` profile installs it): it installs the exact versions of the committed `package-lock.json` without running the dependencies' install scripts, and is skipped when `node_modules` already comes from that lockfile. After a change to its `package.json`, regenerate the lockfile in `dotfiles/.config/eslint-fallback` with `npm install --package-lock-only --ignore-scripts`
- The VS Code user `settings.json` (merged: what you added stays) and `mcp.json` plus the recommended extensions that are missing, when the `code` command is on `PATH` (Debian also handles `code-server`)
- `~/.claude/settings.json`, merged rather than copied (after `rtk init -g --no-patch` when rtk is installed, which writes `~/.claude/RTK.md` and leaves the hooks to the repository's settings), then the Claude Code and Copilot instructions and plugins from the tools repository (pinned with `TOOLS_REF`) and the Claude Code MCP servers when `claude` is on `PATH`

A destination whose content differs is saved under `~/.dotfiles-backup/<timestamp>/` before it is replaced, see [Backing Up Existing Dotfiles](03-dotfiles.md#backing-up-existing-dotfiles); one run uses one backup directory, the VS Code and Claude Code merges included. Each file is written next to its destination and then renamed over it, so it is never left half-written, and it keeps the permissions of the file it replaces. A destination that is a symlink to a file elsewhere (a dotfiles manager such as stow) becomes a regular file: the file it pointed to is not modified, and its content is what the backup holds. The destinations are described in [Dotfiles Structure](03-dotfiles.md).

## What Gets Installed

### Core Components

Every run installs:
- **Commons** - Essential command-line utilities (curl, wget, jq, etc.)
- **oh-my-zsh** - Zsh configuration framework with plugins

The other components depend on the flags:
- **Profiles** (`-p`) - the tools of each selected profile, see [Profiles](04-profiles.md)
- **Dotfiles** (`-d`) - `.zshrc`, `.gitconfig`, shell functions, editor and tool configuration, and the Claude Code and GitHub Copilot instructions
- **Completions** (`-c`) - Auto-completion for the installed tools

### Platform-Specific

**macOS:**
- Homebrew package manager (a prerequisite, installed on request)
- Homebrew Cask applications
- macOS-specific configurations

**Debian/Ubuntu:**
- apt package management for system packages
- zsh as the login shell, and the `en_US.UTF-8` locale
- [mise](https://mise.jdx.dev) for portable CLI binaries
- Debian-specific system configurations

**Both platforms:**
- [mise](https://mise.jdx.dev) for language runtimes

## Post-Installation

### 1. Restart Your Shell

After installation, restart your shell or source the configuration:

```sh
exec zsh
# or
source ~/.zshrc
```

On Debian, zsh becomes your login shell at your next login.

### 2. Add Your Secrets

The first time the setup copies the dotfiles (`-d`) it creates `~/.config/dotfiles/secrets.env` (mode `600`) from [`secrets.env.example`](../dotfiles/.config/dotfiles/secrets.env.example), and it never overwrites that file afterwards. Uncomment and fill in the keys you use:

```sh
vim ~/.config/dotfiles/secrets.env
```

```sh
# Context7 API key for documentation access
CONTEXT7_API_KEY=your_api_key_here
```

The file holds plain `KEY=value` lines and is loaded into every zsh session by `env.sh`, which the setup manages (don't edit it). If you used to put values in `env.sh`, the setup moves them into `secrets.env` the first time you re-run it. Open a new shell, then run `setup/helpers/claude-mcp.sh` (or re-run the setup) so Claude Code registers the MCP servers that need those keys. See [Managing Secrets](07-ai.md#managing-secrets) for how each tool consumes them.

### 3. Check Your Git Identity

The shared `~/.gitconfig` holds no identity and does not sign commits. Your identity (and your signing settings, if you use them) live in `~/.gitconfig.local`, which `-d` creates once from your previous `~/.gitconfig` or from the name and email it asks for. Check it, and set the identity yourself when the setup could not ask (no terminal):

```sh
git config --file ~/.gitconfig.local user.name "Your Name"
git config --file ~/.gitconfig.local user.email you@example.com
```

### 4. Review Installed Tools

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

# Tools managed by mise (language runtimes on both platforms, CLI binaries on Debian)
mise ls
```

### 5. Customize Dotfiles

The dotfiles are installed as templates. Customize them to your needs:

```sh
# Edit zsh configuration
vim ~/.zshrc

# Edit git configuration (shared settings, then your identity and signing)
vim ~/.gitconfig
vim ~/.gitconfig.local

# Edit VS Code settings (macOS)
vim "$HOME/Library/Application Support/Code/User/settings.json"

# Edit VS Code settings (Linux)
vim ~/.config/Code/User/settings.json
```

`~/.zshrc`, `~/.gitconfig` and `~/.config/dotfiles/env.sh` are replaced by the next `-d` run (the previous version is saved under `~/.dotfiles-backup/`), so keep your own changes in `~/.zshrc.local`, `~/.gitconfig.local` and `~/.config/dotfiles/secrets.env`, or re-apply them from the backup. The backup directories are never deleted by the setup: each run that replaces a file adds a new one.

## Troubleshooting

### Permission Denied

If you encounter permission errors:

```sh
chmod +x setup/setup-*.sh
```

### Prerequisites Missing (macOS)

A run without a terminal stops with `Error: Command Line Tools is required but not installed` (or `Homebrew`) when one is absent. Install it first (`xcode-select --install` for the Command Line Tools), or run the script from an interactive terminal so it can ask.

### Homebrew Issues (macOS)

If Homebrew installation fails:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### mise Issues

If a tool fails to install, check mise itself first:

```sh
mise doctor
```

Tool downloads resolve versions through the GitHub API, which rate-limits
unauthenticated requests. On a shared IP or in CI this surfaces as HTTP 403 and
is the most common cause of a failed run — export a token to raise the limit
(for a one-off run, or permanently as `MISE_GITHUB_TOKEN` in
`~/.config/dotfiles/secrets.env`; unlike `GITHUB_TOKEN`, it does not change
which account the `gh` CLI uses):

```sh
export MISE_GITHUB_TOKEN=<your-token>
```

### oh-my-zsh Already Installed

If oh-my-zsh is already installed, the script will skip it. The theme comes back with the next `-d` run. To reinstall:

```sh
rm -rf ~/.oh-my-zsh
# Run setup script again
```

## Uninstallation

To remove installed configurations:

```sh
# Backup first!
./backup/backup-osx.sh  # or backup-debian.sh

# Remove dotfiles (~/.config/dotfiles holds your secrets.env, ~/.gitconfig.local your Git identity)
rm -rf ~/.zshrc ~/.gitconfig ~/.gitconfig.local ~/.config/dotfiles

# Remove oh-my-zsh
rm -rf ~/.oh-my-zsh
```

To go back to the files `-d` replaced, copy them back from `~/.dotfiles-backup/<timestamp>/`, which mirrors their path relative to your home directory.
