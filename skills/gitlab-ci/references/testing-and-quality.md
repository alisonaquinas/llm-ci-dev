# Testing & Quality — Reporting, Scanning, and Code Metrics

## Overview

GitLab CI integrates test reports, code coverage, security scanning, and code quality metrics directly into pipelines and merge requests.
This enables automated quality gates and visual feedback on code changes.

---

## Test Reports

### JUnit XML Format

Jobs can parse and display test results from JUnit XML files:

```yaml
test:
  stage: test
  image: node:18
  script:
    - npm ci
    - npm run test -- --reporter json --outputFile test-results.json
  artifacts:
    when: always
    reports:
      junit: test-results.json
```

GitLab parses test results and displays them in:

- Pipeline detail page
- Merge request discussion
- Test reports widget

### Test Report Formats

GitLab supports multiple test report formats:

#### JUnit XML

```yaml
test:
  script:
    - pytest --junitxml=report.xml
  artifacts:
    reports:
      junit: report.xml
```

#### TAP (Test Anything Protocol)

```yaml
test:
  script:
    - npm test > test.tap
  artifacts:
    reports:
      junit: test.tap
```

#### Custom XML Paths

```yaml
test:
  script:
    - npm test -- --outputDir=test-results
  artifacts:
    reports:
      junit: test-results/**/*.xml
```

### Test Report Features

- **Pass/Fail Visibility** — Display test results in GitLab UI
- **Flaky Test Detection** — Identify tests that fail intermittently
- **Test Durations** — Track slowest tests
- **Failure Messages** — Show assertion failures inline

---

## Code Coverage

### Generating Coverage Reports

```yaml
test:
  stage: test
  image: python:3.11
  script:
    - pip install coverage pytest pytest-cov
    - pytest --cov=app --cov-report=xml
  artifacts:
    reports:
      coverage_report:
        coverage_format: cobertura
        path: coverage.xml
```

### Coverage Report Formats

| Format | Supported | Tool Example |
| --- | --- | --- |
| Cobertura (XML) | Yes | pytest-cov, coverage.py, JaCoCo |
| LCOV (text) | Yes | nyc (JavaScript), lcov |
| Simple (percentage) | Via regex | Custom extraction |

### LCOV Format

```yaml
test_javascript:
  stage: test
  image: node:18
  script:
    - npm ci
    - npm run test -- --coverage
  artifacts:
    reports:
      coverage_report:
        coverage_format: lcov
        path: coverage/lcov.info
```

### Coverage Badge

Display coverage percentage in project README:

```markdown
![Coverage](https://gitlab.example.com/group/project/-/badges/main/coverage.svg)
```

### Merge Request Coverage Analysis

Coverage is automatically calculated and shown in MR comparisons:

```yaml
test:
  stage: test
  script:
    - npm test -- --coverage
  artifacts:
    reports:
      coverage_report:
        coverage_format: cobertura
        path: coverage.xml
```

---

## Security Scanning

### SAST (Static Application Security Testing)

Include GitLab's SAST templates to scan source code for vulnerabilities:

```yaml
include:
  - template: Security/SAST.gitlab-ci.yml
```

Supported languages (auto-detected):

- Java, Kotlin, Scala
- C, C++, Objective-C
- JavaScript, TypeScript
- Python
- Go
- Ruby
- PHP

Results appear in:

- Security scanning widget in MR
- Security dashboard in project settings
- Vulnerability list

### DAST (Dynamic Application Security Testing)

Scan running application for vulnerabilities:

```yaml
include:
  - template: Security/DAST.gitlab-ci.yml

variables:
  DAST_WEBSITE: https://staging.example.com
  DAST_FULL_SCAN_ENABLED: "true"
```

DAST starts a running application and performs active scanning.

### Dependency Scanning

Detect vulnerable dependencies:

```yaml
include:
  - template: Security/Dependency-Scanning.gitlab-ci.yml
```

Scans dependency files:

- `package.json` / `package-lock.json` (Node.js)
- `requirements.txt` / `Pipfile.lock` (Python)
- `Gemfile.lock` (Ruby)
- `pom.xml` (Java)
- `go.mod` (Go)

### License Scanning

Detect software licenses in dependencies:

```yaml
include:
  - template: Security/License-Scanning.gitlab-ci.yml
```

Reports:

- Detected licenses per dependency
- Blacklisted/whitelisted licenses
- Compliance recommendations

### Secret Detection

Scan for exposed credentials, API keys, tokens:

```yaml
include:
  - template: Security/Secret-Detection.gitlab-ci.yml
```

Detects patterns for:

- AWS keys
- GitHub tokens
- Private keys
- Database credentials

---

## Code Quality

### Code Quality Reports

Analyze code style, complexity, and maintainability:

```yaml
quality:
  stage: test
  image: sonarsource/sonar-scanner-cli:latest
  variables:
    SONAR_HOST_URL: https://sonarqube.example.com
    SONAR_LOGIN: $SONAR_TOKEN
  script:
    - sonar-scanner
  artifacts:
    reports:
      sast: gl-sast-report.json
```

