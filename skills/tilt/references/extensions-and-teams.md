# Tilt — Extensions and Teams

## Tilt Extensions

Tilt extensions provide reusable Tiltfile functions for common patterns. Load them with `load('ext://...')`.

```python
# Restart a process inside a container after live_update sync
load('ext://restart_process', 'restart_process')

# Build with kubectl buildkit
load('ext://kubectl_build', 'kubectl_build')

# Ensure a namespace exists before deploying
load('ext://namespace', 'namespace_create', 'namespace_inject')

# Install remote Helm charts
load('ext://helm_remote', 'helm_remote')
```

Browse available extensions: <https://github.com/tilt-dev/tilt-extensions>

## Mono-Repo Pattern

In a mono-repo, use `include()` to compose multiple service Tiltfiles from a root Tiltfile:

```python
# Root Tiltfile
allow_k8s_contexts('docker-desktop')

include('./services/api/Tiltfile')
include('./services/worker/Tiltfile')
include('./services/frontend/Tiltfile')
```

Each service Tiltfile manages its own `docker_build` and `k8s_yaml`:

```python
# services/api/Tiltfile
docker_build('gcr.io/my-project/api', './services/api')
k8s_yaml('./services/api/k8s/deployment.yaml')
k8s_resource('api', port_forwards=['8080:8080'])
```

## Parameterized Tiltfiles

Use `config.parse_args()` to let the agent or CI system select which services to run:

```python
config.define_string_list('services', args=True, usage='Services to run')
cfg = config.parse()
enabled = cfg.get('services', ['api', 'frontend'])

if 'api' in enabled:
    include('./services/api/Tiltfile')
if 'frontend' in enabled:
    include('./services/frontend/Tiltfile')
```

```bash
# Start only the api service
tilt up -- api

# Start api and worker
tilt up -- api worker
```

## Remote Tiltfile Loading

```python
# Load a shared Tiltfile snippet from a remote URL (use with caution)
load_dynamic('https://raw.githubusercontent.com/my-org/tilt-shared/main/common.tiltfile')
```

Always review the content of remote Tiltfiles before use; they execute with full local access.

## Namespace Isolation for Team Clusters

```python
load('ext://namespace', 'namespace_create', 'namespace_inject')

# Create a per-developer namespace
namespace_create('dev-alice')

# Inject namespace into all loaded YAML
k8s_yaml(namespace_inject(read_file('k8s/deployment.yaml'), 'dev-alice'))
```

## CI Mode Patterns

`tilt ci` is the correct command for CI pipelines. It runs until all resources are ready, then exits.

```yaml
# GitHub Actions example
- name: Run Tilt CI
  run: tilt ci
  env:
    KUBECONFIG: ${{ runner.temp }}/kubeconfig.yaml
```

### Exit Codes

| Code | Meaning |
| --- | --- |
| 0 | All resources healthy |
| 1 | One or more resources failed or timed out |

```bash
# Run tilt ci with a custom timeout
tilt ci --timeout=300s
```

## Tilt Cloud — Team Sharing

```bash
# Log in
tilt login

# Start with Tilt Cloud snapshots enabled
tilt up --web-mode=tiltcloud

# Share a snapshot URL with teammates for async debugging
```

## tilt args — Update Args at Runtime

```bash
# Update Tiltfile args while tilt up is running (triggers re-evaluation)
tilt args -- --services=api,worker
```
