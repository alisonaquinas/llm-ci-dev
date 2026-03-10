# Variables & Secrets — Environment Configuration and Sensitive Data Management

## Overview

GitLab CI provides predefined variables for pipeline context, custom variables for configuration,
and secure secret management via protected variables, masked values, and integrations like HashiCorp Vault.

---

## Predefined Variables

GitLab automatically provides variables describing the current pipeline, job, and commit.

### Common Predefined Variables

| Variable | Value | Example |
| --- | --- | --- |
| `$CI_PIPELINE_ID` | Unique pipeline ID | 1234567 |
| `$CI_JOB_ID` | Unique job ID | 5678901 |
| `$CI_COMMIT_SHA` | Full commit hash | abc123def456... |
| `$CI_COMMIT_SHORT_SHA` | Short commit hash (8 chars) | abc123de |
| `$CI_COMMIT_BRANCH` | Current branch name | main |
| `$CI_COMMIT_TAG` | Git tag (if tag push) | v1.0.0 |
| `$CI_COMMIT_MESSAGE` | Full commit message | "feat: add feature" |
| `$CI_PROJECT_ID` | Project ID | 42 |
| `$CI_PROJECT_NAME` | Project name | my-project |
| `$CI_PROJECT_PATH` | Group/project path | group/my-project |
| `$CI_PROJECT_URL` | Project web URL | <https://gitlab.example.com/group/my-project> |
| `$CI_PIPELINE_SOURCE` | Pipeline trigger type | push, merge_request_event, schedule, etc. |
| `$CI_MERGE_REQUEST_IID` | MR internal ID | 123 |
| `$CI_MERGE_REQUEST_APPROVED` | MR approval status | true, false |
| `$CI_REGISTRY` | GitLab Registry hostname | registry.gitlab.com |
| `$CI_REGISTRY_IMAGE` | Full image path | registry.gitlab.com/group/project |
| `$CI_JOB_NAME` | Job name | test_unit |
| `$CI_JOB_STAGE` | Job stage | test |
| `$CI_RUNNER_ID` | Runner ID | 1 |
| `$CI_RUNNER_TAGS` | Runner tags | docker,ubuntu |

### Context Variables

```yaml
build:
  stage: build
  script:
    - echo "Pipeline $CI_PIPELINE_ID started on branch $CI_COMMIT_BRANCH"
    - echo "Commit: $CI_COMMIT_SHORT_SHA by $CI_COMMIT_MESSAGE"
    - docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA .
    - docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
```

### Branch/Tag Variables

```yaml
deploy:
  stage: deploy
  script:
    - |
      if [ "$CI_COMMIT_BRANCH" = "main" ]; then
        make deploy:prod
      elif [ -n "$CI_COMMIT_TAG" ]; then
        make deploy:release VERSION=$CI_COMMIT_TAG
      else
        echo "Skipping deployment for branch $CI_COMMIT_BRANCH"
      fi
```

### Merge Request Variables

```yaml
notify_mr:
  stage: test
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
  script:
    - |
      curl -X POST \
        -H "PRIVATE-TOKEN: $CI_JOB_TOKEN" \
        "$CI_API_V4_URL/projects/$CI_PROJECT_ID/merge_requests/$CI_MERGE_REQUEST_IID/notes" \
        -d "body=Tests passed for commit $CI_COMMIT_SHORT_SHA"
```

### Runner Variables

```yaml
check_runner:
  script:
    - echo "Running on $HOSTNAME"
    - echo "Runner tags: $CI_RUNNER_TAGS"
```

---

## Custom Variables

Define custom variables globally or at job level.

### Global Variables

Set at pipeline level (accessible to all jobs):

```yaml
variables:
  REGISTRY: registry.example.com
  IMAGE_TAG: latest
  NODE_ENV: production
  LOG_LEVEL: info

build:
  script:
    - docker build -t $REGISTRY/myapp:$IMAGE_TAG .

test:
  script:
    - npm test
```

### Job-Level Variables

Override global variables per job:

```yaml
variables:
  ENVIRONMENT: staging

deploy_prod:
  stage: deploy
  variables:
    ENVIRONMENT: production
  script:
    - ./deploy.sh $ENVIRONMENT

deploy_staging:
  stage: deploy
  script:
    - ./deploy.sh $ENVIRONMENT
```

### Variable Expansion

Variables can reference other variables:

```yaml
variables:
  REGISTRY: registry.example.com
  IMAGE: $REGISTRY/myapp
  TAG: $CI_COMMIT_SHA
  FULL_IMAGE: $IMAGE:$TAG

build:
  script:
    - docker build -t $FULL_IMAGE .
    - docker push $FULL_IMAGE
```

### Variable Syntax

#### Bash/Shell Syntax

```yaml
script:
  - echo "Branch: $CI_COMMIT_BRANCH"
  - make deploy ENV=$ENVIRONMENT
```

#### PowerShell Syntax

