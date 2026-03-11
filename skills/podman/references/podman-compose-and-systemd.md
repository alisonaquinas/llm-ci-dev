# Podman Compose and systemd — Podman

## podman-compose

`podman-compose` provides Docker Compose v2 compatible syntax for Podman.

```bash
# Install podman-compose
pip3 install podman-compose
# or
sudo dnf install podman-compose
sudo apt-get install podman-compose
```

```bash
podman-compose up -d        # start services in background
podman-compose down         # stop and remove containers
podman-compose logs -f      # follow logs from all services
podman-compose ps           # list service containers
podman-compose pull         # pull all service images
podman-compose build        # build service images
podman-compose restart web  # restart a specific service
```

## Generating systemd Units (Legacy Approach)

```bash
# Generate a systemd unit for a running container
podman generate systemd --name myapp --files --new

# Generated file: container-myapp.service
# Copy to systemd user directory
mkdir -p ~/.config/systemd/user/
cp container-myapp.service ~/.config/systemd/user/

# Enable and start
systemctl --user daemon-reload
systemctl --user enable --now container-myapp.service
```

Note: `podman generate systemd` is deprecated in Podman v4+. Prefer Quadlets.

## Quadlets (Recommended Modern Approach)

Quadlets are `.container`, `.pod`, `.network`, and `.volume` unit files parsed by systemd generator.

### Container Quadlet Example

```ini
# ~/.config/containers/systemd/myapp.container

[Unit]
Description=My Application

[Container]
Image=docker.io/library/nginx:latest
PublishPort=8080:80
Volume=mydata.volume:/data
Environment=APP_ENV=production
Label=io.containers.autoupdate=registry

[Service]
Restart=always

[Install]
WantedBy=default.target
```

### Volume Quadlet Example

```ini
# ~/.config/containers/systemd/mydata.volume

[Volume]
VolumeName=mydata
```

### Network Quadlet Example

```ini
# ~/.config/containers/systemd/mynet.network

[Network]
NetworkName=mynet
Subnet=10.89.1.0/24
```

### Enable Quadlet Services

```bash
# Reload systemd to pick up new Quadlet files
systemctl --user daemon-reload

# Enable and start
systemctl --user enable --now myapp.service

# View logs
journalctl --user -u myapp.service -f

# Check status
systemctl --user status myapp.service
```

## Auto-Update with Quadlets

```ini
[Container]
Label=io.containers.autoupdate=registry
```

```bash
# Trigger auto-update for all labeled containers
podman auto-update

# Run as a systemd timer (enable the built-in timer)
systemctl --user enable --now podman-auto-update.timer
```

## Podman Desktop

Podman Desktop is a GUI application for managing containers, pods, images, and Kubernetes manifests locally. It supports Podman, Docker, and Kind clusters. Available for macOS, Windows, and Linux from [podman-desktop.io](https://podman-desktop.io).
