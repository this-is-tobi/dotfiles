# Troubleshooting

This guide helps resolve common issues with the dotfiles installation and configuration.

## Installation Issues

### Setup Script Permission Denied

**Problem:** Cannot execute setup script

**Solution:**
```sh
# Make script executable
chmod +x setup/setup-osx.sh
chmod +x setup/setup-debian.sh

# Run with bash
bash setup/setup-osx.sh
```

### Check What the Setup Would Do (-n)

**Problem:** You want to see which profiles and steps a run would use before it installs anything

**Solution:** `-n` prints the resolved settings and exits. It installs and changes nothing:
```sh
./setup/setup-osx.sh -n -p base,js -d
```

An unknown profile name stops the run with `Error: unknown profile '<name>'` and exit status 1, and the message lists the valid profiles. The backup scripts have the same flag: `./backup/backup-osx.sh -n` shows what a backup would copy without creating anything.

### Profiles or Dotfiles Not Installed

**Problem:** The setup stops with `Error: this script needs the rest of the repository`, for example when it was piped into bash (`curl ... | bash`) or the script was copied out of the repository

**Solution:** `-p` and `-d` resolve `profiles/` and `dotfiles/` relative to the script, so the script has to run from a cloned repository:
```sh
git clone https://github.com/this-is-tobi/dotfiles.git
cd dotfiles
./setup/setup-osx.sh -p base -d
```

### Replaced Dotfiles: Where Are They?

**Problem:** After `-d`, your own `~/.zshrc`, `~/.gitconfig` or another file looks overwritten

**Solution:** A destination whose content differs from the repository is saved first under `~/.dotfiles-backup/<timestamp>/`, with the same path relative to `$HOME` (the directory is private, mode `700`). Identical files are left alone, so re-running the setup creates no backup.
```sh
ls -R ~/.dotfiles-backup
# Put one back
cp ~/.dotfiles-backup/<timestamp>/.zshrc ~/.zshrc
```

Edits you made to an installed dotfile (for example `~/.zshrc`) are replaced the same way by the repository version when you re-run the setup with `-d`; the previous content is in that directory. This is not the same thing as the `backup/` scripts, which copy your files to a directory of your choice.

### The -r Flag Does Nothing

**Problem:** `-r` (remove temporary files) no longer cleans anything

**Solution:** `-r` is deprecated and ignored: the setup prints a note and carries on. The scripts that create temporary files remove them themselves, so there is nothing to clean up afterwards. Do not replace it with `rm -rf /tmp/*`, which also deletes other applications' state.

### Setup Stops: Command Line Tools or Homebrew Missing (macOS)

**Problem:** The setup exits with `... is required but not installed, and this shell is non-interactive`

**Solution:** The setup offers to install Command Line Tools and Homebrew (`[y/N]`) only when it runs in an interactive terminal. Run it from one, or install them first (next section).

### Homebrew Installation Fails (macOS)

**Problem:** Homebrew won't install

**Solutions:**

1. **Install Command Line Tools:**
```sh
xcode-select --install
```

2. **Manual Homebrew Install:**
```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

3. **Check Homebrew path:**

The dotfiles' `.zshrc` already finds `brew` on both architectures. If `brew` is not found in a shell that does not load it (for example before `-d` has installed it, or with another `.zshrc`):
```sh
# Apple Silicon (M1/M2)
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile

