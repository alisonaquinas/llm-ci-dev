# Command Cookbook — Podman

## Container Operations

```bash
# Run interactively
podman run --rm -it alpine:latest sh

# Run in background
podman run -d --name myapp -p 8080:80 nginx:latest

# Exec into a running container
podman exec -it myapp sh

# View logs
podman logs myapp
podman logs -f --tail=100 myapp

# List containers
podman ps
podman ps -a           # include stopped containers

# Stop and remove
podman stop myapp
podman rm myapp
podman rm -f myapp     # force remove running container

# Resource stats
podman stats
podman stats myapp
```

## Image Operations

```bash
podman images
podman pull alpine:latest
podman push registry.example.com/myapp:v1.0
podman tag myapp:latest registry.example.com/myapp:v1.0
podman rmi myapp:latest

podman build -t myapp:latest .
podman build -t myapp:latest -f Dockerfile.prod .
```

## Networking

```bash
podman network create mynet
podman network ls
podman network inspect mynet
podman network rm mynet

# Connect a running container to a network
podman network connect mynet myapp
```

## Volumes

```bash
podman volume create mydata
podman volume ls
podman volume inspect mydata
podman volume rm mydata

# Use a volume in a container
podman run -d -v mydata:/data myapp:latest
```

## Pod Management

```bash
# Create a pod with port publishing
podman pod create --name mypod -p 8080:80

# List pods
podman pod ps

# Start / stop / remove pods
podman pod start mypod
podman pod stop mypod
podman pod rm mypod

# Run a container inside a pod
podman run -d --pod mypod --name web nginx:latest

# Inspect a pod
podman pod inspect mypod
```

## Generate and Play Kubernetes YAML

```bash
# Export a pod to Kubernetes YAML
podman generate kube mypod > pod.yaml
podman generate kube mypod myvolume > pod-with-volume.yaml

# Run resources from Kubernetes YAML
podman play kube pod.yaml

# Tear down resources created by play kube
podman play kube --down pod.yaml
```

## System Maintenance

```bash
# Remove stopped containers, dangling images, unused networks/volumes
podman system prune

# Also remove unused images (not just dangling)
podman system prune -a

# Run a container healthcheck manually
podman healthcheck run myapp

# List machines
podman machine list
podman machine inspect default
```
