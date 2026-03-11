---
name: tilt
description: Develop Kubernetes services locally with Tilt and Tiltfiles. Use when tasks mention tilt, Tiltfile, tilt up, tilt dev, local Kubernetes development with Tilt, or docker_build in Starlark.
---

# tilt

Use this skill to keep Tilt-based local Kubernetes development workflows safe, fast, and reproducible across team environments.

## Intent Router

| Request | Reference | Load When |
| --- | --- | --- |
| Install, prerequisites, local cluster setup | `references/install-and-setup.md` | User needs to install Tilt or set up a local cluster |
| tilt up/down/ci/trigger commands | `references/command-cookbook.md` | User needs to run Tilt CLI commands |
| Tiltfile, docker_build, k8s_yaml, live_update | `references/tiltfile-patterns.md` | User needs to write or debug a Tiltfile |
| Extensions, mono-repos, CI mode, Tilt Cloud | `references/extensions-and-teams.md` | User needs advanced team or CI patterns |

## Quick Start

```bash
# Verify Tilt installation and prerequisites
tilt doctor

# Start the interactive dev loop (TUI)
tilt up

# Start in streaming log mode (no TUI, good for terminals)
tilt up --stream

# Tear down all resources created by Tilt
tilt down
```

## Core Command Tracks

- **Dev loop:** `tilt up` — starts the TUI; rebuilds and redeploys on file change
- **CI mode:** `tilt ci` — exits when all resources are healthy (or on failure)
- **Teardown:** `tilt down` — deletes all resources managed by Tilt
- **Trigger:** `tilt trigger <resource>` — force a manual rebuild of a resource
- **Inspect:** `tilt get/describe <resource>` — show resource state
- **Logs:** `tilt logs` — stream logs from all managed resources

## Safety Guardrails

- Always include `allow_k8s_contexts('your-local-context')` in the Tiltfile to prevent accidental deployment to production clusters.
- Use `tilt ci` for CI pipelines — it exits when all resources are healthy, unlike `tilt up` which runs indefinitely.
- Set resource dependencies with `k8s_resource(resource_deps=[...])` to prevent deployment ordering issues.
- Confirm the target Kubernetes context before running `tilt up` against remote clusters.
- Use `local_resource` carefully — commands run on the host machine, not inside containers.
- Review Tiltfile extension source before loading from external URLs.

## Workflow

1. Run `tilt doctor` to verify prerequisites (Docker, kubectl, cluster access).
2. Write a `Tiltfile` at the repo root with `docker_build` and `k8s_yaml` calls.
3. Add `allow_k8s_contexts('docker-desktop')` to guard against wrong-context deploys.
4. Use `k8s_resource(name, resource_deps=[...])` to declare dependency ordering.
5. Run `tilt up` for local development or `tilt ci` for automated pipelines.
6. Use `live_update` sync rules to push file changes without a full image rebuild.

## Related Skills

- **kubectl** — direct Kubernetes resource inspection alongside Tilt
- **docker** — container image building underlying `docker_build`
- **skaffold** — alternative Kubernetes dev loop tool

## References

- `references/install-and-setup.md`
- `references/command-cookbook.md`
- `references/tiltfile-patterns.md`
- `references/extensions-and-teams.md`
- Official docs: <https://docs.tilt.dev/>
- Tiltfile API: <https://api.tilt.dev/>
