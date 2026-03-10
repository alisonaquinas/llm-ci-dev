# GitLab Runner Executors

Choose and configure the execution environment for CI jobs.

---

## Executor Overview

An **executor** defines where and how GitLab Runner executes jobs. Each executor has different requirements, isolation, and use cases.

### Executor Comparison

| Executor | Best For | Requirements | Isolation | Speed | Cost |
| --- | --- | --- | --- | --- | --- |
| **Shell** | Local scripts, dev machines | Shell, same OS as runner | None | Fast | Free |
| **Docker** | Containerized workloads | Docker daemon | High (containers) | Moderate | Low (shared host) |
| **Docker Autoscaler** | Dynamic scaling on VMs | Docker Swarm or cloud VMs | High | Slow (VM startup) | Pay-per-use |
| **Kubernetes** | K8s-native deployments | Kubernetes cluster | High (pods) | Moderate | Cluster-dependent |
| **SSH** | Remote machines | SSH key + remote host | Medium | Fast | Shared infra |
| **VirtualBox** | VM-based isolation (legacy) | VirtualBox, deprecated | Very High | Very Slow | High |

---

## Shell Executor

Execute jobs directly on the runner host using the system shell.

### Configuration

```toml
[[runners]]
  name = "shell-runner"
  executor = "shell"
  shell = "bash"            # or "sh", "pwsh" (PowerShell)
```

### Use Cases

- Local development and testing
- Scripts requiring direct host access
- Simple CI jobs without containerization

### Security Implications

- No isolation from other jobs
- Full access to host filesystem
- Jobs can interfere with each other
- **Not recommended for multi-tenant or untrusted code**

---

## Docker Executor

Execute jobs in ephemeral Docker containers.

### Basic Configuration

```toml
[[runners]]
  name = "docker-runner"
  executor = "docker"
  [runners.docker]
    image = "ubuntu:22.04"  # Default image for all jobs
    pull_policy = "if-not-present"
```

### Docker Executor Options

| Option | Purpose | Example |
| --- | --- | --- |
| `image` | Base container image | `ubuntu:22.04`, `node:18` |
| `pull_policy` | When to pull image | `always`, `if-not-present`, `never` |
| `volumes` | Mount volumes into container | `["/cache", "/tmp:/tmp"]` |
| `network_mode` | Container network | `bridge`, `host`, `custom-network` |
| `privileged` | Run container with privileged flag | `true` |
| `services` | Sidecar services (database, etc.) | `["postgres:13", "redis:latest"]` |
| `environment` | Environment variables in container | `["VAR=value"]` |
| `dns` | Custom DNS servers | `["8.8.8.8", "8.8.4.4"]` |
| `memory` | Memory limit per job | `"1024m"` |
| `cpus` | CPU limit per job | `"1.5"` |

### Full Docker Configuration Example

```toml
[[runners]]
  name = "docker-prod"
  executor = "docker"
  [runners.docker]
    image = "golang:1.20"
    pull_policy = "if-not-present"
    volumes = [
      "/cache",
      "/var/run/docker.sock:/var/run/docker.sock"  # Docker-in-Docker
    ]
    network_mode = "bridge"
    privileged = false
    environment = [
      "DOCKER_HOST=unix:///var/run/docker.sock",
      "DOCKER_DRIVER=overlay2"
    ]
    # Sidecar services
    services = [
      "postgres:15",
      "redis:7"
    ]
```

### Docker Image Pull Policies

| Policy | Behavior |
| --- | --- |
| `always` | Always pull latest image (slower, ensures fresh) |
| `if-not-present` | Pull only if not cached locally (faster, may miss updates) |
| `never` | Never pull; fail if not present locally (fastest, requires pre-cached) |

### Docker Services (Sidecars)

Automatically start additional containers for your job:

```yaml
# In .gitlab-ci.yml
test:
  image: node:18
  services:
    - postgres:15
    - redis:7
  script:
    - npm test
```

Services are available at `postgres`, `redis` hostnames within the job container.

---

## Docker Autoscaler (Advanced)

Automatically scale Docker containers across VMs in a cloud or on-premise environment.

### Use Cases

- On-demand scaling based on job queue depth
- Multi-VM deployments
- Cost optimization (pay only for running VMs)

### Configuration

