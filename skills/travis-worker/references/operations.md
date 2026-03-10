# Travis CI Enterprise Worker Operations

Manage, monitor, and troubleshoot `travis-worker` in production.

---

## Service Control

### Systemd Service Management

Control `travis-worker` via systemd on Linux:

```bash
# Start service
sudo systemctl start travis-worker

# Stop service (graceful)
sudo systemctl stop travis-worker

# Restart service
sudo systemctl restart travis-worker

# Check status
sudo systemctl status travis-worker

# View logs
sudo journalctl -u travis-worker -f

# Enable on boot
sudo systemctl enable travis-worker
```

### Docker Container Management

Control `travis-worker` running in Docker:

```bash
# Start container
docker start travis-worker

# Stop container (graceful)
docker stop travis-worker

# Restart container
docker restart travis-worker

# View logs
docker logs -f travis-worker

# Check status
docker ps | grep travis-worker
```

---

## Logging and Diagnostics

### Log Levels

Configure verbosity in environment or config file:

```bash
# debug: Detailed internal state (verbose)
export TRAVIS_WORKER_LOG_LEVEL="debug"

# info: Normal operation (default)
export TRAVIS_WORKER_LOG_LEVEL="info"

# warn: Warnings and potential issues
export TRAVIS_WORKER_LOG_LEVEL="warn"

# error: Errors only
export TRAVIS_WORKER_LOG_LEVEL="error"
```

### Log Format

Choose between human-readable and structured logging:

```bash
# Text format (default, human-readable)
export TRAVIS_WORKER_LOG_FORMAT="text"

# JSON format (structured logging, for log aggregation)
export TRAVIS_WORKER_LOG_FORMAT="json"
```

JSON output example:

```json
{"@timestamp":"2024-01-10T14:25:30Z","level":"info","msg":"Starting worker","component":"worker"}
```

### Log Location

View logs from different sources:

```bash
# Systemd journal (Linux)
sudo journalctl -u travis-worker -n 100 -f

# Docker logs
docker logs travis-worker

# File-based (if configured)
tail -f /var/log/travis-worker.log

# Check all logs since last boot
sudo journalctl -u travis-worker -b
```

### Debugging Long-Lived Issues

Collect diagnostic information:

```bash
# Check current worker status
systemctl status travis-worker
journalctl -u travis-worker --since "30 min ago"

# Check Docker container state
docker inspect travis-worker | jq '.[] | {State, Status}'

# Check RabbitMQ connectivity
rabbitmqctl list_consumers

# Check disk and memory
df -h
free -h
```

---

## Draining and Maintenance

### Graceful Drain

Stop accepting new jobs but finish in-progress builds before shutdown:

```bash
# Set worker to drain mode (no new jobs accepted)
# Method 1: Kill with signal (allows in-progress jobs to finish)
sudo systemctl stop --no-block travis-worker

# Method 2: Manually pause via TCI-E UI
# Navigate to Workers → Select worker → Pause

# Wait for in-progress jobs to complete
watch -n 5 "docker ps | grep -c build"  # Monitor active builds

# Once builds complete, stop service
sudo systemctl stop travis-worker
```

### Update and Restart

Perform maintenance with minimal disruption:

```bash
# Drain existing jobs
sudo systemctl stop --no-block travis-worker

# Wait for completion
sleep 300  # Wait 5 minutes

# Stop service (if still running)
sudo systemctl stop travis-worker

# Perform maintenance (update, reconfigure)
sudo apt-get update && sudo apt-get upgrade travis-worker

# Restart service
sudo systemctl start travis-worker

# Verify operational
sleep 10 && systemctl status travis-worker
```

---

## Token and Credential Rotation

### RabbitMQ Credentials Update

Update RabbitMQ connection when credentials change:

```bash
# Update environment variable
sudo nano /etc/default/travis-worker
# Edit: TRAVIS_WORKER_AMQP_URI="amqp://newuser:newpass@rabbitmq.example.com"

# Reload and restart
sudo systemctl daemon-reload
sudo systemctl restart travis-worker

# Verify connection
sudo journalctl -u travis-worker --since "5 min ago" | grep "Connected"
```

### Docker Registry Token Update

Update registry credentials for private images:

```bash
# Update Docker credentials
docker login myregistry.azurecr.io

# Export new config
export DOCKER_AUTH_CONFIG=$(cat ~/.docker/config.json | base64 -w0)

# Update worker environment
echo "export DOCKER_AUTH_CONFIG='$DOCKER_AUTH_CONFIG'" | sudo tee -a /etc/default/travis-worker

# Restart worker
sudo systemctl restart travis-worker
```

---

## Monitoring and Metrics

### Health Checks

Monitor worker health and queue status:

```bash
# Check RabbitMQ consumer count (number of connected workers)
curl -u admin:password http://rabbitmq.example.com:15672/api/consumers | jq 'length'

# Expected: 1+ for each running worker

# Check queue depth (number of pending jobs)
curl -u admin:password http://rabbitmq.example.com:15672/api/queues/%2F/builds.default | jq '.messages'
```

### Prometheus Metrics

Enable and scrape metrics:

