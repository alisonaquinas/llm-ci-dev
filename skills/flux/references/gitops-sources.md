# Flux — GitOps Sources

## GitRepository CRD

Watches a Git repository and makes its contents available to Kustomizations.

```yaml
apiVersion: source.toolkit.fluxcd.io/v1
kind: GitRepository
metadata:
  name: my-app
  namespace: flux-system
spec:
  interval: 1m
  url: https://github.com/my-org/my-app
  ref:
    branch: main
  secretRef:
    name: my-git-credentials   # optional for private repos
```

### Create via CLI

```bash
flux create source git my-app \
  --url=https://github.com/my-org/my-app \
  --branch=main \
  --interval=1m
```

## HelmRepository CRD

Indexes a Helm chart repository (HTTP or OCI).

```yaml
# HTTP chart repository
apiVersion: source.toolkit.fluxcd.io/v1
kind: HelmRepository
metadata:
  name: bitnami
  namespace: flux-system
spec:
  interval: 1h
  url: https://charts.bitnami.com/bitnami

---
# OCI chart registry
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: my-oci-registry
  namespace: flux-system
spec:
  type: oci
  interval: 1h
  url: oci://ghcr.io/my-org/helm-charts
  secretRef:
    name: my-registry-credentials
```

## OCIRepository CRD

Watches an OCI artifact (image or Helm chart) on a container registry.

```yaml
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: OCIRepository
metadata:
  name: my-app-manifests
  namespace: flux-system
spec:
  interval: 5m
  url: oci://ghcr.io/my-org/manifests
  ref:
    tag: latest
  secretRef:
    name: ghcr-credentials
```

## Bucket (S3-compatible)

```yaml
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: Bucket
metadata:
  name: my-bucket
  namespace: flux-system
spec:
  interval: 5m
  provider: aws            # aws | gcp | azure | generic
  bucketName: my-flux-bucket
  endpoint: s3.amazonaws.com
  region: us-east-1
  secretRef:
    name: s3-credentials
```

## ImageRepository and ImagePolicy — Automated Image Updates

```yaml
# Watch a container registry for new tags
apiVersion: image.toolkit.fluxcd.io/v1beta2
kind: ImageRepository
metadata:
  name: my-app
  namespace: flux-system
spec:
  interval: 1m
  image: ghcr.io/my-org/my-app
  secretRef:
    name: ghcr-credentials

---
# Select which tag to use based on a semver policy
apiVersion: image.toolkit.fluxcd.io/v1beta2
kind: ImagePolicy
metadata:
  name: my-app
  namespace: flux-system
spec:
  imageRepositoryRef:
    name: my-app
  policy:
    semver:
      range: ">=1.0.0 <2.0.0"
```

## ImageUpdateAutomation — Git Write-Back

```yaml
apiVersion: image.toolkit.fluxcd.io/v1beta1
kind: ImageUpdateAutomation
metadata:
  name: flux-system
  namespace: flux-system
spec:
  interval: 30m
  sourceRef:
    kind: GitRepository
    name: flux-system
  git:
    commit:
      author:
        name: Flux
        email: flux@example.com
    push:
      branch: main
  update:
    strategy: Setters
```

## Secret Types by Source

| Source | Secret type | Fields |
| --- | --- | --- |
| GitRepository (HTTPS) | `Opaque` | `username`, `password` |
| GitRepository (SSH) | `Opaque` | `identity`, `identity.pub`, `known_hosts` |
| HelmRepository (OCI) | `kubernetes.io/dockerconfigjson` | registry credentials |
| OCIRepository | `kubernetes.io/dockerconfigjson` | registry credentials |
| Bucket (AWS) | `Opaque` | `accesskey`, `secretkey` |

```bash
# Create a Git HTTP basic auth secret
flux create secret git my-git-credentials \
  --url=https://github.com/my-org/private-repo \
  --username=my-user \
  --password=ghp_...
```
