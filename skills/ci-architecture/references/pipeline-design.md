# CI/CD Pipeline Design

## Canonical Pipeline Stages

A well-designed pipeline follows this order to fail fast:

1. **Trigger** — Webhook, schedule, or manual trigger
2. **Source** — Code checkout and setup
3. **Lint & Format** — Code style, syntax validation (seconds; catches obvious errors early)
4. **SAST** — Code scanning for vulnerabilities
5. **Build** — Compile, package, create artifact (single artifact used for all environments)
6. **Unit Tests** — Fast, isolated unit-level tests
7. **Integration Tests** — Service-to-service tests with mocks/doubles
8. **SCA** — Dependency scanning, vulnerability advisories
9. **Container Scanning** — Image vulnerability scan (if Docker)
10. **Artifact Store** — Push image/binary to registry (immutable, signed)
11. **Deploy to Staging** — Use the stored artifact; never rebuild
12. **E2E Tests** — Full end-to-end tests against staging
13. **DAST** — Dynamic security scanning (optional; expensive)
14. **Approval Gate** — Manual approval only if policy requires
15. **Deploy to Production** — Automated deployment of artifact
16. **Monitor & Observe** — Health checks, logs, dashboards
17. **Auto-Rollback** — Automatic rollback if health thresholds breached

### Why This Order?

- **Fail fast**: Lint + SAST run first (minutes) before expensive builds (CPU, time)
- **Immutable artifact**: Build once; same image/binary tests and deploys everywhere
- **Security shift-left**: SAST, SCA, container scanning prevent issues before staging
- **Testability**: Staged deployment allows E2E validation before production
- **Recovery**: Auto-rollback based on observable health reduces MTTR

## Test Pyramid

Invest in tests that are fast and cheap; use few expensive E2E tests:

```text
       /\
      /  \  — E2E & UI Tests (~10% of tests)
     /____\   (slow, expensive, most flaky)

    /      \
   /  /__  \_\ — Integration Tests (~20% of tests)
  /__/    \_/   (moderate speed, database interaction)

 /__________\  — Unit Tests (~70% of tests)
  (fast, isolated, deterministic)
```

**Target ratio**: 70% unit, 20% integration, 10% E2E.

**Benefits**:

- Fast feedback (unit tests finish in seconds)
- Cheap to run (no external dependencies)
- High signal-to-noise (fewer flaky tests)
- Easy to debug (isolated failures)

Avoid the "ice cream cone" (mostly E2E, few units): slow feedback, high flake rate, expensive.

## Branching Strategies

### Trunk-Based Development (Recommended)

All developers commit to `main` (or `trunk`). Feature branches live <1 day before merge.

```text
main:   ─ A ─ B ─ C ─ D ─ E ─
         ↓   ↓   ↓
feat-X:  └─ X─┘ (short-lived, <1 day)
feat-Y:          └─ Y─┘
```

**Pros**:

- Continuous integration (no divergence)
- Easy rollback (revert commit to main)
- DORA-aligned deployment frequency
- No merge debt

**Cons**:

- Requires strong test coverage and automation
- Need strong gating (cannot merge failing code)

### GitHub Flow (GitHub-Centric Variant)

Feature branch → PR → Review → Merge to main.

```text
main:   ─ A ─ B ─ C ─ D ──────────
         ↓   ↓            ↓
feat-X:  └─ X ─ X ─ X ─┘ (days)
```

**Pros**:

- Familiar workflow (branch/PR/merge)
- Code review before merge
- Protected main branch

**Cons**:

- If PRs take >1 day, integration lag increases
- Requires discipline to prevent long-lived branches

### GitFlow (Not Recommended)

Multiple long-lived branches (main, develop, release, hotfix). Complex.

```text
main:    ─ ────────────── A ─────────
         ↓                ↑
develop: ─ B ─ C ─ D ─ E ─ R ─ F ─ G ─
```

**Avoid for**:

- High-deployment-frequency teams (CD)
- Small teams
- Microservices (multiple repos)

**Use only for**:

- Scheduled releases (once per quarter)
- Strict version control requirements
- Large teams with formal change windows

### GitLab Flow (Environment-Based)

Branches map to environments (production, staging, develop).

```text
develop:     ─ A ─ B ─ C
staging:     ─ ────────── B'
production:  ─ ─────────────── A'
```

**Pros**:

- Clear environment mapping
- Deployment controls per environment

**Cons**:

- Syncing branches is tedious
- Less common than trunk/GitHub Flow

## Artifact Management

### Immutability

- **Tag artifacts with commits**: Docker images tagged `v1.2.3-abc123def` (version + commit hash)
- **Never use `latest` in production**: `latest` is mutable and ambiguous
- **Signed artifacts**: Use Cosign, Sigstore, or GPG signatures; verify on download
- **SBOM (Software Bill of Materials)**: Generate and store with artifact for supply chain visibility

### Artifact Lifecycle

