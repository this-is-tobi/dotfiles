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

Edits you made to an installed dotfile (for example `~/.zshrc`) are replaced the same way by the repository version when you re-run the setup with `-d`; the previous content is in that directory. The setup never deletes those directories: every run that replaces a file adds a new one, holding the version that was on the machine at that moment. This is not the same thing as the `backup/` scripts, which copy your files to a directory of your choice.

The `-d` output says how many lines the old file had that the new one does not, for example `(21 lines it had are not in the new file)`. When it is not 0, see what you would lose, and move it where the setup does not write:
```sh
# Lines that differ between the saved file and the new one (the timestamp is in the -d output)
diff ~/.dotfiles-backup/<timestamp>/.zshrc ~/.zshrc
```
- shell: `~/.zshrc.local`, sourced at the end of `.zshrc`
- git: `~/.gitconfig.local`
- secrets: `~/.config/dotfiles/secrets.env`
- VS Code `settings.json` and `~/.claude/settings.json` are merged, so what you added there stays

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
# Add to ~/.zshrc.local (~/.zshrc is replaced by the setup)
export PATH="/path/to/bin:$PATH"
exec zsh
```

### `command not found: complete` at Shell Start

**Problem:** Every new shell prints `functions-completion.sh:8: command not found: complete`

**Solution:** The completion of `tools` used to be a bash completion, which only works once `bashcompinit` has run, and `.zshrc` only runs it when terraform or vault is installed. It is a native zsh completion now: re-run the setup with `-d` to get the new `~/.config/dotfiles/functions-completion.sh`, then open a new shell.

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

4. **Check for slow commands in .zshrc** (a temporary edit: remove it afterwards, or re-run `-d`):
```sh
# First line of ~/.zshrc
zmodload zsh/zprof
# ... existing config ...
# Last line:
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

3. **If it does not, or the file is missing,** `~/.zshrc` is not the one of this repository (or is an old one): re-run the setup with `-d`, which installs both (the previous `~/.zshrc` is backed up).

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

4. **Keys kept in rta:** see the next section.

### Keys Kept in rta Are Missing

