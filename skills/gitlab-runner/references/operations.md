# GitLab Runner Operations

Manage, monitor, and troubleshoot runners in production.

---

## Runner Status Commands

### List Runners

Display all registered runners:

```bash
gitlab-runner list
```

Output shows runner name, URL, and executor type.

### Verify Connectivity

Test if runners can connect to GitLab:

```bash
sudo gitlab-runner verify
```

Confirms network connectivity, token validity, and GitLab API access.

### Run a Specific Runner

Execute jobs for a named runner:

```bash
gitlab-runner run --help
```

This is typically managed by systemd on Linux.

---

## Service Management

### Systemd (Linux)

Control the `gitlab-runner` service:

```bash
# Start
sudo systemctl start gitlab-runner

# Stop
sudo systemctl stop gitlab-runner

# Restart (graceful reload)
sudo systemctl restart gitlab-runner

# Check status
sudo systemctl status gitlab-runner

# View logs
sudo journalctl -u gitlab-runner -f

# Enable on boot
sudo systemctl enable gitlab-runner
```

### Logs and Diagnostics

View runner logs from systemd journal:

```bash
# Last 50 lines
sudo journalctl -u gitlab-runner -n 50

# Follow in real-time
sudo journalctl -u gitlab-runner -f

# Logs since last boot
sudo journalctl -u gitlab-runner -b

# Logs for specific date range
sudo journalctl -u gitlab-runner --since "2024-01-01" --until "2024-01-02"
```

### macOS (launchd)

Control runner as a launch agent:

```bash
# Start
gitlab-runner start

# Stop
gitlab-runner stop

# Restart
gitlab-runner restart

# Check status
gitlab-runner status

# View logs
tail -f ~/Library/Logs/gitlab-runner.log
```

### Windows (PowerShell Service)

```powershell
# Start service
Start-Service -Name gitlab-runner

# Stop service
Stop-Service -Name gitlab-runner

# Restart
Restart-Service -Name gitlab-runner

# Check status
Get-Service -Name gitlab-runner

# View logs
Get-EventLog -LogName Application | Where-Object { $_.Source -like "*gitlab-runner*" }
```

---

## Log Management

### Log Level Configuration

Set verbosity in `config.toml`:

```toml
log_level = "info"   # debug, info, warn, error
log_format = "text"  # text or json (for structured logging)
```

Log levels:

- `debug`: Detailed internal state (verbose, for troubleshooting)
- `info`: Normal operation (default)
- `warn`: Warnings and issues
- `error`: Errors only

### Log Locations

| Platform | Location |
| --- | --- |
| Linux (systemd) | journalctl output; also `/var/log/gitlab-runner/` if configured |
| Docker | `docker logs <container>` |
| Kubernetes | `kubectl logs <pod>` |
| macOS | `~/Library/Logs/gitlab-runner.log` |
| Windows | Windows Event Viewer (Application log) |

---

## Pause and Resume Runners

### Pause via GitLab UI

Prevent a runner from accepting new jobs:

1. Navigate to Admin → Runners (or Group/Project → CI/CD → Runners)
2. Find the runner
3. Click **Pause** (or **Resume** to re-enable)

Paused runners finish in-progress jobs but do not pick up new ones.

### Pause via API

```bash
# Get runner ID first
RUNNER_ID=$(curl --header "PRIVATE-TOKEN: $CI_JOB_TOKEN" \
  https://gitlab.example.com/api/v4/runners?status=online | \
  jq '.[0].id')

# Pause runner
curl --request PUT \
  --header "PRIVATE-TOKEN: $CI_JOB_TOKEN" \
  https://gitlab.example.com/api/v4/runners/$RUNNER_ID \
  --data "paused=true"
```

---

## Upgrade and Maintenance

### Check Current Version

```bash
gitlab-runner --version
```

### Upgrade via Package Manager

```bash
# Debian/Ubuntu
sudo apt-get upgrade gitlab-runner

# RHEL/CentOS
sudo yum upgrade gitlab-runner
sudo systemctl restart gitlab-runner
```

