---
name: podman
description: Build and run containers with Podman without a daemon. Use when tasks mention podman, podman run, rootless containers, podman machine, podman-compose, or running containers without Docker daemon.
---

# Podman

Use this skill to build and run containers with Podman in a daemonless, rootless-first architecture.

## Quick Start

1. Run `podman info` to verify Podman is installed and rootless mode is active.
2. On macOS/Windows, start the VM first: `podman machine start`.
3. Use `podman` with the same flags as Docker — most commands are drop-in compatible.
4. Use `podman system prune` carefully — it removes stopped containers and unused images.

## Intent Router

- `references/install-and-setup.md` — install Podman by platform, machine setup, config files
- `references/command-cookbook.md` — podman run/build/push/pod/generate/play/compose commands
- `references/rootless-and-pods.md` — rootless architecture, user namespaces, pod networking
- `references/podman-compose-and-systemd.md` — podman-compose, Quadlets, systemd unit generation

## Workflow

### Run a Container

```bash
# Run interactively
podman run --rm -it alpine:latest sh

# Run in background
podman run -d --name myapp -p 8080:80 nginx:latest
```

### Build and Push Images

```bash
podman build -t myapp:latest .
podman push registry.example.com/myapp:latest
```

### Manage Pods

```bash
podman pod create --name mypod -p 8080:80
podman run -d --pod mypod --name mycontainer nginx:latest
podman pod ps
```

### Export to Kubernetes YAML

```bash
podman generate kube mypod > pod.yaml
podman play kube pod.yaml
```

## Safety Guardrails

- Prefer rootless Podman (default on modern systems) over rootful to minimize attack surface — rootful Podman requires root privileges.
- On macOS/Windows, always start `podman machine` before running containers; the VM hosts the container runtime.
- Verify `/etc/subuid` and `/etc/subgid` contain entries for the current user before running rootless containers.
- Use `podman system prune` carefully — it removes all stopped containers, unused images, and build cache.
- When using `podman generate kube`, review the generated YAML before deploying to Kubernetes — some Podman-specific fields may not be portable.
- For production systemd services, prefer Quadlets over `podman generate systemd` — Quadlets are the modern, maintained approach.
- Use `podman machine ssh` to inspect the VM; do not run container workloads directly on the macOS host.

## Related Skills

docker, containerd, cri-o
