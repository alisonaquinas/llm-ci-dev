---
name: gitlab-docs
description: >
  Look up GitLab documentation at docs.gitlab.com using WebFetch.
  Teaches URL patterns, site navigation, and how to fetch specific docs pages.
---

# GitLab Docs Lookup

Navigate and fetch documentation from docs.gitlab.com to answer questions about GitLab features, CI/CD pipelines, runners, API, and administration.
This skill encodes the GitLab docs structure so the agent can construct direct links and retrieve relevant documentation.

---

## Intent Router

Load reference files for depth on specific topics:

| Topic | File | Load when... |
| --- | --- | --- |
| Site Navigation | `references/navigation.md` | Understanding the docs structure and top-level sections |
| Quick Reference | `references/quick-reference.md` | Looking up the most frequently needed pages |
| CI/CD Reference | `references/ci-cd-reference.md` | Configuring GitLab CI/CD pipelines and .gitlab-ci.yml |
| Troubleshooting | `references/troubleshooting.md` | Finding error-specific docs or version-specific information |

---

## Quick Start

### Key URL Patterns

The GitLab docs are organized around these top-level sections:

- **Base**: `https://docs.gitlab.com/`
- **CI/CD**: `https://docs.gitlab.com/ci/`
- **Pipeline config**: `https://docs.gitlab.com/ci/yaml/`
- **Runners**: `https://docs.gitlab.com/runner/`
- **API**: `https://docs.gitlab.com/api/rest/`
- **User docs**: `https://docs.gitlab.com/user/`
- **Administration**: `https://docs.gitlab.com/administration/`

### How to Look Up Documentation

1. Identify the topic (CI/CD, runners, API, user features, admin tasks)
2. Start with the appropriate section URL from above
3. Use WebFetch to load the page and extract relevant details
4. When the specific page is unknown, load the quick-reference to find the most common pages
5. For version-specific docs, append `/17.x/` (current version) to the base URL if needed

### Common WebFetch Patterns

```text
Use WebFetch on https://docs.gitlab.com/ci/yaml/ to fetch the .gitlab-ci.yml reference
Use WebFetch on https://docs.gitlab.com/ci/variables/ to look up predefined variables
Use WebFetch on https://docs.gitlab.com/runner/install/ to find runner installation guides
Use WebFetch on https://docs.gitlab.com/api/rest/users.html to retrieve API endpoint docs
```

---

## Related References

- Load **Site Navigation** to understand docs.gitlab.com structure and version handling
- Load **Quick Reference** for the top 30 most frequently needed documentation pages
- Load **CI/CD Reference** for complete .gitlab-ci.yml configuration and pipeline patterns
- Load **Troubleshooting** when searching for error-specific docs or navigating version-specific pages
