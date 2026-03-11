# Command Cookbook — containerd

## nerdctl Container Operations

```bash
# Run containers (Docker flag-compatible)
nerdctl run --rm -it alpine:latest sh
nerdctl run -d --name myapp -p 8080:80 nginx:latest
nerdctl run -d --name mydb -e POSTGRES_PASSWORD=secret postgres:15

# Exec into a running container
nerdctl exec -it myapp sh

# View logs
nerdctl logs myapp
nerdctl logs -f --tail=100 myapp

# List containers
nerdctl ps
nerdctl ps -a          # include stopped containers

# Stop and remove
nerdctl stop myapp
nerdctl rm myapp
nerdctl rm -f myapp    # force remove running container

# Stats
nerdctl stats
```

## nerdctl Image Operations

```bash
nerdctl images
nerdctl pull alpine:latest
nerdctl push registry.example.com/myapp:v1.0
nerdctl tag myapp:latest registry.example.com/myapp:v1.0
nerdctl rmi myapp:latest
nerdctl build -t myapp:latest .
nerdctl build -t myapp:latest -f Dockerfile.prod .
```

## nerdctl Compose

```bash
nerdctl compose up -d
nerdctl compose down
nerdctl compose logs -f
nerdctl compose ps
nerdctl compose pull
nerdctl compose build
```

## ctr Image Operations

```bash
# Pull image
ctr images pull docker.io/library/alpine:latest

# List images
ctr images list

# Tag image
ctr images tag docker.io/library/alpine:latest myrepo/alpine:custom

# Remove image
ctr images remove docker.io/library/alpine:latest
```

## ctr Container and Task Operations

```bash
# List containers
ctr containers list

# Delete a container
ctr containers delete <container-id>

# List running tasks (processes)
ctr tasks list

# Execute a command in a running task
ctr tasks exec --exec-id debug1 <task-id> sh

# Kill a task
ctr tasks kill <task-id>
```

## ctr Namespace and Snapshot Operations

```bash
# List namespaces
ctr namespaces list

# List containers in Kubernetes namespace
ctr --namespace k8s.io containers list

# List snapshots
ctr snapshots list

# List content in content store
ctr content ls
```

## ctr Version and Info

```bash
ctr version
ctr plugins list      # list loaded plugins including snapshotters
```
