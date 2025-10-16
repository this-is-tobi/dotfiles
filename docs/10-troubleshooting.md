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

3. **Reinstall WakeMeOps repository:**
```sh
curl https://raw.githubusercontent.com/upciti/wakemeops/main/assets/install_repository | sudo bash
```

4. **Check sources:**
```sh
cat /etc/apt/sources.list.d/wakemeops.list
```

### oh-my-zsh Installation Fails

**Problem:** oh-my-zsh won't install

**Solutions:**

1. **Manual install:**
```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

2. **Remove existing installation:**
```sh
rm -rf ~/.oh-my-zsh
# Run setup again
```

3. **Check Git availability:**
```sh
git --version
# Install if missing
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
ls -la ~/.config/copilot/instructions/
```

2. **Check settings.json:**
```sh
# Ensure absolute paths with ~
code ~/.vscode/settings.json
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

2. **Verify environment variables:**
```sh
echo $CONTEXT7_API_KEY
```

3. **Restart VS Code:**
```sh
# Quit completely
# Re-open
code .
```

4. **Check Docker (for Docker-based servers):**
```sh
docker ps
# Start Docker Desktop if not running
```

5. **Verify mcp.json syntax:**
```sh
# Validate JSON
cat ~/.vscode/mcp.json | jq .
```

### Docker MCP Server Not Working

**Problem:** Kubernetes or GitKraken MCP not connecting

**Solutions:**

1. **Ensure Docker is running:**
```sh
docker ps
# If error, start Docker Desktop
```

2. **Test Docker:**
```sh
docker run hello-world
```

3. **Check volume mounts:**
```sh
# Kubernetes
ls -la ~/.kube/config

# GitKraken
ls -la ~/.gitkraken/
```

4. **Pull images manually:**
```sh
docker pull ghcr.io/stophobia/mcp-k8s:latest
docker pull gitkraken/mcp-server-gk
```

## Git Issues

### Git Configuration Not Applied

**Problem:** Git config not working

**Solutions:**

1. **Check .gitconfig:**
```sh
cat ~/.gitconfig
```

2. **Verify user info:**
```sh
git config --global user.name
git config --global user.email
```

3. **Set if missing:**
```sh
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
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

2. **Configure credential helper:**
```sh
# macOS
git config --global credential.helper osxkeychain

# Linux
git config --global credential.helper store
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
- Docker Desktop requires macOS 10.15+

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

1. **Check proto installation:**
```sh
proto --version
```

2. **Install Node:**
```sh
proto install node 20
proto use node 20
```

3. **Check PATH:**
```sh
echo $PATH | grep proto
```

4. **Add proto to PATH:**
```sh
# Add to ~/.zshrc
export PATH="$HOME/.proto/bin:$PATH"
source ~/.zshrc
```

### npm Permissions Error

**Problem:** npm install fails with EACCES

**Solutions:**

1. **Use proto (recommended):**
```sh
proto install node
# Proto manages permissions correctly
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

1. **Install Nerd Font:**
```sh
# macOS
brew tap homebrew/cask-fonts
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

1. **Check kube-ps1 plugin:**
```sh
grep "kube-ps1" ~/.zshrc
```

2. **Enable in .zshrc:**
```sh
# Should be in plugins list
plugins=(
  ...
  kube-ps1
  ...
)
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

**Problem:** Backup doesn't complete

**Solutions:**

1. **Check destination exists:**
```sh
mkdir -p ~/backups
```

2. **Check permissions:**
```sh
ls -la ~/backups
```

3. **Check disk space:**
```sh
df -h
```

4. **Run with verbose output:**
```sh
bash -x backup/backup-osx.sh -d ~/backups
```

### Restore Doesn't Work

**Problem:** Files not restored correctly

**Solutions:**

1. **Verify backup integrity:**
```sh
ls -la ~/backups/dotfiles
```

2. **Copy files manually:**
```sh
cp ~/backups/dotfiles/.zshrc ~/
```

3. **Check ownership:**
```sh
sudo chown -R $USER:$USER ~/backups
```

4. **Restore permissions:**
```sh
chmod 600 ~/.ssh/id_*
chmod 644 ~/.ssh/*.pub
```

## Getting Help

### Enable Debug Mode

Add to top of script to debug:

```sh
set -x  # Print commands
set -e  # Exit on error
set -u  # Error on undefined variable
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

# Backup regularly
./backup/backup-osx.sh
```

### Version Pinning

Pin important tool versions:

```sh
# Proto
proto pin node 20
proto pin go 1.21

# Document in README
echo "Node.js: $(node --version)" >> VERSIONS.md
```
