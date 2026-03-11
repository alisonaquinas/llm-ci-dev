# Flux — Install and Setup

## Install flux CLI

### Linux/macOS (curl)

```bash
curl -s https://fluxcd.io/install.sh | sudo bash
flux version
```

### macOS (Homebrew)

```bash
brew install fluxcd/tap/flux
flux version
```

### Debian/Ubuntu (apt)

```bash
curl -s https://fluxcd.io/install.sh | sudo bash
# Or via the official package repo:
curl -fsSL https://pkgs.fluxcd.io/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/fluxcd.gpg
echo "deb [signed-by=/etc/apt/keyrings/fluxcd.gpg] https://pkgs.fluxcd.io/ stable main" | sudo tee /etc/apt/sources.list.d/fluxcd.list
sudo apt-get update && sudo apt-get install -y flux
```

### asdf plugin

```bash
asdf plugin add flux2 https://github.com/tablexi/asdf-flux2.git
asdf install flux2 latest
asdf global flux2 latest
```

## Verify Installation

```bash
flux version
flux --version
```

## Check Prerequisites Before Bootstrap

```bash
# Verify cluster access and Flux compatibility
flux check --pre
```

This checks kubectl connectivity, Kubernetes version compatibility, and required RBAC permissions.

## Bootstrap — GitHub

```bash
export GITHUB_TOKEN=ghp_...

flux bootstrap github \
  --owner=my-org \
  --repository=my-fleet-repo \
  --path=clusters/my-cluster \
  --personal                  # omit for org repos; use --team instead
```

### Common bootstrap flags

| Flag | Purpose |
| --- | --- |
| `--owner` | GitHub user or org name |
| `--repository` | Repository name (created if missing) |
| `--path` | Path in the repo where flux-system/ will be committed |
| `--personal` | Use a personal (user-owned) repository |
| `--branch` | Branch to use (default: main) |
| `--token-auth` | Use PAT token auth instead of deploy keys |

## Bootstrap — GitLab

```bash
export GITLAB_TOKEN=glpat-...

flux bootstrap gitlab \
  --owner=my-group \
  --repository=my-fleet-repo \
  --path=clusters/my-cluster \
  --branch=main
```

## Generated Files in Git

After bootstrap, Flux commits the following to the fleet repo:

```text
clusters/my-cluster/
└── flux-system/
    ├── gotk-components.yaml   # Flux controllers and CRDs
    ├── gotk-sync.yaml         # GitRepository + Kustomization pointing to clusters/my-cluster
    └── kustomization.yaml
```

## FLUX_SYSTEM_NAMESPACE

The default namespace for Flux controllers is `flux-system`. Override with:

```bash
export FLUX_SYSTEM_NAMESPACE=flux-system
```

## Verify After Bootstrap

```bash
# Check all Flux controllers are healthy
flux check

# Show all managed sources and workloads
flux get all

# Watch reconciliation in real time
flux get kustomizations --watch
```

## Shell Completion

```bash
# bash
echo 'source <(flux completion bash)' >> ~/.bashrc

# zsh
echo 'source <(flux completion zsh)' >> ~/.zshrc
```
