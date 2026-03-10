# CI/CD Measurement & Observability

## DORA Metrics (DevOps Research & Assessment)

The **DORA metrics** are the gold standard for measuring software delivery performance. They correlate strongly with business outcomes (profitability, market share, stability).

### The Four Key Metrics

#### 1. Deployment Frequency

**How often does the organization deploy code to production?**

- **Elite**: Multiple deployments per day (10+/day)
- **High**: Between once per week and once per day
- **Medium**: Between once per month and once per week
- **Low**: Fewer than once per month

**Measurement**:

```text
Count: number of successful deployments to production per time period
Time period: week, month, or quarter

Example: 5 deployments last week = Deployment Frequency: 5/week
```

**Why it matters**: Higher frequency = more feedback, smaller changes, lower risk.

#### 2. Lead Time for Changes

**How long does it take from code commit to code running in production?**

- **Elite**: Less than 1 hour
- **High**: Between 1 hour and 1 day
- **Medium**: Between 1 day and 1 month
- **Low**: More than 1 month

**Measurement**:

```text
From: Code commit timestamp
To: Deployment to production timestamp
Aggregate: Average or P50/P95

Example: Average time from commit → prod = 45 minutes = Lead Time: 45min
```

**Why it matters**: Shorter lead time = faster feedback, faster bug fixes, competitive advantage.

#### 3. Change Failure Rate

**What percentage of deployments cause a failure in production?**

- **Elite**: 0–15% (or near-zero with quick recovery)
- **High**: 16–30%
- **Medium**: 31–45%
- **Low**: >46%

**Measurement**:

```text
Failures: Count of deployments causing a production incident
Total deployments: All deployments in period

CFR = (Failed deployments / Total deployments) × 100

Example: 1 failed deploy out of 10 = CFR: 10%
```

**Note**: A "failure" may be quickly fixed via rollback. What matters is detection + recovery speed.

**Why it matters**: Low CFR = high quality, confidence in deployments, predictable incidents.

#### 4. Mean Time to Recovery (MTTR)

**How long does it take to recover from a production incident?**

Also called: "Time to Restore Service"

- **Elite**: Less than 1 hour
- **High**: Between 1 hour and 1 day
- **Medium**: Between 1 day and 1 week
- **Low**: More than 1 week

**Measurement**:

```text
From: Incident detection (alert fired, user reported, error rate spike)
To: Service restored to normal (traffic restored, error rate normal, users unaffected)
Aggregate: Average or P50

Example: Average incident recovery = 30 minutes = MTTR: 30min
```

**Why it matters**: Even with failures, quick recovery minimizes user impact. Speed saves revenue.

### Elite Performance Targets (Composite)

An "elite" team on DORA metrics achieves:

| Metric | Target |
| --- | --- |
| **Deployment Frequency** | ≥1/day (ideally 10+/day) |
| **Lead Time** | <1 hour |
| **Change Failure Rate** | <15% |
| **MTTR** | <1 hour |

This correlates with:

- 200× more frequent deployments than low performers
- 2400× faster lead times
- 5× lower change failure rate
- 360× faster recovery

### 2024 DORA Report Findings

Key findings from the 2024 DORA report (State of DevOps):

1. **AI/ML adoption** is accelerating elite performer gains (code generation, anomaly detection)
2. **Platform engineering** is becoming critical; self-service deployment speeds up lead time
3. **Observability** (logs, traces, metrics) is the #1 bottleneck for slow teams
4. **Toil reduction** (automation) correlates with elite performance
5. **Psychological safety** (low blame culture) enables faster, riskier deployments

**Actionable**: If your team lacks observability, that's the #1 blocker to elite metrics.

## Pipeline Observability

### Build Metrics

Track these to identify pipeline bottlenecks:

```yaml
# Prometheus metrics (example)
build_duration_seconds{job="myapp", stage="lint"}
build_duration_seconds{job="myapp", stage="unit_tests"}
build_duration_seconds{job="myapp", stage="build"}
build_duration_seconds{job="myapp", stage="e2e"}

build_success_rate{job="myapp"}  # % of builds succeeding
test_flake_rate{job="myapp"}     # % of flaky tests
build_queue_wait_seconds         # Time waiting for runner availability
```

### Analysis

```text
Goal: P95 build time < 15 minutes

Baseline:
  lint: 1 min
  unit tests: 4 min (parallelized across 4 workers)
  build: 3 min
  E2E: 8 min
  Total: 16 min (P95)

Bottleneck: E2E tests (50% of duration)
Action: Parallelize E2E across 2 workers → 4 min each
Result: Total drops to 13 min

Track: build_duration_seconds{stage="e2e"} = 4 min (down from 8)
```

### Test Quality Metrics

```yaml
# Flake rate (% of tests that fail intermittently)
test_flake_rate{test_id="auth_integration_test"}  # 3% flake = quarantine

# Coverage (but don't gate on coverage %)
code_coverage_percent{project="myapp"}  # 75%

# Test duration distribution
test_duration_p50{test_id="..."}
test_duration_p95{test_id="..."}  # Slow tests are red flags
```

## Deployment Observability

### Deployment Metrics

```yaml
# Deployment frequency and lead time
deployments_total{service="myapp"}
deployment_lead_time_seconds{service="myapp"}

# Change failure rate
deployment_failures_total{service="myapp"}
deployment_success_rate{service="myapp"}

# MTTR
incident_detection_latency_seconds
incident_recovery_time_seconds
```

