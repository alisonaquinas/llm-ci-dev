---
name: gitlab-cd
description: >
  Deploy with GitLab CD environments and pipelines.
  Manage deployments, environments, and releases using GitLab's native CD capabilities.
---

# GitLab CD

Deploy applications using GitLab CD environments, pipelines, and release management.
This skill covers deployment lifecycle management, environment protection, review apps,
and integration with deployment targets like Kubernetes, cloud platforms, and container registries.

---

## Intent Router

Load reference files for depth on specific topics:

| Topic | File | Load when... |
| --- | --- | --- |
| Environments & Deployments | `references/environments-and-deployments.md` | Setting up deployment environments, tiers, protected environments, and tracking |
| Deployment Targets | `references/deployment-targets.md` | Integrating with Kubernetes, cloud providers, registries, or custom targets |
| Review Apps | `references/review-apps.md` | Creating dynamic review environments for merge requests |
| Release & Versioning | `references/release-and-versioning.md` | Managing releases, semantic versioning, and artifact distribution |

---

## Quick Start

### Deployment Job Pattern

A basic deployment job in `.gitlab-ci.yml`:

```yaml
deploy_production:
  stage: deploy
  image: alpine:latest
  script:
    - echo "Deploying to production..."
  environment:
    name: production
    url: https://app.example.com
    deployment_tier: production
    auto_stop_in: never
  only:
    - main
```

### Manual vs Automatic Deployments

- **Automatic** — Runs immediately when pipeline conditions are met
- **Manual** — Requires `when: manual` and explicit trigger from pipeline UI or API

```yaml
deploy_staging:
  environment:
    name: staging
  when: manual  # Requires manual trigger
```

### Protected Environments

Restrict deployments to specific users, groups, or approval requirements:

```yaml
deploy_production:
  environment:
    name: production
  only:
    - main
```

Enable production environment protection in GitLab UI under **Deployments > Environments**
to require approvals.

### Environment URLs

Set deployment URLs for easy access from the GitLab interface:

```yaml
environment:
  name: production
  url: https://app.example.com
  auto_stop_in: 1 week  # Auto-stop review app after 1 week
```

---

## Related References

- Load **Environments & Deployments** to configure deployment tiers, protection, and history
- Load **Deployment Targets** for Kubernetes, AWS, GCP, Heroku, or registry integration
- Load **Review Apps** for per-branch dynamic environments
- Load **Release & Versioning** for release management and semantic versioning
