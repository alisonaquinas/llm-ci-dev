---
name: containerd
description: Manage containers and images with containerd using ctr and nerdctl. Use when tasks mention containerd, ctr, nerdctl, /etc/containerd/config.toml, containerd snapshotter, or containerd as container runtime.
---

# containerd

Use this skill to manage containers and images using containerd's CLI tools safely and effectively.

## Quick Start

1. Run `ctr version` to verify containerd is running and accessible.
2. Use `nerdctl` for Docker-compatible container operations — it supports the same flags.
3. Use `ctr` only for low-level debugging; it bypasses higher-level abstractions.
4. Inspect `/etc/containerd/config.toml` before modifying; back it up first.

## Reference Files

- `references/install-and-setup.md` — install containerd, nerdctl, CNI plugins, BuildKit
- `references/command-cookbook.md` — nerdctl and ctr commands for containers, images, tasks
- `references/containerd-config.md` — config.toml structure, CRI plugin, snapshotters, registry mirrors
- `references/kubernetes-integration.md` — containerd as Kubernetes CRI, crictl debugging, image GC

## Workflow

### Run a Container with nerdctl

```bash
# Pull and run a container
nerdctl run --rm -it alpine:latest sh

# Run in background
nerdctl run -d --name myapp -p 8080:80 nginx:latest

# Build an image
nerdctl build -t myapp:latest .
```

### Inspect Kubernetes Containers via ctr

```bash
# List containers in the k8s.io namespace
ctr --namespace k8s.io containers list

# List running tasks (processes)
ctr --namespace k8s.io tasks list
```

### Use nerdctl Compose

```bash
nerdctl compose up -d
nerdctl compose logs -f
nerdctl compose down
```

## Safety Guardrails

- Use `nerdctl` for day-to-day operations and `ctr` only for low-level debugging — `ctr` bypasses containerd's higher-level abstractions.
- Always specify the namespace with `--namespace k8s.io` when inspecting Kubernetes-managed containers via `ctr` to avoid confusion with default namespace containers.
- Run `systemctl restart containerd` (not stop/start) to minimize downtime when reloading configuration changes.
- Back up `/etc/containerd/config.toml` before modifying; a bad config prevents containerd from starting.
- Test registry mirror and TLS configuration in a non-production cluster before applying to production nodes.
- Rootless containerd requires user namespace support — verify kernel capabilities before enabling in production.

## Related Skills

docker, podman, cri-o, kubectl
