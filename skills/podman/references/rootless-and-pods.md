# Rootless Mode and Pods — Podman

## Rootless Architecture

Podman runs without a central daemon. In rootless mode:

- Containers run as the current user (no root required)
- Each user has an isolated set of containers, images, and volumes
- Storage is at `~/.local/share/containers/storage/`
- Socket is at `/run/user/<uid>/podman/podman.sock`

```bash
# Verify rootless mode
podman info | grep -A5 "host:"
id    # confirm you are NOT root when using rootless
```

## User Namespace Mapping

Rootless containers use Linux user namespaces to map UIDs inside the container to a range of UIDs on the host.

```bash
# View subuid/subgid configuration
cat /etc/subuid      # username:100000:65536
cat /etc/subgid

# Add ranges for a user if missing
sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 myuser

# Enter user namespace for inspection
podman unshare id
podman unshare cat /proc/self/uid_map
```

## Networking in Rootless Mode

Two network stacks are available for rootless containers:

| Option | Description |
| -------- | ------------- |
| `slirp4netns` | User-space TCP/IP stack; default on older systems |
| `pasta` | Faster; recommended on modern systems (Podman 4.x+) |

```bash
# Check which network mode is in use
podman info | grep networkBackend

# Force pasta for a specific run
podman run --network=pasta myapp:latest
```

Port publishing in rootless mode uses slirp/pasta to map host ports — no `CAP_NET_BIND_SERVICE` required for ports > 1024.

## Pod Networking and Shared Namespaces

A Podman pod is a group of containers sharing network (and optionally IPC/UTS) namespaces — equivalent to a Kubernetes pod.

```bash
# Create pod with published port
podman pod create --name mypod -p 8080:80

# Containers in the pod share the same network interface
podman run -d --pod mypod --name frontend nginx:latest
podman run -d --pod mypod --name backend mybackend:latest

# Containers in the same pod communicate via localhost
# e.g., backend can connect to frontend at http://localhost:80
```

An infra (pause) container holds the pod's namespaces. It starts automatically when the pod starts.

## Rootful vs Rootless Port Publishing

| Scenario | Rootless | Rootful |
| ---------- | ---------- | --------- |
| Port > 1024 | Works via slirp/pasta | Works directly |
| Port <= 1024 | Requires `net.ipv4.ip_unprivileged_port_start` sysctl | Works directly |
| Container-to-container via pod | Localhost | Localhost |

```bash
# Allow rootless binding to port 80 (system-wide)
sudo sysctl -w net.ipv4.ip_unprivileged_port_start=80
```

## Podman Remote Access

```bash
# Enable Podman socket for the current user
systemctl --user enable --now podman.socket

# Use the socket remotely via SSH
podman --remote --connection myhost images
```

## SELinux and AppArmor Labels

```bash
# Add SELinux label for volume mounts
podman run -v /mydata:/data:z myapp:latest     # shared label
podman run -v /mydata:/data:Z myapp:latest     # private label

# Disable SELinux for a container (use sparingly)
podman run --security-opt label=disable myapp:latest
```
