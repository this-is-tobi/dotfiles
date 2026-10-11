#!/bin/bash

# Register the Claude Code MCP servers at user scope.
#
# Secrets never land in ~/.claude.json: header and env values are stored as
# ${VAR} references, single-quoted so the shell does not expand them here, and
# Claude Code expands them from its own environment at launch (export them from
# ~/.config/dotfiles/secrets.env).
#
# The servers below belong to this script: each one is removed and added again on
# every run, so the entry always runs the version pinned here (npx starts the
# package with your kube credentials or an API token, so it is never @latest;
# Renovate proposes the bumps) and a value once written in plain text is replaced
# by its ${VAR} reference. Servers registered under other names are left alone.

set -eo pipefail

# Colorize terminal
red='\e[0;31m'
no_color='\033[0m'

SECRETS_FILE="$HOME/.config/dotfiles/secrets.env"

# Optional: the ArgoCD server is only registered once ARGOCD_BASE_URL is set
if [ -r "$SECRETS_FILE" ]; then
  set -a
  # shellcheck disable=SC1090
  . "$SECRETS_FILE"
  set +a
fi

printf "\n${red}[mcp] =>${no_color} Register Claude Code MCP servers\n\n"

# shellcheck disable=SC2016 # the ${...} references must reach Claude Code unexpanded
{
  claude mcp remove context7 -s user >/dev/null 2>&1 || true
  claude mcp add --transport http context7 https://mcp.context7.com/mcp -H 'CONTEXT7_API_KEY: ${CONTEXT7_API_KEY}' -s user

  claude mcp remove kubernetes -s user >/dev/null 2>&1 || true
  claude mcp add kubernetes -s user -- npx -y kubernetes-mcp-server@0.0.67

  claude mcp remove playwright -s user >/dev/null 2>&1 || true
  claude mcp add playwright -s user -- npx -y @playwright/mcp@0.0.83

  if [ -n "${ARGOCD_BASE_URL:-}" ]; then
    claude mcp remove argocd -s user >/dev/null 2>&1 || true
    claude mcp add argocd -s user -e ARGOCD_BASE_URL='${ARGOCD_BASE_URL}' -e ARGOCD_API_TOKEN='${ARGOCD_API_TOKEN}' -- npx -y argocd-mcp@0.9.0 stdio
  else
    printf "Skipping argocd: set ARGOCD_BASE_URL in %s and re-run to register it\n" "$SECRETS_FILE"
  fi
}
