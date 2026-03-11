# Skaffold — Profiles and CI Integration

## Profiles Overview

Profiles allow environment-specific configuration overrides without duplicating the base `skaffold.yaml`.

```yaml
profiles:
  - name: dev
    build:
      artifacts:
        - image: gcr.io/my-project/api
          docker:
            dockerfile: Dockerfile.dev
    deploy:
      kubectl:
        manifests:
          - k8s/overlays/dev/*.yaml

  - name: prod
    build:
      artifacts:
        - image: gcr.io/my-project/api
          kaniko: {}
    deploy:
      helm:
        releases:
          - name: my-app
            chartPath: charts/my-app
            valuesFiles:
              - values/prod.yaml
```

## Profile Activation

```bash
# Activate by CLI flag
skaffold run --profile=prod

# Activate by environment variable
SKAFFOLD_PROFILE=prod skaffold run

# Activate by kubeContext (automatic)
profiles:
  - name: prod
    activation:
      - kubeContext: my-prod-cluster
```

## Patches Within Profiles

Use `patches` to make surgical overrides to the base config:

```yaml
profiles:
  - name: staging
    patches:
      - op: replace
        path: /build/artifacts/0/docker/dockerfile
        value: Dockerfile.staging
      - op: add
        path: /deploy/kubectl/manifests/-
        value: k8s/overlays/staging/patch.yaml
```

## Artifact Caching

```bash
# Enable caching to skip rebuilds when source hasn't changed
skaffold run --cache-artifacts

# Disable caching (always rebuild)
skaffold run --no-prune=false --cache-artifacts=false
```

```yaml
# In skaffold.yaml
build:
  local:
    useDockerCLI: true
    useBuildkit: true
```

## CI Integration — GitHub Actions

```yaml
# .github/workflows/deploy.yaml
name: Deploy
on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Set up Cloud SDK
        uses: google-github-actions/setup-gcloud@v2

      - name: Configure Docker
        run: gcloud auth configure-docker

      - name: Install Skaffold
        run: |
          curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64
          chmod +x skaffold && sudo mv skaffold /usr/local/bin/skaffold

      - name: Deploy
        run: skaffold run --profile=prod --status-check
        env:
          SKAFFOLD_DEFAULT_REPO: gcr.io/${{ secrets.GCP_PROJECT_ID }}
```

## CI Integration — GitLab CI

```yaml
# .gitlab-ci.yml
deploy:
  stage: deploy
  image: google/cloud-sdk:slim
  script:
    - curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64
    - chmod +x skaffold && mv skaffold /usr/local/bin/
    - gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS
    - gcloud auth configure-docker --quiet
    - skaffold run --profile=prod --status-check
  only:
    - main
```

## Status Check

```bash
# Wait for all deployments to roll out successfully before exiting
skaffold run --status-check

# Set a custom timeout for status check (default: 10 minutes)
skaffold run --status-check --status-check-deadline=300
```

## Cleanup Control

```bash
# Disable automatic resource pruning after skaffold dev exits
SKAFFOLD_NO_PRUNE=true skaffold dev

# Equivalent flag
skaffold dev --no-prune
```

## Multi-Module Repos

Use `requires:` to compose multiple `skaffold.yaml` files:

```yaml
# Root skaffold.yaml
apiVersion: skaffold/v4beta11
kind: Config
metadata:
  name: root

requires:
  - path: services/api
    configs: [api]
  - path: services/frontend
    configs: [frontend]
```

Each sub-module has its own `skaffold.yaml` with its own `metadata.name` to reference.
