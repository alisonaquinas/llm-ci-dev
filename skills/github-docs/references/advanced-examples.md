# GitHub Actions Advanced Examples

Curated index of canonical pages for advanced workflow patterns. The agent should
WebFetch these directly rather than guessing structure — each link below is a
hand-checked authoritative source on docs.github.com or the runner-images repo.

## Matrix Strategies

| Pattern | Documentation URL |
| --- | --- |
| Matrix overview (`jobs.<id>.strategy.matrix`) | `https://docs.github.com/en/actions/using-jobs/using-a-matrix-for-your-jobs` |
| Matrix `include` (extra variants) | `https://docs.github.com/en/actions/using-jobs/using-a-matrix-for-your-jobs#expanding-or-adding-matrix-configurations` |
| Matrix `exclude` (skip variants) | `https://docs.github.com/en/actions/using-jobs/using-a-matrix-for-your-jobs#excluding-matrix-configurations` |
| `fail-fast` and `max-parallel` | `https://docs.github.com/en/actions/using-jobs/using-a-matrix-for-your-jobs#handling-failures` |
| Dynamic matrix from prior job output | `https://docs.github.com/en/actions/using-jobs/using-a-matrix-for-your-jobs#using-the-output-of-one-job-as-the-input-of-another` |

## Reusable Workflows

| Pattern | Documentation URL |
| --- | --- |
| `workflow_call` trigger | `https://docs.github.com/en/actions/using-workflows/reusing-workflows` |
| Passing inputs and secrets | `https://docs.github.com/en/actions/using-workflows/reusing-workflows#passing-inputs-and-secrets-to-a-reusable-workflow` |
| `secrets: inherit` | `https://docs.github.com/en/actions/using-workflows/reusing-workflows#passing-inputs-and-secrets-to-a-reusable-workflow` |
| Reusable workflow outputs | `https://docs.github.com/en/actions/using-workflows/reusing-workflows#using-outputs-from-a-reusable-workflow` |
| Nesting reusable workflows | `https://docs.github.com/en/actions/using-workflows/reusing-workflows#nesting-reusable-workflows` |

## Environments & Deployment Gates

| Pattern | Documentation URL |
| --- | --- |
| Environments overview | `https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment` |
| Required reviewers | `https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment#required-reviewers` |
| Wait timer and branch policies | `https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment#environment-protection-rules` |
| Environment secrets | `https://docs.github.com/en/actions/security-for-github-actions/security-guides/using-secrets-in-github-actions#creating-secrets-for-an-environment` |
| Deployment statuses | `https://docs.github.com/en/actions/deployment/targeting-different-environments/deployment-statuses` |

## OIDC with Cloud Providers

| Provider | Documentation URL |
| --- | --- |
| OIDC overview | `https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect` |
| AWS | `https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services` |
| Azure | `https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-azure` |
| Google Cloud | `https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-google-cloud-platform` |
| HashiCorp Vault | `https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-hashicorp-vault` |
| Customizing the OIDC token claim (sub) | `https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect#customizing-the-token-claims` |

## Composite Actions

| Pattern | Documentation URL |
| --- | --- |
| Composite actions overview | `https://docs.github.com/en/actions/creating-actions/creating-a-composite-action` |
| Composite inputs and outputs | `https://docs.github.com/en/actions/creating-actions/metadata-syntax-for-github-actions#inputs` |
| Sharing actions across repos | `https://docs.github.com/en/actions/creating-actions/sharing-actions-and-workflows-with-your-organization` |
| Publishing to GitHub Marketplace | `https://docs.github.com/en/actions/creating-actions/publishing-actions-in-github-marketplace` |
| Action immutability and signed releases | `https://docs.github.com/en/actions/security-for-github-actions/using-artifact-attestations` |

## Self-Hosted Runner Autoscaling

| Pattern | Documentation URL |
| --- | --- |
| Self-hosted runners overview | `https://docs.github.com/en/actions/hosting-your-own-runners/about-self-hosted-runners` |
| Autoscaling guidance | `https://docs.github.com/en/actions/hosting-your-own-runners/autoscaling-with-self-hosted-runners` |
| Actions Runner Controller (ARC) for Kubernetes | `https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners-with-actions-runner-controller/quickstart-for-actions-runner-controller` |
| ARC scaling sets | `https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners-with-actions-runner-controller/deploying-runner-scale-sets-with-actions-runner-controller` |
| Runner groups for access control | `https://docs.github.com/en/actions/hosting-your-own-runners/managing-access-to-self-hosted-runners-using-groups` |

## Caching & Performance

| Pattern | Documentation URL |
| --- | --- |
| `actions/cache` usage | `https://docs.github.com/en/actions/using-workflows/caching-dependencies-to-speed-up-workflows` |
| Cache scopes and keys | `https://docs.github.com/en/actions/using-workflows/caching-dependencies-to-speed-up-workflows#restrictions-for-accessing-a-cache` |
| Restoring cache across branches | `https://docs.github.com/en/actions/using-workflows/caching-dependencies-to-speed-up-workflows#matching-a-cache-key` |
| Built-in setup-* caching (setup-node, setup-python, etc.) | `https://docs.github.com/en/actions/using-workflows/caching-dependencies-to-speed-up-workflows#using-the-cache-action` |

## Runner Images & Pinning

| Topic | Source |
| --- | --- |
| Runner images repo (release notes, image contents) | `https://github.com/actions/runner-images` |
| Pinning by image label vs `latest` | `https://docs.github.com/en/actions/using-github-hosted-runners/about-github-hosted-runners#supported-runners-and-hardware-resources` |
| Preview/GA status of new images | `https://github.com/actions/runner-images#available-images` |
