---
name: cri-o
description: Configure and debug CRI-O as a Kubernetes container runtime with crictl. Use when tasks mention cri-o, CRI-O, crictl, /etc/crio/crio.conf, CRI-O container runtime, or configuring Kubernetes with CRI-O.
---

# CRI-O

Use this skill to configure and debug CRI-O as a Kubernetes container runtime using crictl and crio.conf.

## Quick Start

1. Set `CONTAINER_RUNTIME_ENDPOINT=unix:///var/run/crio/crio.sock` before using `crictl`.
2. Run `crictl info` to verify CRI-O is running and reachable.
3. Use `crictl pods` and `crictl ps` to inspect pods and containers.
4. Back up `/etc/crio/crio.conf` before making any configuration changes.

## Reference Files

- `references/install-and-setup.md` — install CRI-O, crictl, OCI runtime, CNI plugins
- `references/command-cookbook.md` — crictl pods/ps/images/exec/logs/inspect/stats commands
- `references/crio-configuration.md` — crio.conf structure, runtime table, image config, log config
- `references/kubernetes-integration.md` — kubelet CRI socket, CNI config, OCI runtime selection, GC tuning

## Workflow

### Inspect Running Pods and Containers

```bash
# List all pod sandboxes
crictl pods

# List all containers
crictl ps

# Exec into a container
crictl exec -it <container-id> sh

# View container logs
crictl logs <container-id>
```

### Reload Configuration

```bash
# Back up config first
sudo cp /etc/crio/crio.conf /etc/crio/crio.conf.bak

# Edit configuration
sudo vi /etc/crio/crio.conf

# Reload without restarting (for supported settings)
sudo systemctl reload crio
```

### Debug a Failed Pod

```bash
crictl pods --name failing-pod
crictl inspect <container-id>
crictl inspectp <pod-id>
crictl logs <container-id>
```

## Safety Guardrails

- Always set `CONTAINER_RUNTIME_ENDPOINT=unix:///var/run/crio/crio.sock` or configure `/etc/crictl.yaml` before using `crictl` to ensure commands target CRI-O.
- Use `crictl` only for read-only inspection in production — avoid `crictl runp` or `crictl rmp` on live Kubernetes nodes as it bypasses kubelet.
- Back up `/etc/crio/crio.conf` before modifying; invalid TOML syntax prevents CRI-O from starting and breaks the Kubernetes node.
- Use `systemctl reload crio` for configuration changes that support live reload; use `systemctl restart crio` only when necessary as it briefly disrupts running containers.
- Verify CRI-O version compatibility with the Kubernetes version before upgrading either component.
- When changing the OCI runtime (e.g., from runc to crun), test on a non-production node first.
- Ensure `cgroup_manager` in crio.conf matches the kubelet `--cgroup-driver` setting; mismatch causes pod creation failures.

## Related Skills

containerd, podman, kubectl
