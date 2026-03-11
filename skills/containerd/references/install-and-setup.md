# Install and Setup — containerd

## Install containerd

### Debian/Ubuntu (apt)

```bash
sudo apt-get update
sudo apt-get install -y containerd
containerd --version
```

### RHEL/Fedora (dnf)

```bash
sudo dnf install -y containerd
containerd --version
```

### Binary Tarball

```bash
VERSION=1.7.14
curl -sSL https://github.com/containerd/containerd/releases/download/v${VERSION}/containerd-${VERSION}-linux-amd64.tar.gz \
  | sudo tar -C /usr/local -xz
sudo systemctl daemon-reload
sudo systemctl enable --now containerd
containerd --version
```

## Install nerdctl (Docker-compatible CLI)

```bash
NERDCTL_VERSION=1.7.4
curl -sSL https://github.com/containerd/nerdctl/releases/download/v${NERDCTL_VERSION}/nerdctl-${NERDCTL_VERSION}-linux-amd64.tar.gz \
  | sudo tar -C /usr/local/bin -xz
nerdctl version
```

## Install CNI Plugins (required for networking)

```bash
CNI_VERSION=1.4.1
sudo mkdir -p /opt/cni/bin
curl -sSL https://github.com/containernetworking/plugins/releases/download/v${CNI_VERSION}/cni-plugins-linux-amd64-v${CNI_VERSION}.tgz \
  | sudo tar -C /opt/cni/bin -xz
```

## Install BuildKit (required for nerdctl build)

```bash
BUILDKIT_VERSION=0.13.2
curl -sSL https://github.com/moby/buildkit/releases/download/v${BUILDKIT_VERSION}/buildkit-v${BUILDKIT_VERSION}.linux-amd64.tar.gz \
  | sudo tar -C /usr/local -xz
sudo systemctl enable --now buildkit
```

## Environment Variables

```bash
export CONTAINERD_ADDRESS=/run/containerd/containerd.sock
export CONTAINERD_NAMESPACE=default       # use k8s.io for Kubernetes containers
```

## Verify Installation

```bash
ctr version
nerdctl version
nerdctl info
systemctl status containerd
```

## Rootless containerd Setup

```bash
# Install rootlesskit
curl -sSL https://github.com/rootless-containers/rootlesskit/releases/latest/download/rootlesskit-x86_64.tar.gz \
  | tar -C /usr/local/bin -xz

# Enable user namespaces
sudo sysctl -w kernel.unprivileged_userns_clone=1

# Set up rootless containerd for current user
containerd-rootless-setuptool.sh install
```
