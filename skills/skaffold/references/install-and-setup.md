# Skaffold — Install and Setup

## Install by Platform

### Linux (curl binary)

```bash
# Download latest stable release
curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64
chmod +x skaffold
sudo mv skaffold /usr/local/bin/skaffold
skaffold version
```

### macOS (Homebrew)

```bash
brew install skaffold
skaffold version
```

### Debian/Ubuntu (apt)

```bash
sudo apt-get install -y apt-transport-https gnupg
curl -fsSL https://storage.googleapis.com/skaffold/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/skaffold.gpg
echo "deb [signed-by=/etc/apt/keyrings/skaffold.gpg] https://storage.googleapis.com/skaffold/apt stable main" | sudo tee /etc/apt/sources.list.d/skaffold.list
sudo apt-get update && sudo apt-get install -y skaffold
```

### Google Cloud SDK component

```bash
gcloud components install skaffold
skaffold version
```

### asdf plugin

```bash
asdf plugin add skaffold https://github.com/nklmilojevic/asdf-skaffold.git
asdf install skaffold latest
asdf global skaffold latest
```

## Verify Installation

```bash
skaffold version
skaffold diagnose  # also checks prerequisites
```

## Prerequisites

- **Docker** (for local builds) or **Kaniko** (for in-cluster builds)
- **kubectl** configured with access to a Kubernetes cluster
- A running Kubernetes cluster (local: kind, k3d, minikube; or remote: GKE, EKS, AKS)
- A container registry that Skaffold can push images to

```bash
# Verify Docker is running
docker info

# Verify kubectl cluster access
kubectl cluster-info

# Verify kubectl context
kubectl config current-context
```

## Image Registry Configuration

Set a default registry prefix so Skaffold knows where to push images:

```bash
# Set via environment variable (recommended for CI)
export SKAFFOLD_DEFAULT_REPO=gcr.io/my-project

# Or via CLI flag
skaffold run --default-repo=gcr.io/my-project

# Or configure globally in ~/.skaffold/config
skaffold config set default-repo gcr.io/my-project --global
```

## Container Registry Authentication

```bash
# Google Container Registry / Artifact Registry
gcloud auth configure-docker

# Amazon ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 123456789.dkr.ecr.us-east-1.amazonaws.com

# Docker Hub
docker login

# Generic (credentials in ~/.docker/config.json are used automatically)
```

## Skaffold Config Directory

Global config lives in `~/.skaffold/`:

```bash
# View current global config
skaffold config list --global

# Set a global default-repo
skaffold config set default-repo myregistry.example.com/myproject --global

# Unset a global value
skaffold config unset default-repo --global
```

## Shell Completion

```bash
# bash
echo 'source <(skaffold completion bash)' >> ~/.bashrc

# zsh
echo 'source <(skaffold completion zsh)' >> ~/.zshrc
```
