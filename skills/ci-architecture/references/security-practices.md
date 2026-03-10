# CI/CD Security Practices

## DevSecOps Scanning Matrix

Shift security left by scanning at multiple stages. Each tool catches different issues:

### Scanning Across the Pipeline

| Scan Type | Tool Examples | When | Cost | False Positives |
| --- | --- | --- | --- | --- |
| **SAST** (Code) | SonarQube, CodeQL, Checkmarx, Semgrep | Every commit | Low | Medium–High |
| **SCA** (Dependencies) | Dependabot, Snyk, WhiteSource, Owasp Dependency-Check | Every commit | Low | Low |
| **Secrets** | GitGuardian, TruffleHog, git-secrets, detect-secrets | Every commit | Low | Low |
| **IaC** (Infrastructure) | Checkov, tfsec, Kics | Every commit (if IaC) | Low | Medium |
| **Container** (Image) | Trivy, Anchore, Clair, Aqua | After build | Low | Low |
| **DAST** (Dynamic) | OWASP ZAP, Burp Suite, Nikto | Post-staging deploy | High | Medium |
| **SBOM** (Bill of Materials) | CycloneDX, SPDX, syft | After build | Low | None |
| **Policy** (Compliance) | Kyverno, OPA, Falco | Runtime | Medium | Low |

### Recommended Minimum (MVP)

```text
Commit → SAST (SonarQube/CodeQL) ✓
       → SCA (Dependabot/Snyk) ✓
       → Secrets (GitGuardian/detect-secrets) ✓
       → Build
       → Container Scan (Trivy) ✓
       → Deploy to staging
       (DAST is optional; expensive)
```

This catches 80% of issues with low false-positive rate.

## Secrets Management

### Never Hardcode Secrets

**Bad**:

```yaml
env:
  DB_PASSWORD: "super-secret-123"
  API_KEY: "sk-1234567890"
```

**Good**:

```yaml
env:
  DB_PASSWORD: ${{ secrets.DB_PASSWORD }}
  API_KEY: ${{ secrets.API_KEY }}
```

### Secret Storage Patterns

#### 1. CI/CD Platform Secrets (Simple)

- **GitHub Secrets**: `https://docs.github.com/en/actions/security-for-github-actions/security-guides/using-secrets-in-github-actions`
- **GitLab CI Variables**: `https://docs.gitlab.com/ci/variables/`
- **Jenkins Credentials**: Jenkins UI → Manage Credentials
- **Travis CI Encrypted Variables**: `travis encrypt KEY=value`

**Pros**: Integrated, simple, no external dependency
**Cons**: Not centralized; per-repo; no rotation; no audit

#### 2. Dedicated Secrets Manager (Recommended)

- **HashiCorp Vault**: Centralized, audited, rotatable, policy-driven
- **AWS Secrets Manager**: AWS-native, integrated with IAM, rotation
- **Azure Key Vault**: Azure-native, integrated with RBAC
- **Google Secret Manager**: GCP-native, integrated with Workload Identity

**Pattern**:

```yaml
# CI/CD platform credentials authenticate to Vault
# Vault returns actual secrets (short-lived)
- name: Get secret from Vault
  run: |
    curl -H "X-Vault-Token: ${{ env.VAULT_TOKEN }}" \
      https://vault.example.com/v1/secret/data/prod/db \
      | jq '.data.data.password' > /tmp/db_pass
```

**Pros**: Centralized, auditable, rotatable, policy-controlled

**Cons**: Extra infrastructure, latency, complexity

#### 3. OIDC (Identity Federation; Preferred for Cloud)

Use **OpenID Connect (OIDC)** to eliminate static credentials. CI/CD platforms mint short-lived tokens; cloud providers accept them as identity proof.

**Pattern**:

```yaml
# GitHub Actions + AWS OIDC
jobs:
  deploy:
    permissions:
      id-token: write
      contents: read
    steps:
      - uses: aws-actions/configure-aws-credentials@v2
        with:
          role-to-assume: arn:aws:iam::ACCOUNT:role/GitHubActionsRole
          aws-region: us-east-1
          # No static credentials needed!
```

**Why OIDC?**:

- No static credentials to leak or rotate
- Token is valid only for this workflow run
- Automatic revocation (token expires after run)
- Cloud provider verifies issuer identity (GitHub, GitLab, etc.)

**Support**:

- ✅ AWS IAM (via AssumeRoleWithWebIdentity)
- ✅ Google Cloud (via Workload Identity Federation)
- ✅ Azure AD (via OIDC)
- ✅ Kubernetes (via ServiceAccount tokens)
- ✅ GitLab (via CI Job Token + OIDC)
- ✅ GitHub Actions (via OIDC Provider)

**Recommended approach**:

1. Enable OIDC in your cloud provider (one-time setup)
2. Create IAM roles with least-privilege permissions
3. Configure CI/CD platform to use OIDC
4. Eliminate all static credentials

## Least Privilege Access

### Service Account Permissions

Each CI/CD job should have **only** the permissions it needs:

#### Build Job

- ✅ Write artifacts to registry
- ✅ Upload test reports
- ❌ Deploy permissions
- ❌ Database access
- ❌ Secrets beyond build args

