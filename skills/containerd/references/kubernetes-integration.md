# Kubernetes Integration — containerd

## Configure kubelet to Use containerd

```bash
# kubelet flag (in kubelet configuration or systemd unit)
--container-runtime-endpoint=unix:///run/containerd/containerd.sock

# In kubelet config file (/var/lib/kubelet/config.yaml)
containerRuntimeEndpoint: unix:///run/containerd/containerd.sock
```

## SystemdCgroup Requirement

For Kubernetes with systemd cgroup driver, ensure `SystemdCgroup = true` in config.toml:

```toml
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
  SystemdCgroup = true
```

And match kubelet:

```bash
--cgroup-driver=systemd
```

## crictl for Kubernetes Container Debugging

```bash
# Install crictl
VERSION=1.29.0
curl -sSL https://github.com/kubernetes-sigs/cri-tools/releases/download/v${VERSION}/crictl-v${VERSION}-linux-amd64.tar.gz \
  | sudo tar -C /usr/local/bin -xz

# Configure crictl to use containerd
cat <<EOF | sudo tee /etc/crictl.yaml
runtime-endpoint: unix:///run/containerd/containerd.sock
image-endpoint: unix:///run/containerd/containerd.sock
timeout: 10
debug: false
EOF
```

## crictl Commands for Kubernetes Debugging

```bash
crictl pods                          # list pod sandboxes
crictl ps                            # list containers
crictl images                        # list images
crictl pull registry.example.com/myapp:v1
crictl exec -it <container-id> sh    # exec into container
crictl logs <container-id>           # view container logs
crictl inspect <container-id>        # detailed container info
crictl inspectp <pod-id>             # detailed pod info
crictl stats                         # container resource usage
```

## Inspect Kubernetes Containers via ctr Directly

```bash
# List Kubernetes containers using k8s.io namespace
ctr --namespace k8s.io containers list

# List images used by Kubernetes
ctr --namespace k8s.io images list

# List running tasks for Kubernetes containers
ctr --namespace k8s.io tasks list
```

## Private Registry Authentication

```bash
# Create Kubernetes image pull secret
kubectl create secret docker-registry regcred \
  --docker-server=registry.example.com \
  --docker-username=myuser \
  --docker-password=mypassword \
  --docker-email=myuser@example.com

# Reference in pod spec
# spec:
#   imagePullSecrets:
#     - name: regcred
```

## Image Garbage Collection Settings

```toml
[plugins."io.containerd.grpc.v1.cri"]
  [plugins."io.containerd.grpc.v1.cri".image_decryption]
    # GC is managed by kubelet, not containerd directly
    # Configure in kubelet --image-gc-high-threshold and --image-gc-low-threshold
```

## Migration from Docker Shim (dockershim)

```bash
# 1. Drain the node
kubectl drain <node-name> --ignore-daemonsets --delete-emptydir-data

# 2. Update /etc/containerd/config.toml with SystemdCgroup = true

# 3. Update kubelet configuration to use containerd endpoint
# containerd socket: /run/containerd/containerd.sock

# 4. Restart kubelet and containerd
sudo systemctl restart containerd kubelet

# 5. Uncordon the node
kubectl uncordon <node-name>
```

## Snapshotter Requirements for Overlay

```bash
# Check overlayfs support
modprobe overlay
lsmod | grep overlay

# Verify mount options
mount | grep overlay
```
