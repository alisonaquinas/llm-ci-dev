# GitLab Runner Installation

Install and manage the `gitlab-runner` binary across supported platforms.

---

## Linux Installation

### Debian/Ubuntu (apt)

Add the official GitLab package repository and install:

```bash
# Add repository and update package lists
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash

# Install latest version
sudo apt-get install gitlab-runner

# Install specific version
sudo apt-get install gitlab-runner=15.11.0
```

The package creates a `gitlab-runner` systemd service and system user.

### RHEL/CentOS/Rocky (yum/dnf)

Add the official repository:

```bash
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh | sudo bash

# Install with yum
sudo yum install gitlab-runner

# Or with dnf (newer systems)
sudo dnf install gitlab-runner
```

### Manual Installation (Binary)

Download and run the binary directly:

```bash
# Download latest release
curl -L https://gitlab-runner-downloads.s3.amazonaws.com/latest/deb/gitlab-runner_amd64.deb -o gitlab-runner_amd64.deb

# Install
sudo dpkg -i gitlab-runner_amd64.deb

# Or extract binary and run
curl -L https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64 -o /usr/local/bin/gitlab-runner
sudo chmod +x /usr/local/bin/gitlab-runner
```

### Systemd Service

After installation, enable and start the service:

```bash
sudo systemctl daemon-reload
sudo systemctl enable gitlab-runner
sudo systemctl start gitlab-runner
sudo systemctl status gitlab-runner
```

View logs:

```bash
sudo journalctl -u gitlab-runner -f
```

---

## Docker Installation

Run `gitlab-runner` in a container for ephemeral or orchestrated environments:

```bash
# Basic Docker run
docker run --rm -d \
  --name gitlab-runner \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v gitlab-runner-config:/etc/gitlab-runner \
  gitlab/gitlab-runner:latest
```

### Docker Volumes

Mount persistent configuration to preserve runner registration across container restarts:

```bash
# Create named volume for config
docker volume create gitlab-runner-config

# Run with volume
docker run -d \
  --name gitlab-runner \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v gitlab-runner-config:/etc/gitlab-runner \
  gitlab/gitlab-runner:latest
```

### Docker Registration

Register inside container:

```bash
docker exec gitlab-runner gitlab-runner register \
  --non-interactive \
  --url https://gitlab.example.com/ \
  --registration-token <TOKEN> \
  --executor docker \
  --docker-image ubuntu:22.04
```

---

## Kubernetes Installation

Deploy `gitlab-runner` as a Helm chart for Kubernetes environments:

```bash
# Add GitLab Helm repository
helm repo add gitlab https://charts.gitlab.io
helm repo update

# Install with minimal values
helm install gitlab-runner gitlab/gitlab-runner \
  --namespace gitlab-runner --create-namespace \
  --set gitlabUrl=https://gitlab.example.com/ \
  --set gitlabRunnerRegistrationToken=<TOKEN>
```

### Helm Values Reference

Key configuration options in `values.yaml`:

```yaml
gitlabUrl: https://gitlab.example.com/
gitlabRunnerRegistrationToken: <TOKEN>
runners:
  # Number of runner instances
  replicas: 3
  tags: "kubernetes,docker"
  # Pod template configuration
  image: ubuntu:22.04
  # Kubernetes executor options
  namespace: gitlab-runner
  privileged: true
    # Service account for pod execution
  serviceAccountName: gitlab-runner

# Kubernetes executor settings
runners:
  config: |
    [[runners]]
      [runners.kubernetes]
        namespace = "gitlab-runner"
        privileged = true
        cpu_request = "100m"
        memory_request = "128Mi"
        cpu_limit = "1000m"
        memory_limit = "1024Mi"
```

Verify Kubernetes installation:

```bash
# Check Helm release
helm list -n gitlab-runner

# View pod status
kubectl get pods -n gitlab-runner

# View runner logs
kubectl logs -n gitlab-runner -l app=gitlab-runner
```

---

## macOS Installation

Install via Homebrew or binary:

```bash
# Using Homebrew
brew install gitlab-runner

# Using binary download
curl -L https://gitlab-runner-downloads.s3.amazonaws.com/latest/osx/gitlab-runner > /usr/local/bin/gitlab-runner
chmod +x /usr/local/bin/gitlab-runner
```

### macOS Service (launchd)