#### Security Scan Job

- ✅ Read repository code
- ✅ Write scan reports
- ✅ Push SBOM to artifact store
- ❌ Modify code
- ❌ Trigger deployments
- ❌ Access production

#### Staging Deploy Job

- ✅ Read artifact from registry
- ✅ Deploy to staging namespace/account
- ✅ Update Kubernetes manifests (staging only)
- ❌ Access production
- ❌ Modify main branch
- ❌ Delete artifacts

#### Production Deploy Job (Most Restricted)

- ✅ Read artifact from registry (specific image tags)
- ✅ Deploy to production namespace/account only
- ❌ Modify any other infrastructure
- ❌ Access secrets beyond deploy credentials
- ❌ Trigger other pipelines

### Implementing Least Privilege

**AWS IAM Policy (for staging deploy)**:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage"
      ],
      "Resource": "arn:aws:ecr:us-east-1:ACCOUNT:repository/myapp-staging"
    },
    {
      "Effect": "Allow",
      "Action": [
        "eks:UpdateClusterConfig"
      ],
      "Resource": "arn:aws:eks:us-east-1:ACCOUNT:cluster/staging-*"
    }
  ]
}
```

**Kubernetes RBAC (for staging deploy)**:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: staging
  name: ci-cd-staging-deployer
rules:
- apiGroups: ["apps"]
  resources: ["deployments"]
  verbs: ["get", "patch", "update"]
  resourceNames: ["myapp"]  # Only this app
- apiGroups: [""]
  resources: ["services"]
  verbs: ["get"]
```

## Signed & Verified Artifacts

### Container Image Signing (Cosign/Sigstore)

```bash
# Sign image after build
cosign sign -key cosign.key gcr.io/myproject/myapp:v1.0.0

# Verify image before deployment
cosign verify --key cosign.pub gcr.io/myproject/myapp:v1.0.0
```

**Benefits**: Proves artifact hasn't been tampered with; ensures provenance.

## SLSA Framework

**SLSA** (Supply-chain Levels for Software Artifacts) defines supply-chain security maturity:

| Level | Requirements | Achievable By |
| --- | --- | --- |
| **L0** | None (baseline) | Any project |
| **L1** | Version control + build logs | GitHub Actions, GitLab CI, Jenkins (basic) |
| **L2** | Signed provenance + test coverage | GitHub Actions + Sigstore, GitLab CI + signing |
| **L3** | Hardened builder + restricted access | Self-hosted builders, SLSA-compliant infra |
| **L4** | Hardened + auditable + hermetic | Google, Hermetic Build System (rare) |

### Achieving L1 (Minimum)

```yaml
# GitHub Actions + signed provenance
jobs:
  build:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
      attestations: write
    steps:
      - uses: actions/checkout@v3
      - run: npm ci && npm run build
      - uses: actions/attest-build-provenance@v1
        with:
          subject-path: 'dist/'
```

This generates a signed attestation proving: who built it, when, what was built, which code.

### Recommended Target

**L2 is practical for most teams**:

- Version control ✓
- Automated builds ✓
- Test coverage ✓
- Signed artifacts ✓
- Build provenance ✓
- No hardcoded secrets ✓

L3+ requires specialized infrastructure; L0–L1 leave vulnerabilities.

## Log Masking

Prevent secrets from appearing in logs:

**GitHub Actions**:

```yaml
- name: Deploy
  env:
    DB_PASSWORD: ${{ secrets.DB_PASSWORD }}
  run: |
    # This line: password is masked in logs
    psql -U admin -P password=***
```

**GitLab CI**:

```yaml
deploy:
  script:
    - echo "Token is hidden: $CI_JOB_TOKEN"  # Auto-masked
  artifacts:
    paths:
      - build.log
  allow_failure: false
```

**Best practice**: Never echo secrets; log only sanitized output.

## Dependency Scanning

### Software Composition Analysis (SCA)

Tools: Dependabot, Snyk, WhiteSource, Owasp Dependency-Check

**Pattern**:

```yaml
# Create PR for dependency updates (Dependabot)
# Scan for vulnerabilities (Snyk)
# Block PR merge if high-severity CVEs
```

**Gating strategy**:

- ✅ Auto-update minor/patch versions
- ✅ Create PR for major versions (requires review)
- ❌ Merge without SCA scan
- ❌ Ignore known vulnerabilities (track as tech debt)

## OWASP CI/CD Security Cheat Sheet Highlights

Key practices from [OWASP CI/CD Security](https://cheatsheetseries.owasp.org/cheatsheets/CI-CD_Pipeline_Security.html):

1. **Isolate build environments** — Separate runners per workload; no shared state
2. **Minimize runner surface area** — No unnecessary tools; immutable runner images
3. **Audit all pipeline changes** — Log every modification; require review
4. **Secure integrations** — Webhook secret verification; API rate limiting
5. **Build provenance** — Sign artifacts; include build context (repo, branch, commit)
6. **Token lifecycle** — Short-lived tokens; rotate regularly; revoke on compromise
7. **Encrypted communication** — TLS for all secrets in transit; signed artifacts
8. **Threat modeling** — Identify supply-chain attack vectors; design controls
