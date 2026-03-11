# containerd Configuration — config.toml

## Generate Default Configuration

```bash
containerd config default | sudo tee /etc/containerd/config.toml
```

## Configuration File Location

`/etc/containerd/config.toml`

## Key Configuration Sections

### CRI Plugin (Kubernetes Integration)

```toml
[plugins."io.containerd.grpc.v1.cri"]
  sandbox_image = "registry.k8s.io/pause:3.9"

  [plugins."io.containerd.grpc.v1.cri".containerd]
    snapshotter = "overlayfs"
    default_runtime_name = "runc"

    [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
      runtime_type = "io.containerd.runc.v2"

      [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
        SystemdCgroup = true    # required for Kubernetes with systemd cgroup driver
```

### Registry Mirrors and TLS

```toml
[plugins."io.containerd.grpc.v1.cri".registry]
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors]
    [plugins."io.containerd.grpc.v1.cri".registry.mirrors."docker.io"]
      endpoint = ["https://mirror.example.com"]

  [plugins."io.containerd.grpc.v1.cri".registry.configs]
    [plugins."io.containerd.grpc.v1.cri".registry.configs."registry.example.com".tls]
      insecure_skip_verify = false
      ca_file = "/etc/containerd/certs/registry-ca.crt"
    [plugins."io.containerd.grpc.v1.cri".registry.configs."registry.example.com".auth]
      username = "myuser"
      password = "mypassword"
```

### Snapshotters

| Snapshotter | Use Case |
| ------------- | ---------- |
| `overlayfs` | Default on modern Linux kernels |
| `zfs` | ZFS filesystem environments |
| `devmapper` | Older kernels or specific storage requirements |
| `native` | Fallback; no overlay support |

```toml
[plugins."io.containerd.grpc.v1.cri".containerd]
  snapshotter = "overlayfs"
```

### Log Level and Log File

```toml
[debug]
  level = "info"     # trace | debug | info | warn | error

[grpc]
  address = "/run/containerd/containerd.sock"
```

## Apply Configuration Changes

```bash
# Always back up before editing
sudo cp /etc/containerd/config.toml /etc/containerd/config.toml.bak

# Validate TOML syntax (optional, requires toml-lint or similar)
# Then restart containerd
sudo systemctl restart containerd

# Verify containerd is running after restart
systemctl status containerd
ctr version
```