# Intel Mac
echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
```

### apt Repository Issues (Debian/Ubuntu)

**Problem:** Package installation fails

**Solutions:**

1. **Update package lists:**
```sh
sudo apt update
```

2. **Fix broken packages:**
```sh
sudo apt --fix-broken install
```

3. **Check sources:**
```sh
cat /etc/apt/sources.list.d/*.list
```

Note: CLI tooling no longer comes from apt - see
[mise Issues](02-installation.md#mise-issues) if the missing package is a tool
rather than a system library.

Docker's apt repository follows the distribution (`debian` or `ubuntu`): on any
other distribution the setup stops with an error instead of adding it.

### oh-my-zsh Installation Fails

**Problem:** oh-my-zsh won't install

**Solutions:**

1. **Manual install** (the setup runs the installer with `--unattended`, which neither switches your login shell nor starts zsh):
```sh
KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
```

2. **Remove existing installation:**
```sh
rm -rf ~/.oh-my-zsh
# Run setup again (with -d to put the theme back)
```

3. **Check Git availability:**
```sh
git --version
# The Debian setup installs git when it is missing; on macOS it comes with
# the Command Line Tools
```

### Package Installation Fails

**Problem:** Specific package won't install

**Solutions:**

1. **Install manually:**
```sh
# Homebrew
brew install <package>

# apt
sudo apt install <package>
```

2. **Skip package and continue:**
```sh
# Edit setup script to comment out failing package
vim setup/setup-osx.sh
```

3. **Check package availability:**
```sh
# Homebrew
brew search <package>

# apt
apt search <package>
```

## Shell Issues

### Command Not Found

**Problem:** Installed command not found

**Solutions:**

1. **Restart shell:**
```sh
exec zsh
```

2. **Check PATH:**
```sh
echo $PATH
```

3. **Locate command:**
```sh
# Find where command is installed
which <command>
find / -name <command> 2>/dev/null
```

4. **Add to PATH:**
```sh
# Add to ~/.zshrc
export PATH="/path/to/bin:$PATH"
source ~/.zshrc
```

### Slow Shell Startup

**Problem:** Shell takes long to start

**Solutions:**

1. **Profile startup:**
```sh
time zsh -i -c exit
```

2. **Disable plugins one by one:**
```sh
# Edit ~/.zshrc
# Comment out plugins gradually
plugins=(
  git
  # docker  # Disabled for testing
  # kubectl # Disabled for testing
)
```

3. **Clear completion cache:**
```sh
rm ~/.zcompdump*
exec zsh
```

4. **Check for slow commands in .zshrc:**
```sh
# Add to .zshrc to profile
zmodload zsh/zprof
# ... existing config ...
# At end:
zprof
```

### Functions Not Working

**Problem:** Custom functions not available

**Solutions:**

1. **Source functions:**
```sh
source ~/.config/dotfiles/functions.sh
```

2. **Check .zshrc sources it:**
```sh
grep "functions.sh" ~/.zshrc
```

3. **Add to .zshrc if missing:**
```sh
# Add this line
source ~/.config/dotfiles/functions.sh
```

4. **Verify file exists:**
```sh
ls -la ~/.config/dotfiles/functions.sh
```

### API Keys or Environment Variables Missing

**Problem:** `CONTEXT7_API_KEY`, `ARGOCD_BASE_URL` or another variable is empty in a shell, or an MCP server complains about a missing key

**Solutions:**

1. **Check the secrets file:** secrets live in `~/.config/dotfiles/secrets.env`, plain `KEY=value` lines, created once by the setup with `-d` (mode `600`, from `secrets.env.example`) and never overwritten. `env.sh` is managed by the setup (edits are lost) and only loads that file:
```sh
ls -l ~/.config/dotfiles/secrets.env
# values you used to keep in env.sh were moved here by the setup
```
If the file does not exist, run the setup with `-d`.

2. **Fill in the keys you use** (uncomment them in the template), then open a new shell:
```sh
vim ~/.config/dotfiles/secrets.env
exec zsh
```

3. **Register them with Claude Code:** MCP servers that need a key only see it after `setup/helpers/claude-mcp.sh` has run again (see [MCP Server Connection Failed](#mcp-server-connection-failed)). VS Code prompts for its keys itself the first time a server starts.

### Completions Not Working

**Problem:** Tab completion doesn't work

**Solutions:**

1. **Rebuild completion cache:**
```sh
rm -f ~/.zcompdump*
compinit
```

2. **Check completion system:**
```sh
# Add to ~/.zshrc if missing
autoload -Uz compinit
compinit
```

3. **Restart shell:**
```sh
exec zsh
```

## VS Code Issues

### Copilot Instructions Not Loaded

**Problem:** Instructions don't affect Copilot behavior

**Solutions:**

1. **Verify file paths:**
```sh
ls -la ~/.copilot/instructions/
```

2. **Check settings.json** (the user settings file is not in `~/.vscode`):
```sh
# macOS
code ~/Library/Application\ Support/Code/User/settings.json

# Linux
code ~/.config/Code/User/settings.json
```

3. **Reload window:**
- `Cmd+Shift+P` → "Reload Window"

4. **Verify Copilot is enabled:**
- Check GitHub Copilot status in VS Code

### MCP Server Connection Failed

**Problem:** MCP server won't connect

**Solutions:**

1. **Check server status:**
- `Cmd+Shift+P` → "MCP: Show Server Status"

2. **Verify secrets:** VS Code asks for MCP keys the first time a server starts. Claude Code and the shell read them from `~/.config/dotfiles/secrets.env`:
```sh
[ -n "$CONTEXT7_API_KEY" ] && echo set || echo missing
```

3. **Restart VS Code:**
```sh
# Quit completely
# Re-open
code .
```

4. **Verify mcp.json syntax:**
```sh
# macOS: ~/Library/Application Support/Code/User/mcp.json
# Linux: ~/.config/Code/User/mcp.json
# The file allows // comment lines, which jq rejects: drop them first
grep -v '^[[:space:]]*//' ~/Library/Application\ Support/Code/User/mcp.json | jq .
```

### npx-based MCP Servers Not Starting

**Problem:** The `kubernetes`, `argocd` or `playwright` server does not start

The servers in `dotfiles/.vscode/mcp.json` are `github` (remote, authenticated by your VS Code session), `context7` (remote, API key), and three servers started with `npx`: `kubernetes` (`kubernetes-mcp-server`), `argocd` (`argocd-mcp`) and `playwright` (`@playwright/mcp`). None of them needs Docker.

**Solutions:**

1. **Check that Node and npx are available** (the `js` profile installs Node with mise):
```sh
command -v npx
mise doctor
```

2. **Run the server by hand** to see its error (it should start and wait for input, stop it with `Ctrl+C`):
```sh
npx -y kubernetes-mcp-server@latest
```

3. **Kubernetes:** the server reads your kubeconfig:
```sh
ls -la ~/.kube/config
kubectl config current-context
```

4. **Argo CD:** it needs the server URL and an API token. VS Code asks for both the first time the server starts. For Claude Code, set `ARGOCD_BASE_URL` and `ARGOCD_API_TOKEN` in `~/.config/dotfiles/secrets.env`: the setup registers the server only when `ARGOCD_BASE_URL` is set, so re-run `setup/helpers/claude-mcp.sh` afterwards.

5. **Claude Code:** `setup/helpers/claude-mcp.sh` (the setup runs it with `-d` when `claude` is installed) registers `context7`, `kubernetes`, `playwright` and, when configured, `argocd`, and is safe to re-run:
```sh
claude mcp list
```

## Git Issues

### Git Configuration Not Applied

**Problem:** Git config not working, or commits fail with `Author identity unknown`

The shared `~/.gitconfig` carries no identity and no commit signing: those are per machine and live in `~/.gitconfig.local`, which `~/.gitconfig` includes last. The setup creates `~/.gitconfig.local` once (it carries your name, email and signing settings over from an existing `~/.gitconfig`, otherwise it asks, or prints how to set them when there is no terminal) and never overwrites it.

**Solutions:**

1. **Check .gitconfig:**
```sh
cat ~/.gitconfig
```

2. **Verify user info and where it comes from:**
```sh
git config --show-origin user.name
git config --show-origin user.email
```
(`git config --global user.name` only reads `~/.gitconfig` and shows nothing here.)

3. **Set if missing** (not with `--global`: `~/.gitconfig` is replaced when you re-run the setup with `-d`):
```sh
git config --file ~/.gitconfig.local user.name "Your Name"
git config --file ~/.gitconfig.local user.email "you@example.com"
```

### Git Credentials Not Saved

**Problem:** Git asks for password every time

**Solutions:**

1. **Use SSH:**
```sh
# Generate SSH key
ssh-keygen -t ed25519 -C "your@email.com"

