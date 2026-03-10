# OIDC & Authentication

OpenID Connect (OIDC) provides secure, keyless authentication for GitHub Actions deployments.
Exchange GitHub-issued OIDC tokens for short-lived credentials without managing static secrets.

## Why OIDC

### Problems with Static Credentials

- **No expiration** — Long-lived tokens create persistent risk
- **Shared secrets** — Hard to rotate, audit, or scope access
- **Revocation complexity** — Revoking compromised tokens requires multiple systems
- **Audit gaps** — Hard to trace which workflow used which credential

### OIDC Benefits

| Benefit | Explanation |
| --- | --- |
| **No static secrets** | Tokens issued dynamically per workflow run |
| **Auto expiration** | Tokens expire after job completes (typically 5 minutes) |
| **Audit trail** | Every token issue logged with workflow metadata |
| **Granular scoping** | Restrict by branch, environment, actor, or repository |
| **Cloud-native** | All major cloud providers support OIDC (AWS, GCP, Azure) |
| **Zero trust** | No long-lived credentials to leak or rotate |

## OIDC Token Claims

GitHub issues OIDC tokens containing claims that identify the workflow:

```json
{
  "iss": "https://token.actions.githubusercontent.com",
  "sub": "repo:owner/repo:ref:refs/heads/main",
  "aud": "https://aws.amazonaws.com/sts",
  "ref": "refs/heads/main",
  "sha": "abc123",
  "repository": "owner/repo",
  "repository_owner": "owner",
  "actor": "github-user",
  "environment": "production",
  "event_name": "push",
  "workflow_ref": "owner/repo/.github/workflows/deploy.yml@refs/heads/main"
}
```

Key claims for scoping:

- **sub** — Workflow identity (repo:owner/repo:ref:refs/heads/main)
- **ref** — Git reference (refs/heads/main, refs/tags/v1.0.0)
- **environment** — Deployment environment (production, staging)
- **repository** — Full repository path (owner/repo)
- **actor** — GitHub user who triggered workflow
- **workflow_ref** — Exact workflow file and branch

## AWS Setup

### Step 1: Create OIDC Provider

Create an OIDC identity provider in AWS IAM:

```bash
aws iam create-open-id-connect-provider \
  --url https://token.actions.githubusercontent.com \
  --client-id-list sts.amazonaws.com \
  --thumbprint-list 6938fd4d98bab03faadb97b34396831e3780aea1
```

Verify provider created:

```bash
aws iam list-open-id-connect-providers
```

### Step 2: Create IAM Role

Create an IAM role with OIDC trust relationship:

```bash
aws iam create-role \
  --role-name GitHubActionsRole \
  --assume-role-policy-document '{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Federated": "arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com"
        },
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Condition": {
          "StringEquals": {
            "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
          },
          "StringLike": {
            "token.actions.githubusercontent.com:sub": "repo:owner/repo:ref:refs/heads/main"
          }
        }
      }
    ]
  }'
```

### Step 3: Attach Policies

Attach permissions needed by your workflow:

```bash
aws iam attach-role-policy \
  --role-name GitHubActionsRole \
  --policy-arn arn:aws:iam::aws:policy/AmazonECS_FullAccess

aws iam attach-role-policy \
  --role-name GitHubActionsRole \
  --policy-arn arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser
```

### Step 4: Use in Workflow

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
    steps:
      - uses: actions/checkout@v4

      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: arn:aws:iam::123456789012:role/GitHubActionsRole
          aws-region: us-east-1

      - name: Deploy
        run: aws ecs update-service --cluster prod --service myapp --force-new-deployment
```

## GCP Setup

### Step 1: Create Workload Identity Pool

```bash
gcloud iam workload-identity-pools create "github-pool" \
  --project="PROJECT_ID" \
  --location="global" \
  --display-name="GitHub Actions"
```

### Step 2: Create Workload Identity Provider

```bash
gcloud iam workload-identity-pools providers create-oidc "github-provider" \
  --project="PROJECT_ID" \
  --location="global" \
  --workload-identity-pool="github-pool" \
  --display-name="GitHub" \
  --attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.repository=assertion.repository" \
  --issuer-uri="https://token.actions.githubusercontent.com"
```

### Step 3: Create Service Account

```bash
gcloud iam service-accounts create "github-actions" \
  --project="PROJECT_ID"
```

### Step 4: Grant Permissions

```bash
gcloud projects add-iam-policy-binding "PROJECT_ID" \
  --member="serviceAccount:github-actions@PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/container.developer"
