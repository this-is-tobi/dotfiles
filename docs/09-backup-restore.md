# Backup & Restore

This document explains how to backup and restore your dotfiles and system configurations.

## Overview

The backup scripts save your dotfiles, configurations, and important system files to a specified directory (local or remote). This ensures you can:
- Restore configurations after a system reinstall
- Sync settings across multiple machines
- Keep a history of configuration changes
- Migrate to a new computer

## Backup Scripts

### macOS: backup-osx.sh

**Location:** `backup/backup-osx.sh`

**Purpose:** Backup macOS-specific configurations and dotfiles

**Usage:**
```sh
./backup/backup-osx.sh [OPTIONS]
```

**Options:**
```
-d, --destination DIR   Backup destination directory (default: ./backup-<timestamp>)
-h, --help             Display help message
```

**Examples:**
```sh
# Backup to default location
./backup/backup-osx.sh

# Backup to specific directory
./backup/backup-osx.sh -d ~/Dropbox/dotfiles-backup

# Backup to external drive
./backup/backup-osx.sh -d /Volumes/Backup/dotfiles

# Backup to remote mount
./backup/backup-osx.sh -d ~/mnt/nas/dotfiles
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
-d, --destination DIR   Backup destination directory (default: ./backup-<timestamp>)
-h, --help             Display help message
```

**Examples:**
```sh
# Backup to default location
./backup/backup-debian.sh

# Backup to specific directory
./backup/backup-debian.sh -d ~/backup/dotfiles

# Backup to mounted network share
./backup/backup-debian.sh -d /mnt/backup/dotfiles
```

## What Gets Backed Up

### Shell Configuration
- `.zshrc` - Zsh configuration
- `.bashrc` - Bash configuration (if exists)
- `.profile` - Shell profile
- `.config/dotfiles/` - Custom functions and environment

### Development Tools
- `.gitconfig` - Git configuration
- `.vscode/` - VS Code workspace settings
- `.config/gh/` - GitHub CLI configuration
- `.config/gh-dash/` - GitHub Dashboard config
- `.config/lazygit/` - Lazygit configuration
- `.config/nvim/` - Neovim configuration

### Application Configs
- `.config/cheat/` - Cheat configuration
- `.mattermost/` - Mattermost theme
- `.continue/` - Continue.dev config
- `.prototools` - Proto version manager

### Oh-my-zsh
- `.oh-my-zsh/custom/` - Custom themes and plugins
- Theme file: `this-is-tobi.zsh-theme`

### Kubernetes & Cloud
- `.kube/config` - Kubernetes configuration
- `.aws/` - AWS CLI configuration (if exists)
- `.config/gcloud/` - Google Cloud SDK (if exists)

### SSH Keys (Optional)
- `.ssh/` - SSH keys and configuration
  - **Note:** Keys are backed up with restrictive permissions

### Package Lists
The scripts also create package lists:
- **macOS:** Homebrew package list
- **Debian:** apt package list
- **Proto:** Installed tool versions
- **npm:** Global packages (if installed)

## Backup Structure

Example backup directory structure:

```
backup-2023-10-15-143022/
├── dotfiles/
│   ├── .zshrc
│   ├── .gitconfig
│   ├── .prototools
│   └── .config/
│       ├── dotfiles/
│       ├── cheat/
│       ├── gh-dash/
│       ├── lazygit/
│       └── nvim/
├── vscode/
│   ├── settings.json
│   ├── mcp.json
│   └── extensions.json
├── oh-my-zsh/
│   └── custom/
│       └── themes/
│           └── this-is-tobi.zsh-theme
├── kubernetes/
│   └── config
├── ssh/ (optional)
│   ├── config
│   └── *.pub
└── package-lists/
    ├── brew-packages.txt
    ├── brew-casks.txt
    ├── apt-packages.txt
    └── proto-tools.txt
```

## Backup Best Practices

### Regular Backups
```sh
# Weekly backup
./backup/backup-osx.sh -d ~/Dropbox/dotfiles-backup

# Use cron for automation (macOS/Linux)
# Edit crontab
crontab -e

# Add weekly backup (Sunday at 2 AM)
0 2 * * 0 /path/to/dotfiles/backup/backup-osx.sh -d ~/Dropbox/dotfiles-backup
```

### Version Control
```sh
# Initialize git in backup directory
cd ~/backups/dotfiles
git init
git add .
git commit -m "Backup $(date +%Y-%m-%d)"

# Push to private repository
git remote add origin git@github.com:you/private-dotfiles-backup.git
git push -u origin main
```

### Multiple Destinations
```sh
# Local backup
./backup/backup-osx.sh -d ~/backups/dotfiles

# Cloud backup (Dropbox)
./backup/backup-osx.sh -d ~/Dropbox/dotfiles-backup

# Network backup
./backup/backup-osx.sh -d /Volumes/NAS/backups/dotfiles

# External drive
./backup/backup-osx.sh -d /Volumes/Backup/dotfiles
```

### Encryption
For sensitive data:

```sh
# Backup first
./backup/backup-osx.sh -d ~/backup-temp

# Encrypt with gpg
tar czf - ~/backup-temp | gpg -c > dotfiles-backup.tar.gz.gpg

# Or use age
tar czf - ~/backup-temp | age -p > dotfiles-backup.tar.gz.age

# Upload encrypted backup to cloud
rclone copy dotfiles-backup.tar.gz.gpg remote:backups/
```

## Restoring from Backup

### Full Restore

1. **Clone dotfiles repository:**
```sh
git clone https://github.com/this-is-tobi/dotfiles.git
cd dotfiles
```

