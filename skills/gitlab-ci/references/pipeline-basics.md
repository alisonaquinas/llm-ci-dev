# Pipeline Basics — .gitlab-ci.yml Structure and Keywords

## Overview

A `.gitlab-ci.yml` file defines a GitLab CI pipeline as a series of jobs organized into stages.
Jobs execute shell commands in a runner environment, with dependencies and conditional rules controlling execution order and behavior.

---

## Pipeline Structure

### Stages and Sequential Execution

Stages execute sequentially; all jobs in a stage must complete before the next stage begins.

```yaml
stages:
  - lint
  - build
  - test
  - deploy

lint:
  stage: lint
  script: yamllint . && shellcheck scripts/*.sh

build:
  stage: build
  script: make build
  dependencies:
    - lint

test:
  stage: test
  script: make test
  dependencies:
    - build

deploy:
  stage: deploy
  script: make deploy
  dependencies:
    - test
  when: manual
```

If a job fails and `allow_failure: false` (default), the entire pipeline stops.

### Job Anatomy

Every job requires a `stage` and `script` (or other execution directive):

```yaml
job_name:
  stage: build
  image: ubuntu:22.04
  script:
    - echo "Building..."
    - make build
  before_script:
    - apt-get update
  after_script:
    - rm -rf build/
  tags:
    - docker
  artifacts:
    paths:
      - build/
    expire_in: 1 week
  cache:
    key: deps
    paths:
      - node_modules/
  retry:
    max: 2
    when: runner_system_failure
  timeout: 1h
  allow_failure: false
```

---

## Global Keywords

### `stages`

List of stage names in execution order (required for most pipelines):

```yaml
stages:
  - validate
  - compile
  - test
  - package
  - deploy
```

### `default`

Set default values for all jobs (can be overridden per job):

```yaml
default:
  image: node:18
  tags:
    - docker
  retry:
    max: 2
  before_script:
    - npm ci
```

### `variables`

Global environment variables accessible to all jobs:

```yaml
variables:
  REGISTRY: registry.gitlab.com
  IMAGE_TAG: $CI_COMMIT_SHA
  NODE_ENV: production
```

---

## Job Keywords

### `script`

Execute shell commands (required unless using `trigger` or `deploy_freeze`):

```yaml
test:
  stage: test
  script:
    - npm run test
    - npm run coverage
```

Multiple lines are concatenated and executed as a single shell script.

### `before_script` / `after_script`

Run commands before/after the main script. `after_script` runs even if `script` fails.

```yaml
build:
  stage: build
  before_script:
    - export PATH=$PATH:/opt/tools/bin
  script:
    - make build
  after_script:
    - make clean
```

### `image`

Specify Docker image for job execution (overrides default):

```yaml
test:
  stage: test
  image: python:3.11
  script:
    - pip install -r requirements.txt
    - pytest
```

### `stage`

Assign job to a stage:

```yaml
deploy:
  stage: deploy
```

### `tags`

Select runners by tag. Runner must have all listed tags:

```yaml
gpu_job:
  stage: compute
  tags:
    - gpu
    - cuda-11
  script:
    - nvidia-smi
```

### `dependencies` and `needs`

#### `dependencies`

Wait for jobs to complete and download their artifacts:

```yaml
deploy:
  stage: deploy
  dependencies:
    - build
  script:
    - ls -la build/  # Artifacts from build job available
```

#### `needs`

Explicit DAG-based dependency; allows parallelism within a stage:

```yaml
build_frontend:
  stage: build
  script: npm run build

build_backend:
  stage: build
  script: make build

test_integration:
  stage: test
  needs:
    - build_frontend
    - build_backend
  script: npm run test:integration
```

All jobs in the `build` stage run in parallel; `test_integration` waits for both.

### `rules`

Conditional execution based on variables, refs, pipeline type, or schedules:

