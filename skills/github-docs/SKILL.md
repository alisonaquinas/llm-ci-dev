---
name: github-docs
description: >
  Look up GitHub and GitHub Actions documentation at docs.github.com/en using WebFetch.
  Teaches URL patterns, site navigation, and how to fetch specific docs pages.
---

# GitHub Docs Lookup

Navigate and fetch documentation from docs.github.com/en to answer questions about GitHub, GitHub Actions, Packages, Security, API, and workflows.
This skill encodes the GitHub docs structure so the agent can construct direct links and retrieve relevant documentation.

---

## Intent Router

Load reference files for depth on specific topics:

| Topic | File | Load when... |
| --- | --- | --- |
| Site Navigation | `references/navigation.md` | Understanding the docs structure and top-level sections |
| Quick Reference | `references/quick-reference.md` | Looking up the most frequently needed pages |
| Actions Reference | `references/actions-reference.md` | Configuring GitHub Actions workflows and workflow syntax |
| Troubleshooting | `references/troubleshooting.md` | Finding error-specific docs or version-specific information |

---

## Quick Start

### Key URL Patterns

The GitHub docs are organized around these top-level sections:

- **Base**: `https://docs.github.com/en`
- **Actions**: `https://docs.github.com/en/actions`
- **Workflow syntax**: `https://docs.github.com/en/actions/writing-workflows/workflow-syntax-for-github-actions`
- **Security**: `https://docs.github.com/en/actions/security-for-github-actions`
- **REST API**: `https://docs.github.com/en/rest`
- **Packages**: `https://docs.github.com/en/packages`
- **Repositories**: `https://docs.github.com/en/repositories`

### How to Look Up Documentation

1. Identify the topic (Actions, API, Packages, Repositories, Security, Codespaces)
2. Start with the appropriate section URL from above
3. Use WebFetch to load the page and extract relevant details
4. When the specific page is unknown, load the quick-reference to find the most common pages
5. For GitHub Enterprise, replace `/en` with `/en/enterprise-server@x.x` in the URL

### Common WebFetch Patterns

```text
Use WebFetch on https://docs.github.com/en/actions/writing-workflows/workflow-syntax-for-github-actions to fetch workflow syntax
Use WebFetch on https://docs.github.com/en/actions/using-workflows/workflow-events-that-trigger-workflows to look up workflow triggers
Use WebFetch on https://docs.github.com/en/rest/reference/actions to retrieve Actions API reference
Use WebFetch on https://docs.github.com/en/actions/security-for-github-actions/security-guides/automatic-token-authentication to understand token handling
```

---

## Related References

- Load **Site Navigation** to understand docs.github.com structure and version handling
- Load **Quick Reference** for the top URLs and most frequently needed documentation pages
- Load **Actions Reference** for complete workflow syntax, triggers, contexts, and best practices
- Load **Troubleshooting** when searching for error-specific docs or navigating GitHub Enterprise documentation
