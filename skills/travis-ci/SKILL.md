---
name: travis-ci
description: >
  Write and maintain Travis CI build configuration.
  Design complete CI pipelines with build phases, environment matrices, test patterns, and caching strategies.
---

# Travis CI

Travis CI is a distributed CI/CD platform that automatically tests and deploys code after every commit.
This skill enables you to design, configure, and maintain `.travis.yml` files for automated testing and deployment workflows.

---

## Intent Router

Load reference files for depth on specific topics:

| Topic | File | Load when... |
| --- | --- | --- |
| Build Lifecycle | `references/build-lifecycle.md` | Understanding build phases and controlling build execution |
| Matrix & Environments | `references/matrix-and-environments.md` | Configuring language versions, OS variants, and conditional stages |
| Testing Patterns | `references/testing-patterns.md` | Setting up tests, parallelization, and external service integration |
| Caching Strategies | `references/caching-strategies.md` | Optimizing build times with built-in and custom caching |

---

## Quick Start

### Minimal `.travis.yml`

```yaml
language: python
python:
  - "3.11"
  - "3.10"
script:
  - pytest
```

### Essential Directives

- **`language`** — Build environment (python, node_js, ruby, java, go, rust, etc.)
- **`os`** — Operating system (linux, osx, windows)
- **`dist`** — Ubuntu distribution (focal, bionic, xenial, trusty)
- **Build phases** — before_install, install, before_script, script, after_success, after_failure, after_script, deploy, after_deploy

### Build Phase Sequence

1. Optional: Check syntax and config
2. `before_install` — Pre-installation setup
3. `install` — Install dependencies (auto-detected or custom)
4. `before_script` — Setup before main test
5. `script` — Main test/build command (failure exits build)
6. `after_success` or `after_failure` — Conditional cleanup
7. `after_script` — Always runs after main script
8. `before_deploy` — Pre-deployment setup
9. `deploy` — Deploy to target platform
10. `after_deploy` — Post-deployment tasks

### Common Language Setups

**Python:**

```yaml
language: python
python:
  - "3.11"
install:
  - pip install -r requirements.txt
script:
  - pytest
```

**Node.js:**

```yaml
language: node_js
node_js:
  - "18"
  - "16"
script:
  - npm test
```

**Ruby:**

```yaml
language: ruby
rvm:
  - "3.2"
  - "3.1"
script:
  - bundle exec rspec
```

### Validation

Before committing `.travis.yml`, validate with YAML linting:

```bash
docker run --rm -v "$(pwd):/data" pipelinecomponents/yamllint yamllint /data/.travis.yml
```

---

## Build Failure Control

### Fail Fast with `travis_wait`

The `script` phase exits the build on failure. Use `travis_wait` to retry flaky commands:

```yaml
script:
  - travis_wait 20 npm test
```

This waits up to 20 minutes without output before timing out.

### Control Build Result

Build result is determined by the `script` phase exit code. Subsequent phases (`after_success`, `after_failure`, `after_script`) do not affect build status:

```yaml
script:
  - pytest --cov
after_success:
  - codecov  # Upload coverage; failure does not fail build
after_failure:
  - echo "Tests failed"  # Runs if script failed; does not re-fail
```

---

## Related References

- Load **Build Lifecycle** to understand phase execution order and failure semantics
- Load **Matrix & Environments** to configure multi-version testing
- Load **Testing Patterns** for language-specific test frameworks and parallelization
- Load **Caching Strategies** to optimize build times

---

## Note

Travis CI for open-source projects has been superseded by GitHub Actions as of 2021. However, existing `.travis.yml` files remain in many repositories and continue to require maintenance. This skill is intended for teams actively maintaining Travis CI pipelines.