```text
Build Job
   ↓
Create artifact (binary, image, wheel, gem)
   ↓
Push to registry (immutable tag: v1.2.3-abc123)
   ↓
Scan container / dependencies
   ↓
Deploy Job retrieves artifact by tag
   ↓
Promote through environments (same artifact everywhere)
   ↓
Sign artifact after successful prod deployment (optional; for future)
```

### Registry Choice

- **Docker/Container**: Docker Hub, ECR (AWS), GCR (Google), Artifactory, Quay
- **Language-Specific**: npm (Node), PyPI (Python), Maven Central (Java), RubyGems (Ruby), NuGet (.NET)
- **Artifact Store**: Artifactory, Nexus, Archiva, or cloud-native (S3, GCS, Blob Storage)

**Best practice**: Use immutable tags; scan before promote; sign high-value artifacts.

## Caching Strategies

Caching reduces pipeline duration by reusing expensive builds:

### Dependency Caching

Cache package manager directories:

- **npm**: `node_modules/` or `~/.npm/`
- **pip**: `~/.cache/pip/`
- **Maven**: `~/.m2/repository/`
- **RubyGems**: `~/.gems/` or `vendor/`

**Cache keys**: Include lockfile hash (`package-lock.json`, `requirements.txt`, `Gemfile.lock`).

```yaml
# Example (GitHub Actions)
- uses: actions/cache@v3
  with:
    path: ~/.npm
    key: npm-${{ hashFiles('package-lock.json') }}
```

### Docker Layer Caching

Reuse Docker build layers to speed image builds:

```dockerfile
# Good: stable base first, changing code last
FROM node:18-alpine
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build
```

Build reuses layers 1–3 if package.json unchanged; only rebuilds code.

### Build Cache (Gradle, Maven, Turborepo)

Reuse compiled classes, compiled modules:

- **Gradle**: `~/.gradle/`
- **Maven**: `target/` per module (with incremental compilation)
- **Turborepo**: `.turbo/`
- **TypeScript**: `dist/`, `build/` with incremental flag

**Cache strategy**: Invalidate when lock files change; preserve for same code.

### Database Schema Cache

For integration tests, cache initialized database:

- Snapshot database after schema creation
- Restore snapshot on test start (faster than migration replay)
- Migrate if schema changed

**Trade-off**: Saves setup time for multi-test runs; harder to test migrations.

## Pipeline Duration & Performance

### Target Duration

- **Development feedback cycle**: <5 minutes (lint + unit + build)
- **Full staging validation**: <15 minutes (+ integration + E2E + staging deploy)
- **Production deployment**: <30 seconds (artifact already validated)

### Optimization Tactics

1. **Parallelize stages** — Run unit tests, lint, SAST in parallel (independent jobs)
2. **Cache dependencies** — Never download npm/pip packages twice
3. **Split tests** — Shard unit tests across 4–8 workers; shard E2E across runners
4. **Skip redundant checks** — Don't re-lint if only docs changed
5. **Background jobs** — Move non-critical work (analytics, reporting) to async jobs
6. **Fail fast** — Stop pipeline on first error; don't wait for all jobs

### Monitoring Pipeline Health

Track these metrics:

- **P50, P95 pipeline duration** — Is it trending slower?
- **Test flake rate** — Are >2% of tests flaky? Quarantine them
- **Build success rate** — Baseline should be >95% (else bad tests)
- **Queue wait time** — Are runners overloaded? Add capacity
- **Deployment frequency** — Track deploys per day; should increase over time

## Quality Gates

### What to Gate On

✅ **Gate on failure**:

- Lint/format errors
- SAST/SCA findings (high severity)
- Test failures (unit + integration)
- Container scanning (high-severity CVEs)

⚠️ **Gate with review**:

- Security findings (medium severity)
- Performance regressions (>10% latency increase)
- Test coverage drops (>5% decrease)

❌ **Don't gate on** (advisory only):

- Code coverage thresholds (not strongly correlated with quality)
- Minor lint warnings
- Documentation completeness (aspirational, not blocking)

### Gating Strategy

```text
Commit → Lint → SAST/SCA → Build → Unit Tests
              ↓ (fail: stop)        ↓ (fail: stop)
          (pass: continue)      Merge to main? (blocked)
```

On PR/feature branch: strict gates (fail = don't merge).
On main: gates are advisory; use trunk-based development discipline instead.

## Conditional Builds

Run expensive jobs only when relevant:

```yaml
# Example: Only run Docker build if Dockerfile or app code changed
if: contains(github.event.pull_request.files[*].name, 'Dockerfile')
   || contains(github.event.pull_request.files[*].name, 'app/*')
then:
  run: docker build .
```

**Use cases**:

- Skip E2E tests if only docs changed
- Skip Docker build if only backend changed (no frontend impact)
- Skip deployment staging if only unit tests changed (revert; no code change)

## Environment Parity

Staging should mirror production:

- Same infrastructure (Kubernetes version, container runtime, network policies)
- Same database schema (but with test data)
- Same secrets/credentials (but for staging accounts)
- Same deployment process (Infrastructure as Code)

This catches environment-specific bugs before production.
