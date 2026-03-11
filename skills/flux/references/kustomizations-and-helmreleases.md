# Flux — Kustomizations and HelmReleases

## Kustomization CRD

Flux Kustomization reconciles a path inside a GitRepository (or OCIRepository) as a Kustomize overlay.

```yaml
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: my-app
  namespace: flux-system
spec:
  interval: 5m
  sourceRef:
    kind: GitRepository
    name: flux-system
  path: ./clusters/production/my-app
  prune: true
  targetNamespace: my-app
  dependsOn:
    - name: infrastructure
  healthChecks:
    - apiVersion: apps/v1
      kind: Deployment
      name: my-app
      namespace: my-app
  postBuild:
    substituteFrom:
      - kind: ConfigMap
        name: cluster-vars
      - kind: Secret
        name: cluster-secrets
```

### Key Kustomization Fields

| Field | Purpose |
| --- | --- |
| `sourceRef` | Which GitRepository/OCIRepository/Bucket to reconcile from |
| `path` | Path within the source to the kustomization root |
| `prune` | Delete resources removed from git (set `true` carefully) |
| `interval` | How often to reconcile (e.g. `5m`, `1h`) |
| `targetNamespace` | Override namespace for all resources |
| `dependsOn` | Wait for these Kustomizations before reconciling |
| `healthChecks` | Resources to check for readiness before marking Ready |
| `postBuild.substituteFrom` | Variable substitution from ConfigMap or Secret |

### postBuild Variable Substitution

```yaml
# ConfigMap referenced by substituteFrom
apiVersion: v1
kind: ConfigMap
metadata:
  name: cluster-vars
  namespace: flux-system
data:
  CLUSTER_REGION: us-east-1
  APP_VERSION: "1.5.0"
```

In your Kustomize overlay, reference variables with `${VAR_NAME}`:

```yaml
# k8s/deployment.yaml
env:
  - name: REGION
    value: ${CLUSTER_REGION}
```

## HelmRelease CRD

Flux HelmRelease installs or upgrades a Helm chart from a HelmRepository.

```yaml
apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: my-app
  namespace: my-app
spec:
  interval: 5m
  chart:
    spec:
      chart: my-app
      version: ">=1.0.0 <2.0.0"
      sourceRef:
        kind: HelmRepository
        name: my-registry
        namespace: flux-system
  targetNamespace: my-app
  values:
    replicaCount: 2
    image:
      tag: "1.5.0"
  valuesFrom:
    - kind: ConfigMap
      name: my-app-values
    - kind: Secret
      name: my-app-secrets
      valuesKey: values.yaml
  install:
    remediation:
      retries: 3
  upgrade:
    remediation:
      retries: 3
      remediateLastFailure: true
  rollback:
    timeout: 5m
  dependsOn:
    - name: cert-manager
      namespace: cert-manager
```

### Key HelmRelease Fields

| Field | Purpose |
| --- | --- |
| `chart.spec.chart` | Chart name in the HelmRepository |
| `chart.spec.version` | Semver constraint for chart version |
| `chart.spec.sourceRef` | Reference to HelmRepository |
| `values` | Inline Helm values |
| `valuesFrom` | Reference external ConfigMap or Secret for values |
| `targetNamespace` | Namespace to install the release into |
| `dependsOn` | Wait for these HelmReleases before reconciling |
| `install.remediation.retries` | Retry count for failed installs |
| `upgrade.remediation.retries` | Retry count for failed upgrades |

## dependsOn — Ordering

Use `dependsOn` to prevent reconciliation race conditions:

```yaml
# infrastructure/kustomization.yaml
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: infrastructure
  namespace: flux-system
spec:
  # ... installs CRDs and namespaces

---
# apps/kustomization.yaml — waits for infrastructure to be Ready
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: apps
  namespace: flux-system
spec:
  dependsOn:
    - name: infrastructure
```

## flux diff kustomization Workflow

```bash
# 1. Make changes to manifests in your local clone
vim clusters/production/my-app/deployment.yaml

# 2. Preview what the cluster would change without committing
flux diff kustomization my-app --path=./clusters/production/my-app

# 3. If the diff looks correct, commit and push
git add . && git commit -m "chore: bump my-app to 1.5.0"
git push

# 4. Watch reconciliation
flux get kustomization my-app --watch
```

## Multi-Tenancy and Namespace Isolation

```yaml
# Tenant Kustomization scoped to its own namespace
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: team-alpha
  namespace: flux-system
spec:
  serviceAccountName: team-alpha-reconciler  # limited RBAC
  targetNamespace: team-alpha
  sourceRef:
    kind: GitRepository
    name: team-alpha-repo
  path: ./deploy
  prune: true
```

Grant the service account only the permissions needed for the tenant's namespace to enforce isolation.
