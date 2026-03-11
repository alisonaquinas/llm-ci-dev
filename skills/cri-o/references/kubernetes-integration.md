# Kubernetes Integration — CRI-O

## Configure kubelet to Use CRI-O

```bash
# kubelet flag
--container-runtime-endpoint=unix:///var/run/crio/crio.sock

# In kubelet config file (/var/lib/kubelet/config.yaml)
containerRuntimeEndpoint: unix:///var/run/crio/crio.sock
```

## Cgroup Driver Alignment

CRI-O and kubelet must use the same cgroup driver.

```toml
# /etc/crio/crio.conf
[crio.runtime]
  cgroup_manager = "systemd"
```

```bash
# kubelet config
--cgroup-driver=systemd
```

Mismatch causes pod creation failures — verify both settings match before deploying.

## CRI-O Version Compatibility Matrix

| Kubernetes Version | CRI-O Version |
| ------------------- | --------------- |
| 1.30.x | 1.30.x |
| 1.29.x | 1.29.x |
| 1.28.x | 1.28.x |

CRI-O minor version must match Kubernetes minor version.

## CNI Plugin Configuration

```bash
# CNI config directory
ls /etc/cni/net.d/

# Example: flannel CNI config
cat /etc/cni/net.d/10-flannel.conflist

# Example: Calico CNI config
cat /etc/cni/net.d/10-calico.conflist
```

## OCI Runtime Selection

Select the OCI runtime per pod using RuntimeClass:

```yaml
# Define a RuntimeClass for crun
apiVersion: node.k8s.io/v1
kind: RuntimeClass
metadata:
  name: crun
handler: crun
```

```yaml
# Use in a pod spec
spec:
  runtimeClassName: crun
```

For Kata Containers VM isolation:

```yaml
spec:
  runtimeClassName: kata-containers
```

## Image Storage

CRI-O stores images at: `/var/lib/containers/storage/`

```bash
# Inspect image storage directly
ls /var/lib/containers/storage/overlay/

# Use skopeo to inspect images without pulling
skopeo inspect docker://registry.example.com/myapp:v1.0
```

## Garbage Collection Tuning

Image GC is managed by kubelet, not CRI-O directly. Configure in kubelet:

```bash
--image-gc-high-threshold=85   # GC starts when disk usage reaches 85%
--image-gc-low-threshold=80    # GC stops when disk usage falls to 80%
```

## Troubleshooting Pod Sandbox Failures

```bash
# Check CRI-O journal for errors
journalctl -u crio -n 100 --no-pager

# Check sandbox creation errors
crictl pods
crictl inspectp <failing-pod-id>

# Check CNI plugin errors
journalctl -u crio | grep -i cni

# Verify CRI-O socket is accessible
ls -la /var/run/crio/crio.sock
crictl info
```

## Pull Images from Private Registries

```bash
# Create auth.json with registry credentials
cat <<EOF | sudo tee /etc/crio/auth.json
{
  "auths": {
    "registry.example.com": {
      "auth": "$(echo -n 'username:password' | base64)"
    }
  }
}
EOF

# Reference in crio.conf
# global_auth_file = "/etc/crio/auth.json"
sudo systemctl reload crio
```
