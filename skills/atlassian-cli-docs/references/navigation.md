# Atlassian CLI Docs Site Navigation

## ACLI Overview

The Atlassian CLI (ACLI) is the official command-line interface for Atlassian Cloud products, enabling automation
and integration across Jira Cloud, Confluence Cloud, and other Atlassian services. ACLI is Cloud-only and does not
support Server, Data Center, or Government Cloud deployments.

**Current Version**: 1.x series (see changelog for latest)

**Supported Platforms**: macOS, Linux, Windows

## Top-Level Documentation Sites

| Section | Base URL | Contents |
| --- | --- | --- |
| **Guides Hub** | `https://developer.atlassian.com/cloud/acli/guides/` | Overview and guide index |
| **Installation** | `https://developer.atlassian.com/cloud/acli/guides/installation/` | Platform-specific install guides |
| **Getting Started** | `https://developer.atlassian.com/cloud/acli/guides/getting-started/` | First steps, authentication setup |
| **Command Reference** | `https://developer.atlassian.com/cloud/acli/reference/` | Full command index and documentation |
| **Changelog** | `https://developer.atlassian.com/cloud/acli/changelog/` | Version history and release notes |

## Guide Sections

### Guides (`/guides/`)

- `/introduction/` — What is ACLI, capabilities overview
- `/installation/` — Install on macOS, Linux, Windows
- `/getting-started/` — Authentication, first commands, API token setup
- `/troubleshooting/` — Common issues and diagnostics
- `/shell-autocompletion/` — Enable bash/zsh/fish completion
- `/command-chaining/` — Combine multiple commands
- `/output-redirection/` — Capture and process command output
- `/ci-pipeline-integration/` — Integration patterns for GitHub Actions, GitLab CI, Jenkins, etc.

### Product Reference (`/reference/`)

The command tree is organized as `/reference/[product]/[noun]/[verb]/`:

**Products**:

- `admin` — Administrative commands (auth, org management)
- `jira` — Jira-specific commands (work items, projects, boards, sprints)
- `rovodev` — Rovo Dev CLI commands

**Examples**:

- `/reference/admin/auth/login/` — Admin login command
- `/reference/jira/workitem/create/` — Create Jira work item
- `/reference/jira/board/list/` — List Jira boards

## URL Pattern Convention

ACLI docs follow these patterns:

```text
https://developer.atlassian.com/cloud/acli/guides/[topic-slug]/
https://developer.atlassian.com/cloud/acli/reference/[product]/[noun]/[verb]/
```

Examples:

- `https://developer.atlassian.com/cloud/acli/guides/installation/`
- `https://developer.atlassian.com/cloud/acli/reference/jira/workitem/create/`

## Platform & Compatibility Notes

- **Cloud-only**: ACLI requires Atlassian Cloud. Server and Data Center are not supported.
- **Government Cloud**: Not supported in Government Cloud deployments.
- **macOS**: Intel and Apple Silicon (M1/M2/M3) support
- **Linux**: x86_64 and ARM64 architectures
- **Windows**: PowerShell and cmd.exe support
