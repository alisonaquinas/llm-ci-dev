# Skaffold — skaffold.yaml Reference

## Top-Level Structure

```yaml
apiVersion: skaffold/v4beta11
kind: Config
metadata:
  name: my-app

build:
  artifacts: []

test: []

deploy:
  kubectl: {}

portForward: []
```

## build.artifacts — Define Images to Build

```yaml
build:
  artifacts:
    - image: gcr.io/my-project/my-app
      context: .
      docker:
        dockerfile: Dockerfile
        buildArgs:
          VERSION: "1.0.0"
```

## Docker Builder

```yaml
build:
  artifacts:
    - image: gcr.io/my-project/api
      docker:
        dockerfile: Dockerfile.prod
        target: production         # multi-stage target
        buildArgs:
          ENV: production
        cacheFrom:
          - gcr.io/my-project/api:cache
```

## Cloud Native Buildpacks (CNB)

```yaml
build:
  artifacts:
    - image: gcr.io/my-project/api
      buildpacks:
        builder: gcr.io/buildpacks/builder:v1
        env:
          - GOOGLE_RUNTIME_VERSION=1.21
```

## Jib Builder (Java/Maven/Gradle)

```yaml
build:
  artifacts:
    - image: gcr.io/my-project/java-app
      jib:
        project: my-module        # Maven module or Gradle subproject
        type: maven               # maven | gradle
```

## Kaniko Builder (In-Cluster Builds)

```yaml
build:
  artifacts:
    - image: gcr.io/my-project/api
      kaniko:
        dockerfile: Dockerfile
  cluster:
    pullSecretPath: /path/to/key.json
    namespace: kaniko
```

## deploy — kubectl Deployer

```yaml
deploy:
  kubectl:
    manifests:
      - k8s/*.yaml
      - k8s/base/*.yaml
```

## deploy — Helm Deployer

```yaml
deploy:
  helm:
    releases:
      - name: my-app
        chartPath: charts/my-app
        valuesFiles:
          - values/dev.yaml
        setValues:
          image.tag: "{{.IMAGE_TAG}}"
```

## deploy — Kustomize Deployer

```yaml
deploy:
  kustomize:
    paths:
      - k8s/overlays/dev
```

## sync — File Sync Without Rebuild

```yaml
build:
  artifacts:
    - image: gcr.io/my-project/api
      sync:
        infer:
          - "**/*.js"
          - "static/**"
        manual:
          - src: "src/**/*.py"
            dest: /app/src
```

## portForward

```yaml
portForward:
  - resourceType: service
    resourceName: my-app
    namespace: default
    port: 8080
    localPort: 8080
```

## test — Container Structure Tests

```yaml
test:
  - image: gcr.io/my-project/api
    structureTests:
      - ./tests/structure-test.yaml
```