### GitLab Code Quality Template

```yaml
include:
  - template: Code-Quality.gitlab-ci.yml
```

Common code quality tools:

- **SonarQube** — Comprehensive code quality and coverage
- **CodeClimate** — Maintainability and complexity
- **ESLint** — JavaScript/TypeScript linting
- **Pylint** — Python static analysis

### Custom Code Quality Job

```yaml
quality:
  stage: test
  image: python:3.11
  script:
    - pip install pylint
    - pylint app/ --exit-zero --output-format=json > report.json
  artifacts:
    reports:
      sast: report.json
```

---

## Merge Request Test Integration

### Test Results in MR

Jobs with test reports display results directly in merge requests:

```yaml
test:
  stage: test
  script:
    - npm test -- --reporter json --outputFile results.json
  artifacts:
    reports:
      junit: results.json
```

Results appear as:

- Test summary (pass/fail count)
- Detailed test list with durations
- Failed assertion messages

### Blocking on Test Failure

Prevent merge until tests pass:

```yaml
test:
  stage: test
  script: pytest
  artifacts:
    reports:
      junit: report.xml
  allow_failure: false  # Block MR if tests fail
```

### Optional Test Jobs

Allow merge even if optional tests fail:

```yaml
test_optional:
  stage: test
  script: npm run test:e2e
  artifacts:
    reports:
      junit: e2e-results.xml
  allow_failure: true
```

### MR Test Trends

Track test metrics over time in MR:

- Coverage change (improved/decreased)
- New/fixed issues from security scanning
- Performance regressions (if integrated)

---

## Matrix Testing

Run tests across multiple configurations:

### Multi-Version Testing

```yaml
test:
  stage: test
  image: python:$PY_VERSION
  parallel:
    matrix:
      - PY_VERSION: [ "3.9", "3.10", "3.11" ]
  script:
    - pip install -r requirements.txt
    - pytest
```

Generates 3 jobs (one per Python version).

### Multi-Browser Testing

```yaml
e2e:
  stage: test
  parallel:
    matrix:
      - BROWSER: [ chrome, firefox, safari ]
        OS: [ linux, macos, windows ]
  script:
    - npm run test:e2e -- --browser=$BROWSER --os=$OS
```

Generates 9 jobs (3 browsers × 3 OSes).

### Combined Matrix and Artifacts

```yaml
test:
  parallel:
    matrix:
      - NODE_VERSION: [ 16, 18, 20 ]
  script:
    - npm test -- --outputFile=results-$NODE_VERSION.xml
  artifacts:
    reports:
      junit: results-*.xml
```

All variant jobs' test reports are collected into a single MR view.

---

## Test Report Features in MR

### Test Summary Widget

Merge request shows:

- Total tests passed/failed
- Skipped tests
- Job duration
- Flaky test warnings

### Test Details View

Click to expand and see:

- Individual test names
- Pass/fail status
- Execution time per test
- Assertion failure messages

### Coverage Comparison

Merge request shows coverage change:

- Current MR coverage
- Main branch coverage
- Change percentage
- Diff coverage (lines added/modified)

### Quality Trends

Combine multiple quality metrics:

```yaml
stages:
  - test
  - quality

test:
  stage: test
  script: pytest --cov --cov-report=xml --junitxml=report.xml
  artifacts:
    reports:
      junit: report.xml
      coverage_report:
        coverage_format: cobertura
        path: coverage.xml

sast:
  stage: quality
  script: sonar-scanner
  artifacts:
    reports:
      sast: gl-sast-report.json
```

---

## Performance Testing

### Load Testing

```yaml
load_test:
  stage: test
  script:
    - npm install -g artillery
    - artillery quick --count 100 --num 10 https://staging.example.com
  artifacts:
    reports:
      load: load-results.json
```

### Performance Regression Detection

```yaml
perf:
  stage: test
  script:
    - npm run build
    - npm run measure:perf > perf.json
  artifacts:
    reports:
      performance: perf.json
```

Results track performance over time and detect regressions.

---

## Accessibility Testing

### Automated A11y Scanning

```yaml
a11y:
  stage: test
  image: node:18
  script:
    - npm install @axe-core/cli
    - axe https://staging.example.com --format json --output a11y-report.json
  artifacts:
    reports:
      sast: a11y-report.json
```

---

## Best Practices

1. **Always include test reports** — Provide visibility in MR
2. **Fail on critical issues** — Block merge on security or test failures
3. **Track coverage trends** — Set target coverage and enforce increase
4. **Matrix test critical paths** — Test across versions/browsers/platforms
5. **Use quality gates** — Combine SAST, coverage, and test results
6. **Cache test dependencies** — Speed up repeated test runs
7. **Store artifacts with expiration** — Clean up old reports automatically
8. **Integrate with external tools** — Connect to SonarQube, CodeClimate, etc.
9. **Use flaky test detection** — Identify intermittent failures early
10. **Report trends** — Track coverage, performance, and issue counts over time
