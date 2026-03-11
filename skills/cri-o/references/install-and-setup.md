# Install and Setup — CRI-O

## Install CRI-O

### Debian/Ubuntu (OBS repository)

```bash
# Set Kubernetes and CRI-O version
KUBERNETES_VERSION=1.29
CRIO_VERSION=1.29

# Add OBS repo
curl -fsSL https://pkgs.k8s.io/addons:/cri-o:/stable:/v${CRIO_VERSION}/deb/Release.key \
  | gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] \
  https://pkgs.k8s.io/addons:/cri-o:/stable:/v${CRIO_VERSION}/deb/ /" \
  | tee /etc/apt/sources.list.d/cri-o.list

sudo apt-get update
sudo apt-get install -y cri-o
crio --version
```

### RHEL / Fedora (dnf/yum)

```bash
CRIO_VERSION=1.29
sudo dnf install -y cri-o
crio --version
```

## Install crictl

```bash
VERSION=1.29.0
curl -sSL https://github.com/kubernetes-sigs/cri-tools/releases/download/v${VERSION}/crictl-v${VERSION}-linux-amd64.tar.gz \
  | sudo tar -C /usr/local/bin -xz
crictl version
```

## Configure crictl

```bash
cat <<EOF | sudo tee /etc/crictl.yaml
runtime-endpoint: unix:///var/run/crio/crio.sock
image-endpoint: unix:///var/run/crio/crio.sock
timeout: 10
debug: false
EOF
```

Alternatively, set the environment variable:

```bash
export CONTAINER_RUNTIME_ENDPOINT=unix:///var/run/crio/crio.sock
```

## Install OCI Runtime

### runc (default)

```bash
sudo apt-get install -y runc
# or
sudo dnf install -y runc
runc --version
```

### crun (lower memory footprint)

```bash
sudo apt-get install -y crun
# or
sudo dnf install -y crun
crun --version
```

## Install CNI Plugins

```bash
CNI_VERSION=1.4.1
sudo mkdir -p /opt/cni/bin
curl -sSL https://github.com/containernetworking/plugins/releases/download/v${CNI_VERSION}/cni-plugins-linux-amd64-v${CNI_VERSION}.tgz \
  | sudo tar -C /opt/cni/bin -xz
```

## Start and Enable CRI-O

```bash
sudo systemctl enable --now crio
systemctl status crio
```

## Verify Installation

```bash
crio --version
crictl version
crictl info        # runtime status and configuration
```
