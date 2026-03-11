# Vault Auth Methods

## Token Auth

Token auth is the built-in default. All other auth methods ultimately issue a token.

```bash
# Use root token (initial setup only)
export VAULT_TOKEN='<root-token>'

# Create a scoped child token
vault token create -policy=app-read -ttl=1h

# Create an orphan token (no parent — useful for long-running processes)
vault token create -orphan -policy=app-read -ttl=24h

# Look up token details
vault token lookup
vault token lookup <specific-token>
```

## AppRole Auth (CI/CD)

AppRole is the recommended auth method for automated pipelines. A `role_id` (non-sensitive, like a username) and `secret_id` (sensitive, single-use) are combined to obtain a token.

```bash
# Enable AppRole (one-time setup)
vault auth enable approle

# Create a role with a policy and TTL
vault write auth/approle/role/ci-pipeline \
  token_policies="ci-read" \
  token_ttl=1h \
  token_max_ttl=4h \
  secret_id_ttl=10m \
  secret_id_num_uses=1

# Fetch the role_id (not sensitive — can be stored in CI config)
vault read auth/approle/role/ci-pipeline/role-id

# Generate a secret_id (sensitive — use immediately, discard after use)
vault write -f auth/approle/role/ci-pipeline/secret-id

# Login with role_id + secret_id to get a token
vault write auth/approle/login \
  role_id="<role-id>" \
  secret_id="<secret-id>"

# Use the returned token
export VAULT_TOKEN="<returned-client-token>"
vault kv get secret/ci/db-password
```

## AWS IAM Auth

Vault can authenticate AWS workloads (EC2 instances, Lambda functions, ECS tasks) using IAM identity.

```bash
# Enable AWS auth method
vault auth enable aws

# Configure with AWS credentials (or use instance profile)
vault write auth/aws/config/client \
  access_key="<AWS_ACCESS_KEY_ID>" \
  secret_key="<AWS_SECRET_ACCESS_KEY>" \
  region="us-east-1"

# Create a role bound to an IAM role ARN
vault write auth/aws/role/ec2-app \
  auth_type=iam \
  bound_iam_principal_arn="arn:aws:iam::123456789012:role/my-ec2-role" \
  policies="app-read" \
  ttl=1h

# Login from an EC2 instance or Lambda (uses AWS SDK signing)
vault login -method=aws role=ec2-app
```

## Kubernetes Auth

Kubernetes pods can authenticate using their ServiceAccount JWT token.

```bash
# Enable Kubernetes auth method
vault auth enable kubernetes

# Configure with the cluster's API server and CA
vault write auth/kubernetes/config \
  kubernetes_host="https://kubernetes.default.svc" \
  kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt

# Create a role bound to a Kubernetes service account
vault write auth/kubernetes/role/webapp \
  bound_service_account_names=webapp-sa \
  bound_service_account_namespaces=production \
  policies=webapp-read \
  ttl=1h

# Login from inside a pod
vault write auth/kubernetes/login \
  role=webapp \
  jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)"
```

## Environment-Based vs File-Based Token

```bash
# Environment variable (takes precedence)
export VAULT_TOKEN="<token>"

# File-based (used when VAULT_TOKEN is not set)
# vault login writes the token to ~/.vault-token automatically
vault login
cat ~/.vault-token

# Clear the file-based token
rm ~/.vault-token
```

## Pipeline Patterns

For CI/CD, prefer short-lived tokens obtained at job start:

1. Store `role_id` as a non-secret CI variable.
2. Store `secret_id` (or generate it at runtime) as an encrypted CI secret.
3. At job start: call `vault write auth/approle/login` and export `VAULT_TOKEN`.
4. Fetch secrets during the job.
5. Token expires automatically at end of TTL — no explicit revocation needed.

For advanced patterns, see: <https://developer.hashicorp.com/vault/tutorials>