```yaml
deploy:
  stage: deploy
  script: make deploy
  rules:
    - if: $CI_COMMIT_BRANCH == "main" && $CI_PIPELINE_SOURCE == "push"
      when: always
    - if: $CI_COMMIT_TAG
      when: always
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
      when: manual
    - when: never  # Default: do not run in other cases
```

Common conditions:

- `$CI_COMMIT_BRANCH` — Current branch name
- `$CI_COMMIT_TAG` — Git tag
- `$CI_PIPELINE_SOURCE` — Pipeline trigger type (push, merge_request_event, schedule, etc.)
- `$CI_MERGE_REQUEST_APPROVED` — MR approval status (true/false)

`when` values: `always`, `manual`, `delayed`, `never`

### `only` / `except`

Legacy conditional syntax (use `rules` in new pipelines):

```yaml
deploy:
  stage: deploy
  script: make deploy
  only:
    - main
    - tags
  except:
    - merge_requests
```

---

## Job Reuse with `extends`

### Local Extends

Define a template job (starting with `.`) and inherit from it:

```yaml
.test_template: &test_template
  stage: test
  image: python:3.11
  before_script:
    - pip install -r requirements.txt
  retry:
    max: 2

test_unit:
  <<: *test_template
  script:
    - pytest tests/unit/

test_integration:
  <<: *test_template
  script:
    - pytest tests/integration/

# Or using extends keyword
test_system:
  extends: .test_template
  script:
    - pytest tests/system/
```

### Extends with Multiple Templates

```yaml
.common:
  image: ubuntu:22.04
  tags: [ docker ]

.test:
  stage: test
  before_script:
    - apt-get update

test:
  extends:
    - .common
    - .test
  script:
    - make test
```

---

## Including External Configuration

### `include`

Import jobs and configuration from external `.gitlab-ci.yml` files:

```yaml
include:
  - local: '.gitlab/ci/lint.yml'
  - local: '.gitlab/ci/test.yml'
  - project: 'group/shared-ci'
    ref: 'main'
    file: 'templates.yml'
  - remote: 'https://example.com/ci/common.yml'
  - template: Security/SAST.gitlab-ci.yml
```

#### Local includes

Reference `.gitlab-ci.yml` files within the repository:

```yaml
include:
  - local: 'ci/build.yml'
  - local: 'ci/test.yml'
  - local: 'ci/deploy.yml'
```

#### Project includes

Reference files from another GitLab project:

```yaml
include:
  - project: 'devops/shared-ci'
    ref: 'main'
    file: 'python-template.yml'
```

#### Remote includes

Reference external URLs (must return valid YAML):

```yaml
include:
  - remote: 'https://gitlab.example.com/ci-templates/common.yml'
```

#### Template includes

Use GitLab's built-in CI templates:

```yaml
include:
  - template: Security/SAST.gitlab-ci.yml
  - template: Dependency-Scanning.gitlab-ci.yml
  - template: Code-Quality.gitlab-ci.yml
```

---

## Parallel Jobs

Run multiple jobs simultaneously (across runners or in the same runner if available):

```yaml
test:
  stage: test
  parallel: 5
  script:
    - npm run test -- --shard=$CI_NODE_INDEX/$CI_NODE_TOTAL
```

Variables available:

- `$CI_NODE_INDEX` — Current parallel job index (1 to N)
- `$CI_NODE_TOTAL` — Total parallel jobs (N)

### Matrix Jobs

Generate multiple job variants from a matrix of variables:

```yaml
test:
  stage: test
  script:
    - npm run test:$TEST_SUITE on $NODE_VERSION
  parallel:
    matrix:
      - TEST_SUITE: [ unit, integration, e2e ]
        NODE_VERSION: [ 16, 18, 20 ]
```

Generates 9 jobs (3 TEST_SUITE × 3 NODE_VERSION combinations).

---

## Triggering Other Pipelines

### `trigger` for Child Pipelines

Trigger a downstream project's pipeline or create a child pipeline:

```yaml
trigger_deploy:
  stage: deploy
  trigger:
    project: infra/deployment-config
    branch: main
  needs:
    - build
```

