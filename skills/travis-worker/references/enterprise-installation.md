# Travis CI Enterprise Worker Installation

Install and register the `travis-worker` daemon for Travis CI Enterprise (TCI-E) self-hosted deployments.

---

## System Requirements

### Minimum Specifications

- **OS**: Linux (Ubuntu 20.04 LTS or later recommended)
- **Memory**: 4 GB RAM minimum (8 GB+ recommended per pool_size)
- **CPU**: 2+ cores
- **Disk**: 50 GB+ for build workspace and Docker layers
- **Docker**: Docker daemon running and accessible
- **Network**: Connectivity to TCI-E controller via RabbitMQ queue

### Supported Configurations

- **Container**: Docker daemon running on Linux host or LXD
- **Docker Version**: 20.10+
- **Go Runtime**: Included in binary

---

## Installation Methods

### Debian Package Repository

Add the Travis CI repository and install via deb:

```bash
# Add Travis CI repository
curl -L https://deb.travis-ci.com/key.pub | sudo apt-key add -
echo "deb https://deb.travis-ci.com travis main" | sudo tee /etc/apt/sources.list.d/travis.list

# Update and install
sudo apt-get update
sudo apt-get install travis-worker
```

Verify installation:

```bash
travis-worker --version
```

### Docker Container Installation

Run `travis-worker` in a container:

```bash
# Pull image from Travis CI registry
docker pull travis-ci/worker:latest

# Run container with required environment variables
docker run -d \
  --name travis-worker \
  -e TRAVIS_WORKER_AMQP_URI="amqp://user:pass@rabbitmq.example.com:5672" \
  -e TRAVIS_WORKER_POOL_SIZE=4 \
  -e TRAVIS_WORKER_DOCKER_IMAGE="travis-ci/worker" \
  -v /var/run/docker.sock:/var/run/docker.sock \
  travis-ci/worker:latest
```

### Binary Installation

Download the compiled `travis-worker` binary:

```bash
# Download latest release
wget https://github.com/travis-ci/worker/releases/download/v13.0.0/travis-worker-linux-amd64 \
  -O /tmp/travis-worker

# Make executable and install
sudo mv /tmp/travis-worker /usr/local/bin/travis-worker
sudo chmod +x /usr/local/bin/travis-worker

# Verify
travis-worker --version
```

---

## Configuration and Environment Variables

### Essential Environment Variables

Configure `travis-worker` via environment variables:

```bash
# AMQP/RabbitMQ connection to TCI-E controller (REQUIRED)
export TRAVIS_WORKER_AMQP_URI="amqp://user:password@rabbitmq.example.com:5672"
```

Full configuration example:

```bash

# Docker configuration
export TRAVIS_WORKER_POOL_SIZE=4
export TRAVIS_WORKER_DOCKER_IMAGE="travis-ci/worker"

# Worker identification
export TRAVIS_WORKER_HOSTNAME="worker-1.example.com"
export TRAVIS_WORKER_QUEUE_NAME="default"

# Logging
export TRAVIS_WORKER_LOG_LEVEL="info"
export TRAVIS_WORKER_LOG_FORMAT="text"  # or "json"

# Build timeout
export TRAVIS_WORKER_HARD_TIMEOUT=3600  # 1 hour in seconds
export TRAVIS_WORKER_LOG_TIMEOUT=600    # 10 minutes no-output timeout
```

### Environment Variables Reference Table

| Variable | Purpose | Default |
| --- | --- | --- |
| `TRAVIS_WORKER_AMQP_URI` | RabbitMQ connection URI | Required |
| `TRAVIS_WORKER_POOL_SIZE` | Concurrent job goroutines | 2 |
| `TRAVIS_WORKER_DOCKER_IMAGE` | Default build container image | `travis-ci/worker` |
| `TRAVIS_WORKER_DOCKER_NETWORK` | Docker network for containers | `bridge` |
| `TRAVIS_WORKER_DOCKER_PRIVILEGED` | Run containers privileged | `false` |
| `TRAVIS_WORKER_DOCKER_INSECURE_REGISTRIES` | Comma-separated registries | (empty) |
| `TRAVIS_WORKER_HOSTNAME` | Worker hostname for display | Auto-detect |
| `TRAVIS_WORKER_QUEUE_NAME` | RabbitMQ queue name | `builds.default` |
| `TRAVIS_WORKER_HARD_TIMEOUT` | Max job duration in seconds | 3600 |
| `TRAVIS_WORKER_LOG_TIMEOUT` | No-output timeout in seconds | 600 |
| `TRAVIS_WORKER_LOG_LEVEL` | Log verbosity | `info` |
| `TRAVIS_WORKER_LOG_FORMAT` | Log format (text or json) | `text` |
| `TRAVIS_WORKER_METRICS_ENABLED` | Enable metrics endpoint | `false` |
| `TRAVIS_WORKER_METRICS_PORT` | Metrics listen port | 8080 |

