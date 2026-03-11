# kustomize — Install and Setup

## Install Standalone Binary

### Linux (curl)

```bash
KUSTOMIZE_VERSION=$(curl -s https://api.github.com/repos/kubernetes-sigs/kustomize/releases/latest | grep tag_name | cut -d'"' -f4 | sed 's/kustomize\///')
curl -sLO "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_linux_amd64.tar.gz"
tar -xzf kustomize_${KUSTOMIZE_VERSION}_linux_amd64.tar.gz
sudo mv kustomize /usr/local/bin/kustomize
kustomize version
```

### macOS (Homebrew)

```bash
brew install kustomize
kustomize version
```

### Debian/Ubuntu (apt)

```bash
# Via Homebrew on Linux (recommended)
brew install kustomize

# Or via binary download (see Linux/curl above)
```

### Windows (choco)

```powershell
choco install kustomize
kustomize version
```

## Verify Installation

```bash
kustomize version
# Output: {Version:kustomize/v5.x.x ...}
```

## kubectl Built-in Kustomize

kubectl ships with a bundled version of kustomize accessible via `-k`:

```bash
# Apply using kubectl built-in kustomize
kubectl apply -k ./overlays/production

# Build using kubectl built-in kustomize
kubectl kustomize ./overlays/production

# Diff using kubectl built-in kustomize
kubectl diff -k ./overlays/production
```

## Version Mismatch Note

The kustomize version bundled with `kubectl` may lag behind the standalone binary. Check both:

```bash
kustomize version           # standalone binary
kubectl version --client    # kubectl (bundled kustomize version shown in verbose mode)
```

If your `kustomization.yaml` uses features from a newer kustomize version, use the standalone binary and pipe output to kubectl:

```bash
kustomize build ./overlays/production | kubectl apply -f -
```

## KUSTOMIZE_PLUGIN_HOME

For exec or Go plugins, set the plugin home directory:

```bash
export KUSTOMIZE_PLUGIN_HOME=~/.config/kustomize/plugin

# Enable alpha plugins (required for some transformers)
kustomize build --enable-alpha-plugins ./overlays/production
```

## Basic Verification

```bash
# Build from current directory (must contain kustomization.yaml)
kustomize build .

# Build a specific directory
kustomize build ./base

# Build and count resources
kustomize build ./base | kubectl apply --dry-run=client -f - 2>&1 | grep "configured\|created\|unchanged"
```
