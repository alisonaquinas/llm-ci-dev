# Runners & Caching — Execution Environments and Performance Optimization

## Overview

GitLab Runners execute jobs in isolated environments (Docker, VMs, or shell).
Selecting the right executor, tagging runners, and optimizing caching improves pipeline speed and reliability.

---

## Runner Types and Executors

### Executor Types

| Executor | Environment | Use Case |
| --- | --- | --- |
| `docker` | Docker container | Most projects; clean isolated environment |
| `shell` | Host shell (bash/cmd) | Direct file system access; debugging |
| `kubernetes` | Kubernetes pod | Cloud-native deployments |
| `parallels` | macOS VM | iOS/macOS builds |
| `virtualbox` | Linux VM | Full OS isolation |

### Docker Executor (Recommended)

Runs jobs in isolated Docker containers. Each job pulls a base image, installs dependencies, and executes the script.

```yaml
test:
  image: node:18
  script:
    - npm ci
    - npm run test
```

The agent runs in a container derived from `node:18`, with a clean filesystem for each job.

#### Specifying Images

```yaml
# Official image from Docker Hub
build_node:
  image: node:18
  script: npm run build

# Private registry
build_custom:
  image: registry.example.com/myapp:latest
  script: ./build.sh

# Image with tag
test_python:
  image: python:3.11-slim
  script: pytest
```

#### Image Pulling Policies

Control when images are pulled:

```yaml
test:
  image: myregistry.com/myimage:latest
  # Always pull latest from registry
  image:
    name: myregistry.com/myimage:latest
    pull_policy: always
  script: pytest
```

Policies:

- `always` — Always pull from registry
- `if-not-present` — Use local cache if available
- `never` — Use local cache; fail if not available

### Shell Executor

Runs jobs directly on the host machine (no Docker isolation):

```yaml
# Runner configured with shell executor
build:
  tags:
    - shell
  script:
    - make build
    - ./deploy.sh
```

Useful for:

- Debugging (direct access to host filesystem)
- Jobs requiring specific host software
- Legacy CI/CD workflows

Downside: No isolation; job failure can affect host state.

---

## Runner Tags and Selection

### Tagging Runners

Assign tags when registering a runner:

```bash
gitlab-runner register \
  --url https://gitlab.example.com \
  --registration-token <token> \
  --executor docker \
  --docker-image ubuntu:22.04 \
  --tags docker,ubuntu,build
```

Or edit runner configuration directly:

```toml
# /etc/gitlab-runner/config.toml
[[runners]]
  token = "glrt_abc123"
  tags = ["docker", "ubuntu", "build"]
```

### Using Tags in Jobs

Specify runner selection via tags:

```yaml
build_linux:
  stage: build
  tags:
    - docker
    - ubuntu
  script: make build

build_macos:
  stage: build
  tags:
    - macos
    - shell
  script: make build

gpu_test:
  stage: test
  tags:
    - gpu
    - cuda-11
  script: ./run_gpu_test.sh
```

Runner must have ALL listed tags to be selected.

### Tag-Based Runner Groups

Organize runners by capability:

```yaml
# Docker runners
docker_runners:
  tags: [ docker ]

# macOS runners
macos_runners:
  tags: [ macos ]

# GPU runners
gpu_runners:
  tags: [ gpu, cuda ]

# Shell runners (direct access)
shell_runners:
  tags: [ shell ]
```

---

## Caching Strategy

### Cache Basics

Persist data between job runs to speed up subsequent executions:

```yaml
build:
  stage: build
  cache:
    paths:
      - node_modules/
      - .gradle/
  script:
    - npm ci
    - npm run build
```

Cache is stored on the runner and shared across jobs with the same cache key.

### Cache Keys

#### Default Key

All jobs use the same cache:

```yaml
cache:
  paths:
    - vendor/
```

#### Branch-Specific Key

Different cache per branch:

```yaml
cache:
  key: $CI_COMMIT_REF_SLUG
  paths:
    - node_modules/
```

- `$CI_COMMIT_REF_SLUG` — Sanitized branch name (e.g., `feature-branch` for `feature/branch`)

#### Job-Specific Key

Different cache per job:

```yaml
cache:
  key: $CI_JOB_NAME
  paths:
    - build/
```

#### File-Based Key

Cache depends on a file's checksum (invalidate on dependency changes):

```yaml
cache:
  key:
    files:
      - package-lock.json
  paths:
    - node_modules/
```

When `package-lock.json` changes, the cache key changes; a new cache is created.

#### Composite Key

Combine multiple variables:

```yaml
cache:
  key: $CI_COMMIT_REF_SLUG-$CI_PIPELINE_ID
  paths:
    - .gradle/
```

### Cache Policies

#### Pull and Push (Default)

```yaml
build:
  cache:
    key: deps
    paths:
      - node_modules/
    policy: pull-push  # Download on start, upload on finish
  script:
    - npm ci
    - npm run build
```

#### Pull Only

Download cache but do not upload changes:

```yaml
test:
  cache:
    key: deps
    paths:
      - node_modules/
    policy: pull  # Do not update cache after job
  script:
    - npm test
```

Useful for read-only jobs (e.g., testing) to avoid cache conflicts.

#### No Cache

Disable caching for a job:

```yaml
test:
  cache: {}
  script: npm test
```

### Shared vs. Local Cache

#### Shared Cache (Default)

Cache shared across jobs and runners (if using same storage):

```yaml
cache:
  paths:
    - build/
```

#### Local Cache

