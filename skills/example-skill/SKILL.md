---
name: example-skill
description: >
  This is an example/template skill demonstrating the SKILL.md format.
  Use this as a reference when creating new CI/CD skills. Trigger this skill when
  you need to understand the skill development process.
---

# Example CI/CD Skill

This is a template skill demonstrating the structure and format used by all skills in this collection.

---

## Intent Router

Load reference files for depth on specific topics:

| Topic | File | Load when... |
| --- | --- | --- |
| Setup & Installation | `references/install-and-setup.md` | User needs to install or configure |
| Quick Reference | `references/quick-reference.md` | User needs a quick cheatsheet |
| Advanced Usage | `references/advanced-usage.md` | User needs in-depth explanation |
| Troubleshooting | `references/troubleshooting.md` | User is debugging an issue |

---

## Quick Start

This section provides ~80% of what users need for common tasks.

### Basic Workflow

1. **Step One** — Brief description of the first action
2. **Step Two** — Brief description of the second action
3. **Step Three** — Brief description of the third action

For more details, load the relevant reference file from the Intent Router above.

---

## Example Commands

```bash
# Comment explaining what this does
example-command --option value
```

---

## When to Load References

- Load **Setup & Installation** if the user needs to install or configure the tool
- Load **Quick Reference** for common tasks and syntax
- Load **Advanced Usage** for complex workflows or troubleshooting
- Load **Troubleshooting** if the user is debugging an error

---

## Key Concepts

**Platform-agnostic language:** Use "the agent" instead of "Claude" or "Codex" when discussing
the agent tool's capabilities.

**Cross-compatibility:** All skills work identically in both Claude Code and Codex without
modification, thanks to the shared `SKILL.md` format and complementary `agents/` metadata.

---

## Summary

This template demonstrates:

- YAML frontmatter with `name` and `description` only
- Intent Router for reference file selection
- Quick reference section for ~80% of use cases
- Platform-agnostic language throughout
- Link to related reference files

Use this as a starting point for new CI/CD skills!
