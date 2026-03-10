# Review Apps

Create dynamic preview environments for merge requests.

## Dynamic Environment Naming

### Using CI/CD Variables

Generate unique environment names per merge request:

```yaml
review:
  stage: deploy
  script:
    - ./deploy.sh
  environment:
    name: review/$CI_MERGE_REQUEST_IID
    url: https://review-$CI_MERGE_REQUEST_IID.example.com
```

**Available variables:**

- `$CI_MERGE_REQUEST_IID` — Merge request internal ID (unique within project)
- `$CI_MERGE_REQUEST_SOURCE_BRANCH_NAME` — Source branch name
- `$CI_MERGE_REQUEST_TITLE` — Merge request title
- `$CI_COMMIT_SHA` — Full commit hash

### Example Naming Patterns

```yaml
# Pattern: review/123
name: review/$CI_MERGE_REQUEST_IID

# Pattern: feature-my-feature-123
name: feature-$CI_MERGE_REQUEST_SOURCE_BRANCH_NAME-$CI_MERGE_REQUEST_IID

# Pattern: mr-title-slug-123
name: mr-$CI_MERGE_REQUEST_IID-$CI_COMMIT_SHA
```

## Review App Lifecycle

### Deployment

Review apps deploy automatically when merge requests are created:

```yaml
review_deploy:
  stage: review
  script:
    - docker build -t review:$CI_COMMIT_SHA .
    - docker run -d -p 8000:3000 --name review-app-$CI_MERGE_REQUEST_IID review:$CI_COMMIT_SHA
  environment:
    name: review/$CI_MERGE_REQUEST_IID
    url: https://review-$CI_MERGE_REQUEST_IID.example.com
    on_stop: review_stop
  only:
    - merge_requests
```

### Stopping Review Apps

Define stop job to tear down review apps when merge requests close:

```yaml
review_stop:
  stage: review
  script:
    - docker stop review-app-$CI_MERGE_REQUEST_IID || true
    - docker rm review-app-$CI_MERGE_REQUEST_IID || true
  environment:
    name: review/$CI_MERGE_REQUEST_IID
    action: stop
  when: manual
  only:
    - merge_requests
```

Use `when: manual` to require explicit trigger, or omit to auto-stop.

### Auto-Stop Configuration

Automatically stop review apps after inactivity or elapsed time:

```yaml
review:
  environment:
    name: review/$CI_MERGE_REQUEST_IID
    url: https://review-$CI_MERGE_REQUEST_IID.example.com
    auto_stop_in: 1 week
```

Review apps stop automatically after the specified duration.

## Deployment URLs

### Accessing Review Apps

Review app URLs appear in:

1. **Merge Request UI** — Under **Deployments** section
2. **GitLab Pipelines** — Environment card shows deployment link
3. **Deployments page** — All active review apps listed

### Dynamic URL Construction

```yaml
environment:
  url: https://review-$CI_MERGE_REQUEST_IID.example.com
```

Or construct based on branch or commit:

```yaml
environment:
  url: https://$CI_COMMIT_SHA.review.example.com
```

### Custom Domain Setup

Configure DNS or reverse proxy to map review app URLs:

```bash
*.review.example.com → your-k8s-cluster.example.com
```

Then use wildcard in environment URL.

## Per-Branch Namespaces

### Namespace Isolation in Kubernetes

Deploy each review app to its own namespace:

```yaml
review_k8s:
  stage: deploy
  script:
    - kubectl create namespace review-$CI_MERGE_REQUEST_IID || true
    - kubectl apply -f k8s/ -n review-$CI_MERGE_REQUEST_IID
  environment:
    name: review/$CI_MERGE_REQUEST_IID
    kubernetes:
      namespace: review-$CI_MERGE_REQUEST_IID
  only:
    - merge_requests
```

**Benefits:**

- Isolation between review apps
- Easy cleanup via namespace deletion
- Per-namespace RBAC and resource limits

### Docker Compose Networks

Isolate review apps using Docker Compose networks:

```yaml
review_docker:
  services:
    - docker:dind
  script:
    - docker-compose -p review-$CI_MERGE_REQUEST_IID up -d
    - docker-compose -p review-$CI_MERGE_REQUEST_IID ps
  environment:
    name: review/$CI_MERGE_REQUEST_IID
    url: http://review-$CI_MERGE_REQUEST_IID-app:3000
```

## Auto DevOps Integration

### Enabling Auto DevOps

Auto DevOps automatically creates review apps without manual job configuration:

1. Go to **CI/CD > Auto DevOps**
2. Toggle **Enable Auto DevOps**
3. Choose deployment platform (Kubernetes, etc.)

### Auto DevOps Review App Features

- Automatic review app creation per merge request
- Dynamic subdomain assignment
- Database seeding
- Automated stop on merge request close
- Optional approval requirement

### Configuration

In `.auto-devops.yml` or project settings:

```yaml
review_app:
  enabled: true
  stop_review_app_on_mr_close: true
  auto_deploy_on_default_branch: true
```

## Related Topics

- See **Environments & Deployments** for environment protection and URLs
- See **Deployment Targets** for Kubernetes and cloud platform setup