### Configuration File Method

Store variables in `/etc/default/travis-worker` or `/etc/travis-worker/worker.conf`:

```bash
# /etc/default/travis-worker
export TRAVIS_WORKER_AMQP_URI="amqp://travis:secret@rabbitmq.example.com"
export TRAVIS_WORKER_POOL_SIZE=4
export TRAVIS_WORKER_DOCKER_IMAGE="travis-ci/worker:latest"
export TRAVIS_WORKER_LOG_LEVEL="debug"
```

Then start with systemd (see Service Management section).

---

## RabbitMQ Connection

### RabbitMQ URI Format

The `TRAVIS_WORKER_AMQP_URI` specifies RabbitMQ connectivity:

```text
amqp://username:password@host:port/vhost
amqp://travis:secret@rabbitmq.example.com:5672/
```

### Verifying RabbitMQ Connectivity

Test connection from worker host:

```bash
# Use amqp-url-cli tool (if available)
amqp-url-cli check amqp://user:pass@rabbitmq.example.com

# Or use Python
python3 -c "import pika; pika.BlockingConnection(pika.URLParameters('amqp://user:pass@host'))"
```

### Multiple Workers and Queue Depth

As workers register, RabbitMQ consumer count increases. Monitor via TCI-E dashboard or RabbitMQ API:

```bash
# Get consumer count for builds.default queue
curl http://admin:admin@rabbitmq.example.com:15672/api/queues/%2F/builds.default | jq '.consumers'
```

---

## Systemd Service Configuration

### Service File Setup

Create a systemd unit for `travis-worker`:

```ini
# /etc/systemd/system/travis-worker.service
[Unit]
Description=Travis CI Worker
After=network.target
Wants=network-online.target

[Service]
Type=simple
User=travis-worker
EnvironmentFile=/etc/default/travis-worker
ExecStart=/usr/bin/travis-worker
Restart=on-failure
RestartSec=10s

# Resource limits
MemoryLimit=8G
CPUQuota=80%

[Install]
WantedBy=multi-user.target
```

### Enable and Start Service

```bash
# Create travis-worker user (if not exists)
sudo useradd -r -s /bin/false travis-worker

# Reload systemd and enable service
sudo systemctl daemon-reload
sudo systemctl enable travis-worker
sudo systemctl start travis-worker

# Check status
sudo systemctl status travis-worker
```

---

## Docker Image Selection

### Official Travis Worker Image

The official Docker image for TCI-E:

```bash
# Pull image
docker pull travis-ci/worker:latest

# Inspect image
docker inspect travis-ci/worker:latest | jq '.[] | {Architecture, OsVersion}'
```

### Custom Build Images

Build custom images with pre-installed tools:

```dockerfile
# Dockerfile
FROM travis-ci/worker:latest

# Install additional tools
RUN apt-get update && apt-get install -y \
    postgresql-client \
    redis-tools \
    docker.io

# Save base image for reuse
ENV CUSTOM_IMAGE=myorg/travis-worker:custom
```

Build and push:

```bash
docker build -t myorg/travis-worker:custom .
docker push myorg/travis-worker:custom

# Configure worker to use custom image
export TRAVIS_WORKER_DOCKER_IMAGE="myorg/travis-worker:custom"
```

### Custom Registry Authentication

For private registries, configure credentials:

```bash
# Create .docker/config.json
docker login myregistry.azurecr.io

# Copy credentials into worker container/process
export DOCKER_AUTH_CONFIG=$(cat ~/.docker/config.json | base64 -w0)
```

---

## Registration Verification

### Check Worker Registration

Verify the worker is connected and operational via TCI-E dashboard or API:

