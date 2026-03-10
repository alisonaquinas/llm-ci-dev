# GitHub Actions Runner Registration and Configuration

Register runners and manage configuration for GitHub Actions.

---

## Token Types and Acquisition

### Generate Runner Registration Token

Runner tokens are generated from GitHub settings:

**Repository-level runner:**

- Go to: **Repository** → **Settings** → **Actions** → **Runners** → **New self-hosted runner**

**Organization-level runner:**

- Go to: **Organization Settings** → **Actions** → **Runners** → **New self-hosted runner**

**Enterprise-level runner:**

- Go to: **Enterprise Settings** → **Actions** → **Runners** → **New self-hosted runner**

Token is valid for 1 hour; must be used within that timeframe to complete registration.

### Token Acquisition Methods

```bash
# Method 1: Manual copy from UI
# Copy token shown in GitHub interface, use directly in config.sh

# Method 2: GitHub CLI
gh runner create \
  --name my-runner \
  --url https://github.com/owner/repo \
  --labels linux,docker

# Method 3: GitHub API
curl -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  https://api.github.com/repos/owner/repo/actions/runners/registration-token
```

---

## Runner Configuration

### config.sh Registration

Register with `config.sh`:

```bash
./config.sh \
  --url https://github.com/owner/repo \
  --token <REGISTRATION_TOKEN> \
  --name my-runner \
  --labels linux,docker,production \
  --runnergroup default \
  --work "_work" \
  --ephemeral \
  --disableupdate
```

### Configuration Flags Reference

| Flag | Purpose | Example |
| --- | --- | --- |
| `--url` | Repository/org/enterprise URL | `https://github.com/owner/repo` |
| `--token` | Registration token (1-hour validity) | `<TOKEN>` |
| `--name` | Display name for runner | `prod-runner-1` |
| `--labels` | Comma-separated labels for job selection | `linux,docker,aws` |
| `--runnergroup` | Runner group (org/enterprise only) | `default`, `heavy-compute` |
| `--work` | Workspace directory path | `_work`, `/opt/runner/_work` |
| `--ephemeral` | Run single job then exit (Kubernetes) | (flag only) |
| `--disableupdate` | Prevent automatic updates | (flag only) |
| `--replace` | Replace existing runner registration | (flag only) |
| `--pat` | (New) Use PAT instead of registration token | `--pat <PAT>` |

### Non-Interactive Configuration

Use environment variables or flags for scripted setup:

```bash
# Via environment variables
export GITHUB_URL="https://github.com/owner/repo"
export GITHUB_TOKEN="<TOKEN>"
export RUNNER_NAME="automated-runner"
export RUNNER_LABELS="docker,linux"
export RUNNER_WORK="_work"

# Non-interactive mode
./config.sh --unattended
```

---

## Runner Labels

### Default Labels

Runners automatically include default labels:

- `self-hosted` — All self-hosted runners
- `<os>` — Operating system (linux, macos, windows)
- `<architecture>` — CPU architecture (x64, arm64, arm)

### Custom Labels

Add labels during registration:

```bash
./config.sh \
  --labels "docker,kubernetes,production,us-east-1"
```

### Label Usage in Workflows

```yaml
jobs:
  build:
    runs-on: [self-hosted, docker, production]  # Matches runner with all labels
```

---

## Runner Groups

### Runner Groups (Org/Enterprise)

Organize runners by group for access control:

**Create runner group:**

- Organization/Enterprise Settings → Actions → Runner Groups → New Runner Group

**Assign runners:**

- Select group → Add runners by name

**Scope:**

- Groups restrict which repositories can use the runners
- Example: "Production" group only accessible to production repositories

### Default Runner Group

All runners belong to "default" group unless assigned otherwise.

---

## Proxy Configuration

Configure runner to connect through HTTP/HTTPS proxy:

### Environment Variables

