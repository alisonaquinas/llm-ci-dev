---
name: rovo-docs
description: >
  Look up Atlassian Rovo documentation at support.atlassian.com/rovo using WebFetch.
  Covers Rovo Search, Chat, and Agents features; the Rovo Dev CLI commands, MCP server
  integration, IDE support, and organizational administration.
---

# Rovo Docs Lookup

Navigate and fetch documentation from support.atlassian.com/rovo to answer questions about Atlassian Rovo (AI assistant),
Search and Chat features, AI Agents, the Rovo Dev CLI, MCP integrations, IDE support, and org administration.
This skill encodes the Rovo docs structure so the agent can construct direct links and retrieve relevant documentation.

---

## Intent Router

Load reference files for depth on specific topics:

| Topic | File | Load when... |
| --- | --- | --- |
| Site Navigation | `references/navigation.md` | Understanding the Rovo docs site structure and main feature areas |
| Quick Reference | `references/quick-reference.md` | Looking up the most frequently needed Rovo feature and CLI pages |
| Rovo Dev Reference | `references/rovo-dev-reference.md` | Configuring and using the Rovo Dev CLI, MCP servers, and IDE integrations |
| Agents & Governance | `references/agents-and-governance.md` | Finding Rovo Agents documentation, governance, and org administration |

---

## Quick Start

### Key URL Patterns

The Rovo documentation is organized around these top-level sections:

- **Resources Hub**: `https://support.atlassian.com/rovo/resources/`
- **Get to Know Rovo**: `https://support.atlassian.com/rovo/docs/get-to-know-rovo/`
- **Using Rovo**: `https://support.atlassian.com/rovo/docs/using-rovo/`
- **Rovo Dev CLI**: `https://support.atlassian.com/rovo/docs/work-with-rovo-dev/`
- **Organization Admin**: `https://support.atlassian.com/rovo/docs/manage-rovo/`
- **Community Forums**: `https://community.atlassian.com/forums/rovo`
- **Status Page**: `https://rovo.status.atlassian.com`

### How to Look Up Documentation

1. Identify the topic (Search, Chat, Agents, Rovo Dev CLI, IDE integration, org admin)
2. Start with the appropriate section URL from above
3. Use WebFetch to load the page and extract relevant details
4. When the specific page is unknown, load the quick-reference to find the most common pages
5. For Rovo Dev CLI details, consult the Rovo Dev Reference

### Common WebFetch Patterns

```text
Use WebFetch on https://support.atlassian.com/rovo/resources/ to find all Rovo resources
Use WebFetch on https://support.atlassian.com/rovo/docs/using-rovo/ to explore features
Use WebFetch on https://support.atlassian.com/rovo/docs/work-with-rovo-dev/ for Rovo Dev CLI
Use WebFetch on https://support.atlassian.com/rovo/docs/manage-rovo/ for org administration
```

---

## Notable

- **Cloud-only**: Rovo is an AI-native Cloud product and does not support Server, Data Center, or Government Cloud.
- **Atlassian AI Family**: Rovo works alongside Compass (team collaboration) and Loom (workspace insights) in Atlassian's AI product family.

---

## Related References

- Load **Site Navigation** to understand the Rovo docs structure and feature areas
- Load **Quick Reference** for the most frequently accessed Rovo pages and CLI pages
- Load **Rovo Dev Reference** for CLI command details, MCP server integration, and IDE support
- Load **Agents & Governance** for Rovo Agents documentation, creation, governance, and org administration
