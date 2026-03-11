# CRI-O Configuration — crio.conf

## Configuration File Locations

- Primary: `/etc/crio/crio.conf`
- Drop-in directory: `/etc/crio/crio.conf.d/*.conf` (merged alphabetically)

## Generate Default Configuration

```bash
crio config --default | sudo tee /etc/crio/crio.conf
```

## Key Configuration Sections

### Runtime Section

```toml
[crio.runtime]
  # Cgroup driver: must match kubelet --cgroup-driver
  cgroup_manager = "systemd"

  # Default OCI runtime
  default_runtime = "runc"

  # OCI runtime table — add additional runtimes here
  [crio.runtime.runtimes.runc]
    runtime_path = ""         # empty = auto-detect
    runtime_type = "oci"
    runtime_root = "/run/runc"

  [crio.runtime.runtimes.crun]
    runtime_path = "/usr/bin/crun"
    runtime_type = "oci"
    runtime_root = "/run/crun"

  # Kata Containers for VM isolation
  [crio.runtime.runtimes.kata-containers]
    runtime_path = "/usr/bin/containerd-shim-kata-v2"
    runtime_type = "vm"
    runtime_root = "/run/vc"
    privileged_without_host_devices = true
```

### Image Section

```toml
[crio.image]
  # Registries to search when image name has no host
  registries = ["docker.io", "quay.io", "registry.access.redhat.com"]

  # Insecure (HTTP or self-signed TLS) registries
  insecure_registries = ["registry.internal.example.com"]

  # Global authentication file (Docker config.json format)
  global_auth_file = "/etc/crio/auth.json"

  # Pause container image
  pause_image = "registry.k8s.io/pause:3.9"
```

### Network Section

```toml
[crio.network]
  # Directory containing CNI plugin configs
  network_dir = "/etc/cni/net.d/"

  # CNI plugin binaries directory
  plugin_dirs = ["/opt/cni/bin/", "/usr/lib/cni/"]

  # Default CNI network name
  cni_default_network = ""
```

### Log Configuration

```toml
[crio]
  # Log level: trace, debug, info, warn, error, fatal
  log_level = "info"

  # Log format: text or json
  log_format = "text"
```

## OCI Hooks

OCI hooks allow running programs at container lifecycle events.

Hook configs go in `/usr/share/containers/oci/hooks.d/` (JSON format, OCI Runtime Spec hooks).

## Apply Configuration Changes

```bash
# Back up before editing
sudo cp /etc/crio/crio.conf /etc/crio/crio.conf.bak

# Reload CRI-O (for settings that support live reload)
sudo systemctl reload crio

# Full restart when necessary
sudo systemctl restart crio

# Verify CRI-O is healthy after changes
systemctl status crio
crictl info
```

## Drop-in Configuration Example

```bash
# Override only cgroup_manager without touching main config
cat <<EOF | sudo tee /etc/crio/crio.conf.d/10-cgroup.conf
[crio.runtime]
  cgroup_manager = "systemd"
EOF

sudo systemctl reload crio
```
