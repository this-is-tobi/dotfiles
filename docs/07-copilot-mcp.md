# GitHub Copilot & Model Context Protocol

This document explains the GitHub Copilot instructions and Model Context Protocol (MCP) server configuration included in this dotfiles repository.

## GitHub Copilot Instructions

### Overview

GitHub Copilot instructions are specialized markdown files that guide Copilot's behavior for specific tasks:
- **Code generation** - Language and framework best practices
- **Commit messages** - Conventional commit formatting
- **Pull request descriptions** - PR template compliance
- **Code review** - Review checklists and standards

### Installation

The setup scripts automatically clone Copilot instructions from the [tools repository](https://github.com/this-is-tobi/tools/tree/main/copilot/instructions):

**Automatic (during setup):**
```sh
# Instructions are installed automatically
./setup/setup-osx.sh
```

**Manual installation:**
```sh
curl -fsSL https://raw.githubusercontent.com/this-is-tobi/tools/main/shell/clone-subdir.sh | bash -s -- \
  -u https://github.com/this-is-tobi/tools \
  -b main \
  -s copilot/instructions \
  -o ~/.config/copilot/instructions \
  -d
```

### Instruction Files

#### copilot-instructions.md

**Purpose:** Universal development guidelines

**Location:** `~/.config/copilot/instructions/copilot-instructions.md`

**Content:**
- Shell scripting best practices (error handling, quoting, etc.)
- Docker guidelines (multi-stage builds, caching, security)
- Kubernetes patterns (resource limits, health checks, labels)
- GitHub Actions workflows (reusability, security, caching)
- JavaScript/TypeScript standards (ESM, async/await, types)
- Go conventions (error handling, naming, concurrency)
- TypeScript monorepo patterns (workspace protocols, versioning)
- Performance & monitoring (observability, optimization)

**Usage in VS Code:**
```json
{
  "github.copilot.chat.codeGeneration.instructions": [
    {"file": "~/.config/copilot/instructions/copilot-instructions.md"}
  ]
}
```

#### commit-message.md

**Purpose:** Conventional commit message generation

**Location:** `~/.config/copilot/instructions/commit-message.md`

**Content:**
- Conventional Commits v1.0.0 specification
- Commit type definitions (feat, fix, docs, etc.)
- Scope guidelines
- Breaking change handling
- Commit message examples by type
- Multi-commit scenarios
- Best practices for atomic commits

**Format enforced:**
```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

**Usage in VS Code:**
```json
{
  "github.copilot.chat.commitMessageGeneration.instructions": [
    {"file": "~/.config/copilot/instructions/commit-message.md"}
  ]
}
```

**Examples:**
```
feat(api): add user authentication endpoint

fix: resolve memory leak in cache layer

docs(readme): add installation instructions

chore(deps): upgrade dependencies to latest versions
```

#### pull-request.md

**Purpose:** PR description best practices and template compliance

**Location:** `~/.config/copilot/instructions/pull-request.md`

**Content:**
- PR description structure
- Template checking priority system
- Context extraction from commits
- Issue reference formatting
- Breaking change highlighting
- Examples for different PR types (features, fixes, refactors)

**Template priorities:**
1. `.github/pull_request_template.md` (highest)
2. `.github/PULL_REQUEST_TEMPLATE.md`
3. `docs/pull_request_template.md`
4. `docs/PULL_REQUEST_TEMPLATE.md`
5. Custom templates via comments

**Usage in VS Code:**
```json
{
  "github.copilot.chat.pullRequestDescriptionGeneration.instructions": [
    {"file": "~/.config/copilot/instructions/pull-request.md"}
  ]
}
```

#### code-review.md

**Purpose:** Expert code review guidelines

**Location:** `~/.config/copilot/instructions/code-review.md`

**Content:**
- Priority-based review system (P0: Critical → P3: Nice-to-have)
- 10 core review areas:
  - Correctness & Logic
  - Security
  - Performance
  - Code Quality
  - Testing
  - Documentation
  - Error Handling
  - Dependencies
  - Maintainability
  - Best Practices
- Language-specific checks (JS/TS, Go, Python, Rust, Java)
- Framework-specific checks (React, Next.js, etc.)
- Infrastructure checks (Docker, Kubernetes, Terraform)
- Output format templates

**Usage in VS Code:**
```json
{
  "github.copilot.chat.reviewSelection.instructions": [
    {"file": "~/.config/copilot/instructions/code-review.md"}
  ]
}
```

**Review priorities:**
- **P0 (Critical)** - Must fix before merge (security, correctness)
- **P1 (Important)** - Should fix (performance, errors)
- **P2 (Moderate)** - Consider fixing (quality, tests)
- **P3 (Minor)** - Nice to have (style, docs)

### Using Copilot Instructions

#### Generating Commit Messages

1. Stage your changes: `git add .`
2. In VS Code, use Copilot Chat: `/commit`
3. Copilot generates conventional commit message
4. Review and accept or modify

**Example:**
```
You: /commit
Copilot: feat(auth): add OAuth2 authentication support

Implements OAuth2 authentication flow with support for
Google and GitHub providers. Includes token refresh logic
and secure session management.

BREAKING CHANGE: replaces existing basic auth system
```

#### Generating PR Descriptions

1. Create PR in VS Code or web
2. Use Copilot to generate description
3. Copilot checks for templates and formats appropriately

**Example:**
```markdown
## Summary
Adds OAuth2 authentication support with Google and GitHub providers.

## Changes
- Implement OAuth2 flow
- Add token refresh mechanism
- Update authentication middleware

## Breaking Changes
⚠️ This replaces the existing basic authentication system

## Related Issues
Closes #123
```

#### Code Review

1. Select code in editor
2. Use Copilot Chat: `@workspace /review`
3. Copilot provides structured review with priorities

**Example:**
```
P0 (Critical):
- Missing input validation on user email (security)

P1 (Important):
- Database query in loop (performance)
- No error handling for API call

P2 (Moderate):
- Missing unit tests for new function
- Consider extracting magic number to constant

P3 (Minor):
- Add JSDoc comment
- Variable name could be more descriptive
```

## Model Context Protocol (MCP)

### Overview

MCP provides standardized access to external tools and data sources for AI assistants. This dotfiles includes configuration for several MCP servers.

### Configured Servers

#### GitHub MCP Server

**Type:** HTTP

**Purpose:** GitHub API integration

**Features:**
- Repository information
- Pull request and issue management
- Code search
- GitHub Actions workflows
- Organization and team data

**Configuration:**
```json
{
  "github": {
    "type": "http",
    "serverUrl": "https://mcp-github.vercel.app/mcp"
  }
}
```

**No setup required** - uses your VS Code GitHub authentication.

**Example usage:**
```
You: What's the status of PR #42?
Copilot: [uses GitHub MCP to fetch PR details]
```

#### Context7 MCP Server

**Type:** Server-Sent Events (SSE)

**Purpose:** Up-to-date library and framework documentation

**Features:**
- Documentation for thousands of libraries
- Code examples
- API references
- Best practices

**Configuration:**
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

**Setup required:**
1. Get API key from [context7.io](https://context7.io/)
2. Add to `~/.config/dotfiles/env.sh`:
```sh
export CONTEXT7_API_KEY="your_api_key_here"
```
3. Restart terminal and VS Code

**Example usage:**
```
You: How do I use React hooks?
Copilot: [uses Context7 to fetch latest React documentation]
```

#### Kubernetes MCP Server

**Type:** Docker

**Purpose:** Kubernetes cluster management

**Features:**
- Cluster information
- Resource management (pods, services, deployments)
- Logs and events
- Configuration and secrets

**Configuration:**
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

**Setup required:**
1. Docker must be running
2. `~/.kube/config` must exist and be valid
3. Cluster must be accessible

**Example usage:**
```
You: List all pods in production namespace
Copilot: [uses Kubernetes MCP to query cluster]
```

#### GitKraken MCP Server

**Type:** Standard I/O (Docker)

**Purpose:** Advanced Git workflows

**Features:**
- Git repository information
- Branch management
- Commit history
- Merge and rebase operations
- Stash management

**Configuration:**
```json
{
  "gitkraken": {
    "type": "stdio",
    "command": "docker",
    "args": [
      "run", "--rm", "-i",
      "-v", "/Users/tobi/.gitkraken:/root/.gitkraken:ro",
      "gitkraken/mcp-server-gk"
    ]
  }
}
```

**Setup required:**
1. Docker must be running
2. GitKraken settings in `~/.gitkraken/`

**Example usage:**
```
You: Show recent commits on feature branch
Copilot: [uses GitKraken MCP to access git history]
```

### Adding Custom MCP Servers

#### Finding MCP Servers

Browse available servers:
- [Awesome MCP Servers](https://github.com/punkpeye/awesome-mcp-servers)
- [MCP Registry](https://mcp-registry.org/)
- Community repositories

#### Adding a Server

1. **Edit `.vscode/mcp.json`:**

```json
{
  "my-server": {
    "type": "stdio",
    "command": "node",
    "args": ["/path/to/server.js"]
  }
}
```

2. **Server types:**

**stdio** (Standard Input/Output):
```json
{
  "type": "stdio",
  "command": "node",
  "args": ["server.js"]
}
```

**http** (HTTP Endpoint):
```json
{
  "type": "http",
  "serverUrl": "https://api.example.com/mcp"
}
```

**sse** (Server-Sent Events):
```json
{
  "type": "sse",
  "serverUrl": "https://api.example.com/sse",
  "headers": {
    "Authorization": "Bearer ${API_TOKEN}"
  }
}
```

**docker** (Docker Container):
```json
{
  "type": "docker",
  "args": {
    "image": "my-mcp-server:latest",
    "volumes": ["/host/path:/container/path:ro"]
  }
}
```

3. **Restart VS Code** to load new server

### Troubleshooting

#### Copilot Instructions Not Applied

**Check file paths:**
```sh
ls -la ~/.config/copilot/instructions/
```

**Verify VS Code settings:**
```sh
code ~/.vscode/settings.json
# Ensure paths use absolute notation starting with ~
```

**Reload instructions:**
1. Restart VS Code
2. Or reload window: `Cmd+Shift+P` → "Reload Window"

#### MCP Server Connection Failed

**Check server status:**
1. `Cmd+Shift+P` → "MCP: Show Server Status"
2. Review error messages

**Common issues:**

**Missing environment variables:**
```sh
# Verify in terminal
echo $CONTEXT7_API_KEY

# Add to env.sh if missing
vim ~/.config/dotfiles/env.sh
```

**Docker not running:**
```sh
# Start Docker Desktop
open -a Docker

# Verify
docker ps
```

**Invalid Kubernetes config:**
```sh
# Test cluster access
kubectl cluster-info

# Update config if needed
```

#### Copilot Not Using MCP Servers

**Explicitly mention the server:**
```
You: Using GitHub MCP, what's the status of PR #42?
```

**Check Copilot settings:**
- Ensure Copilot is enabled
- Verify MCP integration is active
- Check network connectivity

## Best Practices

### Instruction Files
- Keep instructions concise and actionable
- Update instructions as practices evolve
- Use project-specific instructions when needed
- Share instructions with team

### MCP Servers
- Only enable servers you actively use
- Use read-only volumes for security
- Rotate API keys regularly
- Monitor server performance
- Keep Docker images updated

### Security
- Never commit API keys to git
- Use environment variables for secrets
- Review MCP server permissions
- Use minimal necessary scopes

## Further Reading

- [GitHub Copilot Documentation](https://docs.github.com/copilot)
- [Model Context Protocol Specification](https://spec.modelcontextprotocol.io/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Tools Repository](https://github.com/this-is-tobi/tools)
