# kustomize — Overlays and Bases

## Base/Overlay Directory Layout

The canonical kustomize structure separates shared base manifests from environment-specific overlays:

```text
k8s/
  base/
    kustomization.yaml
    deployment.yaml
    service.yaml
    configmap.yaml
  overlays/
    dev/
      kustomization.yaml
      patches/
        replicas.yaml
    staging/
      kustomization.yaml
      patches/
        replicas.yaml
        env-vars.yaml
    production/
      kustomization.yaml
      patches/
        replicas.yaml
        resources.yaml
        env-vars.yaml
```

## Base kustomization.yaml

```yaml
# base/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - deployment.yaml
  - service.yaml
  - configmap.yaml
```

## Overlay kustomization.yaml (Development)

```yaml
# overlays/dev/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - ../../base

namespace: dev

namePrefix: dev-

images:
  - name: myapp
    newTag: "latest"

patches:
  - path: patches/replicas.yaml
    target:
      kind: Deployment
      name: myapp
```

## Overlay kustomization.yaml (Production)

```yaml
# overlays/production/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - ../../base

namespace: production

images:
  - name: myapp
    newTag: "v1.5.0"

patches:
  - path: patches/replicas.yaml
  - path: patches/resources.yaml
  - path: patches/env-vars.yaml

configMapGenerator:
  - name: app-config
    behavior: merge
    literals:
      - ENV=production
      - LOG_LEVEL=warn
```

## Strategic Merge Patch Examples

Patch to increase replicas for production:

```yaml
# overlays/production/patches/replicas.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  replicas: 5
```

Patch to add resource limits:

```yaml
# overlays/production/patches/resources.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  template:
    spec:
      containers:
        - name: myapp
          resources:
            requests:
              cpu: 500m
              memory: 512Mi
            limits:
              cpu: "2"
              memory: 2Gi
```

## JSON Patch (RFC 6902) Syntax

More surgical than strategic merge; operates on specific paths:

```yaml
# overlays/production/patches/env-vars.yaml (used with patchesJson6902)
- op: replace
  path: /spec/template/spec/containers/0/env/0/value
  value: "production"
- op: add
  path: /spec/template/spec/containers/0/env/-
  value:
    name: FEATURE_FLAG
    value: "enabled"
- op: remove
  path: /spec/template/spec/containers/0/env/2
```

## components: for Reusable Cross-Cutting Config

Components allow reusable configuration shared across multiple overlays:

```yaml
# components/monitoring/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1alpha1
kind: Component

resources:
  - servicemonitor.yaml

patches:
  - patch: |-
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: not-important
      spec:
        template:
          metadata:
            annotations:
              prometheus.io/scrape: "true"
              prometheus.io/port: "8080"
    target:
      kind: Deployment
```

Reference components in overlays:

```yaml
# overlays/production/kustomization.yaml
resources:
  - ../../base

components:
  - ../../components/monitoring
  - ../../components/autoscaling
```

## Multi-Base Overlays

An overlay can reference multiple bases:

```yaml
# overlays/full-stack/kustomization.yaml
resources:
  - ../../apps/frontend/base
  - ../../apps/backend/base
  - ../../apps/database/base

namespace: full-stack
```

## GitOps Integration

### FluxCD

FluxCD references kustomize directories via `Kustomization` CRDs:

```yaml
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: myapp-production
  namespace: flux-system
spec:
  interval: 5m
  path: ./k8s/overlays/production
  prune: true
  sourceRef:
    kind: GitRepository
    name: myapp-repo
  targetNamespace: production
```

### ArgoCD

ArgoCD references kustomize directories in Application CRDs:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: myapp-production
  namespace: argocd
spec:
  source:
    repoURL: https://github.com/myorg/myapp
    targetRevision: main
    path: k8s/overlays/production
  destination:
    server: https://kubernetes.default.svc
    namespace: production
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

## Build Output Inspection Workflow

Before applying to a live cluster, always inspect build output:

```bash
# Step 1: render and review
kustomize build ./overlays/production | less

# Step 2: count resources
kustomize build ./overlays/production | grep "^kind:" | sort | uniq -c

# Step 3: validate with kubeconform
kustomize build ./overlays/production | kubeconform -strict -

# Step 4: diff against cluster
kubectl diff -k ./overlays/production

# Step 5: apply
kubectl apply -k ./overlays/production
```
