---
name: github-cd
description: >
  Deploy with GitHub Actions CD workflows and OIDC.
  Configure secure deployments to cloud providers using OpenID Connect.
---

# GitHub CD

Deploy applications using GitHub Actions CD workflows and OpenID Connect (OIDC) authentication.
This skill provides guidance for configuring secure, zero-trust deployments to cloud providers without managing static credentials.

---

## Intent Router

Load reference files for depth on specific topics:

| Topic | File | Load when... |
| --- | --- | --- |
| Environments & Protection | `references/environments-and-protection.md` | Setting up deployment environments, protection rules, and approval workflows |
| Cloud Deployments | `references/cloud-deployments.md` | Deploying to AWS, GCP, Azure, Kubernetes, registries, or package managers |
| OIDC & Authentication | `references/oidc-and-auth.md` | Understanding OIDC, configuring trust relationships, and scoping by environment |
| Releases & Packages | `references/releases-and-packages.md` | Publishing releases, packages, and artifacts with signing |

---

## Quick Start

### Deployment Job with OIDC

```yaml
jobs:
  deploy:
    name: Deploy to Production
    runs-on: ubuntu-latest
    needs: test  # Gate on CI passing
    environment:
      name: production
      url: https://example.com
    permissions:
      id-token: write
      contents: read
    steps:
      - uses: actions/checkout@v4

      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: arn:aws:iam::ACCOUNT:role/GitHubActionsRole
          aws-region: us-east-1

      - name: Deploy
        run: aws ecs update-service --cluster prod --service myapp --force-new-deployment
```

### Key Patterns

1. **Environment Protection**: Define `environment:` in jobs to gate deployments
2. **Needs Gating**: Use `needs:` to depend on CI jobs before deploying
3. **Manual Promotion**: Add `environment: production` to require manual approval
4. **Workflow Dispatch**: Add `workflow_dispatch:` trigger for manual deployments
5. **OIDC Pattern**: Request `id-token: write` permission and use cloud provider's action to exchange token

### Manual Deployment Trigger

```yaml
on:
  workflow_dispatch:
    inputs:
      environment:
        type: choice
        options:
          - staging
          - production
        required: true

jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: ${{ inputs.environment }}
    steps:
      - uses: actions/checkout@v4
      - run: ./deploy.sh ${{ inputs.environment }}
```

---

## Related Skills

Cross-reference these skills for complementary capabilities:

- **ci-architecture** — Overall CI/CD pipeline design patterns
- **github-docs** — GitHub API, webhook configuration, branch protection
- **yaml-linting** — Validate workflow YAML syntax before committing
- **yaml-lsp** — Editor support for authoring GitHub Actions workflows

---

## Common Deployment Patterns

### Deploy on Release

```yaml
on:
  release:
    types: [published]

jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: production
    steps:
      - uses: actions/checkout@v4
        with:
          ref: ${{ github.event.release.tag_name }}
      - run: ./deploy.sh ${{ github.event.release.tag_name }}
```

### Promote Through Environments

```yaml
on:
  push:
    branches: [main]

jobs:
  deploy-staging:
    runs-on: ubuntu-latest
    environment: staging
    steps:
      - uses: actions/checkout@v4
      - run: ./deploy.sh staging

  deploy-prod:
    runs-on: ubuntu-latest
    needs: deploy-staging
    environment: production
    steps:
      - uses: actions/checkout@v4
      - run: ./deploy.sh production
```

---
