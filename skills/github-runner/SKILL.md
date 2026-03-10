---
name: github-runner
description: >
  Install, register, configure, and maintain GitHub Actions self-hosted runners on Linux, macOS, Windows, and Kubernetes via Actions Runner Controller (ARC).
  Cover runner binary installation, service setup, token management, ARC deployment, scaling, and operational management.
---

# GitHub Actions Runner

Install, register, and operate GitHub Actions self-hosted runners to execute jobs on your infrastructure.
This skill covers runner binary installation, registration, service management, Kubernetes ARC deployment, and operations.

---

## Intent Router

Load reference files for depth on specific topics:

| Topic | File | Load when... |
| --- | --- | --- |
| Installation | `references/installation.md` | Installing runner binary, setting up services on Linux, macOS, Windows, or containers |
| Registration & Configuration | `references/registration-and-config.md` | Registering runners, token management, labels, groups, and proxy configuration |
| ARC and Scaling | `references/arc-and-scaling.md` | Deploying Actions Runner Controller on Kubernetes, ephemeral runners, auto-scaling |
| Operations | `references/operations.md` | Service control, token rotation, updates, firewall, and troubleshooting |

---

## Quick Start

### Core Concepts

GitHub Actions Runner is a self-hosted agent that executes workflow jobs from GitHub repositories.
The lifecycle: **download** → **configure** (obtain token from GitHub) → **run** (execute workflow jobs).

### Minimal Installation & Registration (Linux)

```bash
# Create directory for runner
mkdir -p ~/runner && cd ~/runner

# Download latest runner for x64
curl -o actions-runner-linux-x64-latest.tar.gz \
  -L https://github.com/actions/runner/releases/download/v2.414.0/actions-runner-linux-x64-2.414.0.tar.gz

# Extract
tar xzf actions-runner-linux-x64-latest.tar.gz

# Generate a token from GitHub (repo/org settings → Runners)
# Then configure
./config.sh \
  --url https://github.com/owner/repo \
  --token <GITHUB_TOKEN> \
  --name "my-runner" \
  --labels "linux,docker" \
  --runnergroup "default" \
  --work "_work"

# Install service
./svc.sh install

# Start service
./svc.sh start
```

### Runner Scope and Tokens

Runners can be registered at three GitHub levels:

| Scope | URL | Token Source |
| --- | --- | --- |
| **Repository** | `https://github.com/owner/repo` | Repo → Settings → Actions → Runners |
| **Organization** | `https://github.com/owner` | Org → Settings → Actions → Runners |
| **Enterprise** | `https://github.com/enterprises/name` | Enterprise → Settings → Actions → Runners |

Each scope level has its own authentication tokens.

### config.sh Flags

```bash
./config.sh \
  --url <GITHUB_URL> \              # GitHub repo, org, or enterprise URL
  --token <TOKEN> \                 # PAT or fine-grained token
  --name <RUNNER_NAME> \            # Display name for runner
  --labels docker,linux,ubuntu \    # Comma-separated labels
  --runnergroup "default" \         # Runner group assignment
  --work "_work" \                  # Workspace directory
  --ephemeral \                     # Ephemeral runner (runs one job then exits)
  --disableupdate                   # Prevent auto-update
```

---

## Cross-References

Use alongside these skills for deeper context:

- **github-ci** — Write and maintain GitHub Actions workflows that trigger runner jobs
- **github-docs** — Deep syntax reference for GitHub Actions workflow keywords
- **ci-architecture** — Design patterns for multi-runner deployments and runner group management

---

## Related References

- Load **Installation** for platform-specific setup (Linux, macOS, Windows, Docker, Kubernetes)
- Load **Registration & Configuration** to understand tokens, labels, groups, and proxy configuration
- Load **ARC and Scaling** to deploy Kubernetes-based runners with auto-scaling
- Load **Operations** for service management, updates, token rotation, and troubleshooting
