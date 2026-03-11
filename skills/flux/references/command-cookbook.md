# Flux — Command Cookbook

## Status Commands

```bash
# Show all sources and workloads
flux get all

# Show all GitRepository sources
flux get sources git

# Show all HelmRepository sources
flux get sources helm

# Show all OCI sources
flux get sources oci

# Show all Kustomizations
flux get kustomizations

# Show all HelmReleases
flux get helmreleases

# Watch kustomizations until ready
flux get kustomizations --watch
```

## Reconcile Commands

```bash
# Force sync a GitRepository source from remote
flux reconcile source git flux-system

# Force reconcile a Kustomization
flux reconcile kustomization flux-system

# Force reconcile a HelmRelease
flux reconcile helmrelease my-app -n my-namespace

# Reconcile with output
flux reconcile source git my-app-source --verbose
```

## Suspend and Resume

```bash
# Suspend a Kustomization (stops automatic reconciliation)
flux suspend kustomization my-app

# Resume a suspended Kustomization
flux resume kustomization my-app

# Suspend a HelmRelease
flux suspend helmrelease my-app -n my-namespace

# Resume a HelmRelease
flux resume helmrelease my-app -n my-namespace
```

## Diff — Preview Changes

```bash
# Show what a Kustomization would change before committing to git
flux diff kustomization my-app

# Diff using a local directory instead of the current live state
flux diff kustomization my-app --path=./clusters/staging
```

## Events

```bash
# Show recent events from all Flux objects
flux events

# Show events for a specific Kustomization
flux events --for Kustomization/my-app

# Show events for a specific HelmRelease
flux events --for HelmRelease/my-app -n my-namespace
```

## Logs

```bash
# Stream logs from all Flux controllers
flux logs

# Stream logs from a specific controller
flux logs --source=kustomize-controller
flux logs --source=helm-controller

# Follow logs
flux logs -f
```

## Create Secrets

```bash
# Create a Git SSH secret for a private repo
flux create secret git my-git-credentials \
  --url=ssh://git@github.com/my-org/my-repo \
  --private-key-file=~/.ssh/id_rsa

# Create a Helm OCI credentials secret
flux create secret helm my-registry-credentials \
  --username=my-user \
  --password=my-password

# Create a generic TLS secret
flux create secret tls my-tls-secret \
  --cert-file=tls.crt \
  --key-file=tls.key
```

## Export

```bash
# Export a Kustomization manifest as YAML
flux export kustomization my-app

# Export a HelmRelease manifest as YAML
flux export helmrelease my-app -n my-namespace

# Export all sources
flux export source git --all
```

## Uninstall

```bash
# Remove all Flux components from the cluster (keeps CRDs by default)
flux uninstall

# Remove Flux components and all CRDs
flux uninstall --crds
```
