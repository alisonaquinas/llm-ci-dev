---
name: kustomize
description: Customize Kubernetes manifests with overlay and base patterns using Kustomize. Use when tasks mention kustomize, Kustomization files, kubectl apply -k, overlay/base patterns, or kustomization.yaml.
---

# kustomize

Use this skill to keep Kubernetes manifest customization structured, overlay-based, and free of template duplication.

## Intent Router

| Request | Reference | Load When |
| --- | --- | --- |
| Install kustomize standalone or kubectl built-in | `references/install-and-setup.md` | User needs to install kustomize or verify version |
| kustomize build, edit, kubectl apply -k commands | `references/command-cookbook.md` | User needs day-to-day kustomize operations |
| kustomization.yaml anatomy, generators, patches | `references/kustomization-structure.md` | User wants to understand or author kustomization.yaml |
| base/overlay layout, environment overlays, GitOps | `references/overlays-and-bases.md` | User asks about multi-environment patterns or GitOps integration |

## Quick Start

```bash
# Preview rendered output
kustomize build ./overlays/production

# Apply directly with kubectl
kubectl apply -k ./overlays/production

# Diff what will change
kubectl diff -k ./overlays/production

# Build and pipe to kubectl
kustomize build ./overlays/production | kubectl apply -f -
```

## Core Command Tracks

- **Build:** `kustomize build <dir>` — render all resources to stdout
- **Apply:** `kubectl apply -k <dir>` — build and apply in one step
- **Diff:** `kubectl diff -k <dir>` — preview changes against live cluster
- **Edit:** `kustomize edit set image/namespace/nameprefix` — modify kustomization.yaml programmatically
- **Inspect:** `kustomize cfg tree <dir>` — visualize resource tree

## Safety Guardrails

- Always run `kustomize build` or `kubectl diff -k` to inspect rendered output before applying to production.
- Verify the correct overlay path before running `kubectl apply -k`; applying the wrong overlay can affect the wrong environment.
- Review patches carefully — strategic merge patches can silently remove fields if not written correctly.
- Do not commit `secretGenerator` literals directly; use `.env` files excluded from version control or reference external secret managers.
- Test changes in a lower environment overlay before promoting to production overlays.
- Use `namePrefix` and `namespace` fields in overlays to prevent accidental cross-environment resource collisions.

## Workflow

1. Identify the target overlay: `ls overlays/`.
2. Preview rendered manifests: `kustomize build ./overlays/<env>`.
3. Diff against live cluster: `kubectl diff -k ./overlays/<env>`.
4. Apply: `kubectl apply -k ./overlays/<env>`.
5. Verify rollout: `kubectl rollout status deployment/<name> -n <namespace>`.

## Related Skills

- **kubectl** — apply and manage resources built by kustomize
- **helm** — chart-based alternative to kustomize for packaging applications
- **docker** — build container images referenced in kustomize image overrides

## References

- `references/install-and-setup.md`
- `references/command-cookbook.md`
- `references/kustomization-structure.md`
- `references/overlays-and-bases.md`
- Official docs: <https://kustomize.io/>
- API reference: <https://kubectl.docs.kubernetes.io/references/kustomize/kustomization/>
