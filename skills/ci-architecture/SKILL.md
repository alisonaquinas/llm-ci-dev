---
name: ci-architecture
description: >
  Design and review CI/CD pipelines using proven best practices.
  Encodes architecture patterns grounded in DORA research, DevSecOps, SLSA, and platform engineering.
---

# CI/CD Architecture

Advise on pipeline design, branching strategies, security practices, deployment patterns, and measurement using well-established CI/CD principles.
This skill encodes architecture patterns sourced from DORA research, Martin Fowler, Thoughtworks Tech Radar, OWASP, SLSA framework, and GitLab/GitHub/Jenkins/Travis CI official documentation.

---

## Intent Router

Load reference files for depth on specific topics:

| Topic | File | Load when... |
| --- | --- | --- |
| Pipeline Design | `references/pipeline-design.md` | Designing pipeline stages, test pyramids, branching strategies, artifact promotion |
| Security Practices | `references/security-practices.md` | DevSecOps scanning, secrets management, least privilege, SLSA framework |
| Deployment Patterns | `references/deployment-patterns.md` | Blue-green, canary, rolling deployments; GitOps; IaC; feature flags |
| Measurement | `references/measurement.md` | DORA metrics, pipeline observability, deployment monitoring, MTTR |

---

## Core Principles

These 10 principles represent consensus among DORA, Google SRE, and Thoughtworks on what makes pipelines effective:

### 1. Fail Fast

The fastest checks run first. Order stages by speed and cost:

- Lint (seconds)
- Static analysis / SAST (minutes)
- Unit tests (minutes)
- Integration tests (minutes)
- E2E tests (tens of minutes)
- Security scanning (minutes to hours)
- Performance tests (if needed)

Failure at any stage stops progression to prevent wasted compute.

### 2. Build Once, Promote Artifacts

Create the artifact (binary, Docker image, wheel, gem) once. Promote the same immutable artifact through environments rather than rebuilding per environment.

This ensures: production code is bit-for-bit identical to tested code; no per-environment compilation surprises; faster promotions; clear artifact lineage for compliance.

### 3. Pipeline as Code

All pipeline configuration lives in version control (Jenkinsfile, .github/workflows, .gitlab-ci.yml, .travis.yml) alongside the code it builds.

Benefits: Code review of pipeline changes; audit trail; easy rollback; collaboration; environment parity.

### 4. Trunk-Based Development (or Short-Lived Branches)

True CI requires continuous integration to main/trunk. Use either:

- **Trunk-based**: feature branches <1 day before merge to main
- **GitHub Flow**: short-lived feature branches with mandatory PR review before merge

Long-lived feature branches hide integration problems until late. CI health metrics assume merges to main ≥1 per day.

### 5. Automate Everything; Manual Gates Only for Production

Automate build, test, SAST, SCA, deployment to staging. Manual approval gates belong only at production promotion, and only when required by policy.

Humans approve the decision to promote; the promotion itself is automated.

### 6. Never Hardcode Secrets; Prefer OIDC

Use a secrets manager (Vault, AWS Secrets Manager, GitHub Secrets, GitLab Secrets, Jenkins Credentials) for sensitive data. For cloud deployments, prefer **OpenID Connect (OIDC)** instead of static credentials (access keys, tokens).

OIDC eliminates static credential rotation, leakage, and revocation complexity.

### 7. Least Privilege for Runners & Service Accounts

CI/CD service accounts should have only the permissions their jobs require:

- Build job: artifact store + test report uploader
- Deploy job: deploy-specific permissions (CloudFormation, Kubernetes, etc.)
- Security scan job: read-only repo + SBOM upload (no write)

Containment limits blast radius of compromised runners or exfiltrated credentials.

### 8. Shift Security Left

Run SAST (code scanning), SCA (dependency scanning), container scanning, and secrets detection on every PR. Catch issues early when fixes are cheap.

Automated gates enforce minimum security posture. Manual review for exceptions.

### 9. Measure with DORA Metrics

Track:

- **Deployment Frequency** (how often deployments happen)
- **Lead Time for Changes** (time from commit to prod)
- **Change Failure Rate** (% of deployments causing incidents)
- **Failed Deployment Recovery Time** (MTTR to fix)

These four metrics correlate with business outcomes (stability, throughput, revenue). Target: daily deployments, <1 hour lead time, <15% failure rate, <1 hour MTTR.

### 10. Automate Rollback Based on Observability

Define health thresholds (error rate >5%, latency p95 >2s, disk usage >90%). After deploy, monitor for 5–15 minutes. If thresholds breached, automatically roll back.

Reduces MTTR and human decision-making under pressure.

---

## Quick Start: Pipeline Stages

A canonical pipeline has these stages:

```bash
# Minimal GitHub Actions job illustrating the fail-fast stage order
# .github/workflows/ci.yml excerpt
# jobs:
#   ci:
#     steps:
#       - uses: actions/checkout@v4
#       - run: npm run lint
#       - run: npm test
#       - run: npm run build
echo "Lint -> Test -> Build order enforced"
```

```text
Trigger (push, PR, schedule)
  ↓
Source (checkout code)
  ↓
Lint & Format Check (fail fast)
  ↓
SAST (code scanning)
  ↓
Build (compile, package artifact)
  ↓
Unit Tests
  ↓
Integration Tests
  ↓
SCA (dependency scanning)
  ↓
Container Scanning (if Docker)
  ↓
Artifact Store (push image/binary to registry)
  ↓
Deploy to Staging (via artifact)
  ↓
E2E Tests (against staging)
  ↓
DAST (dynamic security scan, optional)
  ↓
Approval Gate (manual, if required)
  ↓
Deploy to Production (via artifact)
  ↓
Monitor & Observe (health checks, logs, metrics)
  ↓
Auto-Rollback (if health threshold breached)
```

---

## When to Use Platform-Specific Details

This skill defines universal CI/CD principles. When platform-specific syntax is needed:

- Use `gitlab-docs` for GitLab CI/CD `.gitlab-ci.yml` syntax and keywords
- Use `github-docs` for GitHub Actions workflow syntax and contexts
- Use `jenkins-docs` for Jenkins Declarative Pipeline syntax and steps
- Use `travis-ci` for Travis CI .travis.yml configuration

---

## Related References

- Load **Pipeline Design** to explore stage patterns, test pyramids, branching strategies, and artifact management
- Load **Security Practices** for DevSecOps scanning matrix, secrets management, and SLSA framework
- Load **Deployment Patterns** for blue-green, canary, rolling, GitOps, and IaC best practices
- Load **Measurement** for DORA metrics, observability, and MTTR reduction strategies
