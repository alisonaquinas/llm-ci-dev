# kustomize — Kustomization Structure

## kustomization.yaml Anatomy

The `kustomization.yaml` file is the entry point for kustomize. It declares which resources to include and what transformations to apply.

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

# Resources to include
resources:
  - deployment.yaml
  - service.yaml
  - ../base               # reference a base directory

# Namespace to apply to all resources
namespace: my-namespace

# Name prefix/suffix for all resources
namePrefix: prod-
nameSuffix: -v2

# Common labels added to all resources
commonLabels:
  app: myapp
  env: production

# Common annotations added to all resources
commonAnnotations:
  managed-by: kustomize
  team: platform
```

## resources: List

```yaml
resources:
  - deployment.yaml
  - service.yaml
  - configmap.yaml
  - ../base                          # relative path to base
  - https://example.com/manifest.yaml  # remote resource (use with caution)
  - github.com/org/repo//path?ref=main # GitHub resource
```

## images: Overrides

Override image names and tags without modifying base manifests:

```yaml
images:
  - name: nginx                        # match this image name
    newTag: "1.25.3"                   # set new tag

  - name: myapp                        # match this image name
    newName: myregistry.io/myapp       # set new registry/name
    newTag: "v2.1.0"

  - name: myapp
    digest: sha256:abc123def456        # pin to digest (immutable)
```

## configMapGenerator

Generate ConfigMaps from literals, files, or env files:

```yaml
configMapGenerator:
  - name: app-config
    literals:
      - ENV=production
      - LOG_LEVEL=info

  - name: nginx-config
    files:
      - nginx.conf                     # key = filename, value = file content
      - config.yaml=my-config.yaml     # key = config.yaml, value from my-config.yaml

  - name: env-config
    envs:
      - .env.production                # parse KEY=VALUE pairs

  - name: merged-config
    literals:
      - EXTRA_KEY=value
    files:
      - app.properties
    options:
      disableNameSuffixHash: true      # disable hash suffix in ConfigMap name
```

## secretGenerator

Generate Secrets (values are base64 encoded automatically):

```yaml
secretGenerator:
  - name: db-secret
    literals:
      - DB_PASSWORD=mysecretpassword
      - DB_USER=admin

  - name: tls-secret
    type: kubernetes.io/tls
    files:
      - tls.crt
      - tls.key

  - name: env-secret
    envs:
      - .env.secret                    # KEY=VALUE pairs — exclude from VCS!
    options:
      disableNameSuffixHash: true
```

## patches: (Inline Strategic Merge Patch)

Inline patches without separate patch files:

```yaml
patches:
  - patch: |-
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: myapp
      spec:
        replicas: 3
    target:
      kind: Deployment
      name: myapp

  - patch: |-
      - op: replace
        path: /spec/replicas
        value: 5
    target:
      kind: Deployment
      name: myapp
    options:
      allowNameChange: false
```

## patchesStrategicMerge

Reference external patch files (strategic merge):

```yaml
patchesStrategicMerge:
  - patches/increase-replicas.yaml
  - patches/add-env-vars.yaml
```

Example patch file `patches/increase-replicas.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  replicas: 5
```

## patchesJson6902

JSON patch (RFC 6902) — precise surgical edits:

```yaml
patchesJson6902:
  - target:
      group: apps
      version: v1
      kind: Deployment
      name: myapp
    path: patches/replica-patch.yaml
```

Example `patches/replica-patch.yaml`:

```yaml
- op: replace
  path: /spec/replicas
  value: 5
- op: add
  path: /spec/template/spec/containers/0/env/-
  value:
    name: DEBUG
    value: "true"
```

## replacements

Replace field values from one resource into another (replaces deprecated `vars:`):

```yaml
replacements:
  - source:
      kind: Service
      name: myapp
      fieldPath: spec.ports.0.port
    targets:
      - select:
          kind: ConfigMap
          name: app-config
        fieldPaths:
          - data.SERVICE_PORT
```

## namePrefix and nameSuffix

Prefix or suffix names of all resources to avoid collisions between environments:

```yaml
namePrefix: production-
# Result: deployment "myapp" becomes "production-myapp"

nameSuffix: -v2
# Result: deployment "myapp" becomes "myapp-v2"
```