```bash
# Enable metrics in worker config
export TRAVIS_WORKER_METRICS_ENABLED="true"
export TRAVIS_WORKER_METRICS_PORT="8080"

# Scrape metrics endpoint
curl http://localhost:8080/metrics

# Key metrics:
# - travis_worker_pool_busy_workers (current active jobs)
# - travis_worker_pool_queue_depth (waiting jobs)
# - travis_worker_build_duration_seconds (job execution time)
# - travis_worker_builds_total (total jobs run)
```

### Key Performance Indicators (KPIs)

Monitor these metrics to assess worker health:

| KPI | Target | Action |
| --- | --- | --- |
| **Job Queue Depth** | < 5 minutes wait | Add workers if consistently high |
| **Average Build Duration** | < 30 min (typical) | Optimize jobs if consistently high |
| **Worker Availability** | >= 95% | Investigate connection issues if low |
| **Disk Usage** | < 80% | Clean up old builds or increase capacity |

---

## Troubleshooting

### Worker Not Accepting Jobs

Verify worker is registered and operational:

```bash
# Check worker is online in TCI-E UI (Admin → Workers)
# OR check via API:
curl -H "Authorization: token $ADMIN_TOKEN" https://tci-e.example.com/api/v3/workers

# Check RabbitMQ consumer registration
curl -u admin:pass http://rabbitmq:15672/api/consumers | grep "builds.default"

# If missing, restart worker
sudo systemctl restart travis-worker
```

### RabbitMQ Connection Failures

Test and fix RabbitMQ connectivity:

```bash
# Test network connectivity to RabbitMQ
timeout 5 bash -c "cat < /dev/null > /dev/tcp/rabbitmq.example.com/5672"

# Test credentials
amqp-cli connect amqp://user:pass@rabbitmq.example.com:5672

# Check worker logs for auth errors
sudo journalctl -u travis-worker | grep -i "auth\|connection"

# Verify AMQP_URI format is correct
echo $TRAVIS_WORKER_AMQP_URI
# Expected: amqp://user:pass@host:port/vhost
```

### Docker Permission Issues

Fix Docker socket access:

```bash
# Verify Docker is running
docker ps

# Check travis-worker user docker group membership
groups travis-worker

# Add to docker group if missing
sudo usermod -aG docker travis-worker

# Restart service
sudo systemctl restart travis-worker
```

### Stuck or Zombie Build Containers

Clean up stalled builds:

```bash
# List active containers
docker ps | grep build

# Inspect container for stuck processes
docker exec <container> ps aux

# Kill stuck container (force)
docker kill <container>

# Clean up dangling containers
docker container prune -f
```

### Build Image Pull Failures

Debug image pull issues:

```bash
# Check image availability locally
docker images | grep travis-ci/worker

# Test manual pull
docker pull travis-ci/worker:latest

# Check for private registry auth issues
docker pull myregistry/image:tag  # Should succeed with DOCKER_AUTH_CONFIG set

# Verify pull policy configuration
echo $TRAVIS_WORKER_DOCKER_PULL_POLICY
```

### High Memory or Disk Usage

Monitor and clean up resource usage:

```bash
# Check disk usage
du -sh /data/travis-builds/*

# Clean old builds (>7 days)
find /data/travis-builds -atime +7 -type d -exec rm -rf {} \;

# Check memory usage
free -h
docker stats

# Prune Docker system (remove unused images, containers, volumes)
docker system prune -a
```

---

## Upgrade Process

### Minor Version Upgrade (Patch)

```bash
# Stop worker gracefully
sudo systemctl stop --no-block travis-worker

# Wait for builds to complete
sleep 300

# Upgrade via package manager
sudo apt-get update && sudo apt-get upgrade travis-worker

# Start worker
sudo systemctl start travis-worker

# Verify
journalctl -u travis-worker --since "5 min ago"
```

### Major Version Upgrade (Breaking Changes)

Consult release notes and plan downtime:

```bash
# Backup configuration
sudo cp -r /etc/default/travis-worker /etc/default/travis-worker.backup

# Drain and stop
sudo systemctl stop --no-block travis-worker
sleep 600

# Upgrade
sudo apt-get upgrade travis-worker

# Verify config compatibility
travis-worker --version

# Start
sudo systemctl start travis-worker
```

### Rollback

Revert to previous version if upgrade fails:

```bash
# Pin version to previous release
sudo apt-mark hold travis-worker

# Reinstall previous version
sudo apt-get install travis-worker=<PREVIOUS_VERSION>

# Restart
sudo systemctl restart travis-worker
```

---

## Performance Tuning

### Increase Job Throughput

Optimize for higher concurrency:

```bash
# Increase pool size
export TRAVIS_WORKER_POOL_SIZE=16

# Increase resource limits per job
export TRAVIS_WORKER_DOCKER_CPUS="2"
export TRAVIS_WORKER_DOCKER_MEMORY="4g"

# Reduce timeout for faster job failures
export TRAVIS_WORKER_LOG_TIMEOUT=300  # 5 minutes

# Restart worker
sudo systemctl restart travis-worker
```

### Reduce Job Latency

Optimize for faster job pickup:

```bash
# Pre-cache build images
docker pull travis-ci/worker:latest
docker pull myregistry/custom-worker:latest

# Use "never" pull policy if images are cached
export TRAVIS_WORKER_DOCKER_PULL_POLICY="never"

# Use host networking for lower latency (if isolated network not required)
export TRAVIS_WORKER_DOCKER_NETWORK="host"
```
