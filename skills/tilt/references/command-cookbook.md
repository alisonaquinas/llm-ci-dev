# Tilt — Command Cookbook

## tilt up — Start Dev Loop

```bash
# Start the interactive TUI (default)
tilt up

# Stream logs to stdout without the TUI (useful in terminals without TUI support)
tilt up --stream

# Use a specific Tiltfile
tilt up --file=./path/to/Tiltfile

# Set Tiltfile args (accessed in Tiltfile via config.parse_args())
tilt up -- --environment=dev --feature-flag=true
```

## TUI Keyboard Shortcuts

| Key | Action |
| --- | --- |
| `s` | Toggle log streaming |
| `r` | Reload Tiltfile |
| `0–9` | Filter to resource by index |
| `Ctrl+C` | Exit TUI (resources keep running) |
| `q` | Quit TUI (same as Ctrl+C) |

## tilt down — Tear Down

```bash
# Delete all resources managed by Tilt
tilt down

# Delete and remove images built by Tilt
tilt down --delete-namespaces
```

## tilt ci — CI Mode

```bash
# Run until all resources are healthy, then exit 0; exit 1 on failure
tilt ci

# Use a specific Tiltfile in CI
tilt ci --file=./Tiltfile.ci

# Pass args to Tiltfile
tilt ci -- --environment=staging
```

## tilt trigger — Manual Rebuild

```bash
# Force a rebuild and redeploy of a specific resource
tilt trigger my-service

# Trigger multiple resources
tilt trigger api worker
```

## tilt get / tilt describe — Inspect Resources

```bash
# List all managed resources and their status
tilt get all

# Describe a specific resource
tilt describe session
tilt describe uiresource my-service
```

## tilt logs — Stream Logs

```bash
# Stream all logs from managed resources
tilt logs

# Stream logs from a specific resource
tilt logs my-service

# Follow logs (same as -f)
tilt logs -f my-service
```

## tilt args — Update Running Tiltfile Args

```bash
# Update args while Tilt is running (triggers Tiltfile re-evaluation)
tilt args -- --environment=staging
```

## tilt alpha tiltfile-result

```bash
# Dump the current Tiltfile evaluation result as JSON (for debugging)
tilt alpha tiltfile-result
```