```yaml
script:
  - echo "Branch: $env:CI_COMMIT_BRANCH"
  - make deploy ENV=$env:ENVIRONMENT
```

#### YAML Quotes

Quote variables to ensure correct substitution:

```yaml
script:
  - "echo 'Building $IMAGE_TAG'"
  - 'docker run $IMAGE_TAG /bin/sh'
```

---

## Protected and Masked Variables

### Protected Variables

Accessible only in pipelines on protected branches/tags:

1. Go to **Settings > CI/CD > Variables**
2. Check **"Protect variable"**
3. Variable only available in:
   - main branch pipelines
   - Tag pipelines
   - Protected branches

```yaml
# Protected variable (only on protected branches)
deploy_prod:
  script:
    - curl -X POST \
        -H "Authorization: Bearer $PROD_API_TOKEN" \
        https://api.example.com/deploy
  rules:
    - if: $CI_COMMIT_BRANCH == "main"  # Protected branch only
```

Use cases:

- Production secrets (API keys, database passwords)
- Deployment credentials
- Sensitive API tokens

### Masked Variables

Sensitive values are hidden from job logs:

1. Go to **Settings > CI/CD > Variables**
2. Check **"Mask variable"**
3. Value replaced with `***` in job output

```yaml
variables:
  DATABASE_PASSWORD: secret123  # Masked: appears as *** in logs

script:
  - echo "Password is $DATABASE_PASSWORD"  # Output: Password is ***
```

Masking rules:

- Only exact matches are masked (substring matches are not)
- Values must be at least 8 characters
- Value format must match `/^[a-zA-Z0-9_-]+$/` for masking

### Best Practices for Secrets

```yaml
variables:
  PUBLIC_VAR: my-registry.com  # Not protected/masked; OK for public data

# In Settings > CI/CD > Variables:
# PROD_API_KEY: protected + masked
# DB_PASSWORD: protected + masked
# DOCKER_LOGIN_TOKEN: protected + masked

build:
  script:
    - docker login -u $DOCKER_USER -p $DOCKER_LOGIN_TOKEN $PUBLIC_VAR

deploy:
  script:
    - curl -H "Authorization: Bearer $PROD_API_KEY" https://api.prod.com/deploy
  rules:
    - if: $CI_COMMIT_BRANCH == "main"  # Protected; uses protected variables
```

---

## Dotenv Artifacts

Load variables from a job's artifact file into subsequent jobs:

### Creating Dotenv Artifacts

Job creates a `.env`-format file:

```yaml
build:
  stage: build
  script:
    - |
      echo "BUILD_ID=$CI_PIPELINE_ID" >> build.env
      echo "IMAGE_TAG=$CI_COMMIT_SHA" >> build.env
      echo "BUILD_TIME=$(date)" >> build.env
  artifacts:
    reports:
      dotenv: build.env
```

### Using Dotenv Variables

Subsequent jobs automatically load variables from previous jobs' dotenv artifacts:

```yaml
deploy:
  stage: deploy
  dependencies:
    - build
  script:
    - echo "Deploying build $BUILD_ID with image $IMAGE_TAG"
    - docker run $IMAGE_TAG deploy
```

Variables from `build.env` are available in `deploy` job.

### Multiple Dotenv Files

```yaml
build:
  artifacts:
    reports:
      dotenv:
        - build.env
        - version.env
```

### Format

Dotenv file format (key=value, one per line):

```bash
BUILD_ID=12345
IMAGE_TAG=abc123def456
BUILD_TIME=2026-03-10T10:30:00Z
DEPLOY_URL=https://staging.example.com
```

---

## CI_JOB_TOKEN (Pipeline Token)

Automatic token provided by GitLab for job-to-job and job-to-API authentication.

### Accessing Private Registries

Push to GitLab Registry without hardcoded credentials:

```yaml
build:
  stage: build
  image: docker:latest
  services:
    - docker:dind
  before_script:
    - echo $CI_JOB_TOKEN | docker login -u gitlab-ci-token --password-stdin $CI_REGISTRY
  script:
    - docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA .
    - docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
```

`$CI_JOB_TOKEN` is automatically valid for the current project's registry.

### Accessing Private Dependencies

Pull packages from private repositories:

```yaml
build:
  stage: build
  image: node:18
  before_script:
    - npm config set //registry.npmjs.org/:_authToken=$CI_JOB_TOKEN
  script:
    - npm ci
    - npm run build
```

### Triggering Downstream Pipelines

Trigger pipelines in other projects (if user has access):

```yaml
trigger_deploy:
  stage: deploy
  script:
    - |
      curl -X POST \
        -H "PRIVATE-TOKEN: $CI_JOB_TOKEN" \
        -F "ref=main" \
        "https://gitlab.example.com/api/v4/projects/OTHER_PROJECT_ID/pipeline"
```

### API Calls from Jobs

Make authenticated API calls to GitLab without storing credentials:

