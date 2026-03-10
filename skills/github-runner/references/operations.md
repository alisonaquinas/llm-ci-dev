# GitHub Actions Runner Operations

Manage, monitor, and troubleshoot runners in production.

---

## Service Control

### Linux (Systemd)

Control runner service on Linux:

```bash
# Start service
sudo systemctl start actions.runner.*

# Stop service (graceful)
sudo systemctl stop actions.runner.*

# Restart
sudo systemctl restart actions.runner.*

# Check status
sudo systemctl status actions.runner.*

# View logs
sudo journalctl -u actions.runner.* -f

# Enable on boot
sudo systemctl enable actions.runner.*
```

### macOS (launchd)

Control runner service on macOS:

```bash
# Start service
~/runner/svc.sh start

# Stop service
~/runner/svc.sh stop

# Restart
~/runner/svc.sh restart

# Check status
~/runner/svc.sh status

# View logs
tail -f ~/Library/Logs/actions.runner.*.log
```

### Windows (PowerShell Service)

Control runner service on Windows:

```powershell
# Start service
Start-Service -Name "actions.runner.*"

# Stop service
Stop-Service -Name "actions.runner.*"

# Restart
Restart-Service -Name "actions.runner.*"

# Check status
Get-Service -Name "actions.runner.*"

# View logs
Get-EventLog -LogName Application | Where-Object { $_.Source -like "actions.runner*" }
```

---

## Token Rotation

### Rotate Registration Token

Update runner authentication credentials:

```bash
# Generate new token from GitHub (Settings → Actions → Runners)

# Remove current registration
cd ~/runner
./config.sh remove

# Re-register with new token
./config.sh \
  --url https://github.com/owner/repo \
  --token <NEW_TOKEN> \
  --name my-runner \
  --labels linux,docker

# Restart service
sudo systemctl restart actions.runner.*
```

### Rotate Secrets Used in Workflows

Update repository or organization secrets:

- **Repository secrets**: Settings → Secrets and variables → Actions → Secrets
- **Organization secrets**: Settings → Secrets and variables → Actions → Secrets

New/updated secrets are available in subsequent workflow runs.

---

## Runner Updates

### Auto-Update (Enabled by Default)

Runner automatically updates when new version available:

```bash
# Verify auto-update is enabled
grep -i autoUpdate ~/.runner

# Check runner version
./run.sh --version
```

### Manual Update

Disable auto-update and manually update:

```bash
# Disable auto-update during registration
./config.sh --disableupdate

# Or edit after registration
# In runner root: nano .runner
# Change "autoUpdate": false

# Manually download and extract new version
cd ~/runner
./bin/Runner.Listener exit
# Replace runner binary with new version
tar xzf actions-runner-linux-x64-latest.tar.gz
./bin/Runner.Listener run
```

### Update Process

When auto-update triggers:

1. Runner finishes current job
2. Pauses accepting new jobs
3. Downloads and extracts new binary
4. Restarts service with new version
5. Resumes accepting jobs

No downtime for running jobs.

---

## Firewall and Network Requirements

### Outbound HTTPS Requirements

Runner must access GitHub APIs and artifacts:

| Destination | Port | Purpose |
| --- | --- | --- |
| `github.com` | 443 | Repository cloning, API |
| `api.github.com` | 443 | Actions API, authentication |
| `objects.githubusercontent.com` | 443 | Artifact downloads |
| `github-releases.githubusercontent.com` | 443 | Runner auto-updates |
| `codeload.github.com` | 443 | Source code downloads |

### Proxy Configuration

Configure runner to use HTTP/HTTPS proxy:

```bash
export HTTPS_PROXY="http://proxy.example.com:8080"
export HTTP_PROXY="http://proxy.example.com:8080"
export NO_PROXY="localhost,127.0.0.1,.internal.company.com"

# Start runner with proxy settings
./run.sh
```

### Self-Signed Certificates

For HTTPS inspection or internal GitHub servers:

```bash
export NODE_EXTRA_CA_CERTS="/path/to/ca-bundle.crt"
./run.sh
```

---

## Monitoring and Logs

### Check Runner Status

Verify runner is online and healthy:

```bash
# Via GitHub API
curl -H "Authorization: token $GITHUB_TOKEN" \
  https://api.github.com/repos/owner/repo/actions/runners | \
  jq '.runners[] | {name, status, busy}'

# Expected output: "status": "online"
```

### View Detailed Logs

Enable debug logging:

```bash
# Start runner in debug mode
cd ~/runner
./run.sh --debug

# Or set environment variable
export ACTIONS_RUNNER_DEBUG=true
./run.sh

# Check logs for errors
journalctl -u actions.runner.* --since "10 min ago" | grep -i error
```

