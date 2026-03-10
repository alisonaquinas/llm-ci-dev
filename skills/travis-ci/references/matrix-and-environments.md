# Matrix & Environments

Travis CI's build matrix allows you to test across multiple language versions, operating systems, and environment configurations simultaneously.
This reference covers configuring language matrices, OS variants, conditional stages, and environment variable management.

---

## Language Version Matrix

### Basic Language Matrix

Specify multiple versions of your primary language. Travis will create a build job for each version:

```yaml
language: python
python:
  - "3.11"
  - "3.10"
  - "3.9"
```

This creates 3 separate build jobs, one for each Python version.

### Node.js Matrix

```yaml
language: node_js
node_js:
  - "18"
  - "16"
  - "14"
```

### Ruby Matrix

```yaml
language: ruby
rvm:
  - "3.2"
  - "3.1"
  - "3.0"
```

### Java Matrix

```yaml
language: java
jdk:
  - openjdk17
  - openjdk11
  - openjdk8
```

---

## Operating System Matrix

### `os` Directive

Specify one or more operating systems:

```yaml
os:
  - linux
  - osx
  - windows
```

Each OS creates separate build jobs. Linux is the default.

### Distribution Selection

For Linux, specify the Ubuntu distribution with `dist`:

```yaml
os: linux
dist: focal     # Ubuntu 20.04 (recommended)
```

Available distributions:

- `focal` — Ubuntu 20.04 (recommended)
- `bionic` — Ubuntu 18.04
- `xenial` — Ubuntu 16.04 (deprecated)
- `trusty` — Ubuntu 14.04 (deprecated)

### Cross-Platform Matrix

```yaml
os:
  - linux
  - osx
python:  # Python only supported on Linux; ignored on macOS
  - "3.11"
  - "3.10"
dist: focal
```

**Note:** Not all languages are supported on all OS. Python and Node.js work on Linux and macOS; Windows support is more limited.

---

## Environment Variables

### Global Environment Variables

Set variables available to all build jobs:

```yaml
env:
  global:
    - DEPLOY_TARGET=production
    - DATABASE_URL=postgres://localhost/test_db
```

### Matrix Environment Variables

Create build jobs with different environment variable combinations:

```yaml
env:
  matrix:
    - DB=mysql CACHE=redis
    - DB=postgresql CACHE=memcached
    - DB=sqlite CACHE=none
script:
  - pytest --db=$DB --cache=$CACHE
```

This creates 3 build jobs with different database/cache combinations.

### Secure Environment Variables

Store sensitive values (API keys, tokens) as encrypted secrets:

```yaml
env:
  global:
    - secure: "AbCdEfGhIjKlMnOpQrStUvWxYz..."  # Encrypted env var
```

Generate encrypted variables via the Travis web UI or CLI.

---

## `jobs.include` and `jobs.exclude`

### Include Specific Configurations

Add specific build jobs beyond the standard matrix:

```yaml
language: python
python:
  - "3.11"
  - "3.10"

jobs:
  include:
    - python: "3.11"
      os: windows
      script: pytest --os=windows
    - python: "3.11"
      env: COVERAGE=true
      after_success: codecov
```

This creates the standard 2 jobs (3.11 and 3.10 on Linux) plus 2 additional jobs.

### Exclude Specific Configurations

Skip building certain combinations:

```yaml
language: python
python:
  - "3.11"
  - "3.10"
  - "3.9"
os:
  - linux
  - osx

jobs:
  exclude:
    - python: "3.9"
      os: osx  # Don't test Python 3.9 on macOS
```

This removes the Python 3.9 on macOS job from the matrix.

### Allow Failures

Mark certain jobs as optional; build succeeds even if they fail:

```yaml
jobs:
  allow_failures:
    - python: "3.9"  # This version is experimental
    - os: windows    # Windows support is incomplete
```

Useful for testing against unstable or experimental dependencies.

---

## Conditional Stages with `if`

Use conditional logic to run jobs only when criteria match:

```yaml
jobs:
  include:
    - stage: test
      python: "3.11"
      script: pytest

    - stage: deploy
      if: branch = main AND type != pull_request
      script: npm run deploy
```

### Conditional Expressions

Available conditions:

- `branch = main` — Specific branch
- `branch =~ ^release-.*$` — Regex match
- `type = pull_request` — Only on PRs
- `type != pull_request` — Not on PRs (push to branch)
- `tag =~ ^v.*$` — Only on version tags

Examples:

```yaml
jobs:
  include:
    - stage: build
      script: npm run build

    - stage: deploy-staging
      if: branch = develop
      script: npm run deploy:staging

    - stage: deploy-production
      if: tag =~ ^v[0-9]
      script: npm run deploy:production

    - stage: security-scan
      if: type = pull_request
      script: npm run security:check
```

---

## Build Matrix Display

### `fast_finish`

Mark the build as finished as soon as all required jobs complete, even if some optional jobs are still running:

```yaml
jobs:
  fast_finish: true
  allow_failures:
    - python: "3.9"
```

The build result appears in GitHub immediately after core jobs complete, without waiting for experimental versions.

### Build Name in UI

Customize how each matrix job displays in the web UI by setting `name`:

```yaml
jobs:
  include:
    - name: "Python 3.11 on Linux"
      python: "3.11"
      script: pytest

    - name: "Python 3.11 on Windows"
      python: "3.11"
      os: windows
      script: pytest
```

---

## Complex Matrix Examples

### Multi-Language & Multi-OS Test Suite

```yaml
language: python
python:
  - "3.11"
  - "3.10"
os:
  - linux
  - osx
dist: focal

env:
  matrix:
    - DB=mysql
    - DB=postgresql

jobs:
  exclude:
    - python: "3.10"
      os: osx
  allow_failures:
    - python: "3.10"
      env: DB=postgresql
  fast_finish: true
```

This creates a matrix of 8 jobs (2 Python × 2 OS × 2 DB) minus the excluded 3.10/macOS combination, with the PostgreSQL job marked optional.

### Conditional Deployment

```yaml
language: node_js
node_js:
  - "18"

script:
  - npm test

jobs:
  include:
    - stage: deploy
      if: branch = main AND type != pull_request
      script: skip
      deploy:
        provider: heroku
        app: my-app-production
        on:
          branch: main

    - stage: deploy
      if: branch = develop AND type != pull_request
      script: skip
      deploy:
        provider: heroku
        app: my-app-staging
        on:
          branch: develop
```

---

## Environment Variable Best Practices

1. **Use global for constants** — Values needed by all jobs
2. **Use matrix for variations** — Different configurations to test
3. **Encrypt sensitive values** — API keys, tokens, passwords
4. **Avoid secrets in conditional logic** — Conditions are logged; keep secrets separate
5. **Document matrix intent** — Comments explaining why certain combinations exist

---

## Common Pitfalls

| Issue | Solution |
| --- | --- |
| Too many matrix jobs | Use `exclude` or `allow_failures` to reduce jobs; 50+ jobs get slow |
| Secrets exposed in logs | Always encrypt with `secure:` |
| Confusing OS support | Check language-specific docs; not all languages work on all OS |
| Matrix jobs don't use env vars | Ensure `env.global` or `env.matrix` is specified |
