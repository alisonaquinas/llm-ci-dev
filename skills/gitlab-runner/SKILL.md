---
name: gitlab-runner
description: >
  Install, register, configure, and maintain the GitLab Runner daemon for self-hosted CI job execution.
  Cover installation across Linux, Docker, Kubernetes, macOS, and Windows; runner registration and config.toml anatomy;
  executor selection and configuration; health monitoring, logging, and troubleshooting.
---

# GitLab Runner

Install, register, and operate the GitLab Runner daemon to execute CI jobs on self-hosted infrastructure.
This skill covers installation across multiple platforms, runner registration, executor configuration, and operational management.

---

## Intent Router

Load reference files for depth on specific topics:

| Topic | File | Load when... |
| --- | --- | --- |
| Installation | `references/installation.md` | Installing, upgrading, or uninstalling on any platform (Linux, Docker, Kubernetes, macOS, Windows) |
| Registration & Configuration | `references/registration-and-config.md` | Registering runners, editing config.toml, managing registration and auth tokens |
| Executors | `references/executors.md` | Choosing or configuring an executor (Shell, Docker, Kubernetes, etc.) |
| Operations | `references/operations.md` | Health monitoring, log management, pausing runners, troubleshooting issues |

---

## Quick Start

### Core Concepts

GitLab Runner is a daemon that accepts CI jobs from a GitLab instance and executes them on local infrastructure.
The lifecycle: **install** → **register** (obtain credentials from GitLab) → **run** (pick up jobs from queue).

### Minimal Installation & Registration

```bash
# Install gitlab-runner on Linux (deb/rpm repo)
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
sudo apt-get install gitlab-runner

# Register a runner (non-interactive)
sudo gitlab-runner register \
  --non-interactive \
  --url https://gitlab.example.com/ \
  --registration-token <TOKEN> \
  --executor docker \
  --docker-image ubuntu:22.04 \
  --description "Docker runner" \
  --tag-list docker,linux

# Start the service
sudo systemctl start gitlab-runner
sudo systemctl status gitlab-runner
```

### config.toml Skeleton

Runners store configuration in `/etc/gitlab-runner/config.toml`:

```toml
concurrent = 4
check_interval = 0
log_level = "info"

[[runners]]
  name = "docker-runner-1"
  url = "https://gitlab.example.com/"
  token = "<RUNNER_TOKEN>"
  executor = "docker"
  [runners.docker]
    image = "ubuntu:22.04"
    volumes = ["/cache"]
```

See **Registration & Configuration** reference for full config.toml anatomy and all available keys.

### Common Workflow Tasks

| Task | Command |
| --- | --- |
| List registered runners | `gitlab-runner list` |
| Verify runner connectivity | `sudo gitlab-runner verify` |
| View logs | `sudo systemctl status gitlab-runner` or `journalctl -u gitlab-runner` |
| Pause a runner | Use GitLab UI (Runner Settings → Pause) |
| Upgrade runner | `sudo apt-get upgrade gitlab-runner` |
| Uninstall runner | `sudo apt-get remove gitlab-runner` |

---

## Cross-References

Use alongside these skills for deeper context:

- **gitlab-ci** — Write and maintain .gitlab-ci.yml pipelines that trigger runner jobs
- **gitlab-docs** — Deep syntax reference for GitLab CI keywords and API
- **ci-architecture** — Design patterns for multi-runner deployments and executor selection

---

## Related References

- Load **Installation** for platform-specific setup (Linux, Docker, Kubernetes, macOS, Windows)
- Load **Registration & Configuration** to understand runner registration tokens and config.toml
- Load **Executors** when choosing between Shell, Docker, Kubernetes, or SSH executors
- Load **Operations** for monitoring, logging, and troubleshooting runner health
