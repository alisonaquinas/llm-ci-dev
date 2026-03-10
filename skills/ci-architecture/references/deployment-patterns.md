# Deployment Patterns

## Deployment Strategies

### Blue-Green Deployment

Two identical production environments (Blue = current, Green = new). Switch traffic atomically.

```text
Traffic Routing:
  LB → Blue (v1.0, currently live)
  Green (v1.1, idle, being tested)

Cutover:
  LB → Green (v1.1, now live)
  Blue (v1.0, previous, ready for rollback)
```

**Pros**:

- Atomic switch (zero downtime)
- Instant full rollback (switch LB back to Blue)
- Easy A/B testing
- Full staging validation before cutover

**Cons**:

- 2× infrastructure cost (need both versions running)
- Database migrations are tricky (both versions must understand schema)
- Requires stateless app or session replication

**When to use**:

- Critical services where downtime is unacceptable
- Large batch deployments
- Team has 2× budget for infrastructure

**Implementation**:

```bash
# Deploy to green
kubectl apply -f app-v1.1.yaml --namespace green
sleep 30  # Let it stabilize
health_check()  # Verify green is healthy
if [[ $? -eq 0 ]]; then
  # Switch load balancer
  kubectl patch svc myapp -p '{"spec":{"selector":{"version":"v1.1"}}}'
else
  # Rollback: kill green, stay on blue
  kubectl delete -f app-v1.1.yaml --namespace green
fi
```

### Canary Deployment

Send small % of traffic (1–5%) to new version. Monitor; gradually increase if healthy.

```text
Traffic routing (over 30 minutes):
  Minute 0:   5% → v1.1,  95% → v1.0
  Minute 10:  25% → v1.1, 75% → v1.0
  Minute 20:  50% → v1.1, 50% → v1.0
  Minute 30: 100% → v1.1,  0% → v1.0

If error rate in v1.1 > 5%: rollback immediately (revert to 100% v1.0)
```

**Pros**:

- Real user validation before full rollout
- Quick rollback if issues detected (affected only 5% of users)
- Cost-efficient (only need small new infra initially)
- Automatic observability (compare metrics v1.0 vs v1.1)

**Cons**:

- Slower rollout (30+ minutes)
- Complexity managing two versions concurrently
- Database schema changes harder (both versions must coexist)

**When to use**:

- High-traffic services (1000+ req/s) where 5% is sufficient test
- Mission-critical apps (e.g., payment platforms)
- When you have good metrics infrastructure

**Tools**:

- **Istio**: Advanced traffic splitting, automatic rollback
- **Argo Rollouts**: Kubernetes-native, analysis templates, metrics-driven rollback
- **Flagger**: Progressive delivery with multiple strategies
- **AWS AppConfig**: Managed canary with CloudWatch
- **Google Cloud Deploy**: Integrated canary with Cloud Trace

**Implementation** (Argo Rollouts):

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Rollout
metadata:
  name: myapp
spec:
  strategy:
    canary:
      steps:
      - setWeight: 5
      - pause: {duration: 10m}
      - setWeight: 25
      - pause: {duration: 5m}
      - setWeight: 50
      - pause: {duration: 5m}
      analysis:
        templates:
        - name: error-rate
          interval: 60s
          thresholdCount: 2
          metrics:
          - name: error-rate
            query: error_rate_v1_1
            thresholdValue: "5"
            successCriteria: "< 5%"
```

### Rolling Deployment

Incrementally replace old instances with new. Each instance down briefly.

```text
Initial: [v1.0] [v1.0] [v1.0] [v1.0]