Cache stored locally on the runner (not shared):

```yaml
# Runner configuration: /etc/gitlab-runner/config.toml
[runners.cache]
  type = "local"
  path = "/var/cache/gitlab-runner"
  shared = false
```

---

## Artifacts and Cache Differences

| Aspect | Artifacts | Cache |
| --- | --- | --- |
| Purpose | Store build outputs | Speed up subsequent jobs |
| Persistence | Days/weeks (configured) | As long as cache isn't invalidated |
| Sharing | Across pipeline stages | Same stage/job across runs |
| Download | Via GitLab UI | Automatic at job start |
| Size | No built-in limit | Size depends on runner configuration |

### Example: Build and Test Pipeline

```yaml
build:
  stage: build
  cache:
    key: deps-$CI_COMMIT_REF_SLUG
    paths:
      - node_modules/
  artifacts:
    paths:
      - dist/
    expire_in: 1 week
  script:
    - npm ci
    - npm run build

test:
  stage: test
  cache:
    key: deps-$CI_COMMIT_REF_SLUG
    policy: pull  # Reuse cache from build job
  dependencies:
    - build
  script:
    - npm test
```

- `build` job caches `node_modules/` and artifacts `dist/`
- `test` job pulls cache (no npm ci needed) and downloads artifacts from `build`

---

## Docker-in-Docker (DinD)

Run Docker commands within a Docker job (e.g., build Docker images):

### Basic DinD Setup

```yaml
build_image:
  stage: build
  image: docker:latest
  services:
    - docker:dind
  script:
    - docker build -t myimage:$CI_COMMIT_SHA .
    - docker push myimage:$CI_COMMIT_SHA
```

The `docker:dind` service starts a Docker daemon accessible as `tcp://docker:2375`.

### Using Docker Registry Credentials

```yaml
push_image:
  stage: build
  image: docker:latest
  services:
    - docker:dind
  before_script:
    - echo $CI_REGISTRY_PASSWORD | docker login -u $CI_REGISTRY_USER --password-stdin $CI_REGISTRY
  script:
    - docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA .
    - docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
```

Variables:

- `$CI_REGISTRY` — GitLab Registry hostname (registry.gitlab.com)
- `$CI_REGISTRY_IMAGE` — Full image path (registry.gitlab.com/group/project)
- `$CI_REGISTRY_USER` — Deployed as read-write token
- `$CI_REGISTRY_PASSWORD` — Deployed as token password (masked)

### DinD with TLS

Secure Docker daemon connection:

```yaml
image: docker:latest
services:
  - docker:dind
variables:
  DOCKER_HOST: tcp://docker:2376
  DOCKER_TLS_CERTDIR: /certs
script:
  - docker build -t myimage .
```

---

## Service Containers

Run additional services (databases, caches, message queues) alongside the job:

### PostgreSQL Service

```yaml
test:
  stage: test
  image: node:18
  services:
    - postgres:14
  variables:
    POSTGRES_PASSWORD: secret
    POSTGRES_DB: testdb
  script:
    - npm run test:db
```

Service is accessible at hostname `postgres` on port 5432.

### Redis Service

```yaml
test:
  image: python:3.11
  services:
    - redis:7
  variables:
    REDIS_HOST: redis
    REDIS_PORT: 6379
  script:
    - pytest tests/
```

### Custom Service Image

```yaml
integration_test:
  image: node:18
  services:
    - image: registry.example.com/custom-db:latest
      alias: database
      variables:
        DB_PASS: secret
  script:
    - npm run integration-test
```

Service accessible as `database` hostname.

### Multiple Services

```yaml
test:
  image: python:3.11
  services:
    - postgres:14
    - redis:7
    - elasticsearch:8
  variables:
    POSTGRES_DB: test
  script:
    - python -m pytest
```

All services are accessible by their hostname (postgres, redis, elasticsearch).

---

## Performance Optimization

### Cache Invalidation

Automatically invalidate cache when dependencies change:

```yaml
build:
  cache:
    key:
      files:
        - package-lock.json
        - poetry.lock
      prefix: $CI_COMMIT_REF_SLUG
    paths:
      - node_modules/
      - .venv/
  script:
    - npm ci
    - npm run build
```

### Parallel Builds with Caching

```yaml
test:
  stage: test
  parallel: 4
  cache:
    key: deps-$CI_COMMIT_REF_SLUG
    policy: pull
  script:
    - npm run test -- --shard=$CI_NODE_INDEX/$CI_NODE_TOTAL
```

All parallel jobs share the same cache; `policy: pull` prevents race conditions.

### Distributed Caching

For large teams, use distributed cache storage:

```toml
# /etc/gitlab-runner/config.toml
[runners.cache]
  type = "s3"
  s3:
    server_address = "https://s3.amazonaws.com"
    access_key = "key"
    secret_key = "secret"
    bucket_name = "gitlab-cache"
    bucket_location = "us-east-1"
```

---

## Best Practices

1. **Use `key:files`** — Invalidate cache automatically on dependency changes
2. **Cache aggressively** — Node_modules, .gradle, .m2, venv, etc.
3. **Set `policy: pull` for read-only jobs** — Prevent cache conflicts
4. **Use DinD for image builds** — Build and push Docker images in CI/CD
5. **Limit service containers** — Only include required services
6. **Tag runners by capability** — GPU, Docker, shell, etc.
7. **Monitor cache size** — Prevent runner disk bloat; set cleanup policies
8. **Use distributed cache for large teams** — S3, MinIO, or similar
