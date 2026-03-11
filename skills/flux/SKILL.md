---
name: flux
description: Manage GitOps Kubernetes deployments with FluxCD sources and Kustomizations. Use when tasks mention flux, FluxCD, flux bootstrap, GitRepository CRD, HelmRelease CRD, Kustomization CRD, or GitOps with Flux.
---

# flux

Use this skill to keep FluxCD GitOps deployments safe, auditable, and reconciled correctly across environments.

## Intent Router

| Request | Reference | Load When |
| --- | --- | --- |
| Install flux CLI, bootstrap GitHub/GitLab, verify | `references/install-and-setup.md` | User needs to install flux or bootstrap a cluster |
| get/reconcile/suspend/resume/diff/logs commands | `references/command-cookbook.md` | User needs to run flux CLI commands |
| GitRepository, HelmRepository, OCIRepository, ImagePolicy | `references/gitops-sources.md` | User needs to configure GitOps source CRDs |
| Kustomization and HelmRelease CRD fields | `references/kustomizations-and-helmreleases.md` | User needs to configure workload reconciliation |

## Quick Start

```bash
# Check prerequisites before bootstrap
flux check --pre

# Bootstrap with GitHub
flux bootstrap github \
  --owner=my-org \
  --repository=my-fleet-repo \
  --path=clusters/my-cluster \
  --personal

# Verify all Flux controllers are healthy
flux check

# Show all managed resources
flux get all
```

## Core Command Tracks

- **Status:** `flux get all` — overview of all sources and workloads
- **Reconcile:** `flux reconcile source git <name>` — force sync from git
- **Diff:** `flux diff kustomization <name>` — preview changes before committing
- **Suspend/resume:** `flux suspend/resume kustomization <name>` — pause reconciliation
- **Logs:** `flux logs` — stream Flux controller logs
- **Events:** `flux events` — show recent Kubernetes events from Flux objects

## Safety Guardrails

- Run `flux check` after bootstrap and after any change to the flux-system namespace to verify controller health.
- Use `flux diff kustomization <name>` to preview changes before committing to the GitOps source repo.
- Use `flux suspend kustomization <name>` before making emergency manual changes to avoid immediate reconciliation reverting them.
- Never delete flux-system namespace resources directly — use `flux uninstall` for clean removal.
- Set `prune: true` on Kustomizations only after verifying the resource list is complete; missing resources will be deleted.
- Store bootstrap secrets (GitHub PAT, deploy keys) as Kubernetes secrets or use SOPS/sealed-secrets — never in plaintext in git.
- Use `dependsOn` to ensure infrastructure (CRDs, namespaces) is ready before dependent workloads reconcile.

## Workflow

1. Run `flux check --pre` to verify prerequisites before bootstrap.
2. Run `flux bootstrap github/gitlab` to install Flux and commit generated manifests to git.
3. Define sources (GitRepository, HelmRepository) and workloads (Kustomization, HelmRelease) as YAML in the fleet repo.
4. Use `flux diff kustomization <name>` to preview the effect of changes before pushing to git.
5. Monitor reconciliation with `flux get all` and `flux events`.
6. On failure, use `flux logs` and `kubectl describe` on the failing CRD object to diagnose.

## Related Skills

- **kubectl** — inspect Kubernetes resources managed by Flux
- **kustomize** — Kustomize overlays reconciled by Flux Kustomization CRD
- **helm** — Helm releases managed by Flux HelmRelease CRD
- **ci-architecture** — CI pipeline patterns that feed the GitOps source repo
- **github-cd** — GitHub Actions workflows that push to the Flux fleet repo
- **gitlab-cd** — GitLab CI pipelines that push to the Flux fleet repo

## References

- `references/install-and-setup.md`
- `references/command-cookbook.md`
- `references/gitops-sources.md`
- `references/kustomizations-and-helmreleases.md`
- Official docs: <https://fluxcd.io/flux/>
- CRD reference: <https://fluxcd.io/flux/components/>
