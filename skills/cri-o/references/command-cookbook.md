# Command Cookbook — CRI-O

## Pod (Sandbox) Operations

```bash
# List all pod sandboxes
crictl pods

# Filter pods by name
crictl pods --name my-pod

# Filter pods by namespace label
crictl pods --label io.kubernetes.pod.namespace=kube-system

# Inspect a pod sandbox
crictl inspectp <pod-id>

# Run a pod from config (for debugging only — bypasses kubelet)
crictl runp pod-config.json

# Stop a pod sandbox
crictl stopp <pod-id>

# Remove a pod sandbox
crictl rmp <pod-id>
```

## Container Operations

```bash
# List running containers
crictl ps

# List all containers including stopped
crictl ps -a

# Exec into a running container
crictl exec -it <container-id> sh

# Execute a non-interactive command
crictl exec <container-id> cat /etc/os-release

# View container logs
crictl logs <container-id>
crictl logs --tail=100 <container-id>
crictl logs -f <container-id>     # follow logs

# Inspect a container
crictl inspect <container-id>

# Get container resource stats
crictl stats
crictl stats <container-id>
```

## Image Operations

```bash
# List images on the node
crictl images

# Pull an image
crictl pull alpine:latest
crictl pull registry.example.com/myapp:v1.0

# Inspect an image
crictl inspecti alpine:latest

# Remove an image
crictl rmi alpine:latest
```

## Runtime Status and Info

```bash
# CRI-O runtime status and version
crictl info
crictl version

# Verbose output for debugging
crictl --debug pods
```

## Common Debug Workflow

```bash
# 1. Find the pod
crictl pods --name my-failing-pod

# 2. Get containers in the pod
crictl ps -a | grep <pod-id>

# 3. View logs from the failed container
crictl logs <container-id>

# 4. Inspect container state and exit code
crictl inspect <container-id> | python3 -m json.tool | grep -A5 exitCode

# 5. Inspect the pod sandbox for network issues
crictl inspectp <pod-id>
```