```

### Step 5: Create Service Account Impersonation Grant

```bash
gcloud iam service-accounts add-iam-policy-binding \
  "github-actions@PROJECT_ID.iam.gserviceaccount.com" \
  --project="PROJECT_ID" \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/PROJECT_NUMBER/locations/global/workloadIdentityPools/github-pool/attribute.repository/owner/repo"
```

### Step 6: Use in Workflow

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
    steps:
      - uses: actions/checkout@v4

      - name: Authenticate to Google Cloud
        uses: google-github-actions/auth@v2
        with:
          workload_identity_provider: projects/PROJECT_NUMBER/locations/global/workloadIdentityPools/github-pool/providers/github-provider
          service_account: github-actions@PROJECT_ID.iam.gserviceaccount.com

      - name: Deploy
        run: gcloud run deploy myapp --image gcr.io/PROJECT_ID/myapp:$GITHUB_SHA
```

## Azure Setup

### Step 1: Create Service Principal

```bash
az ad sp create-for-rbac \
  --name "GitHub-Actions" \
  --role "Contributor" \
  --scopes /subscriptions/SUBSCRIPTION_ID
```

Record the output JSON with `clientId`, `clientSecret`, `subscriptionId`, `tenantId`.

### Step 2: Convert to OIDC

Create a federated credential for OIDC trust:

```bash
az ad app federated-credential create \
  --id <CLIENT_ID> \
  --parameters '{
    "name": "GitHubActions",
    "issuer": "https://token.actions.githubusercontent.com",
    "subject": "repo:owner/repo:ref:refs/heads/main",
    "audiences": ["api://AzureADTokenExchange"]
  }'
```

### Step 3: Use in Workflow

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
    steps:
      - uses: actions/checkout@v4

      - name: Azure Login
        uses: azure/login@v2
        with:
          client-id: ${{ secrets.AZURE_CLIENT_ID }}
          tenant-id: ${{ secrets.AZURE_TENANT_ID }}
          subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}

      - name: Deploy
        run: az container create --resource-group myapp --name myapp --image myacr.azurecr.io/myapp:latest
```

## Scoping by Branch

Restrict OIDC access to specific branches:

### AWS

```json
{
  "Condition": {
    "StringLike": {
      "token.actions.githubusercontent.com:sub": "repo:owner/repo:ref:refs/heads/main"
    }
  }
}
```

### GCP

```bash
gcloud iam service-accounts add-iam-policy-binding \
  "github-actions@PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/PROJECT_NUMBER/locations/global/workloadIdentityPools/github-pool/attribute.repository/owner/repo,ref/refs/heads/main"
```

## Scoping by Environment

Restrict OIDC access to specific deployment environments:

### AWS

```json
{
  "Condition": {
    "StringEquals": {
      "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
    },
    "StringLike": {
      "token.actions.githubusercontent.com:sub": "repo:owner/repo:environment:production"
    }
  }
}
```

### GCP

```bash
gcloud iam service-accounts add-iam-policy-binding \
  "github-actions@PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/PROJECT_NUMBER/locations/global/workloadIdentityPools/github-pool/attribute.environment/production"
```

## Troubleshooting OIDC

### Token Validation Fails

**Symptom:** `InvalidToken`, `Invalid token`, or `UnrecognizedTokenClaims`

**Solution:**

1. Verify OIDC provider URL matches exactly: `https://token.actions.githubusercontent.com`
2. Check trust relationship condition:
   - `aud` must match (e.g., `sts.amazonaws.com`)
   - `sub` must match repository (e.g., `repo:owner/repo:ref:refs/heads/main`)
3. Verify permissions include `id-token: write`

### Permission Denied After Auth

**Symptom:** Authenticated successfully but action fails with permission error

**Solution:**

1. Check IAM role/service account has required permissions
2. Verify scope condition matches current workflow:
   - Branch must match if scoped by branch
   - Environment must match if scoped by environment
3. Test with more permissive scope temporarily to isolate issue

### OIDC Provider Not Found

**Symptom:** `ProviderNotFoundException` or similar

**Solution:**

1. Verify OIDC provider created in cloud account (AWS IAM, GCP, Azure)
2. Check provider URL and thumbprint are correct
3. AWS only: Thumbprint must be `6938fd4d98bab03faadb97b34396831e3780aea1`

## Best Practices

- **Never use static credentials** — Use OIDC instead
- **Scope narrowly** — Restrict by branch, environment, and repository
- **Use dedicated roles** — Create separate roles per deployment target
- **Monitor token usage** — Enable audit logging in cloud provider
- **Rotate JWK keys** — GitHub rotates keys regularly; cloud providers auto-refresh
- **Test before production** — Test OIDC trust relationship in staging first