**Problem:** You moved tokens to an [rta](https://github.com/this-is-tobi/rta) store and listed their names in `DOTFILES_RTA_KEYS`, and a shell or Claude Code does not see them

**Solutions:**

1. **Run `secrets`:** the keys are not loaded when a shell starts. `secrets` exports them into the shell it runs in, so run it before starting a program that needs them (Claude Code reads `${VAR}` at launch):
```sh
secrets
claude
```
To load them in every new shell, add `secrets` to `~/.zshrc.local`. That only suits a store that opens without a prompt: a store locked to a key with a passphrase would ask at every shell start.

2. **Read what `secrets` says:** `rta is not installed`, or `DOTFILES_RTA_KEYS is empty` (list the key names, without values, in `~/.config/dotfiles/secrets.env`, then `exec zsh`). `rta kv list` shows the names the store holds, never a value.

### `secrets` Fails With `kv.identity.locked`

**Problem:** `secrets`, or any `rta kv` command, asks for a passphrase and then fails with `kv.identity.locked`

**Solution:** The passphrase asked for is the one of the key that opens the store, not a passphrase of the store: for a store locked to an SSH key, it is that SSH key's passphrase, and a wrong one reports `kv.identity.locked`. Check which key rta uses: `RTA_KV_IDENTITY` names it, and without it rta looks for the key it generated, `~/.config/rta/kv.identity`:
```sh
echo "$RTA_KV_IDENTITY"
rta kv status                              # does a key available here open the store?
RTA_KV_IDENTITY=~/.ssh/<key> rta kv list   # try another key
```
Set `RTA_KV_IDENTITY` in `~/.zshrc.local` (`export RTA_KV_IDENTITY="$HOME/.ssh/<key>"`), not in `secrets.env`. `ssh-agent` cannot decrypt for rta, so the passphrase is asked on each command. See [Keeping secrets in rta](07-ai.md#keeping-secrets-in-rta-optional).

### A Command Is Missing From the History

**Problem:** A command you ran is not in `history`, in `h`, or in another terminal

**Solution:** Two kinds of lines are not written to `~/.zsh_history` (see [History](05-shell-customization.md#history)): a command typed with a leading space, and a line that assigns or passes a credential (`GITHUB_TOKEN=...`, `--password ...`, `Authorization: ...`). They stay in the history of the shell they were typed in until it exits. Check whether a line matches:
```sh
[[ 'export GITHUB_TOKEN=x' == ${~HISTORY_IGNORE} ]] && echo "not saved"
```
To save more, or less, set `HISTORY_IGNORE` in `~/.zshrc.local` (a zsh pattern; `unset HISTORY_IGNORE` saves everything except the lines with a leading space).

### Locale Warnings

**Problem:** `setlocale: LC_ALL: cannot change locale`, `perl: warning: Setting locale failed`, or `bash: warning: setlocale: LC_CTYPE: cannot change locale (en_US.UTF-8)`, often on a remote host

**Solutions:**

1. **Generate the locale** on a Debian/Ubuntu host that lacks it:
```sh
sudo sed -i 's/^# *en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sudo locale-gen
```

2. **Over ssh:** the client forwards `LANG` and `LC_*` (`SendEnv` in its ssh config), and the remote host uses them if it accepts them. `.zshrc` only sets `LANG`; an older version also exported `LC_ALL`, so open a new terminal after re-running `-d`. Check what a shell has:
```sh
locale
```

### Completions Not Working

**Problem:** Tab completion doesn't work

**Solutions:**

1. **Rebuild completion cache:**
```sh
rm -f ~/.zcompdump*
exec zsh
```

2. **Check completion system:** oh-my-zsh runs `compinit` when `.zshrc` sources it, so there is nothing to add. A completion defined before that line, for instance in a file sourced earlier, is lost. `whence -v compdef` should say it is a shell function.

3. **`tools` completes an old or empty list:** the script names are cached for a day, and for an hour after a failed download. Fetch them again on the next `<Tab>`:
```sh
rm -f ~/.cache/dotfiles/tools-scripts-*
```

### `tools` Refuses a Name

**Problem:** `Error : '<name>' is not a script name ...`, or `Error : TOOLS_REF '<ref>' is not a branch, tag or commit.`

**Solution:** `tools` takes the file name of a script in the `shell/` directory of the tools repository, with its `.sh` (`tools clone-subdir.sh`), never a path or a URL. `TOOLS_REF` takes a branch, a tag or a commit SHA: letters, digits, `.`, `_`, `-` and `/`, without `..`. Run `tools` alone to list the scripts.

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

2. **Run the server by hand** to see its error (it should start and wait for input, stop it with `Ctrl+C`). Use the version the configuration pins (`grep -n 'npx -y' setup/helpers/claude-mcp.sh`), not `@latest`:
```sh
npx -y kubernetes-mcp-server@0.0.67
```

3. **Kubernetes:** the server reads your kubeconfig:
```sh
ls -la ~/.kube/config
kubectl config current-context
```

4. **Argo CD:** it needs the server URL and an API token. VS Code asks for both the first time the server starts. For Claude Code, set `ARGOCD_BASE_URL` and `ARGOCD_API_TOKEN` in `~/.config/dotfiles/secrets.env`: the setup registers the server only when `ARGOCD_BASE_URL` is set, so re-run `setup/helpers/claude-mcp.sh` afterwards.

5. **Claude Code:** `setup/helpers/claude-mcp.sh` (the setup runs it with `-d` when `claude` is installed) registers `context7`, `kubernetes`, `playwright` and, when configured, `argocd`. Each run removes and adds again the servers it defines, at the versions pinned in the script (Renovate proposes the updates), so re-run it after such an update; servers registered under other names are left alone:
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

**Problem:** Git asks for a username and password over HTTPS

**Solutions:**

1. **GitHub: log in with gh.** For `https://github.com` and `https://gist.github.com`, the shared `~/.gitconfig` hands credentials to `gh auth git-credential`, so git uses the token of your gh login and never asks:
```sh
gh auth login
gh auth status
git config --get-urlmatch credential.helper https://github.com   # the gh helper
```
Without `gh` on the machine, git asks once and keeps the password in memory for an hour, like for other hosts.

2. **Use SSH:**
```sh
# Generate SSH key
ssh-keygen -t ed25519 -C "your@email.com"

# Add to GitHub
cat ~/.ssh/id_ed25519.pub
# Copy and add to GitHub.com → Settings → SSH Keys
```

3. **Other hosts: a persistent credential helper.** The shared `~/.gitconfig` uses `cache --timeout=3600` for them: a password stays in memory for an hour and is never written to disk. Helpers add up, so one set in `~/.gitconfig.local` is used alongside it. Prefer the system keychain to `store`, which writes passwords in clear to `~/.git-credentials`:
```sh
# macOS
git config --file ~/.gitconfig.local credential.helper osxkeychain

# Linux: libsecret (GNOME keyring), when git-credential-libsecret is built or packaged
git config --file ~/.gitconfig.local credential.helper libsecret
```

### Clone or Fetch Fails With an fsck Error

**Problem:** `git clone` or `git fetch` stops with `fatal: fsck error in packed object` or `error: object <sha>: <check>: ...` (for example `zeroPaddedFilemode`, `badTimezone`, `missingSpaceBeforeDate`)

**Solution:** The shared `~/.gitconfig` sets `transfer.fsckObjects`, so git checks every object it receives and refuses a malformed one. Some old repositories hold objects that a recent git considers malformed though they are harmless. Once you trust the repository, skip that one check (the name is the word after the SHA in the message), or the checks for this command only:
```sh
# in the repository, for that one check
git config fetch.fsck.zeroPaddedFilemode ignore
# for a clone
git clone -c fetch.fsck.zeroPaddedFilemode=ignore <url>
# every check, this command only
git -c transfer.fsckObjects=false clone <url>
```

### `unknown style 'zdiff3'`

**Problem:** `git merge`, `git rebase` or `git checkout` stops with `fatal: unknown style 'zdiff3' given for 'merge.conflictstyle'`

**Solution:** That git is older than 2.35 (Debian 11, Ubuntu 22.04). Install a newer git, or change the value in `~/.gitconfig` on that machine (it comes back with the next `-d`): git stops on the first value it reads, so an override in `~/.gitconfig.local` does not help.
```sh
git --version
git config --global merge.conflictStyle diff3
```

### `ffmerge` Refuses to Merge

**Problem:** `ffmerge` stops before pushing

**Solution:** It says why; nothing was changed. The usual cases:
- `<head> is not based on the current origin/<base>`: the base branch moved since the branch was created. Rebase, push, and wait for the checks before running it again:
```sh
git switch <head> && git fetch origin && git rebase origin/<base> && git push --force-with-lease
```
- `GitHub does not show every commit ... as verified`: sign the listed commits (`git rebase --exec 'git commit --amend --no-edit -S' origin/<base>`, then push), and check that the signing key is on your GitHub account as a signing key and that the commit email is one of your verified emails
- `checks are still running`: wait with the `gh pr checks <pr> --watch` command it prints
- `origin is ..., but PR #<n> belongs to ...`: `gh` resolved another remote (an `upstream`); run it in a clone whose `origin` is the repository of the PR

`the push was refused` happens after the checks: either `origin/<base>` moved in the meantime (run it again), or a branch rule forbids pushing to the base branch, which then has to allow you to bypass it.

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

2. **Add to PATH if missing:** the dotfiles' `.zshrc` already does it; with another `.zshrc`:
```sh
# Add to ~/.zshrc
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
exec zsh
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
# Add to ~/.zshrc.local (read after oh-my-zsh, which raises HISTSIZE to 50000)
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

5. **Check the warnings at the end:** a single item that fails (for example a broken symlink, an unreadable file, or a GPG export that could not get the key's passphrase) does not stop the run. It is listed in a final warning, the output ends with `Backup incomplete.` instead of `Backup complete.`, and the exit status is `2` (`1` means a usage error and nothing was backed up). A command chained with `&&`, such as `backup ... && rclone sync ...`, therefore does not sync a partial backup: fix the listed items and run it again. See [Exit status](09-backup-restore.md#exit-status). The script also needs `rclone` (installed by the base profile).

6. **Run with verbose output:**
```sh
bash -x backup/backup-osx.sh -o ~/backups
```

A backup is private (mode `700`) but not encrypted: see [Backup & Restore](09-backup-restore.md#security-considerations) before copying it anywhere.

### Restore Doesn't Work

**Problem:** Files not restored correctly

**Solutions:**

1. **Verify backup integrity:** each run creates `backup_<timestamp>/` in the output directory, with `etc/`, `dotfiles/`, `home/`, `gpg/` (the exported GPG keys), `rta/` (`kv.age` and `kv.recipients`, when an rta store exists) and, on macOS, `brave/` inside. Each entry only exists when its source does. In a backup made by an earlier version of the scripts, the GPG export is under `dotfiles/.gnupg/backup/` instead of `gpg/`:
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
