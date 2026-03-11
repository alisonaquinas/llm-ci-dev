# Skaffold — Command Cookbook

## Generate skaffold.yaml

```bash
# Auto-detect Dockerfiles and manifests in the current directory
skaffold init

# Non-interactive (accept defaults)
skaffold init --force
```

## Validate Configuration

```bash
# Validate skaffold.yaml and check environment prerequisites
skaffold diagnose

# Show resolved config after profile merging
skaffold diagnose --yaml-only
```

## skaffold dev — Iterative Dev Loop

```bash
# Start watch loop: rebuild and redeploy on file change
skaffold dev

# With a specific profile
skaffold dev --profile=local

# Stream logs from deployed pods
skaffold dev --tail

# Use a specific kubecontext
skaffold dev --kube-context=docker-desktop
```

## skaffold run — One-Shot Build and Deploy (CI)

```bash
# Build, push, deploy, verify
skaffold run

# With status check (wait for rollout to complete)
skaffold run --status-check

# With a specific profile
skaffold run --profile=staging

# Override default-repo at runtime
skaffold run --default-repo=gcr.io/my-project

# Tail logs until deployment completes
skaffold run --tail --status-check
```

## skaffold build — Build Images Only

```bash
# Build and push all images defined in skaffold.yaml
skaffold build

# Output build results as JSON (useful for piping to skaffold deploy)
skaffold build --file-output=build.json

# Build with a specific profile
skaffold build --profile=staging
```

## skaffold deploy — Deploy Pre-Built Images

```bash
# Deploy using a previously saved build artifact list
skaffold deploy --build-artifacts=build.json

# Deploy without re-building
skaffold deploy
```

## skaffold delete — Tear Down Resources

```bash
# Delete all resources deployed by Skaffold
skaffold delete

# Delete with a specific profile
skaffold delete --profile=staging
```

## skaffold debug — Debug Mode

```bash
# Dev loop with debugger port forwarding (adjusts container entrypoints for Go, Node, Python, Java)
skaffold debug

# Attach a debugger after skaffold debug starts and surfaces port-forward info
```

## skaffold render — Preview Manifests

```bash
# Render hydrated manifests to stdout without deploying
skaffold render

# Render to a file
skaffold render --output=rendered.yaml

# Render with a specific profile
skaffold render --profile=prod
```

## Profile Flag

```bash
# Activate a named profile
skaffold dev --profile=dev
skaffold run --profile=prod

# Activate multiple profiles
skaffold run --profile=base --profile=override
```

## Log Streaming

```bash
# Tail pod logs during skaffold run (exits when run completes)
skaffold run --tail

# Tail pod logs in skaffold dev (continuous)
skaffold dev --tail
```
