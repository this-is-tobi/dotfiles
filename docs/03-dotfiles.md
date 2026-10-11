# Dotfiles Structure

This document describes the dotfiles templates provided by this repository and how to use them.

## Overview

The `dotfiles/` directory contains template configuration files for various applications and tools. The setup copies them to your home directory (and the VS Code ones to VS Code's user directory) when run with `-d`.

## Directory Structure

```sh
./dotfiles
├── .claude/                         # Claude Code personal settings
│   └── settings.json                # Hooks (rtk), plugins, attribution, deny rules, effort level
├── .config/
│   ├── cheat/                       # Cheat sheet configuration
│   ├── dotfiles/                    # Environment, custom functions and completions
│   │   ├── env.sh                   # Managed: loads secrets.env
│   │   ├── functions-completion.sh  # Completion for the tools function
│   │   ├── functions.sh             # Custom shell functions
│   │   └── secrets.env.example      # Template for ~/.config/dotfiles/secrets.env
│   ├── eslint-fallback/             # Shared ESLint config used when a project has none of its own
│   ├── gh-dash/                     # GitHub Dashboard configuration
│   ├── lazygit/                     # Lazygit TUI configuration
│   ├── mise/                        # mise settings (conf.d/00-settings.toml)
│   └── nvim/                        # Neovim configuration
├── .continue/                       # Continue.dev AI configuration
├── .mattermost/                     # Mattermost theme configuration (not copied by the setup)
├── .oh-my-zsh/                      # Custom oh-my-zsh theme and completions
│   ├── completions/                 # kubectl view-secret completion (installed by -c)
│   └── this-is-tobi.zsh-theme
├── .vscode/                         # VS Code user settings
│   ├── extensions.json              # Recommended extensions
│   ├── mcp.json                     # Model Context Protocol servers
│   └── settings.json                # VS Code settings
├── .gitconfig                       # Shared Git configuration (identity lives in ~/.gitconfig.local)
├── .zshrc                           # Zsh shell configuration
└── eslint.config.mjs                # Home-level ESLint fallback, re-exports .config/eslint-fallback
```

## Key Configuration Files

### Shell Configuration

#### `.zshrc`
The main Zsh configuration file that:
- Loads oh-my-zsh framework
- Activates plugins for various tools
- Activates [mise](https://mise.jdx.dev) before oh-my-zsh
- Sources custom functions
- Sets up PATH and environment variables
- Configures prompt appearance

**Customization Notes:**
- Homebrew is found on both Apple Silicon and Intel; the direnv plugin only loads when direnv is installed, and the `sed` alias only exists when `gsed` is
- `PATH` and `fpath` keep one copy of each entry, so nested shells do not stack them; `go install` targets `~/go/bin` (`GOBIN`)
- History: a command typed with a leading space, or a line that assigns or passes a token or a password, is not written to `~/.zsh_history` (see [History](05-shell-customization.md#history))
- Locale: only `LANG=en_US.UTF-8` is set, not `LC_ALL`
- Plugin list can be customized
- `-d` replaces the file (the previous version is backed up). Put what is specific to one machine in `~/.zshrc.local`: it is sourced last when it exists, and the setup never writes it

#### `.config/dotfiles/env.sh` and `secrets.env`
`env.sh` is sourced by `.zshrc` and is managed by the setup (overwritten on every run, so don't edit it). It only loads `~/.config/dotfiles/secrets.env`, the local file for:
- API keys and tokens (e.g., `CONTEXT7_API_KEY`)
- Per-machine variables
- Credentials that shouldn't be in version control

`secrets.env` holds plain `KEY=value` lines. The setup creates it from `secrets.env.example` (mode `600`) when it first copies the dotfiles and never overwrites it. See [Managing Secrets](07-ai.md#managing-secrets).

#### `.config/dotfiles/functions.sh`
Custom utility functions (run `lsfn` for the full list) including:
- Base64 encoding/decoding (`b64e`, `b64d`)
- URL encoding/decoding (`urle`, `urld`)
- Timestamp conversion (`timestampe`, `timestampd`)
- Certificate checking (`check_cert`)
- Kubernetes secret decoding (`dks`)
- Password generation (`randompass`)
- Merging a GitHub pull request by fast-forward, signatures kept (`ffmerge`)

#### `.config/dotfiles/functions-completion.sh`
zsh completion of the `tools` function: the script names of the tools repository, cached for a day under `~/.cache/dotfiles/`.

### Git Configuration

#### `.gitconfig`
Shared Git configuration with:
- Useful aliases
- Default branch settings, and `pull.rebase`
- `transfer.fsckObjects`: every object a fetch, a clone or a push to this machine brings in is checked, and a corrupt or malformed one is refused
- `fetch.prune` (remote-tracking branches deleted on the remote go away), `push.autoSetupRemote` (the first `git push` of a new branch creates and tracks it), `rebase.autoStash` and `rebase.updateRefs` (a rebase also moves the branches stacked on the rebased one)
- `diff.algorithm = histogram` and `merge.conflictStyle = zdiff3` (conflicts also show the common ancestor)
- Diff tool setting (`meld`, which the setup does not install)
- Credentials: `https://github.com` and `https://gist.github.com` go through `gh auth git-credential` (your `gh auth login`); without `gh`, and for every other host, a password is kept in memory for an hour (`credential-cache`), never written to disk
- Color schemes
- An include of `~/.gitconfig.local`, placed last so that it wins

It holds no identity and does not sign commits: both are per machine. Any of these settings can be changed in `~/.gitconfig.local`, which wins.

It expects git 2.38 or later (macOS, Debian 12, Ubuntu 24.04 and newer have it). An older git ignores `rebase.updateRefs` and `push.autoSetupRemote`, but merges, rebases and checkouts stop with `unknown style 'zdiff3' given for 'merge.conflictstyle'` before 2.35 (Debian 11, Ubuntu 22.04), and `~/.gitconfig.local` cannot fix that because git stops on the first value it reads: install a newer git, or change the value to `diff3` in `~/.gitconfig` on that machine (again after each `-d`).

#### `~/.gitconfig.local`
The per-machine part of the Git configuration. `-d` creates it once and never overwrites it. Before an existing `~/.gitconfig` is replaced, the setup copies its `user.name`, `user.email`, `user.signingkey`, `commit.gpgsign`, `gpg.format` and `gpg.ssh.allowedSignersFile` into the new file. When there is nothing to carry over, it asks for your name and email, or, without a terminal, prints how to set them:

```sh
git config --file ~/.gitconfig.local user.name "Your Name"
git config --file ~/.gitconfig.local user.email you@example.com
```

Commit signing is optional and configured the same way, e.g. `git config --file ~/.gitconfig.local commit.gpgsign true` together with `user.signingkey`.

### VS Code Configuration

#### `.vscode/settings.json`
VS Code user settings, merged by `-d` when the `code` command is available into `~/Library/Application Support/Code/User/settings.json` on macOS and `~/.config/Code/User/settings.json` on Linux. The setup replaces the `__HOME__` placeholder with your home directory. VS Code writes into the same file (every "always allow" for a command or a URL, the trusted schema domains, the models you pick), so the file is not overwritten: a key the repository sets wins and objects are merged key by key, every other key of yours stays. The file is left alone when the merge changes nothing; when it does, the previous file is backed up and the result is plain JSON, as the comments stay in the repository. A setting the repository stops wanting (removed by VS Code, or an approval that turned out too broad) would stay in your file for good, so it is listed in an optional `.vscode/settings-retired.json` as paths such as `["chat.tools.terminal.autoApprove", "timeout"]`, and the merge deletes it before applying the repository's keys. The settings cover:
- GitHub Copilot instruction references
- Editor formatting preferences
- Language-specific settings
- Extension configurations
- Auto-approve settings for safe terminal commands

#### `.vscode/mcp.json`
Model Context Protocol server configurations, installed next to `settings.json`:
- **GitHub MCP** - GitHub API integration
- **Context7 MCP** - Documentation access (VS Code asks for the API key on first start and stores it securely)
- **Kubernetes MCP** - Kubernetes cluster management
- **ArgoCD MCP** - ArgoCD application management (VS Code asks for the server URL and an API token on first start)
- **Playwright MCP** - Browser automation

#### `.vscode/extensions.json`
Recommended VS Code extensions for this environment, installed by `-d` with `code --install-extension`, skipping the ones the editor already has.

### Claude Code Configuration

#### `.claude/settings.json`
Personal Claude Code settings, merged into `~/.claude/settings.json` during setup. The file is not simply copied, because Claude Code and its commands (`/config`, `/plugin`) write to it too:
- The keys the repository owns win: `hooks`, `attribution`, `extraKnownMarketplaces`, `enabledPlugins` and `permissions`. The `permissions.deny` rules and the `PreToolUse` hooks are added to those already in the file.
- Every other key (e.g. `effortLevel`) is only a default, applied when the file does not set it.
- The previous file is backed up under `~/.dotfiles-backup/` when the merge changes anything.

It sets:
- `rtk hook claude` PreToolUse hook for token-optimized shell output
- `effortLevel` model reasoning effort
- `attribution.commit` and `attribution.pr` set to `""` to disable the `Co-Authored-By: Claude` commit trailer and the pull request description line
- `enabledPlugins` and `extraKnownMarketplaces` for the plugins installed at user scope
- `permissions.deny` rules that keep Claude Code's file tools away from `.env` files, keys and the local secrets

Instructions (`~/.claude/CLAUDE.md`, `~/.claude/general-instructions.md`) are not stored as static dotfiles: they are installed at setup time from the [tools repository](https://github.com/this-is-tobi/tools/blob/main/docs/02-ai.md), so this repo doesn't duplicate content that's already canonically maintained there. The MCP servers (`context7`, `kubernetes`, `playwright`, and `argocd` once `ARGOCD_BASE_URL` is set in `secrets.env`) are registered at user scope by `setup/helpers/claude-mcp.sh`, which stores secrets as `${VAR}` references only. See ai documentation section for details.

### Application Configurations

#### `.config/cheat/conf.yml`
Configuration for the [cheat](https://github.com/cheat/cheat) command:
- Cheatsheet paths
- Syntax highlighting
- Editor preferences

#### `.config/eslint-fallback/`
Shared [`@antfu/eslint-config`](https://github.com/antfu/eslint-config)-based flat config (`eslint.config.mjs` + `package.json`), used by Neovim, VS Code and the CLI as a fallback when the project being edited has no ESLint config of its own. The setup scripts install `~/eslint.config.mjs`, which re-exports it: ESLint looks up its config from each linted file's folder upward, so a project's own `eslint.config.*` always wins, and files without one get this config. Requires `npm install` in this directory once: `-d` runs it, but only when `npm` is on `PATH` (the `js` profile installs node), so run it yourself otherwise.

Things to know:
- ESLint 10 does the per-file lookup by default; ESLint 9 looks up from the working directory, so export `ESLINT_FLAGS=v10_config_lookup_from_file` to get the same behavior.
- Only files under your home directory find `~/eslint.config.mjs`. Neovim still passes the shared config explicitly for projects elsewhere; VS Code has no fallback there.
- A project under your home directory that still uses a legacy `.eslintrc` has it ignored by ESLint 9/10 and is linted with this config instead.

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
Mattermost application theme settings. The setup scripts do not copy it: apply it by hand.

#### `.oh-my-zsh/this-is-tobi.zsh-theme`
Copied by `-d` to `~/.oh-my-zsh/custom/themes/`. Custom oh-my-zsh theme that combines:
- gnzh theme styling (two-line prompt)
- kube-ps1 code, embedded in the theme (no plugin needed), for Kubernetes context display
- Git status information
- Custom prompt format

#### `.oh-my-zsh/completions/_kubectl-view_secret`
Completion for the `kubectl view-secret` krew plugin (alias `kvs`). `-c` copies it to `~/.oh-my-zsh/completions/` when the plugin is installed.

#### `.config/mise/conf.d/00-settings.toml`
mise settings:
- Lockfile and version pinning for reproducible toolchains
- Auto-install of missing tools
- `asdf` backend disabled so installs come from checksum-verifying backends
- Idiomatic version files (`.node-version`, `.go-version`) enabled

Kept in `conf.d/` rather than `config.toml` on purpose: the setup profiles pin
tools with `mise use --global`, which rewrites `config.toml`. Settings in
`conf.d/` are merged on top and survive both that and a re-run of the dotfiles
copy step.

Installed tool versions themselves live in `~/.config/mise/config.toml`, which
is machine state rather than a template and is therefore not tracked here.

## Using These Dotfiles

### Setup Script

The simplest way is the setup script, which copies every file to the right place and backs up what it replaces:

```sh
./setup/setup-osx.sh -d     # or ./setup/setup-debian.sh -d
```

### Manual Copy

You can manually copy individual dotfiles:

```sh
# Copy zsh configuration
cp dotfiles/.zshrc ~/.zshrc

# Copy Git configuration (your identity then has to go in ~/.gitconfig.local, see above)
cp dotfiles/.gitconfig ~/.gitconfig
```

VS Code reads its settings from its user directory, not from `~/.vscode` (that directory holds extensions). The `__HOME__` placeholder of `settings.json` has to be replaced with your home directory:

```sh
# macOS
VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
# Linux
VSCODE_USER_DIR="$HOME/.config/Code/User"

mkdir -p "$VSCODE_USER_DIR"
sed "s|__HOME__|$HOME|g" dotfiles/.vscode/settings.json > "$VSCODE_USER_DIR/settings.json"
cp dotfiles/.vscode/mcp.json "$VSCODE_USER_DIR/mcp.json"
```

Do not copy the whole `dotfiles/` directory with `cp -r dotfiles/. ~`: it would drop `.vscode/` into `~/.vscode`, overwrite `~/.gitconfig` and `env.sh` without any backup, and skip the merge of `~/.claude/settings.json`.

### Selective Installation

During setup, you can choose which files to install by modifying the setup scripts or copying files individually.

### Backing Up Existing Dotfiles

The setup scripts back up before they replace. Each file `-d` writes goes through the same check: when the destination exists and its content differs, the current version is first saved under `~/.dotfiles-backup/<timestamp>/`, keeping its path relative to your home directory (e.g. `~/.dotfiles-backup/20261010120000/.zshrc`, or `.../.config/dotfiles/env.sh`), and the script prints where, with the number of lines the old file had that the new one does not (a hint to run `diff` on the two when it is not 0). The directory is private (mode `700`) and only created when something is saved. Files that are already identical are left untouched, so running the setup again creates no backup. Set `DOTFILES_BACKUP_DIR` to use another directory.

This covers the files the setup copies or merges itself. `~/.claude/settings.json` and the VS Code `settings.json` are merged, so what you added there stays; the other files are replaced, so what you added to them only survives in the backup (for the shell, use `~/.zshrc.local` and `~/.gitconfig.local`). The instructions that the remote AI agent installer writes under `~/.claude` and `~/.copilot` follow that script's own rules (see [AI Assistants](07-ai.md)), and `~/.gitconfig.local` and `secrets.env` are never overwritten in the first place.

For a full backup of your machine's configuration, use the backup scripts, which are separate from this mechanism:

```sh
# Manual backup
./backup/backup-osx.sh
# or
./backup/backup-debian.sh
```

## Customization Guidelines

### DO Customize
- User-specific settings (name and email in `~/.gitconfig.local`, paths)
- API keys and credentials (in `secrets.env`)
- Color schemes and themes
- Plugin selections
- Key bindings

### DON'T Modify (or be careful)
- Core function definitions (may break dependencies)
- Plugin loading order
- PATH structure (may cause tool unavailability)
- Version manager configurations (may affect project compatibility)

## Template Variables

Almost every file is used as is. The few values that depend on you or your machine are:

| Placeholder / key   | Description                                                     | File                    |
| ------------------- | --------------------------------------------------------------- | ----------------------- |
| `__HOME__`          | Your home directory, replaced by the setup (or by you with sed) | `.vscode/settings.json` |
| `user.name`         | Your full name, asked once by the setup                         | `~/.gitconfig.local`    |
| `user.email`        | Your email, asked once by the setup                             | `~/.gitconfig.local`    |
| `CONTEXT7_API_KEY=` | Context7 API key                                                | `secrets.env`           |

## Advanced: Symlinking

Instead of copying files, you can symlink them to keep them in sync with the repository:

```sh
# Backup existing file
mv ~/.zshrc ~/.zshrc.backup

# Create symlink
ln -s ~/dotfiles/dotfiles/.zshrc ~/.zshrc
```

A destination that already is the repository file (a symlink into it) is left untouched by `-d`.

**Pros:**
- Changes in repo are immediately reflected
- Easy to track changes with git

**Cons:**
- Requires keeping the repo directory
- Personal secrets shouldn't be committed

## File Permissions

Some dotfiles need specific permissions:

```sh
# Protect sensitive files (the setup already creates secrets.env with this mode)
chmod 600 ~/.config/dotfiles/secrets.env
```

The shell scripts under `~/.config/dotfiles/` are sourced by `.zshrc`, so they do not need the executable bit.
