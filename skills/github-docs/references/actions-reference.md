# GitHub Actions Full Reference

Complete breakdown of the GitHub Actions section (docs.github.com/en/actions/).

## Workflow Triggers & Configuration

| Trigger/Concept | Documentation URL |
| --- | --- |
| Workflow events (push, pull_request, schedule, etc.) | `https://docs.github.com/en/actions/using-workflows/workflow-events-that-trigger-workflows` |
| Workflow syntax (complete reference) | `https://docs.github.com/en/actions/writing-workflows/workflow-syntax-for-github-actions` |
| Events for workflows in fork repositories | `https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#workflows-in-forked-repositories` |
| Scheduled workflows (cron) | `https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#schedule` |
| Triggering workflows with webhooks | `https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#webhook-events` |
| Controlling workflow concurrency | `https://docs.github.com/en/actions/using-jobs/using-concurrency` |

## Job Configuration

| Keyword/Concept | Documentation URL |
| --- | --- |
| Jobs and steps | `https://docs.github.com/en/actions/learn-github-actions/workflow-syntax-for-github-actions#jobs` |
| Job matrix | `https://docs.github.com/en/actions/using-jobs/using-a-matrix-for-your-jobs` |
| Conditional expressions | `https://docs.github.com/en/actions/learn-github-actions/contexts#context-availability` |
| Job status functions | `https://docs.github.com/en/actions/learn-github-actions/expressions#job-status-check-functions` |
| Container jobs | `https://docs.github.com/en/actions/using-jobs/running-jobs-in-a-container` |
| Service containers | `https://docs.github.com/en/actions/using-containerized-services/about-service-containers` |
| Job timeouts | `https://docs.github.com/en/actions/writing-workflows/workflow-syntax-for-github-actions#jobsjob_idtimeout-minutes` |

## Contexts & Expressions

| Topic | Documentation URL |
| --- | --- |
| Contexts overview | `https://docs.github.com/en/actions/learn-github-actions/contexts` |
| github context | `https://docs.github.com/en/actions/learn-github-actions/contexts#github-context` |
| env context | `https://docs.github.com/en/actions/learn-github-actions/contexts#env-context` |
| secrets context | `https://docs.github.com/en/actions/learn-github-actions/contexts#secrets-context` |
| needs context (job dependencies) | `https://docs.github.com/en/actions/learn-github-actions/contexts#needs-context` |
| runner context | `https://docs.github.com/en/actions/learn-github-actions/contexts#runner-context` |
| Expressions (if, format, etc.) | `https://docs.github.com/en/actions/learn-github-actions/expressions` |
| Environment variables | `https://docs.github.com/en/actions/learn-github-actions/environment-variables` |

## Workflows & Reusability

| Topic | Documentation URL |
| --- | --- |
| Reusing workflows | `https://docs.github.com/en/actions/using-workflows/reusing-workflows` |
| Workflow templates | `https://docs.github.com/en/actions/using-workflows/creating-starter-workflows-for-your-organization` |
| Composing multiple workflows | `https://docs.github.com/en/actions/using-workflows/triggering-a-workflow` |
| Calling workflows in workflows (nested) | `https://docs.github.com/en/actions/using-workflows/reusing-workflows#creating-a-reusable-workflow` |

## Actions & Marketplace

| Topic | Documentation URL |
| --- | --- |
| Finding and customizing actions | `https://docs.github.com/en/actions/learn-github-actions/finding-and-customizing-actions` |
| Using actions from GitHub Marketplace | `https://docs.github.com/en/actions/marketplace/` |
| Creating actions (composite, Docker, JavaScript) | `https://docs.github.com/en/actions/creating-actions/` |
| Composite actions | `https://docs.github.com/en/actions/creating-actions/creating-a-composite-action` |
| Docker container actions | `https://docs.github.com/en/actions/creating-actions/creating-a-docker-container-action` |
| JavaScript actions | `https://docs.github.com/en/actions/creating-actions/creating-a-javascript-action` |

## Security & Hardening

| Topic | Documentation URL |
| --- | --- |
| Automatic token authentication | `https://docs.github.com/en/actions/security-for-github-actions/security-guides/automatic-token-authentication` |
| Using secrets | `https://docs.github.com/en/actions/security-for-github-actions/security-guides/using-secrets-in-github-actions` |
| OpenID Connect (OIDC) for deployments | `https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect` |
| Security best practices | `https://docs.github.com/en/actions/security-for-github-actions/security-guides/security-hardening-for-github-actions` |
| Dependency caching | `https://docs.github.com/en/actions/using-workflows/caching-dependencies-to-speed-up-workflows` |
| Artifact retention | `https://docs.github.com/en/actions/managing-workflow-runs/removing-workflow-artifacts` |

## Runners & Execution

| Topic | Documentation URL |
| --- | --- |
| About GitHub-hosted runners | `https://docs.github.com/en/actions/using-github-hosted-runners/about-github-hosted-runners` |
| GitHub-hosted runner specs | `https://docs.github.com/en/actions/using-github-hosted-runners/about-github-hosted-runners#preinstalled-software` |
| Self-hosted runners overview | `https://docs.github.com/en/actions/hosting-your-own-runners/about-self-hosted-runners` |
| Adding self-hosted runners | `https://docs.github.com/en/actions/hosting-your-own-runners/adding-self-hosted-runners` |
| Autoscaling self-hosted runners | `https://docs.github.com/en/actions/hosting-your-own-runners/autoscaling-with-self-hosted-runners` |
| Monitoring and troubleshooting runners | `https://docs.github.com/en/actions/hosting-your-own-runners/monitoring-and-troubleshooting-self-hosted-runners` |

## Deployment & Environments

| Topic | Documentation URL |
| --- | --- |
| Using environments | `https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment` |
| Deployment status checks | `https://docs.github.com/en/actions/deployment/targeting-different-environments/deployment-statuses` |
| Adding environment protection rules | `https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment#environment-protection-rules` |
| OpenID Connect for deployments | `https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect` |

## Workflow Management & Debugging

| Topic | Documentation URL |
| --- | --- |
| Viewing workflow runs | `https://docs.github.com/en/actions/managing-workflow-runs/viewing-workflow-run-history` |
| Downloading artifacts | `https://docs.github.com/en/actions/managing-workflow-runs/downloading-workflow-artifacts` |
| Debugging workflows | `https://docs.github.com/en/actions/monitoring-and-troubleshooting-workflows/about-workflow-debugging` |
| Enabling debug logging | `https://docs.github.com/en/actions/monitoring-and-troubleshooting-workflows/enabling-debug-logging` |
| Using concurrency limits | `https://docs.github.com/en/actions/using-jobs/using-concurrency` |
| Cancelling workflow runs | `https://docs.github.com/en/actions/managing-workflow-runs/canceling-a-workflow` |