### Diagnostic Bundle

Collect diagnostic information:

```bash
# Generate diagnostic file (includes logs, config, system info)
cd ~/runner
./run.sh --diag

# Output: _diag-20240110-143025.zip
# Submit to GitHub Support if needed
```

---

## Ephemeral Runner Management

### Ephemeral Runner Lifecycle

Ephemeral runners exit after each job:

```bash
# Start ephemeral runner
./config.sh --ephemeral ...
./run.sh

# After one job completes, runner exits automatically
# To run continuously, start new instance
```

Useful for:

- Kubernetes ARC deployments
- Auto-scaling environments
- Temporary CI runners

### Clean Up Ephemeral Infrastructure

```bash
# Docker containers (if running in containers)
docker ps -a | grep actions-runner | grep Exited
docker rm <container-id>

# Kubernetes pods (if using ARC)
kubectl delete pod <runner-pod> -n actions-runner-system
```

---

## Troubleshooting

### Runner Not Accepting Jobs

Verify runner is online and ready:

```bash
# Check GitHub UI: Settings → Actions → Runners
# Status should be green (online)

# Check runner logs
journalctl -u actions.runner.* --since "5 min ago"

# Verify connectivity
./run.sh --check
```

Common causes:

- Runner offline or not registered
- Token expired
- Runner paused (via GitHub UI)
- Job labels don't match runner labels

### Connection Failures

Test GitHub connectivity:

```bash
# Test API connectivity
curl -I https://api.github.com

# Test with proxy (if configured)
curl -x http://proxy.example.com:8080 https://api.github.com

# Test DNS
nslookup api.github.com
```

### Runner Crashes or Restarts Constantly

Check for errors in logs:

```bash
# View recent logs
journalctl -u actions.runner.* -n 100

# Check system resources
free -h  # Memory
df -h    # Disk

# Look for permission or dependency issues
./config.sh --check
```

### Job Timeouts

If jobs timeout before completion:

```bash
# Jobs have no built-in timeout in Actions
# Timeout happens at workflow level:

jobs:
  build:
    runs-on: self-hosted
    timeout-minutes: 120  # Custom timeout
    steps:
      - uses: actions/checkout@v4
```

Also check runner disk space; insufficient space causes job failures.

---

## Pause and Resume

### Pause Runner via UI

Prevent runner from accepting new jobs:

1. Go to: **Settings** → **Actions** → **Runners**
2. Select runner
3. Click **Pause runner**

Paused runner finishes in-progress jobs but rejects new ones.

### Resume Runner via UI

1. Go to: **Settings** → **Actions** → **Runners**
2. Select paused runner
3. Click **Resume runner**

### Via API

```bash
# Pause runner
curl -X PATCH \
  -H "Authorization: token $GITHUB_TOKEN" \
  https://api.github.com/repos/owner/repo/actions/runners/<RUNNER_ID> \
  -d '{"active": false}'

# Resume runner
curl -X PATCH \
  -H "Authorization: token $GITHUB_TOKEN" \
  https://api.github.com/repos/owner/repo/actions/runners/<RUNNER_ID> \
  -d '{"active": true}'
```

---

## Remove Runner

Unregister runner from GitHub:

```bash
cd ~/runner

# Stop service first
sudo systemctl stop actions.runner.*

# Remove registration
./config.sh remove

# Uninstall service
./svc.sh uninstall
```

After removal, runner no longer appears in GitHub UI and cannot accept jobs.

---

## Performance Optimization

### Increase Job Throughput

Run multiple jobs in parallel (careful with resource consumption):

```bash
# Multiple runner instances on same machine
# Create separate directories and register each separately
~/runner1/config.sh --url ... --name runner-1
~/runner2/config.sh --url ... --name runner-2

# Start both services
sudo systemctl start actions.runner.owner-repo.runner-1.service
sudo systemctl start actions.runner.owner-repo.runner-2.service
```

### Optimize Job Speed

- Cache dependencies (workflow artifacts)
- Use matrix builds for parallel testing
- Pre-install common tools on runner
- Use Docker images with pre-baked tools

```yaml
jobs:
  build:
    runs-on: self-hosted
    strategy:
      matrix:
        node-version: [18, 20, 21]
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
          cache: 'npm'  # Cache npm dependencies
      - run: npm test
```

---

## Graceful Shutdown

Drain jobs before maintenance:

```bash
# Pause runner to stop accepting new jobs
# (Via UI or API as shown above)

# Monitor in-progress jobs
watch -n 5 'curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/repos/owner/repo/actions/runs | jq ".workflow_runs[] | select(.status == \"in_progress\") | {id, status}"'

# Once all jobs complete, stop service
sudo systemctl stop actions.runner.*
```
