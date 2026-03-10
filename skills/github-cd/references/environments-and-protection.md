# Environments & Protection

GitHub Environments provide controlled deployment gates, approval workflows, and secrets management for CD pipelines.

## Environment Definition in Workflows

Environments are declared in job-level configuration:

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    environment:
      name: production
      url: https://example.com
    steps:
      - uses: actions/checkout@v4
      - run: ./deploy.sh
```

### Environment Properties

- **name** — Required. Environment identifier (e.g., `production`, `staging`, `preview`)
- **url** — Optional. Deployment URL shown in GitHub UI and deployment history
- **Environment secrets** — Scoped to the environment and available as `secrets.*`

### URL Display

The URL appears in deployment tracking and pull request deployment statuses:

```yaml
environment:
  name: production
  url: https://app.example.com/${{ github.sha }}
```

## Protection Rules

Configure protection rules per environment in repository settings → Environments.

### Required Reviewers

Require manual approval from designated teams or users before deployment:

- **Teams** — Use specific team names or code owners
- **Users** — Specify individual GitHub usernames
- **Multiple reviewers** — Require approval from all specified reviewers
- **Dismissal allowance** — Allow existing approvals to be dismissed by new commits

Example: Protect production environment

1. Go to Settings → Environments → production
2. Enable "Deployment branches and tags"
3. Add required reviewers (team leads, DevOps)
4. Save changes

## Deployment Branches

Restrict deployments to specific branches or tags:

```yaml
# Settings > Environments > production > Deployment branches
Deployment branches and tags:
  - release/* (allows release/v1.0.0, release/v1.1.0, etc.)
  - main (only main branch)
```

## Wait Timer

Delay deployment execution after approval:

- **Default:** 0 minutes (immediate)
- **Maximum:** 35 days
- **Use case:** Allow time to detect issues before deployment completes

Example: Require 15-minute wait after approval

1. Settings → Environments → production
2. Set "Wait timer" to 15 minutes
3. Reviewers must approve; deployment starts 15 minutes later

## Deployment History

Track all deployments in GitHub UI:

- **Deployments tab** — Lists all past and current deployments
- **Status checks** — Shows approval status, wait timer progress
- **Rollback** — Revert to previous deployment (manual process in workflow)
- **URL links** — Quick access to deployment URLs

Example workflow step to log deployment:

```yaml
- name: Create Deployment
  uses: actions/github-script@v7
  with:
    script: |
      const deployment = await github.rest.repos.createDeployment({
        owner: context.repo.owner,
        repo: context.repo.repo,
        ref: context.ref,
        environment: 'production',
        required_contexts: [],
        auto_merge: false
      });
```

## Concurrency Groups

Prevent simultaneous deployments to the same environment:

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: production
    concurrency:
      group: deploy-${{ github.ref }}
      cancel-in-progress: false
    steps:
      - uses: actions/checkout@v4
      - run: ./deploy.sh
```

### Concurrency Behavior

- **group** — Identifier for grouping concurrent runs (e.g., per-environment, per-branch)
- **cancel-in-progress** — `true` cancels previous runs in same group; `false` waits
- **Use case:** Ensure only one deployment to production runs at a time

## Environment Secrets

Secrets scoped to specific environments, available only to jobs targeting that environment:

```yaml
jobs:
  deploy:
    environment: production
    steps:
      - name: Deploy
        env:
          DEPLOY_KEY: ${{ secrets.DEPLOY_KEY }}
        run: |
          echo "$DEPLOY_KEY" > /tmp/key.pem
          chmod 600 /tmp/key.pem
          ssh -i /tmp/key.pem user@prod.example.com
```

### Comparing Secrets

| Scope | Visibility | Use Case |
| --- | --- | --- |
| **Repository secrets** | All workflows | Non-sensitive shared config, API endpoints |
| **Environment secrets** | Jobs targeting environment | Credentials, deploy keys, API tokens |
| **Organization secrets** | Across repositories | Shared credentials, common config |

### Accessing Environment Secrets

```yaml
steps:
  - run: echo ${{ secrets.DATABASE_PASSWORD }}
    env:
      DATABASE_PASSWORD: ${{ secrets.PROD_DB_PASS }}
```

Environment-scoped secrets override repository secrets with the same name.

## Protection Rules in Practice

### Staging Environment (Minimal Protection)

```yaml
# Settings > Environments > staging
Required reviewers: None
Deployment branches: develop
Wait timer: 0 minutes
```

### Production Environment (Full Protection)

```yaml
# Settings > Environments > production
Required reviewers: DevOps team (at least 1 approval)
Deployment branches: main, release/*
Wait timer: 15 minutes
```

### Preview Environment (Branch-based)

```yaml
# Settings > Environments > preview
Required reviewers: None
Deployment branches: feature-*, bugfix-*
Concurrency: Cancel previous previews
```

## Example: Protected Multi-Environment Deployment

```yaml
name: Deploy

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm test

  deploy-staging:
    runs-on: ubuntu-latest
    needs: test
    if: github.ref == 'refs/heads/develop'
    environment:
      name: staging
      url: https://staging.example.com
    steps:
      - uses: actions/checkout@v4
      - run: ./deploy.sh staging

  deploy-production:
    runs-on: ubuntu-latest
    needs: test
    if: github.ref == 'refs/heads/main'
    environment:
      name: production
      url: https://example.com
      deployment_branch: main
    steps:
      - uses: actions/checkout@v4
      - run: ./deploy.sh production
```

## Best Practices

- **Use protection rules for critical environments** — Require approval for production
- **Segment environments** — Separate staging and production with different secrets
- **Enable wait timers** — Allow time to detect issues before full deployment
- **Monitor deployment history** — Track who deployed what and when
- **Use deployment branches** — Restrict which code can deploy to which environments
- **Rotate environment secrets regularly** — Update credentials frequently
- **Document approval processes** — Ensure team knows who can approve production deployments