### Correlating Deploys with Incidents

Annotate dashboards with deployment events to see cause ↔ effect:

```yaml
# Grafana annotation (pseudo-code)
Timestamp: 2024-03-10 14:30:00
Deployment: myapp v1.2.3 → prod
Error rate before: 0.5%
Error rate after (5 min): 5.1%  ← Spike!
Decision: Auto-rollback triggered
Recovery time: 8 min
```

### Health Check Thresholds (for auto-rollback)

```yaml
# Define health thresholds
error_rate_threshold: 5%  (baseline 0.5%)
latency_p95_threshold: 2000ms  (baseline 500ms)
cpu_utilization_threshold: 90%  (baseline 60%)
memory_utilization_threshold: 85%  (baseline 70%)

# If any threshold breached for >5 min, auto-rollback
Monitoring interval: 1 min
Unhealthy count: 5 consecutive
Rollback trigger: (5 consecutive unhealthy checks)
```

## Incident & Recovery Tracking

### Incident Response Process

```text
1. Detection (0 min)
   - Alert fires (error rate > threshold)
   - User reports issue
   - Observability tool flags anomaly

2. Acknowledgment (1–5 min)
   - On-call engineer gets paged
   - Joins incident bridge
   - Gathers context (dashboards, logs, recent deploys)

3. Mitigation (5–30 min)
   - Rollback (if deployment caused issue)
   - Scale up (if traffic surge)
   - Kill bad queries (if database issue)

4. Recovery (30–60 min)
   - Service fully restored
   - Error rate normal
   - Users unaffected

5. Post-Incident (day after)
   - RCA (root cause analysis)
   - Identify gaps (missed monitoring, lack of gating)
   - Create action items (add test, improve observability, etc.)

MTTR = Detection + Acknowledgment + Mitigation + Recovery
     = 5 + 5 + 20 + 10 = 40 minutes (good)
```

### Notification Routing by Severity

```yaml
# Route alerts based on severity
Low (warning):
  - Slack #engineering channel
  - Slack DM to on-call (not paged)

Medium (error):
  - Slack #incident channel
  - Email to on-call
  - PagerDuty non-urgent

High (critical):
  - PagerDuty page (wake on-call)
  - Slack critical-incidents channel
  - VictorOps/OpsGenie escalation

Critical (data loss, security breach):
  - All-hands page
  - Executive notification
  - War room initiation
```

## Quality Dashboards

### High-Level Dashboard (Leadership View)

```text
Top KPIs:
  [Deployment Frequency]     10 deploys/week ↑ (good)
  [Lead Time]                45 min avg (good)
  [Change Failure Rate]      8% (low)
  [MTTR]                     22 min (good)

Trends (last 90 days):
  - Deployment Frequency trending up (more commits + CI speed)
  - Lead Time steady (stable pipeline)
  - CFR trending down (better tests)
  - MTTR stable (good observability)
```

### Engineering Dashboard (Team View)

```text
Pipeline Health:
  [Build Success Rate]       98% (goal: >95%)
  [Test Flake Rate]          2.1% (goal: <2%)
  [P95 Build Duration]       13 min (goal: <15 min)
  [Queue Wait Time]          1 min (goal: <2 min)

Recent Deployments (last 24 hours):
  v1.2.3 → prod (2 hours ago) ✓ No errors
  v1.2.2 → prod (8 hours ago) ✓ No errors
  v1.2.1 → prod (16 hours ago) ✓ No errors

Issues & Blockers:
  - E2E tests slow (8 min) → needs parallelization
  - Test flake on payment_test.js (4%) → needs investigation
  - npm package cache misses (30%) → check cache key
```

## Continuous Improvement Cycle

### Monthly Review Meeting

1. **Review DORA metrics** (deployment frequency, lead time, CFR, MTTR)
   - Are we trending in the right direction?
   - Celebrate wins (e.g., "Lead time down 20%")
   - Identify bottlenecks ("E2E tests take 8 min; unit tests parallelized already")

2. **Review incidents** (CFR analysis)
   - How many changes caused failures?
   - Pattern analysis (more failures on Fridays? After large refactors?)
   - Action: Improve gating, add tests, improve observability

3. **Review pipeline metrics**
   - Build duration trends
   - Test flake rates
   - Build success rate

4. **Prioritize improvements**
   - Quick wins (e.g., update Docker layer cache; parallel tests)
   - Strategic (e.g., add SAST; invest in observability)

5. **Track action items**
   - Assign owners
   - Set deadlines
   - Review at next meeting

### Metrics-Driven Culture

**Share metrics openly**:

- Post DORA metrics in #engineering Slack
- Include lead time and CFR in sprint retrospectives
- Celebrate deployment frequency wins

**Use metrics to drive decisions**:

- "Lead time is 2 hours; we want <1 hour → where's the bottleneck?"
- "CFR spiked to 20% last sprint → did we skip testing?"
- "MTTR is 2 hours; we want <30 min → improve observability"

**Avoid metric abuse**:

- ❌ Don't use deployment frequency as individual KPI (encourages small, unrelated commits)
- ❌ Don't blame teams for high CFR without context (may be business risk tolerance)
- ❌ Don't chase metrics at expense of quality (ship fast, but with safety)
