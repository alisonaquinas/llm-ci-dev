---
name: gitlab-ci
description: >
  Write and maintain GitLab CI pipelines in .gitlab-ci.yml with jobs, stages,
  testing, caching, runners, variables, and secrets.
---

# GitLab CI

Write and maintain GitLab CI pipelines to automate testing, building, and deployment workflows.
This skill covers .gitlab-ci.yml structure, job anatomy, runners, caching, testing strategies, and secrets management.

---

## Intent Router

Load reference files for depth on specific topics:

| Topic | File | Load when... |
| --- | --- | --- |
| Pipeline Basics | `references/pipeline-basics.md` | Structuring .gitlab-ci.yml, jobs, stages, dependencies, rules, extends, include, parallel, trigger, MR pipelines |
| Runners & Caching | `references/runners-and-caching.md` | Runner types, executor selection, tags, cache key design, artifacts, Docker-in-Docker, service containers |
| Testing & Quality | `references/testing-and-quality.md` | JUnit reports, code coverage, SAST/DAST/dependency scanning, merge request tests, matrix testing |
| Variables & Secrets | `references/variables-and-secrets.md` | Predefined variables, custom variables, protected+masked, vault integration, dotenv, CI_JOB_TOKEN, OIDC |

---

## Quick Start

### Minimal Pipeline Structure

A `.gitlab-ci.yml` file at the repository root defines all pipeline stages and jobs:

```yaml
stages:
  - build
  - test
  - deploy

build:
  stage: build
  script:
    - make build

test:
  stage: test
  script:
    - make test

deploy:
  stage: deploy
  script:
    - make deploy
```

### Common Keywords

| Keyword | Purpose |
| --- | --- |
| `stages` | Define pipeline order (executed sequentially) |
| `script` | Commands to execute in the job |
| `stage` | Which stage this job belongs to |
| `needs` | Explicit job dependencies; allows parallel jobs in same stage |
| `rules` | Conditional execution (if/when/variables) |
| `cache` | Persist data between jobs (e.g., dependencies, build artifacts) |
| `artifacts` | Preserve build outputs for download or downstream jobs |
| `before_script` | Run before job commands |
| `after_script` | Run after job commands (even if job fails) |
| `extends` | Reuse job templates from local or included YAML |
| `include` | Import external .gitlab-ci.yml files |
| `retry` | Retry job on failure |
| `timeout` | Job execution timeout |
| `tags` | Select runner by tag |
| `variables` | Job-level or global environment variables |
| `only`/`except` | Legacy conditional execution (use `rules` instead) |

### File Placement

`.gitlab-ci.yml` must be at the repository root to be automatically detected.
Additional configuration files can be included via `include` keyword.

### YAML Validation

Validate `.gitlab-ci.yml` locally before pushing:

```bash
# Using gitlab-runner (if installed)
gitlab-runner verify

# Using yamllint (with custom config)
yamllint -d relaxed .gitlab-ci.yml

# Using curl to GitLab API (requires authentication)
curl --header "PRIVATE-TOKEN: $CI_JOB_TOKEN" \
  --header "Content-Type: application/json" \
  --data '{"dry_run": true, "ref": "main"}' \
  https://gitlab.example.com/api/v4/projects/:id/ci/lint
```

---

## Related References

- Load **Pipeline Basics** to design job dependencies, use extends, and structure stages
- Load **Runners & Caching** for executor selection and performance optimization
- Load **Testing & Quality** to integrate testing reports and code scanning
- Load **Variables & Secrets** to manage CI/CD secrets safely

---

## Cross-References

Related skills in this collection:

- **ci-architecture** — High-level CI/CD pipeline design patterns
- **gitlab-docs** — GitLab API and web UI reference
- **yaml-linting** — Validate .gitlab-ci.yml syntax and style
- **yaml-lsp** — YAML editor integration for .gitlab-ci.yml