Step 1:  [v1.1] [v1.0] [v1.0] [v1.0]  (1 rolling)
Step 2:  [v1.1] [v1.1] [v1.0] [v1.0]
Step 3:  [v1.1] [v1.1] [v1.1] [v1.0]
Step 4:  [v1.1] [v1.1] [v1.1] [v1.1]  (complete)
```

**Pros**:

- Lower infrastructure cost (gradual rollout)
- Standard Kubernetes rollout
- Database schema changes easier (can add new columns; old version ignores)

**Cons**:

- Brief downtime for each instance
- Harder to rollback mid-way (old replicas gone)
- Both versions running simultaneously (compatibility needed)

**When to use**:

- Non-critical services
- Apps with stateless design
- Teams with lower budget

**Configuration** (Kubernetes):

```yaml
spec:
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1        # 1 new pod at a time
      maxUnavailable: 1  # 1 pod down at a time
  template:
    spec:
      containers:
      - image: myapp:v1.1
```

## Feature Flags

Decouple deployment from feature release. Deploy v1.1 but keep feature hidden behind flag.

```yaml
# In app code
if (featureFlags.get("new_checkout_flow")) {
  # Use v1.1 code
  renderNewCheckout()
} else {
  # Use v1.0 code
  renderOldCheckout()
}
```

**Platforms**:

- **LaunchDarkly**: Managed, detailed targeting, analytics
- **Unleash**: Open-source, self-hosted, fast
- **OpenFeature**: Vendor-neutral standard, multiple backends
- **AWS AppConfig**: AWS-native, cheap
- **Split.io**: Experimentation-focused

**Pattern**:

1. Deploy v1.1 with feature hidden
2. Run canary: enable flag for 5% of users
3. Monitor metrics (error rate, latency, business metrics)
4. If good, enable for 100%; rollback (disable flag) if bad

**Pros**:

- Instant rollback (flip flag; no redeployment)
- A/B testing built-in (enable for 50% of users)
- Decouples deployment pace from feature pace

**Cons**:

- Code complexity (feature flag boilerplate)
- Flag sprawl (old flags never cleaned up)
- Storage cost (flag evaluation at every request)

## GitOps

Store infrastructure and app config in Git. Continuous sync: Git → Cluster.

```text
Git Repo (source of truth):
  └─ apps/
    └─ myapp/
      └─ deployment.yaml (v1.1 image)

GitOps Operator (e.g., ArgoCD):
  └─ Watches Git for changes
  └─ Applies to Kubernetes
  └─ Reports status back to Git
```

**Tools**:

- **ArgoCD**: Kubernetes-native, Git-centric, declarative
- **Flux**: CNCF-incubating, Helm-compatible, flexible
- **Kluctl**: Advanced templating, multi-env

**Pattern**:

```yaml
# Instead of kubectl apply or helm upgrade,
# commit to Git and GitOps applies it

# Deployment file in Git
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  template:
    spec:
      containers:
      - image: gcr.io/myapp:v1.1  # Change version here
        # GitOps operator detects, applies to cluster
```

**Pros**:

- Single source of truth (Git)
- Full audit trail (Git commit history)
- Easy rollback (revert commit)
- Drift detection (cluster state != Git state? Alert)

**Cons**:

- Extra tool (ArgoCD, Flux)
- Learning curve (Helm, Kustomize, Jsonnet)
- Pull-based (slower than push-based CI/CD)

## Infrastructure as Code (IaC)

Manage infrastructure (VMs, databases, networks) as code. Terraform, CloudFormation, Pulumi.

**Pattern**:

```bash
# CI/CD pipeline
1. Commit .tf file (infrastructure change)
2. CI: terraform plan → review in PR
3. Approve PR
4. CD: terraform apply → infrastructure deployed
```

**Scanning**:

- **Checkov**: Scan .tf for misconfigurations (open port 22, unencrypted DB, etc.)
- **tfsec**: Terraform-specific security scanning
- **Kics**: Multi-cloud scanning

**Best practices**:

- ✅ All infrastructure in Git (no manual CLI changes)
- ✅ `terraform plan` in PR for review
- ✅ No local `terraform apply` to prod (only CD applies)
- ✅ Remote state with locking (Terraform Cloud, S3 + DynamoDB)
- ✅ Secrets in Vault or cloud secrets manager (never in .tf)
- ✅ Scan .tf with Checkov before apply

**Example**:

```hcl
# main.tf
resource "aws_instance" "myapp" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "myapp-prod"
  }
}
```

```bash
# CI Pipeline
terraform plan -out=tfplan
# Show in PR: 1 resource to create
# Human reviews, approves

