# Rovo Dev Reference

Comprehensive guide to Rovo Dev CLI, MCP server integration, and IDE support.

## Rovo Dev Overview

Rovo Dev is the CLI interface for Rovo, enabling automation, code review, and IDE integration.

**Documentation Hub**: `https://support.atlassian.com/rovo/docs/work-with-rovo-dev/`

## Installation

| Platform | Installation | URL |
| --- | --- | --- |
| macOS (Intel/Apple Silicon) | Homebrew or binary | `https://support.atlassian.com/rovo/docs/install-rovo-dev/` |
| Linux (x86_64/ARM64) | Package manager or binary | `https://support.atlassian.com/rovo/docs/install-rovo-dev/` |
| Windows | Installer or Scoop/Chocolatey | `https://support.atlassian.com/rovo/docs/install-rovo-dev/` |
| Docker | Docker image | `https://support.atlassian.com/rovo/docs/install-rovo-dev/` |

## CLI Commands

| Command Group | Commands | URL |
| --- | --- | --- |
| Authentication | `auth login`, `auth logout`, `auth whoami` | `https://support.atlassian.com/rovo/docs/rovo-dev-cli-reference/` |
| Sessions | `session create`, `session list`, `session delete` | `https://support.atlassian.com/rovo/docs/rovo-dev-sessions/` |
| Memory | `memory add`, `memory list`, `memory clear`, `memory forget` | `https://support.atlassian.com/rovo/docs/rovo-dev-memory/` |
| Prompts | `prompt run`, `prompt list`, `prompt create`, `prompt share` | `https://support.atlassian.com/rovo/docs/rovo-dev-cli-reference/` |
| Tools | `tool list`, `tool execute` | `https://support.atlassian.com/rovo/docs/rovo-dev-cli-reference/` |
| Subagents | `subagent list`, `subagent invoke` | `https://support.atlassian.com/rovo/docs/rovo-dev-cli-reference/` |
| MCP Servers | `mcp add`, `mcp list`, `mcp remove`, `mcp connect` | `https://support.atlassian.com/rovo/docs/rovo-dev-mcp-servers/` |
| Settings | `settings view`, `settings update` | `https://support.atlassian.com/rovo/docs/rovo-dev-cli-reference/` |

## Sessions & Memory

| Concept | Purpose | URL |
| --- | --- | --- |
| Sessions | Stateful agent interactions with memory and context | `https://support.atlassian.com/rovo/docs/rovo-dev-sessions/` |
| Memory | Persistent knowledge base for agent sessions | `https://support.atlassian.com/rovo/docs/rovo-dev-memory/` |
| Memory types | Facts, instructions, context, feedback | `https://support.atlassian.com/rovo/docs/rovo-dev-memory/` |
| Adding facts | Store information for agent recall | `https://support.atlassian.com/rovo/docs/rovo-dev-memory/` |
| Clearing memory | Reset session context | `https://support.atlassian.com/rovo/docs/rovo-dev-memory/` |

## MCP Server Integration

| Topic | Purpose | URL |
| --- | --- | --- |
| What is MCP | Model Context Protocol overview | `https://support.atlassian.com/rovo/docs/rovo-dev-mcp-servers/` |
| Adding MCP servers | Connect protocol servers to Rovo Dev | `https://support.atlassian.com/rovo/docs/rovo-dev-mcp-servers/` |
| Supported servers | Available MCP server implementations | `https://support.atlassian.com/rovo/docs/rovo-dev-mcp-servers/` |
| MCP marketplace | Community MCP server collection | `https://support.atlassian.com/rovo/docs/rovo-dev-mcp-servers/` |
| Creating MCP servers | Build custom MCP servers | `https://support.atlassian.com/rovo/docs/rovo-dev-mcp-servers/` |

## IDE Integration

### VS Code

| Feature | Details | URL |
| --- | --- | --- |
| Extension install | Install Rovo extension from marketplace | `https://support.atlassian.com/rovo/docs/rovo-dev-vscode/` |
| Settings | Configure Rovo in VS Code settings | `https://support.atlassian.com/rovo/docs/rovo-dev-vscode/` |
| Chat in editor | Use Rovo chat in VS Code | `https://support.atlassian.com/rovo/docs/rovo-dev-vscode/` |
| Code review | AI-powered code review in editor | `https://support.atlassian.com/rovo/docs/rovo-dev-vscode/` |
| Keyboard shortcuts | VS Code Rovo keybindings | `https://support.atlassian.com/rovo/docs/rovo-dev-vscode/` |

### Cursor

| Feature | Details | URL |
| --- | --- | --- |
| Setup | Configure Rovo in Cursor | `https://support.atlassian.com/rovo/docs/rovo-dev-cursor/` |
| Chat | Use Rovo chat in Cursor | `https://support.atlassian.com/rovo/docs/rovo-dev-cursor/` |
| Code completion | Rovo code suggestions | `https://support.atlassian.com/rovo/docs/rovo-dev-cursor/` |

### JetBrains IDEs

| Feature | Details | URL |
| --- | --- | --- |
| Plugin setup | Install Rovo plugin | `https://support.atlassian.com/rovo/docs/rovo-dev-jetbrains/` |
| Integration | Use Rovo in IntelliJ, PyCharm, etc. | `https://support.atlassian.com/rovo/docs/rovo-dev-jetbrains/` |

## Bitbucket Pipelines Integration

| Use Case | Details | URL |
| --- | --- | --- |
| Automated reviews | Run Rovo code reviews in pipelines | `https://support.atlassian.com/rovo/docs/rovo-dev-bitbucket-pipelines/` |
| Automation actions | Trigger automation on pipeline events | `https://support.atlassian.com/rovo/docs/rovo-dev-bitbucket-pipelines/` |
| Notifications | Get Rovo insights in pull requests | `https://support.atlassian.com/rovo/docs/rovo-dev-bitbucket-pipelines/` |

## Jira Integration

| Use Case | Details | URL |
| --- | --- | --- |
| Issue tracking | Link Rovo work to Jira issues | `https://support.atlassian.com/rovo/docs/rovo-dev-jira-integration/` |
| Workflow automation | Automate issue transitions | `https://support.atlassian.com/rovo/docs/rovo-dev-jira-integration/` |
| Release notes | Generate release notes from Jira | `https://support.atlassian.com/rovo/docs/rovo-dev-jira-integration/` |

## Code Review Automation

| Feature | Details | URL |
| --- | --- | --- |
| Automated reviews | Run AI code reviews | `https://support.atlassian.com/rovo/docs/rovo-dev-code-reviews/` |
| Review templates | Custom review guidelines | `https://support.atlassian.com/rovo/docs/rovo-dev-code-reviews/` |
| Integration | Code review in Bitbucket, GitHub | `https://support.atlassian.com/rovo/docs/rovo-dev-code-reviews/` |

## Automations Builder

| Feature | Details | URL |
| --- | --- | --- |
| Automations overview | Visual automation creation | `https://support.atlassian.com/rovo/docs/rovo-automations/` |
| Triggers | Automation start conditions | `https://support.atlassian.com/rovo/docs/rovo-automations/` |
| Actions | Automation execution steps | `https://support.atlassian.com/rovo/docs/rovo-automations/` |
| Testing | Test automation rules | `https://support.atlassian.com/rovo/docs/rovo-automations/` |
