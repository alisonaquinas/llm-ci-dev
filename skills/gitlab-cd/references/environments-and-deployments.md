# Environments and Deployments

Manage deployment environments in GitLab, from development through production.

## Environment Configuration

### Basic Environment Setup

Define environments in `.gitlab-ci.yml` using the `environment` keyword:

```yaml
deploy_job:
  stage: deploy
  script:
    - ./deploy.sh
  environment:
    name: staging
    url: https://staging.example.com
```

The `name` field identifies the environment and appears in the GitLab UI.

### Deployment Tiers

Categorize environments by their purpose:

```yaml
environment:
  name: production
  deployment_tier: production  # production, staging, testing, development

environment:
  name: staging
  deployment_tier: staging

environment:
  name: development
  deployment_tier: development
```

**Supported tiers:**

- `production` — Production systems
- `staging` — Pre-production testing
- `testing` — QA and integration testing
- `development` — Development environments

## Protected Environments

### Enabling Protection

Protected environments restrict who can deploy and may require approvals:

1. Go to **Deployments > Environments** in the GitLab project
2. Click the environment name
3. Under **Deployment approvals**, set:
   - Minimum number of approvals required (1-5)
   - Authorized approvers (users, groups, or roles)

### In `.gitlab-ci.yml`

Protected environments are enforced at the environment level, not in job configuration:

```yaml
deploy_production:
  stage: deploy
  script:
    - ./deploy.sh
  environment:
    name: production
  only:
    - main  # Only deploy from main branch
```

Protection rules set in the UI apply automatically to jobs targeting that environment.

### Protected Environment Variables

Define secrets only available in protected environments:

```yaml
deploy_production:
  environment:
    name: production
  script:
    - echo $PROD_API_KEY  # Only available when deploying to protected env
```

Set variables in **Settings > CI/CD > Variables** with **Protected** enabled.

## Deployment Freeze

Prevent deployments during specific times (e.g., holidays, release windows):

1. Go to **Deployments > Environments**
2. Click **Freeze** for the environment
3. Set date/time range when deployments are blocked

Deployments to frozen environments automatically fail.

## Deployment History and Tracking

### Viewing Deployments

Access deployment history under **Deployments > Environments**:

- Each environment shows active and past deployments
- Click a deployment to view logs, approvals, and rollback options
- Deployment status: `running`, `success`, `failed`, `canceled`

### Deployment Information

Each deployment records:

- Timestamp and duration
- Deployed commit/tag
- User who triggered it
- Pipeline job details
- Release link (if applicable)

### Deployment Status API

Query deployments via GitLab API:

```bash
curl --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
  https://gitlab.com/api/v4/projects/:id/deployments
```

## Auto-Stop Environments

### Dynamic Environment Auto-Stop

Automatically stop review apps or temporary environments after a duration:

```yaml
review:
  environment:
    name: review/$CI_MERGE_REQUEST_IID
    url: https://review-$CI_MERGE_REQUEST_IID.example.com
    auto_stop_in: 1 week
```

**Duration formats:**

- `1 day`, `7 days`, `30 days`
- `1 week`, `2 weeks`
- `1 month` (30 days)
- `never` (do not auto-stop)

### Manual Stop

Stop an environment immediately from the GitLab UI under **Deployments > Environments**.

## Deployment Tracking and Rollbacks

### Rollback a Deployment

Revert to a previous deployment:

1. Go to **Deployments > Environments**
2. Click the environment
3. Find the previous successful deployment
4. Click **Rollback** to re-run that deployment's job

### Track Deployment Status

Monitor active deployments in the pipeline view or **Deployments** tab.

### Approval Requirements

For protected environments, deployments show:

- Pending approval status
- List of approvers and their decisions
- Deployment proceeds once minimum approvals are met

## Related Topics

- See **Deployment Targets** for integration with specific platforms
- See **Release & Versioning** for tagging and release management
