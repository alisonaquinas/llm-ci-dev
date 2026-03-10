# Travis CI Enterprise Worker Configuration

Configure pool sizing, build images, resource limits, and worker groups in Travis CI Enterprise.

---

## Worker Pool Sizing

### Pool Size (Concurrency)

Set the number of concurrent jobs a worker can process:

```bash
export TRAVIS_WORKER_POOL_SIZE=4  # Process 4 jobs simultaneously
```

### Capacity Planning Formula

Determine appropriate pool size based on infrastructure:

```text
Recommended Pool Size = (Total CPU Cores - 1) / 2 - 1

Example: 16-core machine
  Pool Size = (16 - 1) / 2 - 1 = 6-7 concurrent jobs
```

Factors:

- **CPU**: Higher pool size requires more cores
- **Memory**: Each job needs ~512 MB - 2 GB depending on workload
- **Disk**: Workspace grows with build artifacts; ensure sufficient space

### Tuning Pool Size for Load

Monitor job queue depth and worker saturation:

- **Queue depth growing**: Increase pool size (if resources available)
- **High CPU/memory usage**: Decrease pool size or add more workers
- **Frequent timeouts**: Decrease pool size or optimize jobs

---

## Build Image Configuration

### Default Build Image

Specify the default Docker image for all builds:

```bash
export TRAVIS_WORKER_DOCKER_IMAGE="travis-ci/worker:latest"
```

Override in .travis.yml for specific jobs:

```yaml
# .travis.yml
image: myregistry.example.com/custom-worker:1.0
```

### Custom Build Images (Packer)

Build custom images with pre-installed tools using Packer:

```hcl
# packer/custom-worker.json
{
  "builders": [
    {
      "type": "docker",
      "image": "travis-ci/worker:latest",
      "pull": true,
      "commit": true
    }
  ],
  "provisioners": [
    {
      "type": "shell",
      "inline": [
        "apt-get update",
        "apt-get install -y postgresql-client redis-tools",
        "npm install -g firebase-tools"
      ]
    }
  ],
  "post-processors": [
    {
      "type": "docker-tag",
      "repository": "myregistry/worker",
      "tag": "1.0"
    }
  ]
}
```

Build and push:

```bash
packer build packer/custom-worker.json
docker push myregistry/worker:1.0
```

### Private Registry Authentication

Configure credentials for private registries:

```bash
# Create registry credentials
echo '{"auths":{"myregistry.azurecr.io":{"username":"user","password":"token"}}}' | base64 -w0

# Set as environment variable
export DOCKER_AUTH_CONFIG="<BASE64_ENCODED_CONFIG>"

# Or login and copy config
docker login myregistry.azurecr.io
export DOCKER_AUTH_CONFIG=$(cat ~/.docker/config.json | base64 -w0)
```

---

## Resource Limits per Build

### CPU and Memory Limits

Control resource usage per build job:

```bash
# Per-job CPU limit (1 = 1 full CPU)
export TRAVIS_WORKER_DOCKER_CPUS="1.5"

# Per-job memory limit
export TRAVIS_WORKER_DOCKER_MEMORY="2g"

# Memory swap limit
export TRAVIS_WORKER_DOCKER_MEMORY_SWAP="3g"
```

Docker run command generated:

```bash
docker run \
  --cpus=1.5 \
  --memory=2g \
  --memory-swap=3g \
  <image>
```

### Timeout Configuration

Set job execution timeouts:

```bash
# Hard timeout: max job duration (in seconds)
export TRAVIS_WORKER_HARD_TIMEOUT=3600  # 1 hour

# Log timeout: max time without output (in seconds)
export TRAVIS_WORKER_LOG_TIMEOUT=600    # 10 minutes
```

Jobs exceeding either timeout are terminated.

---

## Docker Network Configuration

### Network Mode

Select the network mode for build containers:

```bash
export TRAVIS_WORKER_DOCKER_NETWORK="bridge"  # Default; isolated network
export TRAVIS_WORKER_DOCKER_NETWORK="host"    # Host network (faster, less isolated)
```

### DNS Configuration

Override DNS for builds:

```bash
export TRAVIS_WORKER_DOCKER_DNS="8.8.8.8"
export TRAVIS_WORKER_DOCKER_DNS="8.8.4.4"
```

### Custom Docker Networks

Connect build containers to specific networks:

```bash
# Create custom network on host
docker network create builds-net --driver bridge

# Configure worker to use it
export TRAVIS_WORKER_DOCKER_NETWORK_NAME="builds-net"
```

---

## Worker Groups and Queue Routing

### Queue Names

Route jobs to specific workers via queue names:

