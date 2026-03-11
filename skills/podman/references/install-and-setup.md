# Install and Setup — Podman

## Install by Platform

### RHEL / Fedora (dnf/yum)

```bash
sudo dnf install -y podman
podman version
```

### Ubuntu / Debian (apt)

```bash
sudo apt-get update
sudo apt-get install -y podman
podman version
```

### macOS (Homebrew)

```bash
brew install podman
podman version
```

### Windows (Scoop)

```powershell
scoop install podman
podman version
```

## Podman Machine (macOS and Windows)

On macOS and Windows, Podman runs containers in a Linux VM managed by `podman machine`.

```bash
# Initialize a new machine (first time)
podman machine init

# Start the machine
podman machine start

# List machines and their status
podman machine list

# SSH into the machine for debugging
podman machine ssh

# Stop the machine
podman machine stop

# Inspect machine details
podman machine inspect
```

## Rootless Setup Requirements

```bash
# Verify subuid and subgid entries exist for your user
grep $USER /etc/subuid    # should show: username:100000:65536
grep $USER /etc/subgid

# If missing, add them
sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 $USER

# Verify user namespace support
cat /proc/sys/kernel/unprivileged_userns_clone    # should be 1
```

## Configuration File Locations

```text
~/.config/containers/containers.conf   # runtime and default options
~/.config/containers/storage.conf      # image and container storage
~/.config/containers/registries.conf   # search registries and mirrors
/etc/containers/                        # system-wide defaults
```

## Environment Variables

```bash
export CONTAINER_HOST=unix:///run/user/1000/podman/podman.sock   # remote Podman socket
```

## Diagnostics

```bash
podman info
podman system info
podman system df     # disk usage by images, containers, volumes
```
