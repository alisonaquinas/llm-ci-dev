---
name: skaffold
description: Build, push, and deploy to Kubernetes iteratively with Skaffold. Use when tasks mention skaffold, skaffold dev, skaffold run, skaffold.yaml, or Skaffold build/deploy pipelines.
---

# skaffold

Use this skill to keep Skaffold-based Kubernetes build and deploy workflows deterministic and safe across local and CI environments.

## Intent Router

| Request | Reference | Load When |
| --- | --- | --- |
| Install, prerequisites, registry config | `references/install-and-setup.md` | User needs to install Skaffold or configure image registry |
| dev/run/build/deploy/debug commands | `references/command-cookbook.md` | User needs to run Skaffold commands |
| skaffold.yaml structure, builders, deployers, sync | `references/skaffold-yaml.md` | User needs to configure skaffold.yaml |
| Profiles, CI integration, caching, multi-module | `references/profiles-and-ci.md` | User needs environment-specific configs or CI setup |

## Quick Start

```bash
# Generate skaffold.yaml interactively
skaffold init

# Verify configuration before running
skaffold diagnose

# Start iterative dev loop (watches files, rebuilds on change)
skaffold dev

# One-shot build and deploy (for CI)
skaffold run --status-check

# Preview rendered manifests without deploying
skaffold render
```

## Core Command Tracks

- **Dev loop:** `skaffold dev` — watches source, rebuilds images, redeploys on change
- **CI deploy:** `skaffold run` — builds, pushes, and deploys once, then exits
- **Build only:** `skaffold build` — builds and pushes images without deploying
- **Deploy only:** `skaffold deploy` — deploys pre-built images from a build artifact
- **Delete:** `skaffold delete` — tears down resources deployed by Skaffold
- **Debug:** `skaffold debug` — dev loop with debugger port forwarding enabled
- **Render:** `skaffold render` — outputs hydrated manifests without applying them
- **Diagnose:** `skaffold diagnose` — validates skaffold.yaml and environment

## Safety Guardrails

- Always use `skaffold diagnose` to verify configuration before running in CI.
- Use `--default-repo` or `SKAFFOLD_DEFAULT_REPO` to ensure images push to the correct registry.
- Use `skaffold render` to preview manifests without deploying in production contexts.
- In CI, use `skaffold run` not `skaffold dev`; dev mode watches files and blocks indefinitely.
- Use profiles to separate dev, staging, and prod configurations rather than editing the base config.
- Enable `--status-check` in CI to catch failed deployments before marking a build as passing.

## Workflow

1. Run `skaffold init` to generate an initial `skaffold.yaml` if one does not exist.
2. Run `skaffold diagnose` to validate the config and check prerequisites.
3. Set `SKAFFOLD_DEFAULT_REPO` or `--default-repo` to point to the correct container registry.
4. Use `skaffold dev` for local iterative development; use `skaffold run --status-check` in CI.
5. Use profiles (`--profile`) to switch between dev, staging, and prod configurations.
6. Run `skaffold render` to inspect manifests before committing to a deploy.

## Related Skills

- **kubectl** — direct Kubernetes resource management
- **helm** — Helm chart deployer used within Skaffold
- **kustomize** — Kustomize deployer used within Skaffold
- **docker** — container image building underlying Skaffold builders
- **ci-architecture** — CI pipeline patterns for Skaffold-based workflows

## References

- `references/install-and-setup.md`
- `references/command-cookbook.md`
- `references/skaffold-yaml.md`
- `references/profiles-and-ci.md`
- Official docs: <https://skaffold.dev/docs/>
- Command reference: <https://skaffold.dev/docs/references/cli/>
