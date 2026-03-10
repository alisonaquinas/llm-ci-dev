# Deployment Conditions

Control when and where deployments execute using the `on:` block. Deployments respect branch filters, tag conditions, pull request suppression, and arbitrary conditions.

---

## The `on:` Block Anatomy

```yaml
deploy:
  provider: heroku
  api_key:
    secure: <token>
  on:
    branch: main              # Only deploy from this branch
    tags: true               # Deploy on tagged commits
    condition: <expression>  # Custom condition (e.g., env var check)
    repo: owner/repo         # Restrict to specific repository
    all_branches: false      # Usually false; true ignores branch filter
```

---

## Branch-Specific Deployment

Deploy only from specific branches.

```yaml
deploy:
  provider: heroku
  api_key:
    secure: <token>
  app: my-app-production
  on:
    branch: main
```

Deploy to different targets per branch:

```yaml
deploy:
  - provider: heroku
    api_key:
      secure: <prod-key>
    app: my-app-production
    on:
      branch: main

  - provider: heroku
    api_key:
      secure: <staging-key>
    app: my-app-staging
    on:
      branch: develop

  - provider: script
    script: echo "Skipping deploy for $TRAVIS_BRANCH"
    on:
      branch:
        - feature
        - bugfix
```

**Multiple allowed branches:**

```yaml
on:
  branch:
    - main
    - release/*
```

---

## Tag-Based Deployment

Trigger deployments only on git tags (common for releases).

```yaml
deploy:
  provider: npm
  email: user@example.com
  api_key:
    secure: <token>
  on:
    tags: true
    repo: owner/repo
```

Deploy only on matching tag patterns:

```yaml
on:
  tags: true
  condition: $TRAVIS_TAG =~ ^v[0-9]+\.[0-9]+\.[0-9]+$
```

---

## Pull Request Suppression

Prevent deployments on pull request builds.

```yaml
deploy:
  provider: heroku
  api_key:
    secure: <token>
  on:
    branch: main
    # By default, PRs do NOT trigger deployments
    # Only push builds from 'main' trigger this
```

To explicitly allow PR deployments (rare):

```yaml
on:
  branch: main
  condition: $TRAVIS_EVENT_TYPE = pull_request
```

---

## Conditional Deployment

Use custom conditions with `condition:` for fine-grained control.

```yaml
deploy:
  provider: script
  script: ./deploy.sh
  skip_cleanup: true
  on:
    branch: main
    condition: $TRAVIS_EVENT_TYPE = push
```

**Common conditions:**

```yaml
# Deploy only on successful builds
on:
  condition: $TRAVIS_TEST_RESULT = 0

# Deploy only if specific environment variable is set
on:
  condition: $DEPLOY_ENV = production

# Deploy based on git tag format
on:
  tags: true
  condition: $TRAVIS_TAG =~ ^release-[0-9]+$

# Deploy if commit message contains a keyword
on:
  condition: $TRAVIS_COMMIT_MESSAGE =~ /\[deploy\]/

# Complex logic with multiple conditions
on:
  condition: >-
    $TRAVIS_EVENT_TYPE = push &&
    $TRAVIS_BRANCH = main &&
    $DEPLOY_ENABLED = true
```

---

## Repository Restriction

Restrict deployments to specific repositories (useful in forks).

```yaml
deploy:
  provider: releases
  api_key:
    secure: <token>
  file: build/release.tar.gz
  on:
    repo: owner/repo
    tags: true
```

This prevents accidental deployments from forks.

---

## All Branches Mode

Deploy from any branch (use cautiously).

```yaml
deploy:
  provider: s3
  bucket: my-bucket
  on:
    all_branches: true
```

Usually used with additional `condition:` checks:

```yaml
on:
  all_branches: true
  condition: $TRAVIS_TAG =~ ^v[0-9]+\.[0-9]+\.[0-9]+$
```

---

## Skip Cleanup

Preserve build artifacts for deployment.

```yaml
deploy:
  provider: npm
  email: user@example.com
  api_key:
    secure: <token>
  skip_cleanup: true
  on:
    tags: true
```

Travis CI cleans the workspace before deployment by default. Set `skip_cleanup: true` when the provider needs:

- Compiled files (npm, PyPI, Docker)
- node_modules or dependencies
- Build artifacts

---

## Matrix-Aware Deployment

Exclude specific matrix configurations from deployment.

```yaml
env:
  - NODE_VERSION=16
  - NODE_VERSION=18

deploy:
  provider: npm
  api_key:
    secure: <token>
  on:
    tags: true
    condition: $NODE_VERSION = 18
```

This ensures only the Node 18 build publishes to npm.

---

## Allow Failure

Let deployments fail without failing the entire build.

```yaml
deploy:
  - provider: script
    script: ./deploy-to-production.sh
    on:
      branch: main
    on_failure: leave
    on_success: leave

  - provider: script
    script: ./optional-notification.sh
    on:
      branch: main
    allow_failure: true
```

---

## Complete Multi-Target Example

```yaml
deploy:
  # Production deployment on main branch
  - provider: heroku
    api_key:
      secure: <prod-key>
    app: my-app-production
    on:
      branch: main
      condition: $TRAVIS_EVENT_TYPE = push

  # Publish to npm on version tags
  - provider: npm
    email: user@example.com
    api_key:
      secure: <npm-token>
    skip_cleanup: true
    on:
      tags: true
      condition: $TRAVIS_TAG =~ ^v[0-9]+\.[0-9]+\.[0-9]+$

  # Create GitHub Release with assets
  - provider: releases
    api_key:
      secure: <github-token>
    file:
      - dist/app.tar.gz
      - dist/checksums.txt
    skip_cleanup: true
    on:
      tags: true
      repo: owner/repo
      condition: $TRAVIS_TAG =~ ^v[0-9]+\.[0-9]+\.[0-9]+$

  # Staging deployment on develop
  - provider: heroku
    api_key:
      secure: <staging-key>
    app: my-app-staging
    on:
      branch: develop
```

---

## Tips

- **Avoid PRs:** Default behavior skips deployments on pull requests (safe default)
- **Tag pattern matching:** Use regex in `condition:` for version constraints
- **Multiple conditions:** Use `&&` operator with spaces for readability
- **Testing conditionals:** Print `$TRAVIS_*` variables in before_deploy to debug
- **Order matters:** Array order determines execution sequence; first failure stops by default