```bash
# Worker 1 (high-performance jobs)
export TRAVIS_WORKER_QUEUE_NAME="builds.performance"

# Worker 2 (routine jobs)
export TRAVIS_WORKER_QUEUE_NAME="builds.standard"
```

In `.travis.yml`, specify target queue:

```yaml
os: linux
# Route to specific queue (via TCI-E)
group: performance
```

### Multiple Workers with Different Pools

Scale with different pool sizes per worker:

```bash
# Worker 1: high-capacity
POOL_SIZE=8 QUEUE_NAME="builds.default" travis-worker

# Worker 2: low-capacity for special jobs
POOL_SIZE=2 QUEUE_NAME="builds.special" travis-worker
```

---

## Build Workspace Configuration

### Workspace Directory

Configure where builds store files:

```bash
# Default: /tmp/build-workspace
export TRAVIS_WORKER_WORKSPACE_DIR="/data/travis-builds"
```

Ensure the directory:

- Has sufficient disk space (100+ GB recommended)
- Is owned by the travis-worker process
- Has adequate permissions (755)

```bash
sudo mkdir -p /data/travis-builds
sudo chown travis-worker:travis-worker /data/travis-builds
sudo chmod 755 /data/travis-builds
```

### Cleanup Policy

Configure how long build artifacts persist:

```bash
# No explicit cleanup configuration in worker
# Use TCI-E UI to set retention policies
# Or use cronjob:
*/30 * * * * find /data/travis-builds -atime +7 -delete  # Delete >7 days old
```

---

## Advanced Configuration

### Metrics and Monitoring

Enable Prometheus metrics:

```bash
export TRAVIS_WORKER_METRICS_ENABLED="true"
export TRAVIS_WORKER_METRICS_PORT="8080"
export TRAVIS_WORKER_METRICS_LISTEN="0.0.0.0:8080"
```

Scrape metrics:

```bash
# Get metrics
curl http://localhost:8080/metrics
```

### Logging Configuration

Control logging verbosity and format:

```bash
# Log level: debug, info, warn, error
export TRAVIS_WORKER_LOG_LEVEL="debug"

# Log format: text or json (for structured logging)
export TRAVIS_WORKER_LOG_FORMAT="json"

# Log output (default: stderr)
export TRAVIS_WORKER_LOG_FILE="/var/log/travis-worker.log"
```

### Build Image Update Strategy

Control when build images are pulled:

```bash
# Always pull latest image (slower but fresh)
export TRAVIS_WORKER_DOCKER_PULL_POLICY="always"

# Pull only if not cached (faster, may miss updates)
export TRAVIS_WORKER_DOCKER_PULL_POLICY="if-not-present"

# Never pull; use cached only (fastest, requires pre-cache)
export TRAVIS_WORKER_DOCKER_PULL_POLICY="never"
```

---

## Configuration Examples

### Small Deployment (1-2 Workers)

```bash
# /etc/default/travis-worker
export TRAVIS_WORKER_AMQP_URI="amqp://travis:secret@rabbitmq.local"
export TRAVIS_WORKER_POOL_SIZE=4
export TRAVIS_WORKER_DOCKER_IMAGE="travis-ci/worker:latest"
export TRAVIS_WORKER_DOCKER_MEMORY="2g"
export TRAVIS_WORKER_LOG_LEVEL="info"
```

### Large Deployment (10+ Workers)

```bash
# Worker 1: standard jobs (high concurrency)
export TRAVIS_WORKER_QUEUE_NAME="builds.default"
export TRAVIS_WORKER_POOL_SIZE=8
export TRAVIS_WORKER_DOCKER_CPUS="2"
export TRAVIS_WORKER_DOCKER_MEMORY="4g"

# Worker 2: special jobs (low concurrency)
export TRAVIS_WORKER_QUEUE_NAME="builds.special"
export TRAVIS_WORKER_POOL_SIZE=2
export TRAVIS_WORKER_DOCKER_CPUS="1"
export TRAVIS_WORKER_DOCKER_MEMORY="2g"

# Common settings
export TRAVIS_WORKER_AMQP_URI="amqp://travis:secret@rabbitmq.prod"
export TRAVIS_WORKER_METRICS_ENABLED="true"
export TRAVIS_WORKER_LOG_LEVEL="warn"
```

### Performance Tuning

```bash
# For high-throughput environments
export TRAVIS_WORKER_POOL_SIZE=16
export TRAVIS_WORKER_DOCKER_CPUS="1.5"
export TRAVIS_WORKER_DOCKER_MEMORY="3g"
export TRAVIS_WORKER_HARD_TIMEOUT=7200  # 2 hours for long-running builds
export TRAVIS_WORKER_LOG_TIMEOUT=1200   # 20 minutes no-output
```
