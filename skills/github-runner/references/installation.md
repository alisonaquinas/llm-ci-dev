# GitHub Actions Runner Installation

Install and configure the GitHub Actions runner binary across supported platforms.

---

## Operating System Support and Specifications

### Supported Platforms

| OS | Versions | Architecture | Download |
| --- | --- | --- | --- |
| **Linux** | Ubuntu 16.04+, CentOS, RHEL, Alpine | x64, ARM64, ARM | `actions-runner-linux-{x64,arm64,arm}.tar.gz` |
| **macOS** | 10.15+, Monterey, Ventura, Sonoma | x64, ARM64 | `actions-runner-osx-{x64,arm64}.tar.gz` |
| **Windows** | Server 2016+, 2019, 2022 | x64 | `actions-runner-win-x64.zip` |

### Minimum Hardware Requirements

- **CPU**: 2+ cores
- **Memory**: 4 GB RAM minimum (8 GB recommended)
- **Disk**: 10 GB for runner and workspace
- **Network**: Outbound HTTPS to GitHub (443)

---

## Linux Installation

### Step 1: Download Runner Binary

```bash
# Create runner directory
mkdir -p ~/runner && cd ~/runner

# Download latest x64 runner
# Visit https://github.com/actions/runner/releases to find latest version
RUNNER_VERSION="2.414.0"
curl -o actions-runner-linux-x64.tar.gz \
  -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# Verify checksum
curl -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz.sha256 | \
  shasum -a 256 -c
```

### Step 2: Extract and Initialize

```bash
# Extract
tar xzf actions-runner-linux-x64.tar.gz

# Verify dependencies
./bin/installdependencies.sh

# Dependencies: libicu, openssl, git, curl, rsync
```

### Step 3: Configure

Generate a GitHub token at: **Repository/Organization Settings** → **Actions** → **Runners** → **New self-hosted runner**

```bash
./config.sh \
  --url https://github.com/owner/repo \
  --token <TOKEN> \
  --name my-runner \
  --labels linux,docker \
  --unattended  # Non-interactive mode
```

### Step 4: Install Service

```bash
# Install as systemd service
sudo ./svc.sh install

# Start service
sudo systemctl start actions.runner.* \
  # OR
sudo ./svc.sh start

# Check status
sudo systemctl status actions.runner.*
sudo ./svc.sh status
```

### Step 5: Verify Installation

```bash
# Check runner registration
curl -H "Authorization: token $GITHUB_TOKEN" \
  https://api.github.com/repos/owner/repo/actions/runners | \
  jq '.runners[] | {name, status}'
```

---

## macOS Installation

### Manual Installation

```bash
# Create directory
mkdir -p ~/runner && cd ~/runner

# Download macOS runner (x64 or ARM64)
curl -o actions-runner-osx-arm64.tar.gz \
  -L https://github.com/actions/runner/releases/download/v2.414.0/actions-runner-osx-arm64-2.414.0.tar.gz

# Extract
tar xzf actions-runner-osx-arm64.tar.gz

# Configure
./config.sh \
  --url https://github.com/owner/repo \
  --token <TOKEN> \
  --name mac-runner \
  --labels macos,arm64
```

### Service Installation (launchd)

```bash
# Install as launch agent (runs as current user)
./svc.sh install

# Start service
./svc.sh start

# View logs
tail -f ~/Library/Logs/actions.runner.*.log

# Uninstall
./svc.sh uninstall
```

---

## Windows Installation

### Step 1: Download and Extract

```powershell
# Create directory
mkdir $env:USERPROFILE\runner
cd $env:USERPROFILE\runner

# Download Windows runner
$ProgressPreference = "SilentlyContinue"
Invoke-WebRequest `
  -Uri "https://github.com/actions/runner/releases/download/v2.414.0/actions-runner-win-x64-2.414.0.zip" `
  -OutFile "actions-runner-win-x64.zip"

# Extract
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory(
  "$pwd\actions-runner-win-x64.zip",
  "$pwd"
)
```

### Step 2: Configure

```powershell
# Generate token from GitHub (Settings → Actions → Runners)

.\config.cmd `
  --url "https://github.com/owner/repo" `
  --token "<TOKEN>" `
  --name "windows-runner" `
  --labels "windows,powershell" `
  --unattended
```

### Step 3: Install as Windows Service

```powershell
# Run as Administrator
PS> Start-Process powershell -Verb RunAs

# Install service
.\svc.cmd install

# Start service
Start-Service -Name "actions.runner.OWNER-REPO.windows-runner"

# Verify
Get-Service -Name "actions.runner.*"
```

---

## Docker Container Installation

### Using Official Actions Runner Image

```bash
# Pull image
docker pull ghcr.io/actions/runner:latest

# Run container
docker run -d \
  --name github-runner \
  -e GITHUB_URL="https://github.com/owner/repo" \
  -e GITHUB_TOKEN="<TOKEN>" \
  -e RUNNER_NAME="docker-runner" \
  -e RUNNER_LABELS="docker,linux" \
  -v /var/run/docker.sock:/var/run/docker.sock \
  ghcr.io/actions/runner:latest
```

### Custom Dockerfile with Docker-in-Docker

```dockerfile
FROM ghcr.io/actions/runner:latest

# Install additional tools
RUN apt-get update && apt-get install -y \
    postgresql-client \
    redis-tools \
    docker.io

# Set working directory
WORKDIR /runner
```

Build and run:

```bash
docker build -t custom-runner:latest .
docker run -d \
  --name github-runner \
  -e GITHUB_URL="https://github.com/owner/repo" \
  -e GITHUB_TOKEN="<TOKEN>" \
  -e RUNNER_NAME="custom-runner" \
  -v /var/run/docker.sock:/var/run/docker.sock \
  custom-runner:latest
