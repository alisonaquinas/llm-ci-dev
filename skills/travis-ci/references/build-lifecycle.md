# Build Lifecycle

Travis CI follows a fixed sequence of build phases that determine when code is executed and how failures propagate.
Understanding this sequence is essential for designing robust CI pipelines.

---

## Complete Phase Sequence

Travis CI executes the following phases in order. The build result is determined by the `script` phase exit code; subsequent phases do not affect the final build status.

```text
1. Syntax & Config Check
2. before_install
3. install
4. before_script
5. script (determines build pass/fail)
6. after_success OR after_failure
7. after_script (always runs)
8. before_deploy
9. deploy
10. after_deploy
```

### Phase Details

#### 1. **before_install** (optional)

Runs before dependency installation. Useful for:

- Installing system packages via `apt-get` or `brew`
- Downloading and installing tools not in package managers
- Setting up custom environments

```yaml
before_install:
  - sudo apt-get update
  - sudo apt-get install -y libssl-dev
  - curl https://example.com/tool | bash
```

#### 2. **install** (optional, auto-detected)

Installs language-specific dependencies. Travis auto-detects and runs default commands:

- **Python:** `pip install -r requirements.txt`
- **Node.js:** `npm install`
- **Ruby:** `bundle install`
- **Java:** `mvn install` or `gradle build`

Override the default:

```yaml
install:
  - pip install -r requirements-dev.txt
  - pip install -e .
```

Skip installation:

```yaml
install: skip
```

#### 3. **before_script** (optional)

Runs after installation, before the main test script. Useful for:

- Database setup
- Service initialization
- Environment variable setup
- Code linting and static analysis

```yaml
before_script:
  - mysql -u root -e "CREATE DATABASE test_db;"
  - python -m flake8 src/
```

#### 4. **script** (required)

The main build command that determines build success or failure. Exit code 0 means pass; any non-zero exit code means fail.

```yaml
script:
  - pytest tests/
```

Multiple commands:

```yaml
script:
  - pytest tests/unit/
  - pytest tests/integration/
  - npm run lint
```

If any command fails, the build stops immediately and is marked as failed.

#### 5. **after_success or after_failure** (optional)

One of these phases runs after `script`, depending on the result:

```yaml
after_success:
  - codecov  # Upload coverage only if tests pass
  - npm run build  # Build production artifacts only on success

after_failure:
  - npm run test:debug  # Run debug script on failure
  - curl https://hooks.slack.com/... -d "Build failed"  # Notify on failure
```

**Important:** These phases do not affect the build result. Even if `after_success` fails, the build remains marked as passed.

#### 6. **after_script** (optional)

Always runs, regardless of previous phase results. Useful for cleanup:

```yaml
after_script:
  - rm -rf build/
  - docker image prune -f
```

#### 7. **before_deploy** (optional)

Runs before the `deploy` phase. Use for:

- Preparing artifacts
- Setting credentials
- Validating deployment configuration

```yaml
before_deploy:
  - npm run build
  - tar -czf build.tar.gz dist/
```

#### 8. **deploy** (optional)

Deploys build artifacts. Travis provides built-in providers for:

- **GitHub Pages:** `provider: pages`
- **AWS S3:** `provider: s3`
- **Docker Hub:** `provider: docker`
- **Heroku:** `provider: heroku`
- **CloudFormation:** `provider: cloudformation`

Simple example:

```yaml
deploy:
  provider: s3
  access_key_id: $AWS_ACCESS_KEY_ID
  secret_access_key: $AWS_SECRET_ACCESS_KEY
  bucket: my-bucket
  local_dir: build
  on:
    branch: main
```

#### 9. **after_deploy** (optional)

Runs after successful deployment:

```yaml
after_deploy:
  - echo "Deployment completed successfully"
  - curl https://hooks.slack.com/... -d "Deployment complete"
```

---

## Controlling Failure

### Script Phase Failure

The `script` phase is the only phase that determines build status. If any command in `script` exits with non-zero code, the build fails:

```yaml
script:
  - pytest tests/
  - npm run lint  # If this exits non-zero, build fails
```

To continue on failure, use `|| true`:

```yaml
script:
  - pytest tests/ || true  # Build continues even if tests fail
```

**Note:** This is generally not recommended. Failing tests should fail the build.

### After Phases Do Not Affect Build Status

If `after_success`, `after_failure`, `after_script`, or any deploy phase fails, it does not change the build result:

```yaml
script:
  - pytest tests/  # Exit code 0 (pass)

after_success:
  - codecov  # If this fails, build remains "passed"
```

This design allows cleanup and notifications to fail without affecting the build outcome.

---

## Timing Out

### travis_retry

Automatically retry a command up to 3 times if it fails:

```yaml
script:
  - travis_retry npm test  # Retry up to 3 times
```

Useful for flaky tests or network-dependent operations:

```yaml
script:
  - travis_retry pip install -r requirements.txt
```

### travis_wait

Keep the build from timing out even if there's no output. Useful for long-running tests:

```yaml
script:
  - travis_wait 30 npm test  # Wait up to 30 minutes
```

Without output, Travis times out after 10 minutes. `travis_wait` extends this period.

Combine with output redirection for long operations:

```yaml
script:
  - travis_wait 45 python -m pytest tests/ -v --tb=short
```

---

## Build Result Conditions

### Conditional Execution with `if`

Run phases only when conditions match:

```yaml
script:
  - pytest tests/

after_success:
  - |
    if [[ $TRAVIS_BRANCH == "main" && $TRAVIS_PULL_REQUEST == "false" ]]; then
      npm run deploy
    fi
```

Built-in variables available in conditions:

- `$TRAVIS_BRANCH` — Current branch name
- `$TRAVIS_PULL_REQUEST` — PR number or "false"
- `$TRAVIS_EVENT_TYPE` — "push" or "pull_request"
- `$TRAVIS_OS_NAME` — "linux", "osx", or "windows"
- `$TRAVIS_PYTHON_VERSION` — Current Python version (if applicable)

### Conditional Deployment

Deploy only on specific branches:

```yaml
deploy:
  provider: s3
  on:
    branch: main  # Only deploy from main branch
```

---

## Failure Scenarios

| Scenario | Result | Reason |
| --- | --- | --- |
| `script` exits 0 | **Pass** | Main build succeeded |
| `script` exits non-zero | **Fail** | Main build failed; subsequent phases still run |
| `script` passes, `after_success` fails | **Pass** | after_success does not affect result |
| `script` fails, `after_failure` fails | **Fail** | Build already failed; after_failure status ignored |
| `after_script` fails | **Pass or Fail** | after_script does not change result; final status depends on `script` |

---

## Best Practices

1. **Keep `script` focused** — One main test command; use `before_script` for setup
2. **Use `travis_retry` sparingly** — Retry flaky operations, but fix root causes
3. **Use `travis_wait` for long tests** — Extended timeout is better than random failures
4. **Separate concerns** — `after_success` for success artifacts, `after_failure` for debug
5. **Log liberally** — Long-running commands should log progress to avoid timeout suspicion
6. **Avoid brittle `if` conditions** — Prefer language matrix and stages for complex logic
