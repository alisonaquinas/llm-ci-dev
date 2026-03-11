---
name: atlassian-cli-docs
description: >
  Look up Atlassian CLI (ACLI) documentation at developer.atlassian.com/cloud/acli
  using WebFetch. Covers CLI installation, the full command reference for admin, jira,
  and rovodev subcommands, CI pipeline integration, and shell autocompletion.
---

# Atlassian CLI Docs Lookup

Navigate and fetch documentation from developer.atlassian.com/cloud/acli to answer questions about the Atlassian CLI
(ACLI), command installation, all available commands, CI/CD pipeline integration, and shell autocompletion.
This skill encodes the ACLI docs structure so the agent can construct direct links and retrieve relevant documentation.

---

## Intent Router

Load reference files for depth on specific topics:

| Topic | File | Load when... |
| --- | --- | --- |
| Site Navigation | `references/navigation.md` | Understanding the ACLI docs site structure and available guide sections |
| Quick Reference | `references/quick-reference.md` | Looking up the most frequently needed ACLI command pages |
| Command Reference | `references/command-reference.md` | Configuring and using admin, jira, and rovodev subcommands |
| CI Integration | `references/ci-integration.md` | Integrating ACLI into CI pipelines, command chaining, and output redirection |

---

## Quick Start

### Key URL Patterns

The ACLI documentation is organized around these top-level sections:

- **Guides Hub**: `https://developer.atlassian.com/cloud/acli/guides/`
- **Installation**: `https://developer.atlassian.com/cloud/acli/guides/installation/`
- **Getting Started**: `https://developer.atlassian.com/cloud/acli/guides/getting-started/`
- **Command Reference**: `https://developer.atlassian.com/cloud/acli/reference/`
- **CI Pipeline Integration**: `https://developer.atlassian.com/cloud/acli/guides/ci-pipeline-integration/`
- **Changelog**: `https://developer.atlassian.com/cloud/acli/changelog/`

### How to Look Up Documentation

1. Identify the topic (guides, installation, jira commands, admin commands, CI integration)
2. Start with the appropriate section URL from above
3. Use WebFetch to load the page and extract relevant details
4. When the specific page is unknown, load the quick-reference to find the most common pages
5. For CI pipeline patterns, consult the CI Integration reference

```text
# Navigate to a specific command page by constructing its URL
# Pattern: https://developer.atlassian.com/cloud/acli/reference/<subcommand>/<action>/
# Example: look up how to create a Jira work item
Use WebFetch on https://developer.atlassian.com/cloud/acli/reference/jira/workitem/create/
```

### Common WebFetch Patterns

```text
Use WebFetch on https://developer.atlassian.com/cloud/acli/guides/ to find all guides
Use WebFetch on https://developer.atlassian.com/cloud/acli/reference/ to browse all commands
Use WebFetch on https://developer.atlassian.com/cloud/acli/reference/jira/workitem/create/ for command details
Use WebFetch on https://developer.atlassian.com/cloud/acli/guides/ci-pipeline-integration/ for CI patterns
```

---

## Notable

- **Cloud-only**: ACLI works exclusively with Jira Cloud. Server and Data Center are not supported.
- **Government Cloud**: ACLI does not support Atlassian Government Cloud.

---

## Related References

- Load **Site Navigation** to understand the ACLI docs site structure and available sections
- Load **Quick Reference** for the top commands and most frequently accessed pages
- Load **Command Reference** for the complete admin, jira, and rovodev command trees
- Load **CI Integration** for pipeline patterns, command chaining, and CI-specific auth