Run as a launch agent:

```bash
# Install as user agent (runs in current user context)
gitlab-runner install --user

# Start service
gitlab-runner start

# View logs
tail -f ~/Library/Logs/gitlab-runner.log
```

---

## Windows Installation

### MSI Installer

Download and execute the Windows installer:

```powershell
# Download MSI
$url = "https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-windows-amd64.exe"
Invoke-WebRequest -Uri $url -OutFile gitlab-runner-windows-amd64.exe

# Run installer (interactive or silent)
.\gitlab-runner-windows-amd64.exe /S /D=C:\GitLabRunner
```

### PowerShell Service Installation

After installation, register and run as a Windows service:

```powershell
# Navigate to installation directory
cd C:\GitLabRunner

# Install as service
.\gitlab-runner.exe install `
  --service-name gitlab-runner `
  --user "COMPUTERNAME\USERNAME"

# Start service
Start-Service -Name gitlab-runner
```

## Windows Subsystem for Linux 2 (WSL2) Installation

Run GitLab Runner natively on WSL2 using Linux binaries:

### Prerequisites

- WSL2 with Ubuntu 20.04 LTS or later
- Docker Desktop for Windows with WSL2 backend (for Docker executor)

### Installation Steps

```bash
# Inside WSL2 Ubuntu terminal
# Add GitLab repository
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash

# Install runner
sudo apt-get install gitlab-runner

# Register runner (use WSL2 distro name as hostname)
sudo gitlab-runner register \
  --non-interactive \
  --url https://gitlab.example.com/ \
  --token <TOKEN> \
  --executor docker \
  --docker-image ubuntu:22.04 \
  --description "WSL2-runner"

# Start service
sudo systemctl start gitlab-runner
```

### Docker Executor on WSL2

For Docker executor, configure to use Docker Desktop's daemon:

```bash
# Verify Docker daemon connectivity
docker ps

# Register with Docker executor
sudo gitlab-runner register \
  --executor docker \
  --docker-host unix:///var/run/docker.sock
```

Docker Desktop automatically shares the socket with WSL2 distros.

### Persistent Service in WSL2

Enable auto-start on WSL2 boot:

```bash
# Edit sudoers to allow systemctl without password (optional)
sudo visudo
# Add: %sudo ALL=(ALL) NOPASSWD: /bin/systemctl

# Restart WSL2 distro or add to ~/.bashrc for auto-start:
# sudo systemctl start gitlab-runner
```

---

## Upgrade & Uninstall

### Upgrade

The package manager upgrade process gracefully restarts the service:

```bash
# Debian/Ubuntu
sudo apt-get upgrade gitlab-runner

# RHEL/CentOS
sudo yum upgrade gitlab-runner

# Docker
docker pull gitlab/gitlab-runner:latest
docker stop gitlab-runner
docker rm gitlab-runner
# Re-run container with new image

# Kubernetes (Helm)
helm upgrade gitlab-runner gitlab/gitlab-runner -f values.yaml
```

### Uninstall

Remove the runner and configuration:

```bash
# Debian/Ubuntu
sudo apt-get remove gitlab-runner
sudo apt-get remove --purge gitlab-runner  # Remove config too

# RHEL/CentOS
sudo yum remove gitlab-runner

# macOS
gitlab-runner uninstall
brew uninstall gitlab-runner

# Windows
.\gitlab-runner.exe uninstall
```

---

## Troubleshooting Installation

### Installation Fails Due to Package Repository

Ensure the repository is accessible and correctly configured:

```bash
# Verify repository key
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 6DE1EAB6

# Manually fetch and install
curl -L https://packages.gitlab.com/runner/gitlab-runner/release/deb/pool/focal/main/g/gitlab-runner/gitlab-runner_14.2.0_amd64.deb -o gitlab-runner.deb
sudo dpkg -i gitlab-runner.deb
```

### Service Fails to Start

Check systemd logs for errors:

```bash
sudo systemctl status gitlab-runner
sudo journalctl -u gitlab-runner -n 50
```

Common issues: misconfigured config.toml, insufficient permissions, missing Docker socket.

### Permission Denied on Docker Socket

If using Docker executor, add the `gitlab-runner` user to the docker group:

```bash
sudo usermod -aG docker gitlab-runner
sudo systemctl restart gitlab-runner
```
