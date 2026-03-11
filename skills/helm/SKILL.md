---
name: helm
description: Package and deploy Kubernetes applications with Helm charts and releases. Use when tasks mention helm, Helm charts, helm install, helm upgrade, Helm repositories, values.yaml, or Helm releases.
---

# helm

Use this skill to keep Helm-based Kubernetes deployments reproducible, auditable, and safe across environments.

## Intent Router

| Request | Reference | Load When |
| --- | --- | --- |
| Install Helm, add repos, configure registries | `references/install-and-setup.md` | User needs to install Helm or configure repositories |
| install/upgrade/list/rollback/template commands | `references/command-cookbook.md` | User needs day-to-day Helm release operations |
| Chart.yaml, templates, values, helpers | `references/chart-authoring.md` | User wants to author or modify a Helm chart |
| Release lifecycle, --atomic, --wait, diff plugin | `references/release-management.md` | User asks about release management or upgrade strategies |

## Quick Start

```bash
# Add a chart repository
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# Search for a chart
helm search repo bitnami/nginx

# Inspect default values
helm show values bitnami/nginx

# Install with custom values
helm install my-nginx bitnami/nginx --set service.type=ClusterIP -n my-namespace

# Upgrade with a values file
helm upgrade my-nginx bitnami/nginx -f values.yaml -n my-namespace

# List releases
helm list -A
```

## Core Command Tracks

- **Install:** `helm install <release> <chart> [flags]` — create a new release
- **Upgrade:** `helm upgrade --install <release> <chart>` — create or update release
- **Rollback:** `helm rollback <release> [revision]` — revert to previous revision
- **Template:** `helm template <release> <chart>` — render manifests locally without applying
- **Values:** `helm get values <release>` — inspect values used by a deployed release
- **Status:** `helm status <release>` — show release info and notes
- **Uninstall:** `helm uninstall <release>` — remove release and resources

## Safety Guardrails

- Always run `helm upgrade --dry-run --debug` or `helm template` before applying changes to production.
- Use the helm diff plugin (`helm diff upgrade`) to inspect what will change before applying.
- Use `--atomic` in CI pipelines so failed upgrades automatically roll back.
- Never pass secrets via `--set`; use a secrets manager or the helm-secrets plugin.
- Always specify `--namespace` explicitly; do not rely on the default namespace.
- Pin chart versions with `--version` in production to ensure reproducibility.
- Confirm before running `helm uninstall`; it removes all resources managed by the release.

## Workflow

1. Add and update chart repository: `helm repo add` and `helm repo update`.
2. Inspect default values: `helm show values <chart>`.
3. Create a `values.yaml` override file for environment-specific configuration.
4. Render and review manifests: `helm template <release> <chart> -f values.yaml`.
5. Install or upgrade: `helm upgrade --install <release> <chart> -f values.yaml --atomic --wait`.
6. Verify: `helm list`, `helm status <release>`, `kubectl get pods -n <namespace>`.
7. On failure, check: `helm history <release>` and `helm rollback <release>`.

## Related Skills

- **kubectl** — inspect and manage Kubernetes resources created by Helm
- **kustomize** — overlay-based alternative or complement to Helm values
- **docker** — build container images referenced in Helm chart values

## References

- `references/install-and-setup.md`
- `references/command-cookbook.md`
- `references/chart-authoring.md`
- `references/release-management.md`
- Official docs: <https://helm.sh/docs/>
- Chart hub: <https://artifacthub.io/>
