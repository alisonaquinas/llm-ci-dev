# Tilt — Install and Setup

## Install by Platform

### Linux/macOS (curl script)

```bash
curl -fsSL https://raw.githubusercontent.com/tilt-dev/tilt/master/scripts/install.sh | bash
tilt version
```

### macOS (Homebrew)

```bash
brew install tilt
tilt version
```

### Windows (Scoop)

```powershell
scoop bucket add tilt-dev https://github.com/tilt-dev/scoop-bucket
scoop install tilt
tilt version
```

### Linux binary (manual)

```bash
# Download a specific version
VERSION=0.33.20
curl -fsSL https://github.com/tilt-dev/tilt/releases/download/v${VERSION}/tilt.${VERSION}.linux.x86_64.tar.gz | tar -xzv tilt
sudo mv tilt /usr/local/bin/tilt
tilt version
```

## Verify Installation

```bash
# Check Tilt version
tilt version

# Run environment diagnostics (cluster, Docker, kubectl)
tilt doctor
```

## Prerequisites

- **Docker** (or another container runtime such as Podman)
- **kubectl** with a configured kubeconfig
- A running Kubernetes cluster reachable from the local machine

## Local Cluster Options

```bash
# kind
kind create cluster --name dev
kubectl config use-context kind-dev

# k3d
k3d cluster create dev
kubectl config use-context k3d-dev

# minikube
minikube start
kubectl config use-context minikube

# Docker Desktop (enable Kubernetes in settings)
kubectl config use-context docker-desktop
```

## Tilt Environment Variables

```bash
# Override the Tilt web UI host (default: localhost)
export TILT_HOST=0.0.0.0

# Override the Tilt web UI port (default: 10350)
export TILT_PORT=10350
```

## Config Directory

Tilt stores state in `~/.tilt-dev/`:

```bash
# View Tilt config and analytics settings
ls ~/.tilt-dev/

# Disable analytics
tilt analytics opt out
```

## Tilt Cloud (Optional)

Tilt Cloud enables team snapshot sharing and CI visibility:

```bash
# Log in to Tilt Cloud
tilt login

# Link a running Tilt instance to a team project
tilt up --web-mode=tiltcloud
```