# CD Pipeline (on approval)
terraform apply tfplan
```

## Secrets in Git (Sealed Secrets / SOPS)

Never commit plaintext secrets. Encrypt secrets in Git using Sealed Secrets or SOPS.

### Sealed Secrets (Kubernetes)

```bash
# Generate sealed secret (encrypted)
echo -n "my-secret-value" | \
  kubectl create secret generic mysecret --dry-run=client --from-file=- -o yaml | \
  kubeseal > sealed-secret.yaml

# Commit sealed-secret.yaml to Git (safe; encrypted)
git add sealed-secret.yaml

# CD pipeline unseals (only k8s cluster with key can unseal)
kubectl apply -f sealed-secret.yaml
# Seals controller auto-unseals → actual secret in cluster
```

### SOPS (Secrets Operations)

```bash
# Encrypt .yaml
sops -e secrets.yaml > secrets.enc.yaml
git add secrets.enc.yaml

# Decrypt locally (requires GPG key or AWS KMS)
sops -d secrets.enc.yaml

# In CI/CD, KMS key auto-decrypts
sops -d secrets.enc.yaml | kubectl apply -f -
```

**Pros**:

- Secrets in Git (for version history/audit)
- Encrypted at rest
- Only authorized users/services can decrypt

**Cons**:

- Extra tooling
- Key management complexity

## Rollback Patterns

### Automatic Rollback (Recommended)

Monitor health metrics; auto-rollback if thresholds breached:

```yaml
# Argo Rollouts analysis
analysis:
  templates:
  - name: error-rate
    metrics:
    - name: error_rate
      provider:
        prometheus:
          address: http://prometheus:9090
          query: |
            rate(errors_total{job="myapp"}[5m])
      thresholdValue: "0.05"  # 5% error rate
      successCriteria: "< 5%"
  successCriteria: "error_rate"
  # If error_rate > 5%, automatically rollback
```

### Manual Rollback (Simple)

```bash
# Blue-green: flip switch
kubectl patch svc myapp -p '{"spec":{"selector":{"version":"v1.0"}}}'

# Rolling: restart previous deployment
kubectl rollout undo deployment/myapp

# Git-based (Flux/ArgoCD): revert commit
git revert HEAD
git push
# Flux detects revert, applies old config
```

### Rollback Strategy

**Always ensure**:

1. Automated health monitoring active (before rollback decision)
2. Clear rollback criteria (error rate >X%, latency >Y)
3. Fast rollback (<5 minutes to revert)
4. Communication (alert team when rollback happens)
5. Post-incident analysis (why did it fail?)

**Targets**:

- **MTTR goal**: <15 minutes (5 min to detect + 10 min to rollback + stabilize)
- **Error rate threshold**: >5% anomaly (not just minor variance)
- **Latency threshold**: >2× baseline p95

## Environment Parity

Ensure staging and production are identical:

- **Operating System**: Same version/distribution
- **Container Runtime**: Same Docker/CRI version
- **Kubernetes**: Same API version, same plugins
- **Infrastructure**: Same instance types, same networking, same storage
- **Database**: Same schema version (test migrations in staging first)
- **Secrets**: Same structure (but staging values)
- **Deployment Process**: Exact same scripts/tools (IaC)

**When parity fails**:

- Code works in staging but fails in prod (environment-specific bug)
- Testing is unreliable (can't catch prod issues)
- Deployments become risky (unknown unknowns)

**Enforcement**:

- Use Infrastructure as Code (Terraform) for both staging and prod
- Same deployment pipeline for both
- Regular parity audits (compare staging vs prod configs)