### Multi-Project Pipelines

```yaml
trigger_downstream:
  stage: deploy
  trigger:
    project: group/another-project
    branch: main
    strategy: depend  # Wait for downstream pipeline to complete
```

---

## Merge Request Pipelines

### Triggering on MR Events

```yaml
stages:
  - test
  - deploy

test:
  stage: test
  script: npm run test
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"

deploy_staging:
  stage: deploy
  script: npm run deploy:staging
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
      when: manual

deploy_prod:
  stage: deploy
  script: npm run deploy:prod
  rules:
    - if: $CI_COMMIT_BRANCH == "main" && $CI_PIPELINE_SOURCE == "push"
```

### Merge Request Approvals

```yaml
deploy:
  stage: deploy
  script: make deploy
  rules:
    - if: $CI_MERGE_REQUEST_APPROVED == "true"
      when: always
    - when: never
```

---

## Artifacts

### Preserve and Download Job Outputs

```yaml
build:
  stage: build
  script:
    - make build
  artifacts:
    paths:
      - build/
      - dist/
    name: build-$CI_COMMIT_SHORT_SHA
    expire_in: 1 week
    when: always
```

Artifacts are available for:

- Manual download via GitLab UI
- Downstream jobs (via `dependencies` or `needs`)
- Merge request diffs

Options:

- `paths` — Files/directories to preserve
- `expire_in` — How long to keep (e.g., 1 week, 30 days, never)
- `when` — When to collect (always, on_success, on_failure)

### Exclude Artifacts

```yaml
build:
  script: make build
  artifacts:
    paths:
      - build/
    exclude:
      - build/**/*.map
```

---

## Caching

Cache dependencies and build artifacts between job runs:

```yaml
build:
  stage: build
  cache:
    key: deps-$CI_COMMIT_REF_SLUG
    paths:
      - node_modules/
      - .gradle/
  script:
    - npm ci
    - npm run build
```

Cache keys can use variables:

- `$CI_COMMIT_REF_SLUG` — Sanitized branch/tag name
- `$CI_JOB_NAME` — Job name
- `$CI_PIPELINE_ID` — Pipeline ID

Cache is shared across jobs in the same key; use `key:files` to tie cache to specific files:

```yaml
cache:
  key:
    files:
      - package-lock.json
  paths:
    - node_modules/
```

---

## Retry Logic

Automatic retry on failure:

```yaml
test:
  stage: test
  script: npm run test
  retry:
    max: 2
    when:
      - runner_system_failure
      - stuck_or_timeout_failure
```

`when` values:

- `always` — Retry on any failure
- `runner_system_failure` — Runner crashed or system error
- `stuck_or_timeout_failure` — Job timeout
- `script_failure` — Exit code non-zero
- `api_failure` — GitLab API error
- `stuck_or_timeout_failure` — Job timeout

---

## Timeouts and Limits

### Job Timeout

```yaml
long_running_test:
  stage: test
  timeout: 2h
  script:
    - ./run-long-test.sh
```

Default: 60 minutes (configurable globally in GitLab settings).

### Pipeline-Level Limits

Set at project settings, not in .gitlab-ci.yml. Affects:

- Maximum job duration
- Maximum pipeline duration
- Maximum parallel jobs

---

## Best Practices

1. **Keep stages minimal** — 3-5 stages (lint, build, test, deploy)
2. **Use `needs` for DAG** — Enables parallelism and explicit dependencies
3. **Cache intelligently** — Cache slow-to-rebuild data (dependencies, compiled assets)
4. **Expire artifacts** — Prevent disk bloat; set `expire_in` appropriately
5. **Use `extends`** — DRY up repeated job configuration
6. **Conditional rules** — Use `rules` to avoid unnecessary jobs
7. **Tag runners** — Match jobs to runner capabilities (Docker, GPU, etc.)
8. **Validate locally** — Test `.gitlab-ci.yml` syntax before pushing