# Add to GitHub
cat ~/.ssh/id_ed25519.pub
# Copy and add to GitHub.com → Settings → SSH Keys
```

2. **Configure credential helper:** the shared `~/.gitconfig` sets `cache --timeout=3600`, so HTTPS passwords are forgotten after an hour. Credential helpers add up, so a persistent one in `~/.gitconfig.local` is used alongside it:
```sh
# macOS
git config --file ~/.gitconfig.local credential.helper osxkeychain

# Linux
git config --file ~/.gitconfig.local credential.helper store
```

## Kubernetes Issues

### kubectl Not Working

**Problem:** kubectl commands fail

**Solutions:**

1. **Verify installation:**
```sh
kubectl version --client
```

2. **Check config:**
```sh
kubectl config view
```

3. **Test cluster connection:**
```sh
kubectl cluster-info
```

4. **Set context:**
```sh
kubectl config get-contexts
kubectl config use-context <context-name>
```

### kubectl Plugins Not Found

**Problem:** Installed krew plugins not available

**Solutions:**

1. **Check PATH:**
```sh
echo $PATH | grep krew
```

2. **Add to PATH if missing:**
```sh
# Add to ~/.zshrc
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
source ~/.zshrc
```

3. **Verify plugin installation:**
```sh
kubectl krew list
```

4. **Reinstall plugin:**
```sh
kubectl krew install <plugin>
```

## Docker Issues

### Docker Commands Require sudo (Linux)

**Problem:** Must use sudo for Docker

**Solutions:**

1. **Add user to docker group:**
```sh
sudo usermod -aG docker $USER
```

2. **Log out and back in:**
```sh
# Or restart shell
exec $SHELL
```

3. **Verify:**
```sh
docker ps
```

### Docker Desktop Not Starting (macOS)

**Problem:** Docker Desktop won't start

**Solutions:**

1. **Check macOS version:**
- Check that your macOS version is still supported by your Docker Desktop release (see Docker's system requirements)

2. **Reset Docker:**
- Docker Desktop → Troubleshoot → Reset to factory defaults

3. **Reinstall Docker:**
```sh
brew reinstall --cask docker
```

## Node.js / JavaScript Issues

### node Command Not Found

**Problem:** Node.js not available

**Solutions:**

1. **Check mise installation:**
```sh
mise --version
mise doctor
```

2. **Install Node:**
```sh
mise use --global node@22
```

3. **Check PATH:**
```sh
echo $PATH | grep mise
```

4. **Activate mise in the shell:**
```sh
# Should already be in ~/.zshrc
eval "$(mise activate zsh)"
source ~/.zshrc
```

In non-interactive contexts (scripts, CI, container builds) `mise activate` is
unavailable - put the shims directory on PATH instead:
```sh
export PATH="$HOME/.local/share/mise/shims:$PATH"
```

### npm Permissions Error

**Problem:** npm install fails with EACCES

**Solutions:**

1. **Use mise (recommended):**
```sh
mise use --global node@22
# mise installs under $HOME, so no sudo and no permission juggling
```

2. **Fix npm permissions:**
```sh
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
export PATH=~/.npm-global/bin:$PATH
```

## Theme Issues

### Prompt Not Displaying Correctly

**Problem:** Prompt looks broken

**Solutions:**

1. **Check the Nerd Fonts are installed:** the base profile downloads Hack and the Nerd Fonts symbols from the nerd-fonts release zips (see `setup/helpers/fonts.sh`) into `~/.fonts`, and on macOS copies the `.ttf` files to `~/Library/Fonts`:
```sh
# macOS
ls ~/Library/Fonts | grep -i nerd

