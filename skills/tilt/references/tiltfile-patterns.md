# Tilt — Tiltfile Patterns

## Tiltfile Language

The Tiltfile is written in **Starlark**, a Python-like dialect. It is evaluated top-to-bottom each time the Tiltfile changes.

```python
# Tiltfile
# Lines starting with # are comments

print("Tiltfile loaded")
```

## Safety Guard — Restrict Kubernetes Contexts

```python
# Prevent accidental deploys to production clusters
allow_k8s_contexts('docker-desktop')

# Allow multiple contexts
allow_k8s_contexts(['docker-desktop', 'kind-dev', 'k3d-dev'])
```

## docker_build — Build a Container Image

```python
# Basic docker_build
docker_build('gcr.io/my-project/api', '.')

# Specify Dockerfile and build context
docker_build(
    'gcr.io/my-project/api',
    context='.',
    dockerfile='Dockerfile.dev',
    build_args={'ENV': 'dev'},
)
```

## live_update — Sync Files Without Rebuild

```python
docker_build(
    'gcr.io/my-project/api',
    '.',
    live_update=[
        # Sync local files into the container
        sync('./src', '/app/src'),
        # Run a command inside the container after sync
        run('pip install -r requirements.txt', trigger=['requirements.txt']),
        # Restart the process inside the container
        restart_container(),
    ]
)
```

## k8s_yaml — Load Kubernetes Manifests

```python
# Load a single file
k8s_yaml('k8s/deployment.yaml')

# Load multiple files
k8s_yaml(['k8s/deployment.yaml', 'k8s/service.yaml'])

# Load all YAML in a directory (using glob)
k8s_yaml(listdir('k8s'))

# Use kustomize output
k8s_yaml(kustomize('k8s/overlays/dev'))
```

## k8s_resource — Configure a Resource

```python
k8s_resource(
    'my-api',                        # resource name (matches Deployment name)
    port_forwards=['8080:8080'],     # local:container port forwarding
    resource_deps=['postgres'],      # wait for postgres to be ready first
    extra_pod_selectors={'app': 'my-api'},
)
```

## local_resource — Run Local Commands

```python
# Run a local command that re-runs when files change
local_resource(
    'lint',
    cmd='npm run lint',
    deps=['src'],
    labels=['checks'],
)

# Run a command that serves (e.g., a local proxy)
local_resource(
    'mock-server',
    serve_cmd='npx json-server db.json --port 3001',
)
```

## helm_resource and helm_remote

```python
# Install a Helm chart from a local path
helm_resource('my-app', chart='./charts/my-app', flags=['--values=values/dev.yaml'])

# Install a remote Helm chart
load('ext://helm_remote', 'helm_remote')
helm_remote(
    'postgres',
    repo_url='https://charts.bitnami.com/bitnami',
    chart='postgresql',
    version='15.5.0',
    values=['values/postgres-dev.yaml'],
)
```

## include — Split Large Tiltfiles

```python
# Include another Tiltfile (evaluated in the same scope)
include('./services/api/Tiltfile')
include('./services/frontend/Tiltfile')
```

## load — Import Extensions or Functions

```python
# Load a built-in extension
load('ext://restart_process', 'restart_process')

# Load from a remote extension
load('ext://helm_remote', 'helm_remote')
```

## watch_file — Watch Additional Files

```python
# Trigger Tiltfile re-evaluation when this file changes
watch_file('config/app.json')
```

## config.parse_args — Parameterized Tiltfiles

```python
# Define accepted args and defaults
config.define_string_list('services', args=True)
config.define_bool('debug', False)
cfg = config.parse()

services = cfg.get('services', ['api', 'frontend'])
debug = cfg.get('debug', False)
```
