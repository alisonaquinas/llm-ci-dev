---
name: travis-ci-docs
description: >
  Look up Travis CI documentation at docs.travis-ci.com using WebFetch.
  Teaches URL patterns, site navigation, and how to fetch specific docs pages.
---

# Travis CI Docs Lookup

Navigate and fetch documentation from docs.travis-ci.com to answer questions about Travis CI build configuration, stages, caching, environment variables, and deployment.
This skill encodes the Travis CI docs structure so the agent can construct direct links and retrieve relevant documentation.

---

## Intent Router

Load reference files for depth on specific topics:

| Topic | File | Load when... |
| --- | --- | --- |
| Site Navigation | `references/navigation.md` | Understanding the docs structure and top-level sections |
| Quick Reference | `references/quick-reference.md` | Looking up the most frequently needed .travis.yml keys |
| Build Config Reference | `references/build-config-reference.md` | Configuring builds, stages, caching, and deployment |
| Troubleshooting | `references/troubleshooting.md` | Finding error-specific docs or common issues |

---

## Quick Start

### Key URL Patterns

The Travis CI docs are organized around these top-level sections:

- **Base**: `https://docs.travis-ci.com/`
- **User guide**: `https://docs.travis-ci.com/user/`
- **.travis.yml reference**: `https://docs.travis-ci.com/user/customizing-the-build/`
- **Build stages**: `https://docs.travis-ci.com/user/build-stages/`
- **Caching**: `https://docs.travis-ci.com/user/caching/`
- **Environment variables**: `https://docs.travis-ci.com/user/environment-variables/`
- **Language guides**: `https://docs.travis-ci.com/user/language-<name>/` (e.g., `/user/language-python/`)
- **Deployment**: `https://docs.travis-ci.com/user/deployment/`
- **API**: `https://docs.travis-ci.com/api/`

### Historical Note

Travis CI for open-source projects is less commonly used for new projects since 2020, as GitHub Actions became the standard for GitHub projects. However, Travis CI documentation remains relevant for:

- Existing Travis CI configurations
- Projects on GitLab or Bitbucket using Travis CI
- CI/CD strategy evaluation

### How to Look Up Documentation

1. Identify the topic (.travis.yml configuration, stages, caching, deployment)
2. Start with the appropriate section URL from above
3. Use WebFetch to load the page and extract relevant details
4. For language-specific setup, visit the appropriate language guide URL

---

## Related References

- Load **Site Navigation** to understand docs.travis-ci.com structure
- Load **Quick Reference** for the most frequently needed .travis.yml keys and configuration
- Load **Build Config Reference** for stages, caching strategies, deployment, and matrix builds
- Load **Troubleshooting** when searching for error-specific docs or migration guidance
