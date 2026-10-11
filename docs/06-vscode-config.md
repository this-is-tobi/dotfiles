# VS Code Configuration

This document describes the VS Code configuration included in the dotfiles and how to use it effectively.

## Overview

The dotfiles include a VS Code user configuration located in `dotfiles/.vscode/` with settings for:
- Editor preferences
- GitHub Copilot integration
- Model Context Protocol (MCP) servers
- Recommended extensions

When the setup copies the dotfiles (`-d`) and the `code` command is on the `PATH`, it:
- merges `settings.json` into (deleting the settings listed in the optional `.vscode/settings-retired.json` first), and copies `mcp.json` to, the VS Code user directory (`~/Library/Application Support/Code/User/` on macOS, `~/.config/Code/User/` on Debian; on Debian `~/.local/share/code-server/User/` is filled as well when `code-server` is installed). A file whose content differs is first saved under `~/.dotfiles-backup/<timestamp>/`
- replaces the `__HOME__` placeholder of `settings.json` with your home directory (used by `eslint.nodePath`)
- installs the extensions listed in `extensions.json` that are not installed yet (`code --list-extensions` is read once, then `code --install-extension` runs for each missing one); one that fails prints a warning and the setup goes on with the next

## Configuration Files

### settings.json

The main configuration file: `dotfiles/.vscode/settings.json` (JSON with comments)

#### Editor Preferences

- **Appearance** - GitHub Light/Dark Default themes following the OS color scheme, Material Icon Theme, Input Mono / Fira Code editor font with ligatures, Hack Nerd Font Mono in the terminal, minimap off, word wrap on, 2-space tabs
- **Privacy** - `telemetry.telemetryLevel` and `redhat.telemetry.enabled` off
- **ESLint** - `source.fixAll.eslint` runs on explicit save, ESLint is the default formatter for TypeScript, JavaScript and HTML, and `eslint.nodePath` points at the shared fallback in `~/.config/eslint-fallback` so projects without ESLint of their own still get linted (see the ESLint fallback in [Dotfiles Structure](03-dotfiles.md))
- **Other formatters** - Markdown All in One for Markdown, HashiCorp Terraform for Terraform, Red Hat YAML for YAML (`yaml.validate` is off so Helm templates are not flagged, and schema detection is disabled for CI workflow files)
- **Git** - `git.autofetch` on, and `git.addAICoAuthor` off

#### GitHub Copilot Settings

**Instruction Files:**
The configuration points Copilot at personal instruction files for AI-assisted development:

```json
{
  "chat.instructionsFilesLocations": {
    ".github/instructions": true,
    "~/.copilot/instructions": true
  },
  "chat.includeApplyingInstructions": true,
  "chat.useAgentsMdFile": true,
  "chat.useClaudeMdFile": true,
  "github.copilot.chat.commitMessageGeneration.instructions": [
    { "file": "~/.copilot/instructions/commit-message.instructions.md" }
  ],
  "github.copilot.chat.pullRequestDescriptionGeneration.instructions": [
    { "file": "~/.copilot/instructions/pull-request.instructions.md" }
  ],
  "github.copilot.chat.reviewSelection.instructions": [
    { "file": "~/.copilot/instructions/code-review.instructions.md" }
  ]
}
```

> `github.copilot.chat.codeGeneration.instructions` is deprecated and not used here. General guidance lives in `~/.copilot/instructions/general.instructions.md`, a regular instruction file that VS Code loads on its own.

These instruction files provide:
- General development guidance (`general.instructions.md`, installed by the setup)
- Conventional commit message formatting (`commit-message.instructions.md`)
- PR description templates and guidelines (`pull-request.instructions.md`)
- Code review checklists and standards (`code-review.instructions.md`)

