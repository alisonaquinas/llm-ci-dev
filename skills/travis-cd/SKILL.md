---
name: travis-cd
description: >
  Deploy from Travis CI to cloud and registries.
  Configure Travis CI deployments to cloud providers, artifact registries, and custom endpoints.
---

# Travis CD

Configure continuous deployment from Travis CI to cloud providers, artifact registries, and custom endpoints.
This skill covers Travis CI's built-in deployment providers, credential management, and release automation patterns.

---

## Intent Router

Load reference files for depth on specific topics:

| Topic | File | Load when... |
| --- | --- | --- |
| Deployment Providers | `references/deployment-providers.md` | Setting up deployments to Heroku, AWS, npm, PyPI, Docker Hub, or other providers |
| Deployment Conditions | `references/deployment-conditions.md` | Controlling when deployments run (branch filters, tags, PRs, conditions) |
| Credential Management | `references/credential-management.md` | Encrypting secrets, managing API keys, and secure variable handling |
| Release Automation | `references/release-automation.md` | Tag-triggered releases, semantic versioning, GitHub Releases, and changelog generation |

---

## Quick Start

### Basic Deployment Block

```yaml
deploy:
  provider: heroku
  api_key:
    secure: <encrypted-api-key>
  app: my-app
  on:
    branch: main
```

### Provider + Conditions

```yaml
deploy:
  - provider: npm
    email: user@example.com
    api_key:
      secure: <encrypted-token>
    skip_cleanup: true
    on:
      tags: true
      condition: $TRAVIS_TAG =~ ^v[0-9]+\.[0-9]+\.[0-9]+$

  - provider: heroku
    api_key:
      secure: <encrypted-key>
    on:
      branch: main
      condition: $TRAVIS_EVENT_TYPE = push
```

### Encrypted Credentials

```bash
# Encrypt an API key and add to .travis.yml
travis encrypt YOUR_API_KEY --add deploy.api_key

# Encrypt a file (e.g., deploy key)
travis encrypt-file deploy_key.pem
```

### Tag-Triggered GitHub Release

```yaml
deploy:
  provider: releases
  api_key:
    secure: <encrypted-token>
  file: build/app.tar.gz
  skip_cleanup: true
  on:
    tags: true
    repo: owner/repo
```

---

## Key Concepts

**Providers** — Built-in deployment targets (Heroku, AWS S3, npm, PyPI, Docker Hub, GitHub Releases, etc.)

**Deployment Conditions** — Control when deployments execute via `on:` block (branch, tags, conditions, repo, pull requests)

**Encryption** — Use `travis encrypt` to secure API keys and credentials in `.travis.yml`

**Tag-Based Workflows** — Trigger deployments on git tags for automated release pipelines

**Multiple Deployments** — Chain multiple deployments with different conditions and targets

---

## Related References

- Load **Deployment Providers** to configure specific cloud and registry targets
- Load **Deployment Conditions** to filter deployments by branch, tag, or status
- Load **Credential Management** to encrypt and rotate API keys securely
- Load **Release Automation** to set up semantic versioning and automated releases