```toml
[[runners]]
  name = "docker-autoscaler"
  executor = "docker-autoscaler"
  [runners.machine]
    max_builds = 100
    IdleCount = 2
    IdleTime = 600
    [runners.machine.autoscaling]
      periods = ["* * 0-6 * * mon-fri *", "* * 7-23 * * mon-fri *"]
      idle_count = [1, 2]
      idle_time = [600, 300]
```

Requires Docker Machine driver (Docker, AWS, Google Cloud, Azure, etc.) to provision VMs.

---

## Kubernetes Executor

Execute jobs as pods in a Kubernetes cluster.

### Basic Configuration

```toml
[[runners]]
  name = "kubernetes-runner"
  executor = "kubernetes"
  [runners.kubernetes]
    host = "https://kubernetes.example.com"
    token = "<K8S_TOKEN>"
    ca_file = "/etc/ssl/kubernetes/ca.crt"
    namespace = "gitlab-runner"
    image = "ubuntu:22.04"
```

### Kubernetes Executor Options

| Option | Purpose |
| --- | --- |
| `namespace` | Kubernetes namespace where pods run |
| `image` | Default container image for pods |
| `cpu_request` | CPU request per pod (`100m`, `1`, etc.) |
| `memory_request` | Memory request per pod (`128Mi`, `1Gi`, etc.) |
| `cpu_limit` | CPU limit per pod |
| `memory_limit` | Memory limit per pod |
| `service_account` | Kubernetes service account |
| `pod_labels` | Labels for pod identification |
| `pod_annotations` | Kubernetes annotations |

### Full Kubernetes Configuration Example

```toml
[[runners]]
  name = "k8s-runner"
  executor = "kubernetes"
  [runners.kubernetes]
    host = "https://kubernetes.example.com"
    token = "<TOKEN>"
    namespace = "gitlab-runner"
    image = "ubuntu:22.04"
    cpu_request = "100m"
    memory_request = "128Mi"
    cpu_limit = "1000m"
    memory_limit = "1024Mi"
    service_account = "gitlab-runner"
    [runners.kubernetes.pod_labels]
      app = "gitlab-ci"
    [runners.kubernetes.pod_annotations]
      prometheus = "true"
```

### Pod Template Customization

Define custom pod specs:

```toml
[runners.kubernetes.pod_spec]
  # Additional pod spec fields (advanced)
  # Allows full control over pod definition
```

---

## SSH Executor

Execute jobs on a remote machine via SSH.

### Configuration

```toml
[[runners]]
  name = "ssh-runner"
  executor = "ssh"
  [runners.ssh]
    host = "ci.example.com"
    port = 22
    user = "ci-user"
    identity_file = "/home/gitlab-runner/.ssh/id_rsa"
```

### SSH Executor Options

| Option | Purpose |
| --- | --- |
| `host` | Remote machine hostname or IP |
| `port` | SSH port (default 22) |
| `user` | SSH username |
| `password` | SSH password (if not using key) |
| `identity_file` | Path to private SSH key |
| `known_hosts_file` | SSH known_hosts file |

### SSH Setup

On the remote host, prepare for SSH runner jobs:

```bash
# Create ci-user on remote machine
sudo useradd -m -s /bin/bash ci-user

# Generate SSH key pair on runner host
sudo -u gitlab-runner ssh-keygen -t rsa -N "" -f /home/gitlab-runner/.ssh/id_rsa

# Add public key to remote authorized_keys
ssh-copy-id -i /home/gitlab-runner/.ssh/id_rsa ci-user@ci.example.com
```

---

## Executor Comparison & Selection

### When to Use Each Executor

| Executor | Use When | Avoid When |
| --- | --- | --- |
| Shell | Quick scripts, dev machines | Multi-tenant, security-critical |
| Docker | Containerized CI/CD standard | No Docker available, legacy apps |
| Docker Autoscaler | High-scale, variable load | Fixed infrastructure, on-premise only |
| Kubernetes | Cloud-native, K8s infrastructure | No Kubernetes cluster |
| SSH | Existing remote machines | New deployments, need isolation |
| VirtualBox | Complete isolation needed | Modern deployments (use Docker/K8s instead) |

---

## Executor Migration

Changing executors for an existing runner requires re-registration:

```bash
# Unregister old runner
gitlab-runner unregister --name old-runner

# Register with new executor
gitlab-runner register \
  --non-interactive \
  --url https://gitlab.example.com/ \
  --token <TOKEN> \
  --executor <NEW_EXECUTOR>
```

Alternatively, edit `config.toml` directly and change the `executor` key, then restart:

```bash
sudo systemctl restart gitlab-runner
```