### Manual Upgrade

```bash
# Download new binary
curl -L https://gitlab-runner-downloads.s3.amazonaws.com/latest/deb/gitlab-runner_amd64.deb -o gitlab-runner-new.deb

# Stop service
sudo systemctl stop gitlab-runner

# Backup current config
sudo cp -r /etc/gitlab-runner /etc/gitlab-runner.backup

# Upgrade
sudo dpkg -i gitlab-runner-new.deb

# Start service
sudo systemctl start gitlab-runner

# Verify
gitlab-runner verify
```

### Docker Image Upgrade

```bash
# Pull new image
docker pull gitlab/gitlab-runner:latest

# Stop old container
docker stop gitlab-runner

# Remove old container
docker rm gitlab-runner

# Run new container with same volumes
docker run -d \
  --name gitlab-runner \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v gitlab-runner-config:/etc/gitlab-runner \
  gitlab/gitlab-runner:latest
```

### Kubernetes Upgrade

```bash
# Update Helm repository
helm repo update

# Upgrade release
helm upgrade gitlab-runner gitlab/gitlab-runner -f values.yaml
```

---

## Troubleshooting

### Runner Not Picking Up Jobs

1. **Verify runner is online** — Check GitLab UI (Runners page shows green status)
2. **Check job tags** — Ensure job tags match runner tags in config.toml
3. **Check job rules** — Verify job rules allow execution (check `only`/`except` or `rules`)
4. **Check runner capacity** — Ensure `limit` and `concurrent` are not saturated
5. **View logs** — Check runner logs for error messages

```bash
sudo journalctl -u gitlab-runner -f
```

### TLS Certificate Errors

If connecting to GitLab via HTTPS with self-signed certificate:

```toml
[[runners]]
  tls_ca_file = "/etc/ssl/certs/custom-ca.crt"
```

Or disable certificate verification (not recommended for production):

```toml
[[runners]]
  tls_verify = false
```

### Docker Socket Permission Denied

Add `gitlab-runner` user to docker group:

```bash
sudo usermod -aG docker gitlab-runner
sudo systemctl restart gitlab-runner
```

### /builds Directory Ownership Issues

Ensure `/builds` directory on host is owned by the runner process:

```bash
# For Docker executor
sudo chown -R gitlab-runner:gitlab-runner /var/lib/gitlab-runner/builds

# For SSH executor
sudo chown -R ci-user:ci-user /home/ci-user/builds
```

### Disk Space and Cleanup

Runners accumulate build artifacts and Docker layers. Monitor disk usage:

```bash
# Check disk usage
df -h

# Clean Docker system (prune unused images, containers, volumes)
sudo docker system prune -a
```

Configure artifact retention in `.gitlab-ci.yml` to prevent unbounded growth:

```yaml
job:
  artifacts:
    expire_in: 30 days  # Expire artifacts after 30 days
```

---

## Monitoring and Metrics

### Runner Metrics

Enable Prometheus metrics endpoint in `config.toml`:

```toml
metrics_server = "localhost:9252"
```

Access metrics at `http://localhost:9252/metrics`.

### Key Metrics

- `gitlab_runner_job_duration_seconds` — Job execution time
- `gitlab_runner_jobs_total` — Total jobs executed
- `gitlab_runner_errors_total` — Total errors
- `gitlab_runner_autoscaling_machine_creation_duration_seconds` — VM provisioning time

Scrape these metrics into Prometheus/Grafana for dashboards and alerts.

---

## Graceful Shutdown and Draining

Before maintenance, drain in-progress jobs gracefully:

```bash
# Stop accepting new jobs but finish current ones
sudo systemctl stop gitlab-runner  # This allows current jobs to finish

# Or set long timeout
sudo systemctl stop --no-block gitlab-runner
sleep 120  # Wait for jobs to finish
```

After maintenance, restart:

```bash
sudo systemctl start gitlab-runner
```
