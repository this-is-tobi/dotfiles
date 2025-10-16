# VS Code Configuration

This document describes the VS Code configuration included in the dotfiles and how to use it effectively.

## Overview

The dotfiles include VS Code workspace configuration located in `.vscode/` with settings for:
- GitHub Copilot integration
- Model Context Protocol (MCP) servers
- Editor preferences
- Recommended extensions

## Configuration Files

### settings.json

The main configuration file: `.vscode/settings.json`

#### GitHub Copilot Settings

**Instruction Files:**
The configuration references GitHub Copilot instruction files for AI-assisted development:

```json
{
  "github.copilot.chat.codeGeneration.instructions": [
    {
      "file": "~/.config/copilot/instructions/copilot-instructions.md"
    }
  ],
  "github.copilot.chat.commitMessageGeneration.instructions": [
    {
      "file": "~/.config/copilot/instructions/commit-message.md"
    }
  ],
  "github.copilot.chat.pullRequestDescriptionGeneration.instructions": [
    {
      "file": "~/.config/copilot/instructions/pull-request.md"
    }
  ],
  "github.copilot.chat.reviewSelection.instructions": [
    {
      "file": "~/.config/copilot/instructions/code-review.md"
    }
  ]
}
```

These instruction files provide:
- Code generation best practices
- Conventional commit message formatting
- PR description templates and guidelines
- Code review checklists and standards

**Copilot Features:**
```json
{
  "github.copilot.editor.enableAutoCompletions": true,
  "github.copilot.chat.editorAuto Fix.enabled": true,
  "github.copilot.chat.reviewAgent.enabled": true,
  "github.copilot.chat.thinkingTool.enabled": true
}
```

- **Auto-completions** - Inline code suggestions
- **Auto-fix** - Automatic issue resolution
- **Review agent** - AI code review assistance
- **Thinking tool** - Reasoning visualization

#### Terminal Command Auto-Approval

Automatically approve safe terminal commands:

```json
{
  "github.copilot.chat.terminalChatLocation": "terminal",
  "github.copilot.chat.autoApprove.commands": [
    {
      "commandPattern": "^(cat|ls|pwd|echo|cd|mkdir|touch|rm|cp|mv|grep|find|which|whoami|date|cal|history)\\s",
      "comment": "Basic file system and info commands"
    },
    {
      "commandPattern": "^git\\s+(status|log|diff|show|branch|remote|config)\\s",
      "comment": "Safe git read commands"
    },
    {
      "commandPattern": "^(kubectl|k)\\s+(get|describe|logs|explain)\\s",
      "comment": "Safe kubectl read commands"
    }
  ]
}
```

This allows Copilot to run read-only commands without confirmation while requiring approval for write operations.

### mcp.json

Model Context Protocol server configuration: `.vscode/mcp.json`

#### Configured MCP Servers

**GitHub MCP Server:**
```json
{
  "github": {
    "type": "http",
    "serverUrl": "https://mcp-github.vercel.app/mcp"
  }
}
```
Provides GitHub API integration for:
- Repository information
- Pull requests and issues
- Code search
- Actions workflows

**Context7 MCP Server:**
```json
{
  "context7": {
    "type": "sse",
    "serverUrl": "https://mcp.context7.io/sse",
    "headers": {
      "x-api-key": "${CONTEXT7_API_KEY}"
    }
  }
}
```
Provides up-to-date documentation access for libraries and frameworks.

**Requires:** `CONTEXT7_API_KEY` environment variable in `.config/dotfiles/env.sh`

**Kubernetes MCP Server:**
```json
{
  "kubernetes": {
    "type": "docker",
    "args": {
      "image": "ghcr.io/stophobia/mcp-k8s:latest",
      "volumes": [
        "/Users/tobi/.kube/config:/root/.kube/config:ro"
      ]
    }
  }
}
```
Provides Kubernetes cluster management through Docker container.

**GitKraken MCP Server:**
```json
{
  "gitkraken": {
    "type": "stdio",
    "command": "docker",
    "args": [
      "run",
      "--rm",
      "-i",
      "-v",
      "/Users/tobi/.gitkraken:/root/.gitkraken:ro",
      "gitkraken/mcp-server-gk"
    ]
  }
}
```
Provides advanced Git workflow features.

### extensions.json