```

---

## Windows Subsystem for Linux 2 (WSL2) Installation

Run GitHub Actions Runner natively on WSL2 using Linux binaries:

### Prerequisites

- WSL2 with Ubuntu 20.04 LTS or later
- GitHub Actions runner token from repository/org settings
- Docker Desktop for Windows with WSL2 backend (optional, for containerized workflows)

### Installation on WSL2

```bash
# Inside WSL2 Ubuntu terminal
mkdir -p ~/runner && cd ~/runner

# Download runner binary
RUNNER_VERSION="2.414.0"
curl -o actions-runner-linux-x64.tar.gz \
  -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# Extract
tar xzf actions-runner-linux-x64.tar.gz

# Install dependencies
./bin/installdependencies.sh

# Configure
./config.sh \
  --url https://github.com/owner/repo \
  --token <TOKEN> \
  --name wsl2-runner \
  --labels linux,wsl2 \
  --unattended
```

### Run as Systemd Service in WSL2

```bash
# Install service
sudo ./svc.sh install

# Start service
sudo systemctl start actions.runner.*

# Enable auto-start
sudo systemctl enable actions.runner.*

# Verify
sudo systemctl status actions.runner.*
```

### Docker in WSL2 Workflows

Access Docker Desktop daemon from WSL2:

```bash
# Docker Desktop automatically exposes daemon to WSL2
docker ps  # Should work without additional setup

# Register runner with Docker access
./config.sh \
  --url https://github.com/owner/repo \
  --token <TOKEN> \
  --labels docker,wsl2
```

Workflows using `docker://` or `services:` automatically access Docker Desktop.

### WSL2 File System Notes

- GitHub workspace path: `~/runner/_work/` (in Linux filesystem)
- Windows path accessible via: `/mnt/c/Users/...` (slower I/O; avoid for workspace)
- Keep workspace in WSL2 filesystem for best performance

---

## Kubernetes Installation (Actions Runner Controller)

See the **ARC and Scaling** reference for Kubernetes deployment via Helm chart.

---

## Workspace Directory Configuration

### Workspace Location

Specify where runner stores job files:

```bash
./config.sh \
  --url https://github.com/owner/repo \
  --token <TOKEN> \
  --work "/home/runner/_work"  # Custom workspace path
```

### Disk Space Considerations

- **Workspace**: 10+ GB minimum for artifact storage
- **Build outputs**: Varies by job; can accumulate to hundreds of GB
- **Docker layers**: 20+ GB if Docker executor used

Monitor disk usage:

```bash
# Check workspace size
du -sh ~/runner/_work/

# Clean old artifacts
find ~/runner/_work -mtime +30 -type f -delete
```

---

## Token Types and Management

### Classic Personal Access Token (PAT)

```bash
# Create token at GitHub.com → Settings → Developer Settings → Personal Access Tokens
# Scopes needed: repo (for repos), admin:org_hook (for org runners)

# Use in config
./config.sh --token <CLASSIC_PAT> ...
```

### Fine-Grained Personal Access Token

More limited permissions:

```text
Repository access: Select repositories
Permissions:
  - Actions: Read and write
  - Administration: Read and write (for adding runners)
```

### GitHub App Token

For enterprise workflows:

```bash
# Create GitHub App and generate token
./config.sh --token <GITHUB_APP_TOKEN> ...
```

---

## Auto-Update Configuration

### Enable Auto-Update (Default)

Runner automatically updates itself:

```bash
# Auto-update enabled by default
# To verify in config.json:
cat ~/runner/.runner
# Contains: "autoUpdate": true
```

### Disable Auto-Update

```bash
./config.sh --disableupdate

# Or manually in ~/.runner config
# Modify: "autoUpdate": false
```

---

## Service Configuration Files

### Linux Systemd Unit

The service is registered as: `actions.runner.OWNER-REPO.RUNNER_NAME.service`

```ini
# /etc/systemd/system/actions.runner.owner-repo.runner-name.service
[Unit]
Description=GitHub Actions Runner
After=network.target

[Service]
Type=simple
User=runner
ExecStart=/home/runner/runner/run.sh
Restart=always
RestartSec=15

[Install]
WantedBy=multi-user.target
```

### Windows Service

Service name: `actions.runner.OWNER-REPO.WINDOWS-RUNNER`

View service properties:

```powershell
Get-Service -Name "actions.runner.*" | Format-List
```

---

## Troubleshooting Installation

### Dependency Errors (Linux)

Install missing dependencies:

```bash
# For Ubuntu/Debian
sudo apt-get update && sudo apt-get install -y \
    libicu70 \
    libssl3 \
    git \
    curl \
    rsync

# Run installer again
./bin/installdependencies.sh
```

### Token Expired or Invalid

Regenerate token from GitHub and reconfigure:

```bash
# Delete existing registration
./config.sh remove

# Reconfigure with new token
./config.sh --url https://github.com/owner/repo --token <NEW_TOKEN> ...

# Restart service
sudo systemctl restart actions.runner.*
```

### Runner Not Connecting

Check network and firewall:

```bash
# Verify GitHub connectivity
curl -I https://api.github.com

# Check runner logs
journalctl -u actions.runner.* -f
tail -f ~/Library/Logs/actions.runner.*.log  # macOS

# Restart service
sudo systemctl restart actions.runner.*
```

### Firewall Configuration

Ensure egress allowed:

- **Destination**: api.github.com (443)
- **Destination**: github.com (443)
- **Destination**: objects.githubusercontent.com (443)
- **Destination**: github-releases.githubusercontent.com (443)