The setup installs only `general.instructions.md` into `~/.copilot/instructions/`. The three per-feature files referenced above are not installed, because installing them there would load them in every chat; see [GitHub Copilot Instructions](07-ai.md#github-copilot-instructions) for how to install them elsewhere and repoint the settings.

**Skills, Hooks and Agents:**
```json
{
  "chat.useAgentSkills": true,
  "chat.agentSkillsLocations": {
    ".github/skills": true,
    ".claude/skills": true,
    "~/.copilot/skills": true,
    "~/.claude/skills": true
  },
  "chat.useHooks": true,
  "chat.useClaudeHooks": true,
  "chat.hookFilesLocations": { "~/.copilot/hooks": true },
  "chat.agentFilesLocations": {
    ".github/agents": true,
    "~/.copilot/agents": true
  }
}
```

> `chat.instructionsFilesLocations`, `chat.agentSkillsLocations`, `chat.agentFilesLocations` and `chat.promptFilesLocations` are deprecated by VS Code and only read by the Local agent. The Agent Host looks in its default locations instead: `~/.copilot/instructions`, `~/.copilot/copilot-instructions.md`, `~/.claude/rules`, `~/.copilot/skills`, `~/.claude/skills`, `~/.agents/skills`, `~/.copilot/agents` and `~/.claude/agents`. The entries stay in the file for the Local agent; drop them once it is no longer used.

> `chat.useClaudeHooks` (off by default) makes VS Code read the hooks of `~/.claude/settings.json`, which include `rtk hook claude`, a hook written for Claude Code's Bash tool. Check that you want it to run in Copilot sessions too. With `chat.useClaudeMdFile` on, `~/.claude/CLAUDE.md` and `~/.copilot/copilot-instructions.md` can load the same guidance twice.

**Copilot Features:**
```json
{
  "github.copilot.chat.agent.autoFix": true,
  "github.copilot.chat.reviewAgent.enabled": true,
  "github.copilot.chat.backgroundAgent.enabled": true,
  "github.copilot.chat.languageContext.fix.typescript.enabled": true,
  "github.copilot.chat.languageContext.inline.typescript.enabled": true,
  "github.copilot.chat.languageContext.typescript.enabled": true,
  "github.copilot.nextEditSuggestions.enabled": true,
  "github.copilot.editor.enableCodeActions": false,
  "chat.agent.maxRequests": 100
}
```

- **Auto-fix** - the agent fixes the diagnostics (errors, warnings) of the files it edited
- **Review agent** - AI code review assistance
- **Background agent** - the Copilot CLI entry of the "Continue In" menus
- **TypeScript language context** - extra TypeScript context for chat, inline chat and fixes
- **Next edit suggestions** - suggests the next edit as you type
- **Code actions** - Copilot commands are not shown as editor Code Actions
- **Max requests** - the agent asks for confirmation once a turn reaches 100 requests

`github.copilot.enable` activates Copilot for every language except `plaintext` and the source control input box (`scminput`).

#### Tool Auto-Approval and Sandbox

The agent asks before running a terminal command, editing a file or fetching a URL. The file relaxes this for safe cases only, and adds an OS sandbox around the terminal:

```jsonc
{
  "chat.agent.sandbox.enabled": "on",
  "chat.tools.global.autoApprove": false,
  "chat.tools.terminal.autoApprove": {
    "git status": true,
    "/^kubectl\\s+(get|describe|logs|top|...)(?=\\s|$)/": true,
    "/^kubectl\\b.*['\"\\\\$*?[]/": false,
    "/^kubectl\\b(?=.*(\\bsecrets?\\b|...))(?=.*\\s(-[a-z]*o(=|\\s+)?|--output(=|\\s+))(?![\\s=]|(name|wide)(\\s|$))|...)/i": false,
    "/\\$\\{?[A-Za-z0-9_]*(TOKEN|SECRET|PASSWORD|API_?KEY|...)/i": { "approve": false, "matchCommandLine": true },
    "rm": false,
    "curl": false
    // ... see the file for the complete list
  },
  "chat.tools.edits.autoApprove": {
    "**/*": true,
    "**/.git/**": false,
    "**/.github/workflows/**": false
    // ...
  },
  "chat.tools.urls.autoApprove": { "https://artifacthub.io": true }
}
```

**The sandbox is the boundary.** VS Code states that the approval rules only read the command text, and that aliases, quote concatenation or subshells can slip past them. `chat.agent.sandbox.enabled` (macOS and Linux, default `off`, a preview feature) runs the agent's terminal commands in an OS sandbox; one the sandbox blocks can still be run outside it after you confirm (`chat.agent.sandbox.allowUnsandboxedCommands`), and network access stays open unless you restrict it. The approval rules below are a convenience on top, so they are written to name what a command can reach, not only what it is called.

How `chat.tools.terminal.autoApprove` reads:
- A key is a command name or, between slashes, a regular expression. `true` approves without asking, `false` always asks, and a `false` rule wins. The object form `{ "approve": false, "matchCommandLine": true }` matches the whole command line instead of a single command
- **VS Code's own rules already approve read-only commands** (`ls`, `cat`, `head`, `tail`, `grep`, `find`, `sed`, `tree`, `date`, read-only `git`, `docker`, `npm`, `yarn` and `pnpm` subcommands) and already ask for `rm`, `curl`, `wget`, `chmod`, `chown`, `jq`, `xargs` and `eval`. The file only adds what differs
- **Added as read-only**: `awk`, `jq`, `yq`, `sort`, `diff`, system information (`uname`, `whoami`, `id`, `lsof`, ...), network lookups (`ping`, `dig`, `host`, ...), `git status|log|show|diff` (`--output`, which writes a file, asks), `yamllint`
- **Allow lists instead of a whole tool**: `kubectl get|describe|logs|top|events|...`, `helm list|status|template|show|...` and `go build|test|vet|list|...` run by themselves; `kubectl exec|delete|apply|...`, `helm install|get values|env|...`, `go run|get|install` ask. A verb must be a whole word, so a plugin named after one (`kubectl get-all`, `helm list-x`) asks. `helm env` asks because it prints `HELM_KUBETOKEN` when that is set
- **kubectl never prints a secret's value**: a command that names `secret`/`secrets` (also `secret/x`, `cm,secret`, `Secret`), or reads its objects from files (`-f`, `-k`, which can hold a Secret), asks as soon as it has an output format other than `name` or `wide`, in any spelling: `-o yaml`, `-oyaml`, `-o=json`, `-Ao json`, `--output=jsonpath=...`, `custom-columns`, `go-template-file`, `jsonpath-file`, `--template`. A kubectl command containing a quote, a backslash, a `$` or a glob character asks as well, since those can spell `secret` or `-o` in a way the rule does not see (`sec''ret`, `-"o"`, `$KIND`). `kubectl get secrets`, `-o name` and `describe secret` (sizes only) still run by themselves
- **kubectl and helm stay on your own cluster**: `--raw`, `cluster-info dump`, another `--kubeconfig` (its exec plugin runs a command) and another API server (`--server`/`-s`, `--kube-apiserver` for helm, which would receive your credentials) ask. So does `helm status -o json|yaml`, which prints the whole release with its values and rendered Secrets, and `helm template --post-renderer`, which runs a program
- **go builds without running other programs**: `-toolexec`, `-vettool`, `-exec`, an external linker (`-ldflags=-extld=...`) and `go env -w|-u` (it changes what every later go command runs) ask
- **Guards on what a tool can reach**: `awk` cannot call the shell, read files or the environment, and takes no option but `-F` and `-v` (gawk's `-i inplace`, `-l`, `-o`, `-p`, `-d` load or write files); `jq` and `yq` cannot read the environment or other files (`jq -f` and `-L` also when grouped as `-nf`, `yq ... | envsubst`); `yq -i`, `yq -s` (a file per result), `sed -i` and `sort -o` ask in every spelling (`-Pi`, `-ni`, `-uo`, `--in-place`, `--output`). `timeout` always asks, as it runs whatever it is given
- **Grouped and long options count**: short options can be grouped (`-nf` is `-n -f`) and long ones written `--opt=value`, so the guards match every spelling, not only the separate one. For `git`, `helm`, `go`, `sort`, `sed`, `find`, `awk`, `jq` and `yq`, a word split by quotes or a backslash (`--out''put`, `ENV""IRON`) asks, and so does an option written inside quotes (`"--output=x"`), except for `go`, where `-ldflags "-s -w"` is common
- **Secrets**: a command line that names a secret file (`.env*`, `.netrc`, `.npmrc`, `.pypirc`, `.git-credentials`, `.vault-token`, `~/.claude.json`, `~/.ssh`, `~/.aws`, `~/.gnupg`, `~/.kube`, `~/.docker/config.json`, `~/.config/gh/hosts.yml`, `~/.config/argocd`, rta's `kv.identity`, `secrets.env`, a `secrets/` directory, `id_rsa`-style keys, `*.pem`, `*.key`, `*.p12`, `*.pfx`, `/proc/*/environ`) or a variable that looks like one (`$GITHUB_TOKEN`, `${ARGOCD_API_TOKEN}`, ...) always asks, whatever follows the name (`cat .env;`, `cat <.env`, `cat .env*`). This matters because `secrets.env` is loaded into every shell, so a plain `echo $TOKEN` would otherwise run without asking
- **Injection guards**: a command line containing `(...)`, `{...}` or backticks always asks, which also makes any `awk` program with an action ask
- **Changed rules are retired**: when a rule changes, its previous text is listed in `settings-retired.json`, so a re-run of the setup removes it from your settings instead of leaving the old, weaker rule next to the new one
- **Always asks**: `rm`, `dd`, `kill`, `ps`, `top`, remote access (`ssh`, `scp`, `sftp`, `rsync`, `nc`, `socat`, ...), `curl`, `wget`, `chmod`, `chown`, `sudo`, `su`, `eval`, `xargs`

`chat.tools.global.autoApprove` stays `false`, so there is no "approve everything" switch. `chat.tools.edits.autoApprove` approves edits everywhere except what runs by itself later or steers the next agent session: `.vscode/*.json`, `.git/**`, `.env*`, package manifests and lock files, `.github/workflows`, `.github/{actions,instructions,agents,skills,hooks}`, `copilot-instructions.md`, `AGENTS.md`, `CLAUDE.md`, `.claude/**`, `.husky`, `.devcontainer`, `.mcp.json`, `.envrc`, `mise.toml`, `.pre-commit-config.yaml`, keys (`*.pem`, `*.key`) and `secrets/**`. `chat.tools.urls.autoApprove` only trusts `artifacthub.io`.

**Review the diff.** Whatever is auto-approved, read the changes in the diff editor before you commit. A prompt injection in a file, a web page or a tool output can steer the agent, and stopping a request does not undo a command that already ran.

**Not set on purpose:** `security.workspace.trust.untrustedFiles` is left at VS Code's `prompt`, workspace trust stays on (restricted mode disables the agent in a folder you have not trusted, and the MCP servers of that folder with it), and the telemetry of the extensions that do not follow VS Code's own level is turned off where they offer a setting (`sonarlint.disableTelemetry`). Continue's telemetry moved to its own settings page, so switch it off there.

#### MCP Settings

`chat.mcp.autostart` is `newAndOutdated`: MCP servers start automatically when they are new or their configuration changed. `chat.mcp.gallery.enabled` is on.

### mcp.json

Model Context Protocol server configuration: `dotfiles/.vscode/mcp.json`, installed as `mcp.json` in the VS Code user directory

#### Configured MCP Servers

**GitHub MCP Server:**
```json
{
  "github": {
    "type": "http",
    "url": "https://api.githubcopilot.com/mcp/"
  }
}
```
Provides GitHub API integration for:
- Repository information
- Pull requests and issues
- Code search
- Actions workflows

Uses your VS Code GitHub session, no key needed.

**Context7 MCP Server:**
```json
{
  "context7": {
    "type": "http",
    "url": "https://mcp.context7.com/mcp",
    "headers": {
      "CONTEXT7_API_KEY": "${input:context7-api-key}"
    }
  }
}
```
Provides up-to-date documentation access for libraries and frameworks.

**Requires:** a [Context7](https://context7.com/) API key. VS Code asks for it the first time the server starts (`context7-api-key` is a password `input` declared in `mcp.json`) and stores it securely.

**Kubernetes MCP Server:**
```json
{
  "kubernetes": {
    "type": "stdio",
    "command": "npx",
    "args": ["-y", "kubernetes-mcp-server@latest"]
  }
}
```
Provides Kubernetes cluster management (pods, resources, logs, events). It runs through `npx` and reads `~/.kube/config`.

**Argo CD MCP Server:**
```json
{
  "argocd": {
    "type": "stdio",
    "command": "npx",
    "args": ["-y", "argocd-mcp@latest", "stdio"],
    "env": {
      "ARGOCD_BASE_URL": "${input:argocd-base-url}",
      "ARGOCD_API_TOKEN": "${input:argocd-api-token}"
    }
  }
}
```
Lists, syncs and inspects Argo CD applications.

**Requires:** the Argo CD server URL and an API token. VS Code asks for both the first time the server starts (`argocd-base-url` and `argocd-api-token`, the token being a password `input`). Remove the entry if you do not use Argo CD.

**Playwright MCP Server:**
```json
{
  "microsoft/playwright-mcp": {
    "type": "stdio",
    "command": "npx",
    "args": ["-y", "@playwright/mcp@latest"]
  }
}
```
Provides browser automation (navigate, click, screenshot, fill forms). It runs through `npx`.

**Secrets (`inputs`):**
The three values above are declared in the `inputs` array of `mcp.json` as `promptString` entries (`"password": true` hides the value). A server references them with `${input:<id>}`; VS Code prompts once and stores the answer securely, so nothing has to be exported in the environment for it. See [Managing Secrets](07-ai.md#managing-secrets) for how the other tools get the same values.

### extensions.json

Recommended VS Code extensions: `dotfiles/.vscode/extensions.json`

The setup installs every extension of this list with `code --install-extension` (see [Overview](#overview)); the file also makes VS Code recommend them in a workspace that contains it. The list is grouped by comment headers:

- **AI** - Claude Code, Continue (GitHub Copilot is built into VS Code)
- **Languages and tooling** - Go, Python (with Pylance and debugpy), Vue (Volar), Prisma, Ansible, Terraform, YAML, Stylelint, PostCSS, ESLint, Prettify TS, Pretty TypeScript Errors
- **DevOps** - Docker (three extensions), Kubernetes, GitHub Actions, Remote (SSH, Containers, Explorer), Coder
- **Git** - GitLens, GitHub Pull Requests, GitLab Workflow, Git Graph, Conventional Commits
- **Markdown and documents** - Markdown All in One, Markdown Preview Enhanced, PDF viewer, Rainbow CSV
- **General** - EditorConfig, SonarLint, Version Lens, Thunder Client, Todo Tree, Playwright, Live Share, Makefile Tools, database clients
- **Themes and icons** - GitHub theme, Material Icon Theme

Edit the file to add or drop extensions before running `-d`.

## Using the Configuration

### Option 1: Setup Script (Recommended)

Run the setup with `-d` (see [Installation](02-installation.md)). It installs `settings.json`, `mcp.json` and the extensions at user level, as described in the [Overview](#overview).

### Option 2: User-Level, by Hand

Merge settings into VS Code user settings:

**On macOS:**
```sh
# User settings location
~/Library/Application Support/Code/User/settings.json
```

**On Linux:**
```sh
# User settings location
~/.config/Code/User/settings.json
```

`mcp.json` goes in the same directory (or use the `MCP: Open User Configuration` command). Replace the `__HOME__` placeholder of `eslint.nodePath` with your home directory.

**Pros:**
- Applies to all projects
- Single configuration point

**Cons:**
- Global impact
- May conflict with project settings

### Option 3: Workspace-Level

Copy `.vscode/` to your project root:

```sh
cp -r ~/dotfiles/dotfiles/.vscode ~/my-project/
```

Replace the `__HOME__` placeholder of `eslint.nodePath` first. Most chat and Copilot settings are written for the user level (they point at `~/.copilot/...`), so copy only the parts a project needs.

**Pros:**
- Per-project customization
- Easy to version control
- No global impact

**Cons:**
- Must copy to each project
- Updates require manual sync

### Option 4: Settings Sync

Use VS Code's built-in Settings Sync feature:

1. Enable: `Settings Sync: Turn On...`
2. Select settings categories to sync
3. Sign in with GitHub
4. Settings sync across machines

## Customization

### Adding MCP Servers

To add more MCP servers, edit `mcp.json` (user level: `MCP: Open User Configuration`) inside its `servers` object:

```json
{
  "my-custom-server": {
    "type": "stdio",
    "command": "node",
    "args": ["/path/to/server.js"]
  }
}
```

MCP server types:
- `stdio` - Standard input/output (a local command)
- `http` - HTTP endpoint (`url`)
- `sse` - Server-Sent Events (`url`)

For a secret, declare an `inputs` entry and reference it with `${input:<id>}` (see the `inputs` paragraph under [mcp.json](#mcpjson)) instead of writing the value in the file. See also [Adding Custom MCP Servers](07-ai.md#adding-custom-mcp-servers).

### Customizing Copilot Instructions

Edit instruction files in `~/.copilot/instructions/`:

```sh
# Edit the general instructions
vim ~/.copilot/instructions/general.instructions.md
```

Or add project-specific scoped instructions in `.github/instructions/*.instructions.md` (repo-level, takes precedence over personal).

Re-running the personal setup replaces the files it installs (the previous version is kept next to it as `<name>.bak.<timestamp>`), so put lasting personal rules in a file of your own.

### Adjusting Auto-Approve Commands

Modify or add entries in `chat.tools.terminal.autoApprove` in `settings.json`:

```json
{
  "chat.tools.terminal.autoApprove": {
    "npm ls": true,
    "/^npm\\s+(view|info)\\b/": true
  }
}
```

**Warning:** Only approve commands you trust. Prefer a regular expression that names the read-only forms (as the file does for `kubectl`) over approving a whole tool, and keep the sandbox on.

## Environment Variables

Some configurations require secrets:

### Context7 API Key

VS Code prompts for the key the first time the Context7 server starts and stores it securely, so nothing needs to be exported for it. Claude Code and the shell read the same key from `~/.config/dotfiles/secrets.env` (see [Managing Secrets](07-ai.md#managing-secrets)):

```sh
CONTEXT7_API_KEY=your_api_key_here
```

Get your API key from [Context7](https://context7.com/).

### Kubernetes Configuration

Ensure `~/.kube/config` exists and is accessible:

```sh
# Verify config
ls -la ~/.kube/config

# Test access
kubectl cluster-info
```

## Workspace vs User Settings

Understanding the hierarchy:

1. **Default Settings** - VS Code defaults
2. **User Settings** - Global settings (`~/Library/Application Support/Code/User/settings.json` on macOS, `~/.config/Code/User/settings.json` on Linux)
3. **Workspace Settings** - Project-specific (`.vscode/settings.json`)
4. **Folder Settings** - Multi-root workspace folders

**Priority:** Folder > Workspace > User > Default

## VS Code CLI

Useful VS Code command-line operations:

```sh
# Open VS Code in current directory
code .

# Open file
code file.txt

# Install extension
code --install-extension ms-vscode.vscode-typescript-next

# List installed extensions
code --list-extensions

# Compare files
code --diff file1.txt file2.txt
```

## Integration with Dotfiles

The VS Code configuration integrates with:

**Shell Functions:**
- Use `dks` function for Kubernetes secrets
- Use `tools` function for remote scripts
- All functions available in VS Code terminal

**Environment:**
- `secrets.env` variables available in terminal
- oh-my-zsh plugins active in terminal
- Completions work in integrated terminal

**Copilot Instructions:**
- Personal general guidance from `~/.copilot/instructions/general.instructions.md`
- Optional commit, pull request and review instructions (see [GitHub Copilot Instructions](07-ai.md#github-copilot-instructions))
- Skills from `~/.copilot/skills/` (code review, repository audit, commit message, pull request)

## Troubleshooting

### MCP Server Not Working

Check server status in VS Code:

1. Open Command Palette (`Cmd+Shift+P`)
2. Type "MCP: Show Server Status"
3. Review connection status

**Common issues:**
- Node.js missing (the Kubernetes, Argo CD and Playwright servers start through `npx`)
- A missing or wrong answer to an `inputs` prompt (VS Code asks once and stores the answer)
- Invalid `~/.kube/config` (Kubernetes server)
- Network connectivity

### Copilot Instructions Not Applied

Verify file paths:

```sh
# Check files exist
ls ~/.copilot/instructions/

# Open the user settings (Command Palette: "Preferences: Open User Settings (JSON)")
# and verify that the entries reference existing files
```

The `file` entries of the per-feature settings (commit message, pull request, review) point at `~/.copilot/instructions/*.instructions.md` and need those files to exist, but the setup only installs `general.instructions.md` (the others are `applyTo: "**"` and would load in every chat). Install them in another folder and repoint the settings, see [GitHub Copilot Instructions](07-ai.md#github-copilot-instructions).

### Terminal Auto-Approve Not Working

Ensure VS Code is up to date:

```sh
code --version
```

The settings of this file were checked against VS Code 1.141; an older release may not know some of the `chat.*` settings (the Settings editor flags unknown settings). Also check that `chat.tools.global.autoApprove` is not overridden at workspace level.

### Extensions Not Installed

The setup installs the extensions at the end of the VS Code step and prints a warning for each one it could not install. Install them again by hand:

```sh
code --install-extension <publisher.extension>
```

Outside the setup, VS Code also offers the recommendations of `.vscode/extensions.json` when you open a workspace that contains the file.

## Best Practices

### Security
- Use `inputs` or `secrets.env` for secrets, never a value written in a committed file
- Don't commit API keys to git
- Review auto-approve commands carefully, allow read-only forms rather than whole tools, and keep `chat.agent.sandbox.enabled` on
- Review the diff of every agent edit before committing

### Organization
- Use workspace settings for project-specific config
- Use user settings for personal preferences
- Document custom settings in project README
- Share workspace settings with team

### Performance
- Disable unused MCP servers
- Limit auto-approve patterns
- Use lite instruction files when possible
- Monitor extension CPU/memory usage