Recommended VS Code extensions: `.vscode/extensions.json`

While not automatically installed, this file lists recommended extensions that complement the dotfiles:

**Typical Recommendations:**
- GitHub Copilot
- GitHub Copilot Chat
- Markdown All in One
- YAML
- Docker
- Kubernetes
- GitLens
- ESLint
- Prettier

## Using the Configuration

### Option 1: Workspace-Level (Recommended)

Copy `.vscode/` to your project root:

```sh
cp -r ~/dotfiles/dotfiles/.vscode ~/my-project/
```

**Pros:**
- Per-project customization
- Easy to version control
- No global impact

**Cons:**
- Must copy to each project
- Updates require manual sync

### Option 2: User-Level

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

**Pros:**
- Applies to all projects
- Single configuration point

**Cons:**
- Global impact
- May conflict with project settings

### Option 3: Settings Sync

Use VS Code's built-in Settings Sync feature:

1. Enable: `Settings Sync: Turn On...`
2. Select settings categories to sync
3. Sign in with GitHub
4. Settings sync across machines

## Customization

### Adding MCP Servers

To add more MCP servers, edit `.vscode/mcp.json`:

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
- `stdio` - Standard input/output
- `http` - HTTP endpoint
- `sse` - Server-Sent Events
- `docker` - Docker container

### Customizing Copilot Instructions

Edit instruction files in `~/.config/copilot/instructions/`:

```sh
# Edit commit message instructions
vim ~/.config/copilot/instructions/commit-message.md

# Edit code review instructions
vim ~/.config/copilot/instructions/code-review.md
```

Or create project-specific instructions:

```json
{
  "github.copilot.chat.codeGeneration.instructions": [
    {
      "file": "~/.config/copilot/instructions/copilot-instructions.md"
    },
    {
      "file": ".copilot/project-specific.md"
    }
  ]
}
```

### Adjusting Auto-Approve Commands

Modify or add command patterns in `settings.json`:

```json
{
  "github.copilot.chat.autoApprove.commands": [
    {
      "commandPattern": "^npm\\s+(list|ls|view|info)\\s",
      "comment": "Safe npm read commands"
    }
  ]
}
```

**Warning:** Only approve commands you trust! Write operations should require confirmation.

## Environment Variables

Some configurations require environment variables:

### Context7 API Key

Add to `.config/dotfiles/env.sh`:

```sh
export CONTEXT7_API_KEY="your_api_key_here"
```

Get your API key from [Context7](https://context7.io/).

### Kubernetes Configuration

Ensure `~/.kube/config` exists and is accessible:

```sh
# Verify config
ls -la ~/.kube/config

# Test access
kubectl cluster-info
```

### GitKraken Configuration

GitKraken settings are typically in `~/.gitkraken/`.

## Workspace vs User Settings

Understanding the hierarchy:

1. **Default Settings** - VS Code defaults
2. **User Settings** - Global settings (`~/Library/Application Support/Code/User/settings.json`)
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
- `env.sh` variables available in terminal
- oh-my-zsh plugins active in terminal
- Completions work in integrated terminal

**Copilot Instructions:**
- Reference shell script best practices
- Docker/Kubernetes guidelines
- Git workflow conventions
- Language-specific patterns

## Troubleshooting

### MCP Server Not Working

Check server status in VS Code:

1. Open Command Palette (`Cmd+Shift+P`)
2. Type "MCP: Show Server Status"
3. Review connection status

**Common issues:**
- Missing environment variables
- Docker not running (for Docker-based servers)
- Invalid API keys
- Network connectivity

### Copilot Instructions Not Applied

Verify file paths:

```sh
# Check files exist
ls ~/.config/copilot/instructions/

# Verify settings reference correct paths
code ~/.vscode/settings.json
```

**Use absolute paths** (starting with `~` or `/`) in settings.

### Terminal Auto-Approve Not Working

Ensure VS Code is up to date:

```sh
code --version
```

Feature requires VS Code 1.85+.

### Extensions Not Recommended

Verify `extensions.json` exists:

```sh
ls .vscode/extensions.json
```

VS Code will prompt to install recommendations when opening workspace.

## Best Practices

### Security
- Use environment variables for secrets
- Don't commit API keys to git
- Review auto-approve commands carefully
- Use read-only volumes for MCP servers

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
