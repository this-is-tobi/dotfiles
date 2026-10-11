# Backup & Restore

This document explains how to backup and restore your dotfiles and system configurations.

## Overview

The backup scripts copy your dotfiles, credentials, configurations and a few important files to a timestamped directory (local or a mounted share). This ensures you can:
- Restore configurations after a system reinstall
- Keep timestamped snapshots of your configuration
- Migrate to a new computer

> **Backups are not encrypted.** A backup holds `~/.ssh`, `~/.gnupg` (plus an exported GPG private key), `~/.aws`, `~/.kube`, `~/.docker`, `~/.npmrc`, `~/.config/dotfiles/secrets.env` and your Claude Code history. The scripts run with `umask 077` and set the backup directory to mode `700`, so other local users cannot read it, but nothing is encrypted. Keep it on storage only you can access, and encrypt it (see [Encryption](#encryption)) before it leaves the machine: cloud-synced folders, a NAS, a git remote.

## Backup Scripts

Both scripts copy files with [rclone](https://rclone.org), which the base profile installs.

### macOS: backup-osx.sh

**Location:** `backup/backup-osx.sh`

**Purpose:** Backup macOS-specific configurations and dotfiles

**Usage:**
```sh
./backup/backup-osx.sh [OPTIONS]
```

**Options:**
```
-f          Full backup: copy Desktop, dev, Documents, Downloads, Movies, Music and
            Pictures from the home directory, instead of only ~/dev. For personal use.
-n          Dry run: show what would be copied without copying anything (no directory
            is created).
-o DIR      Output directory (default: current directory). The backup itself is
            written to DIR/backup_<timestamp>.
-x FILE     Extra rclone exclude patterns, one per line, applied to every directory
            copy (default: $BACKUP_EXCLUDE_FILE). See Extra excludes.
-h          Display help message
```

Any other flag prints the help and exits with status 1 (there is no `-d` option: the output directory is `-o`).

**Environment:** `BACKUP_GPG_EMAIL` selects the GPG key to export (default: the `user.email` of your git configuration). `BACKUP_EXCLUDE_FILE` is the default for `-x`.

**Examples:**
```sh
# Backup to default location (a backup_<timestamp> directory in the current directory)
./backup/backup-osx.sh

# Preview what a backup would copy, without copying anything
./backup/backup-osx.sh -n

# Backup to specific directory
./backup/backup-osx.sh -o ~/backups/dotfiles

# Full backup (Desktop, Documents, Downloads, ...) to an external drive
./backup/backup-osx.sh -f -o /Volumes/Backup/dotfiles

# Export the GPG key of another identity
BACKUP_GPG_EMAIL=you@example.com ./backup/backup-osx.sh -o ~/backups/dotfiles

# Backup to a mounted share (not encrypted: see Security Considerations)
./backup/backup-osx.sh -o ~/mnt/nas/dotfiles
```

### Debian/Ubuntu: backup-debian.sh

**Location:** `backup/backup-debian.sh`

**Purpose:** Backup Debian/Ubuntu-specific configurations and dotfiles

**Usage:**
```sh
./backup/backup-debian.sh [OPTIONS]
```

**Options:**
```
-f          Full backup: copy Desktop, dev, Documents, Downloads, Music, Pictures and
            Videos from the home directory, instead of only ~/dev. For personal use.
-n          Dry run: show what would be copied without copying anything (no directory
            is created).
-o DIR      Output directory (default: current directory). The backup itself is
            written to DIR/backup_<timestamp>.
-x FILE     Extra rclone exclude patterns, one per line, applied to every directory
            copy (default: $BACKUP_EXCLUDE_FILE). See Extra excludes.
-h          Display help message
```

Any other flag prints the help and exits with status 1. `BACKUP_GPG_EMAIL` and `BACKUP_EXCLUDE_FILE` work as on macOS.

**Examples:**
```sh
# Backup to default location
./backup/backup-debian.sh

# Preview what a backup would copy, without copying anything
./backup/backup-debian.sh -n

# Backup to specific directory
./backup/backup-debian.sh -o ~/backups/dotfiles

# Backup to mounted network share (not encrypted: see Security Considerations)
./backup/backup-debian.sh -o /mnt/backup/dotfiles
```

## What Gets Backed Up

The scripts run five steps in this order. A source that does not exist is skipped silently, and a failing copy does not stop the run: failures are listed in a warning at the end (the exit status stays `0`, so check the output when automating).

### 1. System files
- `/etc/hosts` and `/etc/resolv.conf` go to `etc/`

### 2. GPG key export
- The key is chosen by `BACKUP_GPG_EMAIL` (default: the git `user.email`)
- The public and private key are written as `public-key-<id>.asc` and `private-key-<id>.asc` to `~/.gnupg/backup/` (directory mode `700`, private key mode `600`). As `~/.gnupg` is copied in the next step, they also end up in the backup under `dotfiles/.gnupg/backup/`
- If no matching secret key is found, the step is reported and skipped

### 3. Dotfiles
Each entry goes to `dotfiles/<basename>`:

- `.aws` - AWS CLI configuration (`cli/cache` and `sso/cache` excluded)
- `.claude` - Claude Code settings, instructions, agents, skills, memory and conversation history (`projects/`). Caches, shell snapshots, file history, backups, IDE state, plugin installs and sessions are excluded
- `.config` - everything under `~/.config`: gh, gh-dash, lazygit, nvim, mise, cheat, `dotfiles/` (functions and `secrets.env`), gcloud and any other tool that keeps its configuration there, including the VS Code user settings on Linux. Cache and log directories (`Cache`, `Caches`, `cache`, `GPUCache`, `Code Cache`, `DawnCache`, `logs`, `Logs`) are excluded
- `.copilot` - Copilot CLI configuration (`pkg`, `ide` and `session-state` excluded)
- `.docker` - Docker client configuration (`scout`, `sbom`, `scan`, `desktop`, `buildx`, `mutagen` and `run` excluded)
- `.gitconfig`
- `.gnupg` - the GPG keyring, including the exported key from step 2
- `.kube` - Kubernetes configuration (`cache` and `http-cache` excluded)
- `.mc` - MinIO client configuration
- `.npmrc`
- `.ssh` - SSH keys and configuration
- `.tsh` - Teleport profiles
- `.zshrc`

To keep one of them out of your backups, remove it from the `DOT_FILES` list in the script.

### 4. Home directories
Each directory goes to `home/<name>`:

- **macOS:** `~/dev` by default. With `-f`: `~/Desktop`, `~/dev`, `~/Documents`, `~/Downloads`, `~/Movies`, `~/Music` and `~/Pictures`
- **Debian:** `~/dev` by default. With `-f`: `~/Desktop`, `~/dev`, `~/Documents`, `~/Downloads`, `~/Music`, `~/Pictures` and `~/Videos`

### 5. Brave (macOS only)
- If `~/Library/Application Support/BraveSoftware` exists, the `Default` profile is copied to `brave/Default` (`Cache`, `Code Cache`, `GPUCache`, `DawnCache`, `Crashpad` and the service worker caches `Service Worker/CacheStorage` and `Service Worker/ScriptCache` excluded)

### Always excluded
Every directory copy skips OS metadata (`.DS_Store`, `Thumbs.db`), `*.tmp`, `*.log`, earlier backups (`backup_*`, so a backup written under a source directory never copies itself), `.cache`, `.local/share/mise` and regenerable project output: `node_modules`, `__pycache__`, `*.pyc`, `.venv`, `venv`, `.pytest_cache`, `.mypy_cache`, `.ruff_cache`, `.tox`, `.turbo`, `.angular`, `.svelte-kit`, `.output`, `.terraform`, `.terragrunt-cache`, `target`, `dist`, `build`, `.next`, `.nuxt`, `.gradle`, `.parcel-cache` and `coverage`. These patterns have no leading `/`, so they match at any depth: a project folder named `build` or `dist` is skipped too. Symbolic links are followed (their target is copied).

### Extra excludes
Anything specific to your machine, such as local CI runner state or a scratch directory, belongs in a file of your own rather than in the script. Pass it with `-x` or set `BACKUP_EXCLUDE_FILE`. It holds one rclone pattern per line (`#` starts a comment) and applies to every directory copy:

```
# local act runner state: a registry cache and old artifacts
ci/act/docker/**
ci/act/artifacts/**
```

```sh
./backup/backup-osx.sh -x ~/.config/dotfiles/backup-exclude.txt -o /Volumes/Backup/dotfiles
```

The script exits with status 1 when the file does not exist. A dry run (`-n`) shows what is left to copy.

### Speed
The copies already run 12 files at a time with 24 checkers. In a local-disk test, raising those numbers or skipping checksums changed nothing, and rclone was about twice as fast as `rsync` or `tar`. What shortens a backup is copying fewer files: a dry run (`-n`) lists them, and the patterns above and your exclude file are the lever. A slow destination, such as a USB drive or a network share, sets the limit from there.

### Not backed up
- **Package lists.** The scripts do not record installed packages (see [Package Restore](#package-restore))
- `~/.gitconfig.local`, the per-machine git identity and signing settings: only the shared `~/.gitconfig` is copied
- `~/.bashrc`, `~/.profile` and every shell file other than `~/.zshrc`
- `~/.oh-my-zsh` (the theme and plugins are reinstalled by the setup)
- `~/.continue` (including a `.env` you may keep there) and, on macOS, the VS Code user directory `~/Library/Application Support/Code/User`
- Anything under `/etc` other than the two files above, and anything outside the lists above

## Backup Structure

Each run creates one directory, `backup_<YYYY-MM-DDTHH-MM-SS>`, inside the output directory (`-o`, default: the current directory). Example on macOS:

```
backup_2026-10-10T13-26-17/
├── etc/
│   ├── hosts
│   └── resolv.conf
├── dotfiles/
│   ├── .aws/
│   ├── .claude/
│   ├── .config/
│   │   ├── dotfiles/          (functions, secrets.env)
│   │   ├── gh/
│   │   ├── lazygit/
│   │   ├── mise/
│   │   ├── nvim/
│   │   └── ...
│   ├── .copilot/
│   ├── .docker/
│   ├── .gitconfig
│   ├── .gnupg/
│   │   └── backup/            (exported GPG key)
│   ├── .kube/
│   ├── .mc/
│   ├── .npmrc
│   ├── .ssh/
│   ├── .tsh/
│   └── .zshrc
├── home/
│   └── dev/                   (with -f: also Desktop, Documents, ...)
└── brave/                     (macOS only, when Brave is installed)
    └── Default/
```

Entries only exist when their source exists on the machine. When the run ends, the script prints the location and size of the backup and reminds you that it is not encrypted.

## Backup Best Practices

### Regular Backups
```sh
# Weekly backup to a local directory
./backup/backup-osx.sh -o ~/backups/dotfiles

# Use cron for automation (macOS/Linux)
# Edit crontab
crontab -e

# Add weekly backup (Sunday at 2 AM)
0 2 * * 0 /path/to/dotfiles/backup/backup-osx.sh -o ~/backups/dotfiles
```

### Version Control

Do not commit a backup to a git repository, not even a private one: it holds private keys and tokens in clear text. Your configuration is already versioned by this repository (`dotfiles/`); backups are for what the repository deliberately does not contain.

### Multiple Destinations
```sh
# Local backup
./backup/backup-osx.sh -o ~/backups/dotfiles

# Network backup
./backup/backup-osx.sh -o /Volumes/NAS/backups/dotfiles

# External drive
./backup/backup-osx.sh -o /Volumes/Backup/dotfiles

# Cloud-synced folder (Dropbox, ...): the backup is NOT encrypted and would be
# uploaded in clear text. Only do this with the encrypted archive from the
# Encryption section, never with the raw backup directory.
./backup/backup-osx.sh -o ~/Dropbox/dotfiles-backup
```

### Encryption
The scripts do not encrypt anything. Before a backup is stored anywhere you do not fully control (cloud storage, a shared NAS, a server), encrypt it:

```sh
# Backup first, to a local private directory
./backup/backup-osx.sh -o ~/backups/dotfiles

# The backup to protect (printed as "location" at the end of the run)
BACKUP=$(ls -d ~/backups/dotfiles/backup_* | tail -1)

# Encrypt with gpg (symmetric, passphrase)
tar czf - -C "$(dirname "$BACKUP")" "$(basename "$BACKUP")" | gpg -c > "$BACKUP.tar.gz.gpg"

# Or use age
tar czf - -C "$(dirname "$BACKUP")" "$(basename "$BACKUP")" | age -p > "$BACKUP.tar.gz.age"

# Upload only the encrypted archive
rclone copy "$BACKUP.tar.gz.gpg" remote:backups/
```

To read it back: `gpg -d <file>.tar.gz.gpg | tar xzf - -C ~/restored-dotfiles`. An [rclone `crypt` remote](https://rclone.org/crypt/) is another option: it encrypts file names and contents on the fly (see [Using rclone](#using-rclone)). Once the archive is stored safely, delete the clear-text backup directory.

## Restoring from Backup

In the commands below, `BACKUP` is the backup directory to restore from (the "location" printed at the end of the run):

```sh
BACKUP=~/backups/dotfiles/backup_2026-10-10T13-26-17
```

### Full Restore

1. **Clone dotfiles repository:**
```sh
git clone https://github.com/this-is-tobi/dotfiles.git
cd dotfiles
```

2. **Run setup script** (profiles and dotfiles need the cloned repository):
```sh
./setup/setup-osx.sh -p 'base,devops,js' -d  # Your profiles
```
With `-d` the setup installs the repository's dotfiles. A file it replaces is first saved under `~/.dotfiles-backup/<timestamp>/`.

3. **Restore credentials and tool state** (the repository does not ship them):
```sh
for item in .ssh .gnupg .aws .kube .docker .mc .tsh; do
  [ -d "$BACKUP/dotfiles/$item" ] || continue
  mkdir -p ~/"$item"
  cp -Rp "$BACKUP/dotfiles/$item/." ~/"$item"/
done
[ -f "$BACKUP/dotfiles/.npmrc" ] && cp -p "$BACKUP/dotfiles/.npmrc" ~/.npmrc

# Claude Code conversation history (optional)
[ -d "$BACKUP/dotfiles/.claude/projects" ] && mkdir -p ~/.claude/projects \
  && cp -Rp "$BACKUP/dotfiles/.claude/projects/." ~/.claude/projects/
```

4. **Restore your secrets file:**
```sh
mkdir -p ~/.config/dotfiles
cp -p "$BACKUP/dotfiles/.config/dotfiles/secrets.env" ~/.config/dotfiles/secrets.env
chmod 600 ~/.config/dotfiles/secrets.env
```
The setup already installed the repository's `~/.config`. Copy back from `$BACKUP/dotfiles/.config/` only what you customized (for example `gh` or `lazygit`); copying the whole directory would replace the managed files, such as `env.sh`, with older versions.

5. **Check permissions:** `~/.ssh`, `~/.gnupg`, the private keys and `~/.kube/config` must not be readable by others, see [Permissions](#permissions).

6. **Git identity:** `~/.gitconfig.local` is not part of the backup. The setup asks for your name and email when it creates it. To set them yourself:
```sh
git config --file ~/.gitconfig.local user.name "Your Name"
git config --file ~/.gitconfig.local user.email "you@example.com"
```

7. **Reload shell:**
```sh
exec zsh
```

### Selective Restore

Restore only specific configurations:

```sh
# Just shell config (the setup's -d would otherwise install the repository version)
cp "$BACKUP/dotfiles/.zshrc" ~/

# Just Git config
cp "$BACKUP/dotfiles/.gitconfig" ~/

# Just SSH
mkdir -p ~/.ssh && cp -Rp "$BACKUP/dotfiles/.ssh/." ~/.ssh/ && chmod 700 ~/.ssh

# Just Kubernetes config
mkdir -p ~/.kube
cp -p "$BACKUP/dotfiles/.kube/config" ~/.kube/config
chmod 600 ~/.kube/config

# Your projects
mkdir -p ~/dev && cp -Rp "$BACKUP/home/dev/." ~/dev/

# Brave profile on macOS (quit Brave first)
mkdir -p "$HOME/Library/Application Support/BraveSoftware/Brave-Browser/Default"
cp -Rp "$BACKUP/brave/Default/." "$HOME/Library/Application Support/BraveSoftware/Brave-Browser/Default/"
```

Projects were backed up without `node_modules`, `.venv`, `dist`, `build` and the other regenerable output listed above: reinstall dependencies after restoring.

### GPG Key

`~/.gnupg` is restored with the credentials above. To import the exported key on its own:

```sh
gpg --import "$BACKUP"/dotfiles/.gnupg/backup/private-key-*.asc
gpg --list-secret-keys
```

### Package Restore

The backup contains no package lists. Reinstall the toolset by re-running the setup, which installs everything defined by the profiles:

```sh
./setup/setup-osx.sh -p 'base,devops,js'      # macOS
./setup/setup-debian.sh -p 'base,devops,js'   # Debian/Ubuntu
```

**mise tools:**
```sh
# The backed-up ~/.config/mise/config.toml holds the versions pinned with
# `mise use --global`, so restoring it and running install is enough:
mkdir -p ~/.config/mise
cp -p "$BACKUP/dotfiles/.config/mise/config.toml" ~/.config/mise/
mise install
```

**Anything you installed by hand** is not recorded anywhere. If you want a list before wiping a machine, capture it yourself, for example:
```sh
brew bundle dump --file ~/Brewfile   # macOS
apt-mark showmanual > ~/apt-manual.txt   # Debian/Ubuntu
```

## Remote Backups

> The backup is not encrypted. Everything below moves it to another machine or provider: encrypt first (see [Encryption](#encryption)) or use an encrypted rclone remote.

### Using rclone

Setup rclone for cloud storage:

```sh
# Configure rclone (first time): create a remote for your provider, then a
# "crypt" remote on top of it (called "secret" below) so that names and
# contents are encrypted before they are uploaded
rclone config

# Backup locally, then push through the encrypted remote
./backup/backup-osx.sh -o ~/backups/dotfiles
rclone sync ~/backups/dotfiles secret:dotfiles-backup

# Restore from cloud
rclone sync secret:dotfiles-backup ~/restored-dotfiles
```

Supported providers:
- Google Drive
- Dropbox
- OneDrive
- AWS S3
- Backblaze B2
- And many more

### Using rsync over SSH

Backup to remote server:

```sh
# Initial backup
./backup/backup-osx.sh -o ~/backups/dotfiles
rsync -avz ~/backups/dotfiles/ user@server:/backups/dotfiles/

# Restore from remote
rsync -avz user@server:/backups/dotfiles/ ~/restored-dotfiles/
```

The server then holds your keys and tokens in clear text: use a server (and disk) you trust as much as this machine, or sync an encrypted archive instead.

### Using Git

Do not push a backup directory to a git remote (see [Version Control](#version-control)). If you want history in git, commit only an encrypted archive.

## Automated Backups

The GPG export may ask for the key's passphrase. In an unattended run (cron, launchd, systemd) a failing `gpg` command stops the script, because it runs with `set -e`: make sure gpg-agent can answer, or run the backup by hand.

### cron (macOS/Linux)

```sh
# Edit crontab
crontab -e

# Daily backup at 2 AM
0 2 * * * /Users/you/dotfiles/backup/backup-osx.sh -o ~/backups/dotfiles

# Weekly backup on Sunday at 3 AM, pushed through an encrypted rclone remote
0 3 * * 0 /Users/you/dotfiles/backup/backup-osx.sh -o ~/backups/dotfiles && rclone sync ~/backups/dotfiles secret:dotfiles
```

### launchd (macOS)

Create `~/Library/LaunchAgents/com.user.dotfiles-backup.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.user.dotfiles-backup</string>
    <key>ProgramArguments</key>
    <array>
        <string>/Users/you/dotfiles/backup/backup-osx.sh</string>
        <string>-o</string>
        <string>/Users/you/backups/dotfiles</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>2</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>
</dict>
</plist>
```

Load the agent:
```sh
launchctl load ~/Library/LaunchAgents/com.user.dotfiles-backup.plist
```

### systemd timer (Linux)

Create `/etc/systemd/system/dotfiles-backup.service`:

```ini
[Unit]
Description=Dotfiles Backup

[Service]
Type=oneshot
User=you
ExecStart=/home/you/dotfiles/backup/backup-debian.sh -o /home/you/backups/dotfiles
```

Create `/etc/systemd/system/dotfiles-backup.timer`:

```ini
[Unit]
Description=Dotfiles Backup Timer

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
```

Enable the timer:
```sh
sudo systemctl enable --now dotfiles-backup.timer
```

## Backup Strategies

### 3-2-1 Rule

Keep:
- **3** copies of your data
- On **2** different storage types
- With **1** copy offsite

Example:
1. Original files on your computer
2. Local backup on external drive
3. Encrypted cloud backup (an encrypted rclone remote, or an archive encrypted with gpg or age)

### Incremental Backups

Every run writes its own `backup_<timestamp>` directory, so snapshots accumulate in the output directory. Prune the old ones:

```sh
# Create a snapshot
./backup/backup-osx.sh -o ~/backups/dotfiles

# Keep the last 7 days, delete older snapshots
find ~/backups/dotfiles -maxdepth 1 -name 'backup_*' -mtime +7 -exec rm -rf {} +
```

## Security Considerations

### Sensitive Data

A backup contains:
- SSH private keys (`.ssh`), the GPG keyring (`.gnupg`) and the exported GPG private key
- Cloud and cluster credentials (`.aws`, `.kube`, `.tsh`, `.docker`, `.mc`, `.npmrc`)
- Everything in `~/.config`, including `~/.config/dotfiles/secrets.env`
- Claude Code settings and conversation history, and Copilot CLI configuration

The scripts only keep other local users out (`umask 077`, backup directory mode `700`). They do not encrypt.

**Best practices:**
- Keep backups on storage only you can access, and encrypt them before they go to a cloud folder, a NAS or a server
- Remove entries you do not want from the `DOT_FILES` list of the script
- Delete backups you no longer need: they hold the keys and tokens of their day
- The GPG export stays in `~/.gnupg/backup/` on the machine after each run: store the key safely, then remove it from there if you do not want a second copy
- Use secret management tools (1Password, Vault) rather than long-lived tokens in files

### Permissions

Ensure proper file permissions, especially after a restore:

```sh
# SSH keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_*
chmod 644 ~/.ssh/*.pub

# Kubernetes config
chmod 600 ~/.kube/config

# GPG keys
chmod 700 ~/.gnupg

# Local secrets
chmod 600 ~/.config/dotfiles/secrets.env
```

## Troubleshooting

### Backup Fails

**Check the flags:**
```sh
# An unknown flag (for example -d) prints the help and exits 1: the output directory is -o
./backup/backup-osx.sh -o ~/backups/dotfiles

# Preview without copying anything
./backup/backup-osx.sh -n -o ~/backups/dotfiles
```

**Check permissions:**
```sh
# Ensure script is executable
chmod +x backup/backup-osx.sh

# Check destination is writable
mkdir -p ~/backups && touch ~/backups/test && rm ~/backups/test
```

**Check disk space:**
```sh
# macOS
df -h ~/backups

# Linux
df -h ~/backups
```

**Check the final summary:** an item that could not be copied (for example a broken symlink or an unreadable file) does not stop the run. It is listed in a warning at the end of the output.

### Restore Fails

**Verify backup integrity:**
```sh
# Check backup directory exists
ls -la "$BACKUP"

# Verify files are present
find "$BACKUP" -type f | wc -l
```

**Permissions issues:**
```sh
# Fix ownership
sudo chown -R $USER:$USER ~/restored-dotfiles

# Fix permissions
chmod -R u+rw ~/restored-dotfiles
```
