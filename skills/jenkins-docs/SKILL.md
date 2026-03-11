---
name: jenkins-docs
description: >
  Look up Jenkins documentation at https://www.jenkins.io/doc/ using WebFetch.
  Teaches URL patterns, site navigation, and how to fetch specific docs pages.
---

# Jenkins Docs Lookup

Navigate and fetch documentation from <https://www.jenkins.io/doc/> to answer questions about Jenkins, Declarative Pipeline, Shared Libraries, plugins, and Blue Ocean.
This skill encodes the Jenkins docs structure so the agent can construct direct links and retrieve relevant documentation.

---

## Intent Router

Load reference files for depth on specific topics:

| Topic | File | Load when... |
| --- | --- | --- |
| Site Navigation | `references/navigation.md` | Understanding the docs structure and top-level sections |
| Quick Reference | `references/quick-reference.md` | Looking up the most frequently needed pages |
| Pipeline Reference | `references/pipeline-reference.md` | Configuring Jenkins Declarative Pipeline and pipeline syntax |
| Troubleshooting | `references/troubleshooting.md` | Finding error-specific docs or plugin-specific information |

---

## Quick Start

### Key URL Patterns

The Jenkins docs are organized around these top-level sections:

- **Base**: `https://www.jenkins.io/doc/`
- **Book (guide)**: `https://www.jenkins.io/doc/book/`
- **Pipeline syntax**: `https://www.jenkins.io/doc/book/pipeline/syntax/`
- **Shared Libraries**: `https://www.jenkins.io/doc/book/pipeline/shared-libraries/`
- **Plugin docs**: `https://plugins.jenkins.io/` (separate site, searchable by plugin name)
- **Pipeline steps reference**: `https://www.jenkins.io/doc/pipeline/steps/`
- **Best practices**: `https://www.jenkins.io/doc/book/pipeline/pipeline-best-practices/`

### How to Look Up Documentation

1. Identify the topic (Pipeline, plugins, administration, security)
2. Start with the appropriate section URL from above
3. Use WebFetch to load the page and extract relevant details
4. When looking up plugin-specific details, search plugins.jenkins.io for the plugin name
5. For pipeline steps, consult the `/doc/pipeline/steps/` reference or check individual plugin docs

```text
# Navigate to a specific plugin's documentation page
# Pattern: https://plugins.jenkins.io/<plugin-name>/
Use WebFetch on https://plugins.jenkins.io/git/ to find Git plugin documentation
```

### Common WebFetch Patterns

```text
Use WebFetch on https://www.jenkins.io/doc/book/pipeline/syntax/ to fetch the Declarative Pipeline syntax reference
Use WebFetch on https://www.jenkins.io/doc/book/pipeline/shared-libraries/ to look up Shared Libraries documentation
Use WebFetch on https://www.jenkins.io/doc/pipeline/steps/ to retrieve the complete steps reference
Use WebFetch on https://plugins.jenkins.io/<plugin-name>/ to find plugin-specific documentation
```

---

## Related References

- Load **Site Navigation** to understand jenkins.io/doc structure and sections
- Load **Quick Reference** for the most frequently needed Pipeline documentation pages
- Load **Pipeline Reference** for complete Declarative Pipeline syntax and keyword reference
- Load **Troubleshooting** when searching for error-specific docs or plugin documentation