2. **Run setup script:**
```sh
./setup/setup-osx.sh -p 'base,devops,js'  # Your profiles
```

3. **Restore backed-up files:**
```sh
# Copy from backup
cp -r ~/backups/dotfiles/dotfiles/. ~/

# Or use rsync
rsync -av ~/backups/dotfiles/dotfiles/ ~/
```

4. **Restore application configs:**
```sh
# VS Code
cp -r ~/backups/dotfiles/vscode/.vscode ~/.vscode

# Kubernetes config
mkdir -p ~/.kube
cp ~/backups/dotfiles/kubernetes/config ~/.kube/config
chmod 600 ~/.kube/config
```

5. **Reload shell:**
```sh
exec zsh
```

### Selective Restore

Restore only specific configurations:

```sh
# Just shell config
cp ~/backups/dotfiles/dotfiles/.zshrc ~/

# Just Git config
cp ~/backups/dotfiles/dotfiles/.gitconfig ~/

# Just VS Code settings
cp -r ~/backups/dotfiles/vscode/.vscode ~/workspace/.vscode

# Just Kubernetes config
cp ~/backups/dotfiles/kubernetes/config ~/.kube/config
```

### Package Restore

Reinstall packages from backup lists:

**macOS:**
```sh
# Install Homebrew packages
xargs brew install < ~/backups/dotfiles/package-lists/brew-packages.txt

# Install Cask applications
xargs brew install --cask < ~/backups/dotfiles/package-lists/brew-casks.txt
```

**Debian/Ubuntu:**
```sh
# Install apt packages
xargs sudo apt install -y < ~/backups/dotfiles/package-lists/apt-packages.txt
```

**Proto tools:**
```sh
# Restore Proto tools
while read -r line; do
  tool=$(echo "$line" | awk '{print $1}')
  version=$(echo "$line" | awk '{print $2}')
  proto install "$tool" "$version"
done < ~/backups/dotfiles/package-lists/proto-tools.txt
```

## Remote Backups

### Using rclone

Setup rclone for cloud storage:

```sh
# Configure rclone (first time)
rclone config

# Backup to cloud
./backup/backup-osx.sh -d /tmp/dotfiles-backup
rclone sync /tmp/dotfiles-backup remote:dotfiles-backup

# Restore from cloud
rclone sync remote:dotfiles-backup ~/restored-dotfiles
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
./backup/backup-osx.sh -d /tmp/dotfiles-backup
rsync -avz /tmp/dotfiles-backup user@server:/backups/

# Restore from remote
rsync -avz user@server:/backups/dotfiles-backup ~/restored-dotfiles
```

### Using Git

Backup to private Git repository:

```sh
# Create backup
./backup/backup-osx.sh -d ~/dotfiles-backup

# Initialize git
cd ~/dotfiles-backup
git init
git add .
git commit -m "Backup $(date +%Y-%m-%d)"

# Push to private repo
git remote add origin git@github.com:you/private-backup.git
git push -u origin main
```

## Automated Backups

### cron (macOS/Linux)

```sh
# Edit crontab
crontab -e

# Daily backup at 2 AM
0 2 * * * /Users/you/dotfiles/backup/backup-osx.sh -d ~/Dropbox/dotfiles-backup

# Weekly backup on Sunday at 3 AM with cloud sync
0 3 * * 0 /Users/you/dotfiles/backup/backup-osx.sh -d /tmp/backup && rclone sync /tmp/backup remote:dotfiles
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
        <string>-d</string>
        <string>/Users/you/Dropbox/dotfiles-backup</string>
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
ExecStart=/home/you/dotfiles/backup/backup-debian.sh -d /home/you/backups/dotfiles
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
3. Cloud backup (Dropbox, S3, etc.)

### Incremental Backups

Use time-stamped backups:

```sh
# Create dated backup
./backup/backup-osx.sh -d ~/backups/dotfiles-$(date +%Y-%m-%d)

# Keep last 7 days, delete older
find ~/backups -name 'dotfiles-*' -mtime +7 -exec rm -rf {} \;
```

### Differential Backups

Only backup changed files:

```sh
# First full backup
./backup/backup-osx.sh -d ~/backups/full

# Subsequent differential backups
rsync -av --compare-dest=~/backups/full ~ ~/backups/diff-$(date +%Y-%m-%d)
```

## Security Considerations

### Sensitive Data

Be careful with:
- SSH private keys
- API keys and tokens
- Passwords and credentials
- Cloud provider credentials

**Best practices:**
- Don't backup private keys to cloud (or encrypt them)
- Use secret management tools (1Password, Vault)
- Exclude sensitive files from backups
- Encrypt backups containing credentials

### Permissions

Ensure proper file permissions:

```sh
# SSH keys
chmod 600 ~/.ssh/id_*
chmod 644 ~/.ssh/*.pub

# Kubernetes config
chmod 600 ~/.kube/config

# GPG keys
chmod 700 ~/.gnupg
```

## Troubleshooting

### Backup Fails

**Check permissions:**
```sh
# Ensure script is executable
chmod +x backup/backup-osx.sh

# Check destination is writable
touch ~/backups/test && rm ~/backups/test
```

**Check disk space:**
```sh
# macOS
df -h ~/backups

# Linux
df -h ~/backups
```

### Restore Fails

**Verify backup integrity:**
```sh
# Check backup directory exists
ls -la ~/backups/dotfiles

# Verify files are present
find ~/backups/dotfiles -type f | wc -l
```

**Permissions issues:**
```sh
# Fix ownership
sudo chown -R $USER:$USER ~/restored-dotfiles

# Fix permissions
chmod -R u+rw ~/restored-dotfiles
```