# Debian/Ubuntu
fc-list | grep -i nerd
```
On Debian the font step is skipped when `~/.fonts` already exists: rename that directory and re-run the base profile to get the fonts.

If you prefer Homebrew, the font is a regular cask (no tap needed):
```sh
brew install --cask font-hack-nerd-font
```

2. **Set font in terminal:**
- Terminal → Preferences → Profiles → Font → "Hack Nerd Font"

3. **Check theme file:**
```sh
ls ~/.oh-my-zsh/custom/themes/this-is-tobi.zsh-theme
```

4. **Verify theme setting:**
```sh
grep "ZSH_THEME" ~/.zshrc
# Should be: ZSH_THEME="this-is-tobi"
```

### Kubernetes Context Not Showing

**Problem:** Kubernetes context missing from prompt

**Solutions:**

1. **Check the theme:** kube-ps1 is embedded in the theme `this-is-tobi.zsh-theme`, it is not an oh-my-zsh plugin (nothing to add to `plugins`):
```sh
grep "kube_ps1" ~/.oh-my-zsh/custom/themes/this-is-tobi.zsh-theme | head -3
grep "ZSH_THEME" ~/.zshrc
# Should be: ZSH_THEME="this-is-tobi"
```
If the theme file is missing, re-run the setup with `-d`.

2. **Check the prompt is switched on:** the theme defines `kubeon` and `kubeoff` (`-g` for all shells):
```sh
kubeon
```

3. **Verify kubectl config:**
```sh
kubectl config current-context
```

## Performance Issues

### High CPU Usage

**Problem:** Terminal uses too much CPU

**Solutions:**

1. **Disable unnecessary plugins:**
```sh
# Edit ~/.zshrc
# Remove unused plugins
```

2. **Disable git status in large repos:**
```sh
git config --global oh-my-zsh.hide-status 1
```

3. **Reduce history size:**
```sh
# Add to ~/.zshrc
HISTSIZE=1000
SAVEHIST=1000
```

### High Memory Usage

**Problem:** Shell uses too much memory

**Solutions:**

1. **Restart shell:**
```sh
exec zsh
```

2. **Check running processes:**
```sh
ps aux | grep -E "(zsh|docker|kubectl)"
```

3. **Limit Docker resources:**
- Docker Desktop → Settings → Resources → Adjust limits

## Backup & Restore Issues

### Backup Script Fails

**Problem:** Backup doesn't complete, or nothing is created

**Solutions:**

1. **Use the right flags:** the output directory is `-o` (there is no `-d`). Any unknown flag prints the help and exits with status 1:
```sh
./backup/backup-osx.sh -o ~/backups
```

2. **Preview with a dry run:** `-n` shows what would be copied and creates nothing:
```sh
./backup/backup-osx.sh -n -o ~/backups
```

3. **Check destination exists and is writable:**
```sh
mkdir -p ~/backups
ls -la ~/backups
```

4. **Check disk space:**
```sh
df -h
```

5. **Check the warnings at the end:** a single item that fails (for example a broken symlink) does not stop the run, it is listed in a final warning. The script also needs `rclone` (installed by the base profile).

6. **Run with verbose output:**
```sh
bash -x backup/backup-osx.sh -o ~/backups
```

A backup is private (mode `700`) but not encrypted: see [Backup & Restore](09-backup-restore.md#security-considerations) before copying it anywhere.

### Restore Doesn't Work

**Problem:** Files not restored correctly

**Solutions:**

1. **Verify backup integrity:** each run creates `backup_<timestamp>/` in the output directory, with `etc/`, `dotfiles/`, `home/` (and `brave/` on macOS) inside:
```sh
BACKUP=~/backups/backup_<timestamp>
ls -la "$BACKUP" "$BACKUP/dotfiles"
```

2. **Copy files manually:**
```sh
cp "$BACKUP/dotfiles/.zshrc" ~/
```

3. **Check ownership:**
```sh
sudo chown -R $USER:$USER ~/backups
```

4. **Restore permissions:**
```sh
chmod 700 ~/.ssh ~/.gnupg
chmod 600 ~/.ssh/id_*
chmod 644 ~/.ssh/*.pub
```

## Getting Help

### Enable Debug Mode

Trace a script instead of editing it (the scripts already stop on the first error):

```sh
bash -x setup/setup-osx.sh -p base
```

### Check Logs

View system logs:

```sh
# macOS
log show --predicate 'process == "zsh"' --last 1h

# Linux
journalctl -u <service> -f
```

### Community Support

- [GitHub Issues](https://github.com/this-is-tobi/dotfiles/issues)
- [oh-my-zsh Wiki](https://github.com/ohmyzsh/ohmyzsh/wiki)
- [Homebrew Documentation](https://docs.brew.sh/)
- [VS Code Documentation](https://code.visualstudio.com/docs)

### Report Issues

When reporting issues, include:
- Operating system and version
- Shell version: `zsh --version`
- Error messages
- Steps to reproduce
- Relevant configuration files

## Prevention

### Regular Maintenance

```sh
# Update packages monthly
brew update && brew upgrade  # macOS
sudo apt update && sudo apt upgrade  # Linux

# Clean caches
brew cleanup  # macOS
sudo apt autoremove  # Linux

# Backup regularly (private but not encrypted, see Backup & Restore)
./backup/backup-osx.sh -o ~/backups
```

### Version Pinning

Pin important tool versions:

```sh
# mise (writes to ~/.config/mise/config.toml)
mise use --global node@22
mise use --global go@1.24

# Document in README
echo "Node.js: $(node --version)" >> VERSIONS.md
```
