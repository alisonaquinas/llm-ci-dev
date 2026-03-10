# GitLab Runner Registration and Configuration

Register runners with GitLab and manage `config.toml` settings.

---

## Runner Tokens

GitLab Runner uses two types of credentials:

### Registration Token (Deprecated; Legacy)

Historically used to register a new runner. GitLab now requires **authentication tokens** for secure registration.

```bash
# Legacy registration command (still works)
gitlab-runner register \
  --url https://gitlab.example.com/ \
  --registration-token <TOKEN>
```

For new setups, use the **authentication token** method.

### Authentication Token (Recommended)

New runner registration method that requires a **runner authentication token** obtained from GitLab:

```bash
# New registration method
gitlab-runner register \
  --url https://gitlab.example.com/ \
  --token <RUNNER_AUTH_TOKEN> \
  --executor docker
```

Create runner tokens in GitLab at:

- **Admin**: Admin → CI/CD → Runners (instance-level)
- **Group**: Group → Build → Runners (group-level)
- **Project**: Project → Settings → CI/CD → Runners (project-level)

---

## Non-Interactive Registration

Register a runner without interactive prompts using flags:

```bash
gitlab-runner register \
  --non-interactive \
  --url https://gitlab.example.com/ \
  --token <RUNNER_AUTH_TOKEN> \
  --executor docker \
  --docker-image ubuntu:22.04 \
  --description "My Docker Runner" \
  --tag-list docker,linux,ubuntu \
  --docker-volumes /cache \
  --docker-privileged
```

### Common Registration Flags

| Flag | Purpose | Example |
| --- | --- | --- |
| `--url` | GitLab instance URL | `https://gitlab.example.com/` |
| `--token` | Runner authentication token | `glrt_abc123xyz...` |
| `--executor` | Job execution engine | `docker`, `shell`, `kubernetes`, `ssh` |
| `--description` | Runner display name | `"Production Docker Runner"` |
| `--tag-list` | Comma-separated tags | `docker,production,linux` |
| `--docker-image` | Default Docker image (Docker executor) | `ubuntu:22.04` |
| `--docker-volumes` | Volumes to mount | `/cache,/var/run/docker.sock` |
| `--docker-privileged` | Run containers with privileged flag | (flag, no value) |
| `--maintenance-note` | Admin notes for the runner | `"Temporary for CI migration"` |
| `--paused` | Register runner in paused state | (flag, no value) |

---

## config.toml Anatomy

Runners store all configuration in `/etc/gitlab-runner/config.toml`. This is the source of truth for runner behavior.

### Global Section

```toml
# Overall runner daemon settings
concurrent = 4              # Max jobs to run simultaneously across all runners
check_interval = 0          # Check for jobs every N seconds (0 = default 3s)
log_level = "info"          # Log level: debug, info, warn, error
log_format = "text"         # Log format: text or json
```

### Runner Section: [[runners]]

Each `[[runners]]` block represents one registered runner:

```toml
[[runners]]
  # Identification
  name = "docker-runner-1"
  url = "https://gitlab.example.com/"
  token = "<RUNNER_TOKEN>"

  # Job execution
  executor = "docker"

  # Tags for job matching
  tag_list = ["docker", "linux"]

  # Concurrency
  limit = 2                 # Max concurrent jobs this runner accepts

  # Job timeout
  request_concurrency = 1   # Max concurrent job requests to gitlab

  # Runner scope
  protected = true          # Only run jobs from protected branches/tags
  run_untagged = false      # Accept jobs with no tags

  # Environment variables
  environment = ["CI_RUNNER_CUSTOM_VAR=value"]

  # Docker-specific settings (if executor = "docker")
  [runners.docker]
    image = "ubuntu:22.04"
    volumes = ["/cache"]
    pull_policy = "if-not-present"
    network_mode = "bridge"
    privileged = false

  # Kubernetes-specific settings (if executor = "kubernetes")
  [runners.kubernetes]
    namespace = "gitlab-runner"
    cpu_request = "100m"
    memory_request = "128Mi"
    cpu_limit = "1000m"
    memory_limit = "1024Mi"
```

### Full config.toml Example

```toml
concurrent = 4
check_interval = 0
log_level = "info"
metrics_server = "localhost:9252"

[[runners]]
  name = "docker-1"
  url = "https://gitlab.example.com/"
  token = "<TOKEN>"
  executor = "docker"
  tag_list = ["docker", "linux"]
  limit = 2
  [runners.docker]
    image = "ubuntu:22.04"
    volumes = ["/cache"]
    network_mode = "host"
    pull_policy = "if-not-present"
    services = ["docker:dind"]

[[runners]]
  name = "shell-1"
  url = "https://gitlab.example.com/"
  token = "<TOKEN>"
  executor = "shell"
  tag_list = ["shell", "macos"]
  limit = 1
```

---

## Runner Scope & Access Control

### Scope Levels

Runners can be registered at three GitLab levels:

| Level | Registration Scope | Access | Visibility |
| --- | --- | --- | --- |
| **Instance** | GitLab admin URL | All projects in instance | Instance-wide (all projects) |
| **Group** | Group → Settings → CI/CD → Runners | All projects in group + subgroups | Group + children only |
| **Project** | Project → Settings → CI/CD → Runners | Single project only | Project only |

Instance-level runners are typically used for shared infrastructure; group and project runners for isolated workloads.

### Protected Runners

Prevent runners from executing jobs on unprotected branches/tags:

```toml
[[runners]]
  name = "production-runner"
  protected = true          # Only runs jobs on protected branches/tags
```

With `protected = true`, the runner rejects all jobs from unprotected branches, ensuring secure deployment workflows.

---

## Manual config.toml Editing

Modify `config.toml` directly for bulk changes or advanced configuration:

```bash
# Edit as root (Linux/macOS)
sudo nano /etc/gitlab-runner/config.toml

# Verify syntax after editing
gitlab-runner verify

# Reload configuration
sudo systemctl restart gitlab-runner
```

**Important**: Always verify and restart after manual edits to apply changes.

---

## Common Configuration Tasks

### Change Runner Tags

```toml
[[runners]]
  tag_list = ["docker", "production", "linux"]
```

Then restart:

```bash
sudo systemctl restart gitlab-runner
```

### Increase Concurrency Limit

```toml
concurrent = 8              # Increase from 4 to 8
```

### Add Environment Variables

```toml
[[runners]]
  environment = [
    "CI_RUNNER_ENV=production",
    "CUSTOM_VAR=value"
  ]
```

### Configure Docker Services

```toml
[[runners]]
  [runners.docker]
    image = "ubuntu:22.04"
    services = ["docker:dind", "postgres:13"]
    volumes = ["/cache"]
```

---

## Troubleshooting Registration

### "Token Invalid" Error

Verify the token is correct and has not expired:

```bash
# Check registered runners
gitlab-runner list

# Re-register with valid token
gitlab-runner register --url ... --token <NEW_TOKEN>
```

### config.toml Syntax Errors

Verify the TOML format:

```bash
# Verify syntax
gitlab-runner verify

# Check for specific parse errors
gitlab-runner verify --debug
```

### Runner Not Picking Up Jobs

Ensure runner is not paused and tags match:

```bash
# Check runner status in GitLab UI (Admin → Runners)
# Verify tag_list in config.toml matches job tags
# Confirm runner is online and accepting jobs
```
