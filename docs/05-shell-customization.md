# Shell Customization

This document covers the shell customization provided by this dotfiles repository, including oh-my-zsh configuration, plugins, custom functions, and completions.

## Zsh & oh-my-zsh

### Default Shell

This setup uses **Zsh** as the default shell, configured with the [oh-my-zsh](https://ohmyz.sh/) framework for enhanced functionality and ease of customization.

### Custom Theme

A custom oh-my-zsh theme is included: [this-is-tobi.zsh-theme](../dotfiles/.oh-my-zsh/this-is-tobi.zsh-theme). `setup -d` copies it to `~/.oh-my-zsh/custom/themes/` and `.zshrc` selects it with `ZSH_THEME="this-is-tobi"`.

This theme combines:
- **bira theme** - Two-line prompt layout with git information
- **kube-ps1** - Kubernetes context display, embedded in the theme file itself (it is not an oh-my-zsh plugin and has no entry in `plugins`)

**Features:**
- Git branch indicator
- Current Kubernetes context and namespace (`kubeoff` / `kubeon` hide and show it, `kk` toggles it)
- Exit code of the last command on the right when it is not 0
- Username and hostname display (hostname in red over SSH, username in red for root)
- Current directory, with `~` for the home directory

### oh-my-zsh Plugins

The `plugins=(...)` array of [.zshrc](../dotfiles/.zshrc) activates the following plugins:

#### Development Tools
- **[git](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git)** - Git aliases and functions
- **[gitignore](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/gitignore)** - gitignore.io from command line
- **[gh](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/gh)** - GitHub CLI completion
- **[docker](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/docker)** - Docker completion and aliases
- **[docker-compose](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/docker-compose)** - Docker Compose completion and aliases
- **[direnv](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/direnv)** - direnv hook, added by `.zshrc` only when `direnv` is installed

#### Language-Specific
- **[golang](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/golang)** - Go completion and aliases
- **[node](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/node)** - Node.js documentation function
- **[npm](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/npm)** - npm completion and aliases
- **[bun](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/bun)** - Bun completion

#### DevOps & Cloud
- **[ansible](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/ansible)** - Ansible aliases
- **[argocd](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/argocd)** - Argo CD CLI completion
- **[helm](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/helm)** - Helm completion and aliases
- **[k9s](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/k9s)** - k9s completion
- **[kubectl](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/kubectl)** - kubectl completion and aliases
- **[kubectx](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/kubectx)** - `kubectx_prompt_info` function (name of the active kubectl context)
- **[kind](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/kind)** - Kind completion and aliases
- **[oc](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/oc)** - OpenShift CLI completion
- **[terraform](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/terraform)** - Terraform completion, aliases, and prompt function
- **[scw](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/scw)** - Scaleway CLI completion

#### System Utilities
- **[aliases](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/aliases)** - `als` lists the available aliases by group (needs Python)
- **[brew](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/brew)** - Homebrew aliases
- **[colored-man-pages](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/colored-man-pages)** - Colorize man pages
- **[nmap](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/nmap)** - nmap aliases
- **[rclone](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/rclone)** - rclone completion
- **[ssh](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/ssh)** - Host completion from `~/.ssh/config` and helpers for SSH keys
- **[sudo](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/sudo)** - Press ESC twice to prefix command with sudo
- **[systemadmin](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/systemadmin)** - Sysadmin aliases and functions

### Aliases

`.zshrc` defines these aliases on top of the ones the plugins bring (run `als` to list those):

| Alias                                   | Command                                                                                                           |
| --------------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| `k`, `kc`, `kn`                         | `kubectl`, `kubectx`, `kubens`                                                                                    |
| `kg`, `kd`, `kdesc`, `ke`, `kl`, `kexp` | `kubectl get`, `delete`, `describe`, `exec`, `logs`, `explain`                                                    |
| `kgpw`                                  | `watch 'kubectl get pod'`                                                                                         |
| `kgr`                                   | Pods with their CPU and memory requests and limits                                                                |
| `kcert`, `kcnpg`, `kdfpv`, `kescape`    | kubectl plugins `cert_manager`, `cnpg`, `df_pv`, `kubescape`                                                      |
| `kkrew`, `kktop`, `kkyverno`            | kubectl plugins `krew`, `ktop`, `kyverno`                                                                         |
| `kneat`, `kstern`, `kvs`                | kubectl plugins `neat`, `stern`, `view_secret`                                                                    |
| `gs`, `gsa`, `gsp`                      | `git stash`, `git stash apply`, `git stash pop`                                                                   |
| `lag`, `lad`                            | `lazygit`, `lazydocker`                                                                                           |
| `dsp`                                   | `docker system prune -a -f` (removes stopped containers, unused networks, images and build cache, without asking) |
| `eza`                                   | `eza -lag --git`                                                                                                  |
| `f`                                     | `fzf` with a `bat` preview                                                                                        |
| `h`                                     | Shell history, newest first, in `fzf`                                                                             |
| `hs`, `hsi`                             | `history \| grep` (`-i` for `hsi`)                                                                                |
| `cs`                                    | `cheat_glow`                                                                                                      |
| `img`                                   | `chafa`                                                                                                           |
| `pubip`                                 | Public IP address, through a Cloudflare DNS query                                                                 |
| `sed`                                   | `gsed`, only when GNU sed is installed (macOS ships BSD sed)                                                      |
| `bcu`                                   | Reinstall every outdated cask (only when Homebrew is found)                                                       |
| `arm`, `intel`                          | macOS only: start a login zsh under arm64 or x86_64                                                               |

## Custom Functions

Custom shell functions are defined in `.config/dotfiles/functions.sh` and provide powerful utilities.

### Available Functions

| Function     | Description                                         | Usage                            |
| ------------ | --------------------------------------------------- | -------------------------------- |
| `lsfn`       | List all functions with descriptions                | `lsfn`                           |
| `b64d`       | Decode base64 string                                | `b64d "encoded_string"`          |
| `b64e`       | Encode string to base64                             | `b64e "plain_text"`              |
| `browser`    | Start the Browsh terminal web browser (in Docker)   | `browser [-- <url>]`             |
| `cheat_glow` | View cheat sheets with Glow                         | `cheat_glow <cheatsheet>`        |
| `check_cert` | Print the certificate chain details of an HTTPS URL | `check_cert https://example.com` |
| `dks`        | Decode Kubernetes secret                            | `dks <secret_name> [namespace]`  |
| `kbp`        | Kill the process listening on a TCP port            | `kbp 8080`                       |
| `randompass` | Generate random password (24 characters by default) | `randompass [length]`            |
| `secrets`    | Load the keys in `DOTFILES_RTA_KEYS` from rta       | `secrets`                        |
| `tools`      | Execute remote utility scripts                      | `tools [script_name.sh] [args]`  |
| `timestampd` | Convert timestamp to date                           | `timestampd 1234567890`          |
| `timestampe` | Convert date to timestamp                           | `timestampe "2023-01-01"`        |
| `urld`       | URL decode string                                   | `urld "encoded%20url"`           |
| `urle`       | URL encode string                                   | `urle "plain url"`               |
| `vault-cp`   | Copy a Vault secret (`-f`: every version)           | `vault-cp [-f] <source> <dest>`  |
| `weather`    | Check weather for location (wttr.in, over HTTPS)    | `weather [location]`             |

Every function prints its own help with `-h`.

### Function Examples

#### Base64 Encoding/Decoding
```sh
# Encode
$ b64e "Hello World"
SGVsbG8gV29ybGQ=

# Decode
$ b64d "SGVsbG8gV29ybGQ="
Hello World

# A secret: no argument, the value is asked for and not echoed
$ b64e
Value (hidden):
c2VjcmV0

# From a pipe or a file, encoded byte for byte (echo adds a newline, printf does not)
$ printf '%s' "$TOKEN" | b64e
$ b64e < cert.pem
```

#### URL Encoding/Decoding
```sh
# Encode
$ urle "hello world"
hello%20world

# Decode
$ urld "hello%20world"
hello world

# Without an argument: standard input, or a hidden prompt in a terminal
$ echo "hello world" | urle
hello%20world
```

`urle` and `urld` drop the newline that ends their input, so `echo ... | urle` encodes the text only.

#### Kubernetes Secret Decoding
```sh
# Decode secret in default namespace
$ dks my-secret

# Decode secret in specific namespace
$ dks my-secret production
```

#### Certificate Checking
```sh
$ check_cert https://example.com
# Prints the certificate chain (subject, issuer, validity dates, ...)
```

The URL needs its `https://` scheme. The check does not validate the certificate (`curl -k`), so it also works for expired or self-signed ones. The response body is printed as well.

#### Port Management
```sh
# Kill (SIGKILL) the process listening on TCP port 8080
$ kbp 8080
```

Only the listening process is targeted, not the clients connected to the port (a browser, for instance). When nothing listens on the port, `kbp` says so and returns 1.

#### Password Generation
```sh
# Generate 24-character password (default)
$ randompass

# Generate 32-character password
$ randompass 32
```

The password always contains an uppercase letter, a lowercase letter, a digit and one of `=!?%~_-`, so the minimum length is 4 (shorter values are refused).

#### Timestamp Conversion
```sh
# Timestamp to human-readable date
$ timestampd 1609459200
Fri Jan  1 00:00:00 UTC 2021

# Date to timestamp (the date is read in the local time zone)
$ timestampe "2021-01-01"
1609459200
```

`timestampe` accepts `YYYY-mm-dd` or `YYYY-mm-ddTHH:MM:ss`. The sample outputs above assume a UTC time zone.

#### Vault Secrets
```sh
# Copy the latest version of a secret to another path
$ vault-cp secret/old secret/new

# Copy every version of a secret, oldest first (destroyed or deleted versions are skipped)
$ vault-cp -f secret/old secret/new
```

### The `tools` Function

The `tools` function is special - it allows executing remote utility scripts from the [tools repository](https://github.com/this-is-tobi/tools/tree/main/shell) without installing them locally.

The script is downloaded to a temporary file first and only run once the download succeeded (no `curl | bash`); the file is removed afterwards. The name has to be a plain script name: letters, digits, `.`, `_` and `-`, ending in `.sh` (anything else, such as a path, is refused before any download).

It follows the `main` branch of the tools repository, like the AI agent installer of the same repository. That repository tags its Docker image releases (`backup-v1.4.3`, ...), not the shell scripts, so there is no script release to follow: to pin what gets downloaded, set `TOOLS_REF` to a commit SHA (or any branch or tag), for one call (`TOOLS_REF=<sha> tools <script_name>.sh`) or for the session (`export TOOLS_REF=<sha>`, or in `~/.zshrc.local`). A `TOOLS_REF` that is not a plain git ref name is refused.

**Usage:**
```sh
# List all available scripts
$ tools

# View script help
$ tools <script_name>.sh -h

# Execute script
$ tools <script_name>.sh [arguments]
```

The script name includes its `.sh` extension. An unknown name prints an error and returns 1.

**Auto-completion:**
Type `tools` then press `<Tab>` to see the available scripts with their description (the arguments after the script name complete as files). The list comes from the tools repository at `TOOLS_REF` and is cached in `~/.cache/dotfiles/tools-scripts-<ref>` (under `$XDG_CACHE_HOME` when it is set) for a day, so a `<Tab>` only waits on the network (3 seconds at most) once a day. When the download fails, for example offline, the previous list is used and the next try waits an hour. Delete the cache file to fetch the list again right away.

**Examples:**
```sh
# List scripts
$ tools

# Get help for a specific script
$ tools clone-subdir.sh -h

# Execute script
$ tools clone-subdir.sh -u https://github.com/user/repo -s subdir -o output
```

### The `ffmerge` Function

`ffmerge` merges a GitHub pull request by fast-forwarding its base branch to the head of the PR, with a plain `git push`. The commits that land on the base branch are the ones of the PR, so they keep their signatures (GitHub's "Rebase and merge" re-creates them, and they are no longer signed) and the history stays linear. GitHub then marks the PR merged by itself. It works in any GitHub repository where `origin` is the repository of the PR and needs `gh` (logged in), `git` and `jq`.

```sh
ffmerge             # the PR of the current branch
ffmerge 42          # PR #42
ffmerge -n 42       # dry run: every check, then what would be done; nothing changes
ffmerge -y 42       # no confirmation prompt
ffmerge -k 42       # keep the head branch
```

It stops, without changing anything, when:
- the PR is not open, or comes from a fork
- `origin` is not the repository of the PR
- the head branch moved since GitHub reported it
- the head branch does not contain the current `origin/<base>`. It prints how to rebase it: `git rebase origin/<base>`, then `git push --force-with-lease`, and once the checks passed again, `ffmerge` again
- a commit between `origin/<base>` and the head is not verified by GitHub (its "Verified" badge: signed, with a key on the author's account). The commits are listed with the reason GitHub gives (`unsigned`, `unknown_key`, ...)
- the required checks of the PR did not pass (`gh pr checks <pr> --required`). When the base branch requires none, every check of the PR has to pass. When checks are still running, it prints `gh pr checks <pr> --watch` to wait for them

Otherwise it shows the commits and the steps, and asks for confirmation. Then:
1. `git push origin <head sha>:refs/heads/<base>`: never forced, so it is refused if `origin/<base>` moved in the meantime, and nothing else happens. A branch rule that forbids pushing to the base branch (a rule requiring pull requests, for instance) refuses it as well, unless you are allowed to bypass it
2. The open PRs whose base is the head branch are moved to `<base>` (`gh pr edit <n> --base <base>`), so that deleting the branch does not close them. Since the merged commits kept their SHAs, those PRs need no rebase
3. Once GitHub shows the PR merged, the head branch is deleted on `origin` (unless `-k`). If it does not within about 30 seconds, the branch is kept and `ffmerge` says how to delete it later
4. It prints the state of the PR (`MERGED`), and, when you are still on the head branch, how to switch back to the base branch

## CLI Completions

CLI completions come from three places:
1. **oh-my-zsh plugins** - completion shipped with the plugins listed above (kubectl, helm, docker, docker-compose, gh, npm, terraform, ...)
2. **[completions.sh](../setup/helpers/completions.sh)** - generated completion files, written to `~/.oh-my-zsh/completions`
3. **[zsh-completions](https://github.com/zsh-users/zsh-completions)** - community completions, cloned to `$ZSH_CUSTOM/plugins/zsh-completions` (`.zshrc` adds its `src` directory to `fpath` once it exists)

Both 2 and 3 are set up by `setup-osx.sh -c` / `setup-debian.sh -c`, which runs after the profiles and the dotfiles copy.

### Installed Completions

`completions.sh` only handles tools that are installed (it checks for the binary) when `-c` runs, so run `-c` again after installing a new tool. It generates a completion for:
- argo, argocd, ct (chart-testing), cheat, cobra-cli, docker, gitleaks, glow, helm, kind, kubebuilder, kustomize, kyverno
- kubectl and the kubectl plugins cnpg, kubescape, stern and view_secret, plus kubens and kubectx
- mise, ollama, operator-sdk, pnpm, trivy, velero, yq
- teleport, tbot, tctl and tsh
- cheat, through `cheat --completion zsh`

scw gets its completion from the oh-my-zsh plugin. terraform and vault complete through their own binary, set up in `.zshrc` once oh-my-zsh has loaded: their `-install-autocomplete` flags append lines to `~/.zshrc`, so `completions.sh` does not call them.

Not generated by `completions.sh`: ansible (the oh-my-zsh plugin only adds aliases) and yarn have no completion in this setup; npm, gh and docker-compose get theirs from their oh-my-zsh plugins.

### Custom Completions

`functions-completion.sh` defines the completion of the `tools` function (script names, see above), as a native zsh completion registered with `compdef` once oh-my-zsh has run `compinit`. The other functions have no custom completion.

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

`setup -d` replaces `~/.zshrc` and `~/.config/dotfiles/functions.sh` with the repository versions. When their content differs, the previous file is first saved under `~/.dotfiles-backup/<timestamp>/`, so a local edit does not survive the next run. Make lasting changes in the repository copy (`dotfiles/.zshrc`, `dotfiles/.config/dotfiles/functions.sh`) and re-run `-d`, or use the local file described under Custom Functions.

### Adding Custom Aliases

Add personal aliases to `.zshrc`, after the `source $ZSH/oh-my-zsh.sh` line:

```sh
alias myalias="command --with-flags"
alias tfa="terraform apply"
```

### Adding More Plugins

Add oh-my-zsh plugins to the `plugins=(...)` array of `.zshrc`, before `source $ZSH/oh-my-zsh.sh`:

```sh
plugins=(
  aliases
  ansible
  # ... existing plugins ...
  your-new-plugin
)
```

### Custom Functions

Add your own functions to `~/.config/dotfiles/functions.sh` (the repository copy is `dotfiles/.config/dotfiles/functions.sh`):

```sh
# Add custom function
myfunction() {
  echo "This is my custom function"
  # Your code here
}
```

`.zshrc` also sources `~/.config/dotfiles/functions-dso.sh` when that file exists. It is not part of the repository, so the setup never replaces it: use it for functions that only make sense on one machine.

### Environment Variables

Use `~/.config/dotfiles/secrets.env` for secrets and per-machine variables. It is loaded into every zsh session by `env.sh` (managed by the setup, don't edit it), is created once with mode `600` and is never overwritten:

```sh
MY_VAR=value
CONTEXT7_API_KEY=your_key
```

### Locale

`.zshrc` sets `LANG=en_US.UTF-8` and nothing else: every `LC_*` category follows it unless you set one yourself (for example `export LC_TIME=fr_FR.UTF-8` in `~/.zshrc.local` for dates). It does not set `LC_ALL`, which would override them all and which ssh forwards to the hosts you connect to.

### PATH

`.zshrc` keeps one copy of each `PATH` and `fpath` entry (`typeset -U`), so a nested shell, or the `arm`/`intel` aliases, does not stack the same directories again. A directory added in `~/.zshrc.local` with `export PATH="<dir>:$PATH"` moves to the front if it was already there.

Go programs installed with `go install` land in `~/go/bin` (`GOBIN`), which is on `PATH` and does not change with the go version that mise activates. npm global packages land in the bin directory of the node version mise activates.

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

The script names `tools` completes are cached for a day: `rm ~/.cache/dotfiles/tools-scripts-*` fetches them again on the next `<Tab>`.

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