```yaml
update_mr:
  stage: test
  script:
    - |
      curl -X POST \
        -H "PRIVATE-TOKEN: $CI_JOB_TOKEN" \
        "$CI_API_V4_URL/projects/$CI_PROJECT_ID/merge_requests/$CI_MERGE_REQUEST_IID/notes" \
        -d "body=Tests completed"
```

---

## OpenID Connect (OIDC) ID Tokens

Exchange GitLab ID tokens for credentials in external systems (AWS, GCP, Azure).

### Generating OIDC Tokens

OIDC tokens are automatically issued for each job:

```yaml
deploy:
  stage: deploy
  script:
    - export ID_TOKEN=$CI_JOB_JWT_V2
    - |
      curl -X POST \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -d "grant_type=urn:ietf:params:oauth:grant-type:token-exchange" \
        -d "subject_token=$ID_TOKEN" \
        -d "subject_token_type=urn:ietf:params:oauth:token-type:id_token" \
        -d "audience=https://example.com" \
        https://sts.example.com/token
```

### AWS AssumeRoleWithWebIdentity

Use OIDC token to assume AWS role without hardcoded credentials:

```yaml
deploy_aws:
  stage: deploy
  image: amazon/aws-cli:latest
  script:
    - |
      CREDENTIALS=$(aws sts assume-role-with-web-identity \
        --role-arn arn:aws:iam::123456789:role/GitLabCIRole \
        --role-session-name gitlab-ci-session \
        --web-identity-token $CI_JOB_JWT_V2 \
        --duration-seconds 3600)
    - |
      export AWS_ACCESS_KEY_ID=$(echo $CREDENTIALS | jq -r .Credentials.AccessKeyId)
      export AWS_SECRET_ACCESS_KEY=$(echo $CREDENTIALS | jq -r .Credentials.SecretAccessKey)
      export AWS_SESSION_TOKEN=$(echo $CREDENTIALS | jq -r .Credentials.SessionToken)
    - aws s3 cp build/ s3://my-bucket/builds/
```

### GCP Workload Identity Federation

```yaml
deploy_gcp:
  stage: deploy
  image: google/cloud-sdk:latest
  script:
    - gcloud iam service-accounts keys create key.json --iam-account=sa@project.iam.gserviceaccount.com
    - gcloud auth activate-service-account --key-file=key.json
    - gsutil -m cp -r build/ gs://my-bucket/builds/
```

### Azure Workload Identity Federation

```yaml
deploy_azure:
  stage: deploy
  image: mcr.microsoft.com/azure-cli:latest
  script:
    - |
      az login --federated-token "$CI_JOB_JWT_V2" \
        --user-assigned-identity-client-id "$AZURE_CLIENT_ID"
    - az storage blob upload-batch -d container -s build/ --account-name myaccount
```

---

## HashiCorp Vault Integration

Retrieve secrets from Vault instead of storing in GitLab variables.

### Vault Configuration

1. Configure Vault integration in **Settings > Integrations > HashiCorp Vault**
2. Provide Vault URL and auth method

### Using Vault in Jobs

```yaml
deploy:
  stage: deploy
  image: vault:latest
  script:
    - |
      export VAULT_TOKEN=$(vault write -field=token auth/jwt/login \
        jwt=$CI_JOB_JWT_V2)
    - |
      export DB_PASSWORD=$(vault kv get -field=password secret/database)
      export API_KEY=$(vault kv get -field=key secret/api)
    - ./deploy.sh
```

Or use GitLab's built-in Vault integration:

```yaml
deploy:
  stage: deploy
  secrets:
    DATABASE_PASSWORD:
      vault: secret/data/database/prod#password
    API_KEY:
      vault: secret/data/api#key
  script:
    - echo "Using secrets from Vault"
    - ./deploy.sh
```

---

## Variable Precedence

Variables are resolved in this order (highest to lowest precedence):

1. **Job-level variables** in .gitlab-ci.yml
2. **Protected variables** (on protected branches)
3. **Global variables** in .gitlab-ci.yml
4. **Predefined variables** ($CI_COMMIT_SHA, etc.)
5. **Environment-specific variables** (rarely used)

Example:

```yaml
variables:
  ENV: staging      # Global: used unless overridden

job1:
  variables:
    ENV: production # Job-level: higher precedence; ENV=production
  script: echo $ENV

job2:
  script: echo $ENV  # Uses global; ENV=staging
```

---

## Best Practices

1. **Protect production secrets** — Use Protected + Masked variables on protected branches
2. **Use OIDC when possible** — Avoid hardcoded credentials; exchange tokens instead
3. **Leverage CI_JOB_TOKEN** — Authenticate to GitLab APIs and registries
4. **Rotate secrets regularly** — Update and test credential rotation procedures
5. **Mask sensitive values** — Hide passwords, tokens from logs
6. **Use dotenv artifacts** — Share computed values between jobs
7. **Minimize secret exposure** — Load secrets only where needed
8. **Audit variable access** — Review who/what accesses secrets
9. **Document secret dependencies** — List required variables in README or docs
10. **Test secrets locally** — Verify pipeline logic before deploying secrets
