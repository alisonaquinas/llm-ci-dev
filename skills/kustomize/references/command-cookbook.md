# kustomize — Command Cookbook

## Build Commands

```bash
# Render all resources to stdout
kustomize build ./base
kustomize build ./overlays/production

# Save rendered output to a file
kustomize build ./overlays/production > rendered.yaml

# Build and apply in one pipeline
kustomize build ./overlays/production | kubectl apply -f -

# Build and delete resources
kustomize build ./overlays/production | kubectl delete -f -
```

## Apply with kubectl -k

```bash
# Apply kustomization directly
kubectl apply -k ./overlays/production

# Dry-run apply (preview without making changes)
kubectl apply -k ./overlays/production --dry-run=client

# Server-side dry-run
kubectl apply -k ./overlays/production --dry-run=server
```

## Diff Commands

```bash
# Diff rendered output against live cluster
kubectl diff -k ./overlays/production

# Diff using standalone kustomize + kubectl diff
kustomize build ./overlays/production | kubectl diff -f -
```

## Edit Commands

`kustomize edit` modifies `kustomization.yaml` programmatically:

```bash
# Add a resource
kustomize edit add resource deployment.yaml

# Remove a resource
kustomize edit remove resource deployment.yaml

# Set image override
kustomize edit set image nginx=nginx:1.25.0

# Set image with digest
kustomize edit set image myapp=myregistry.io/myapp@sha256:abc123

# Set namespace
kustomize edit set namespace my-namespace

# Set name prefix
kustomize edit set nameprefix prod-

# Set name suffix
kustomize edit set namesuffix -v2

# Add label
kustomize edit add label env:production

# Add annotation
kustomize edit add annotation managed-by:kustomize
```

## Config Commands

```bash
# Count resources in a kustomization
kustomize cfg count ./overlays/production

# Search for a pattern in rendered manifests
kustomize cfg grep "kind=Deployment" ./base

# Visualize resource tree
kustomize cfg tree ./overlays/production
```

## Function Commands (Transformers)

```bash
# Run KRM functions (alpha)
kustomize fn run ./overlays/production --enable-alpha-plugins

# List available functions
kustomize fn list
```

## Localize

```bash
# Copy remote references locally (for offline builds)
kustomize localize ./overlays/production ./localized-output
```

## Common Workflows

```bash
# Preview production deployment
kustomize build ./overlays/production | less

# Apply and watch rollout
kubectl apply -k ./overlays/production && kubectl rollout status deployment/myapp -n production

# Validate manifests with kubeval or kubeconform
kustomize build ./overlays/production | kubeconform -strict -

# Generate YAML for a GitOps tool
kustomize build ./overlays/production > gitops/rendered-production.yaml
```