```bash
# In TCI-E UI: Administration → Workers
# Should show worker name and status as "online"
```

### Monitor RabbitMQ Consumers

```bash
# View active consumers (number of connected workers)
curl http://admin:admin@rabbitmq.example.com:15672/api/consumers | jq '.[] | {vhost, queue, channel_details}'
```

Expected output shows one entry per connected worker.

---

## Troubleshooting Installation

### Connection Refused to RabbitMQ

Verify RabbitMQ connectivity and credentials:

```bash
# Test RabbitMQ connectivity
timeout 5 bash -c "cat < /dev/null > /dev/tcp/rabbitmq.example.com/5672" && echo "OK" || echo "Failed"

# Check credentials
amqp-cli connect amqp://user:pass@rabbitmq.example.com 2>&1
```

### Docker Socket Permission Denied

Ensure `travis-worker` user can access Docker socket:

```bash
# Add travis-worker to docker group
sudo usermod -aG docker travis-worker

# Restart service
sudo systemctl restart travis-worker
```

### Systemd Service Fails to Start

Check service logs:

```bash
sudo systemctl status travis-worker -l
sudo journalctl -u travis-worker -n 50
```

Fix config errors and restart.

---

## Windows Subsystem for Linux 2 (WSL2) Installation

Run travis-worker natively on WSL2 for Travis CI Enterprise testing/development:

### Prerequisites

- WSL2 with Ubuntu 20.04 LTS or later
- Docker installed in WSL2 (`sudo apt-get install docker.io`)
- RabbitMQ accessible from WSL2 network (use Windows host IP: `10.0.0.1` on WSL2)

### Installation Steps

```bash
# Inside WSL2 terminal

# Add Travis CI repository
curl -L https://deb.travis-ci.com/key.pub | sudo apt-key add -
echo "deb https://deb.travis-ci.com travis main" | sudo tee /etc/apt/sources.list.d/travis.list

# Install travis-worker
sudo apt-get update
sudo apt-get install travis-worker

# Create configuration
sudo mkdir -p /etc/travis-worker
```

### WSL2-Specific Configuration

```bash
# /etc/default/travis-worker for WSL2
sudo tee /etc/default/travis-worker > /dev/null <<'EOF'
# RabbitMQ on Windows network (from WSL2 perspective)
export TRAVIS_WORKER_AMQP_URI="amqp://user:pass@10.0.0.1:5672"

export TRAVIS_WORKER_POOL_SIZE=4
export TRAVIS_WORKER_DOCKER_IMAGE="travis-ci/worker:latest"

# WSL2 hostname
export TRAVIS_WORKER_HOSTNAME="$(hostname)-wsl2"

# Logging
export TRAVIS_WORKER_LOG_LEVEL="info"
EOF
```

### Docker Socket in WSL2

Add WSL2 user to docker group:

```bash
# Enable Docker daemon access without sudo
sudo usermod -aG docker $USER

# Restart Docker
sudo systemctl restart docker

# Verify
docker ps
```

### Enable and Start Service

```bash
# Create systemd service
sudo systemctl daemon-reload
sudo systemctl enable travis-worker
sudo systemctl start travis-worker

# Check status
sudo systemctl status travis-worker
sudo journalctl -u travis-worker -f
```

### WSL2 Network Connectivity Notes

| Resource | Access from WSL2 |
| --- | --- |
| Windows host services | Use host IP: `10.0.0.1` or `host.docker.internal` |
| RabbitMQ on Windows | `10.0.0.1:5672` (default WSL2 gateway) |
| Docker Desktop daemon | Shared automatically with WSL2 |
| External URLs | Direct access (WSL2 proxies through Windows network) |

### Troubleshooting WSL2 Connection

```bash
# Test RabbitMQ connectivity from WSL2
telnet 10.0.0.1 5672

# Check Docker daemon
docker ps

# If Docker daemon not accessible
# - Restart Docker Desktop on Windows
# - Ensure WSL2 backend enabled in Docker Desktop settings
```

### Performance Notes for WSL2

- Build workspace: Keep in WSL2 filesystem (`/home/travis/`) for best I/O
- Artifacts: Avoid mounting Windows paths via `/mnt/c/` (slower)
- Memory: Allocate adequate RAM to WSL2 in Windows `.wslconfig` if hitting limits
