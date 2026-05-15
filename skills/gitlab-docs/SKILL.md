---
name: gitlab-docs
description: >
  Use this skill to look up GitLab documentation at docs.gitlab.com using
  WebFetch. Trigger when the user asks about GitLab CI/CD pipelines and
  .gitlab-ci.yml syntax, `rules:` / `needs:` / `extends:` / `trigger:`,
  CI/CD components and `spec:inputs:`, CI job tokens and fine-grained
  permissions, runners and executors (Docker, Kubernetes, Shell) and
  autoscaling, GitLab Duo / Duo Agent Platform / Duo Chat / Duo Code Review,
  container registry hardening and immutable tags, REST or GraphQL API,
  merge requests and approvals, protected branches, SAST / DAST / dependency
  scanning, administration topics, or GitLab self-managed vs SaaS differences.
  Also trigger for questions like "where is the GitLab doc for X", "find
  the docs.gitlab.com page on Y", or any request to look something up in
  GitLab's official documentation.
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
| Duo & AI | `references/duo-and-ai.md` | Looking up GitLab Duo, Duo Agent Platform, Duo Chat, or AI-driven SDLC features |
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
5. For version-specific docs, insert `/<version>/` (e.g. the GitLab release number running on the target instance) between the base URL and the path. The canonical list of currently supported releases and end-of-life dates is at `https://docs.gitlab.com/ee/policy/maintenance.html`; docs.gitlab.com without a version segment defaults to the current stable release.

```text
# Navigate to a specific CI/CD keyword by constructing its URL
# Pattern: https://docs.gitlab.com/ci/yaml/#<keyword>
Use WebFetch on https://docs.gitlab.com/ci/yaml/ to browse all .gitlab-ci.yml keywords
```

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
- Load **Duo & AI** for GitLab Duo, Duo Agent Platform, Code Suggestions, Duo Chat, and SDLC trends
- Load **Troubleshooting** when searching for error-specific docs or navigating version-specific pages