```bash
# Set proxy before running runner
export HTTPS_PROXY="http://proxy.example.com:8080"
export HTTP_PROXY="http://proxy.example.com:8080"
export NO_PROXY="localhost,127.0.0.1,.example.com"

# Then start runner
./run.sh
```

### Runner Configuration File

Edit runner config after initial registration:

```bash
# Edit .runner file (contains runner metadata)
nano ~/.runner

# Edit config.yml (advanced runner settings)
nano /path/to/runner/.runner
```

### HTTPS Certificate Override

For self-signed certificates:

```bash
export NODE_EXTRA_CA_CERTS="/path/to/ca-bundle.crt"
./run.sh
```

---

## Configuration Files

### .runner File

Located in runner root directory; contains metadata:

```json
{
  "agentId": 1,
  "agentName": "my-runner",
  "serverUrl": "https://github.com",
  "gitHubUrl": "https://github.com/owner/repo",
  "workFolder": "_work"
}
```

Do not edit manually; managed by `config.sh`.

### .env File

Store environment variables for runner jobs:

```bash
# Create ~/runner/.env
export CI=true
export DOCKER_HOST=unix:///var/run/docker.sock
export NODE_ENV=production
```

These variables are available in all jobs executed by this runner.

---

## Runner Scope and Access Control

### Scope Comparison

| Scope | Registration URL | Access | Best For |
| --- | --- | --- | --- |
| **Repository** | `https://github.com/owner/repo` | Single repo only | Specific project infrastructure |
| **Organization** | `https://github.com/owner` | All org repos (configurable) | Shared org infrastructure |
| **Enterprise** | `https://github.com/enterprises/name` | All enterprise repos (configurable) | Enterprise-wide infrastructure |

### Access Control via Runner Groups (Org/Enterprise)

Create groups to restrict access:

```text
Organization Settings → Actions → Runner Groups

Example:
- "Public" group: Accessible to all org repos
- "Private" group: Accessible to selected repos only
- "Shared" group: Accessible to public repos
```

---

## Reconfiguration and Re-registration

### Update Existing Runner

Reconfigure without unregistering:

```bash
./config.sh --replace \
  --url https://github.com/owner/repo \
  --token <NEW_TOKEN> \
  --labels "updated,labels"
```

### Remove and Re-register

```bash
# Remove current registration
./config.sh remove

# Re-register with new settings
./config.sh --url https://github.com/owner/repo --token <TOKEN> ...
```

---

## Advanced Configuration

### Runner Concurrency

Control how many jobs a runner accepts simultaneously:

```yaml
# In workflow
jobs:
  job1:
    runs-on: self-hosted
    concurrency: single  # Only one job per runner at a time
  job2:
    runs-on: self-hosted
    concurrency: build-${{ github.ref }}  # Concurrency per branch
```

### Disable Runner

Pause runner from accepting jobs via UI:

- **Repository/Organization Settings** → **Actions** → **Runners** → Select runner → **Disable**

Or via API:

```bash
curl -X PATCH \
  -H "Authorization: token $GITHUB_TOKEN" \
  https://api.github.com/repos/owner/repo/actions/runners/<RUNNER_ID> \
  -d '{"active": false}'
```

---

## Troubleshooting Registration

### Token Expired

Tokens expire 1 hour after generation. If expired, generate new token and reconfigure:

```bash
./config.sh remove
# Generate new token from GitHub UI
./config.sh --url ... --token <NEW_TOKEN> ...
./svc.sh start
```

### Runner Not Visible in GitHub UI

Verify registration completed:

```bash
# Check runner metadata
cat .runner

# Check logs
journalctl -u actions.runner.* -f
./run.sh --check  # Test runner connectivity
```

### Connection Failures

Test GitHub connectivity:

```bash
# Test API connectivity
curl -I https://api.github.com

# Test with verbose output
./run.sh --debug

# Check firewall/proxy settings
curl -x <PROXY> https://api.github.com
```
