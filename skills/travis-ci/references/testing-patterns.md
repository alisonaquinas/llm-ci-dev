# Testing Patterns

This reference covers language-specific test defaults, running multiple test commands, parallel test sharding, external service integration, code coverage, and timeout handling.

---

## Language-Specific Test Defaults

Travis CI auto-detects the default test command for each language. Override if needed:

### Python

Default: `python -m pytest` or `python -m unittest` (auto-detected from dependencies)

Custom:

```yaml
language: python
python: "3.11"
script:
  - pytest tests/ --cov=src --cov-report=xml
```

### Node.js

Default: `npm test` (runs script in package.json)

Custom:

```yaml
language: node_js
node_js: "18"
script:
  - npm run lint
  - npm test
  - npm run build
```

### Ruby

Default: `bundle exec rake` or `bundle exec rspec` (auto-detected)

Custom:

```yaml
language: ruby
rvm: "3.2"
script:
  - bundle exec rspec spec/
```

### Java

Default: `mvn test` or `gradle test` (auto-detected)

Custom:

```yaml
language: java
jdk: openjdk17
script:
  - mvn clean verify
```

---

## Running Multiple Test Commands

Execute multiple test suites or checks sequentially:

```yaml
script:
  - npm run lint
  - npm run type-check
  - npm test
  - npm run build
```

If any command fails, the build stops immediately. Order matters: place faster checks first for quicker feedback.

---

## Parallel Test Sharding

Distribute tests across multiple jobs to reduce total build time. Tools vary by language.

### Python with `pytest-split`

Distribute tests across multiple workers:

```yaml
language: python
python: "3.11"

env:
  matrix:
    - PYTEST_SPLIT_GROUP=1
    - PYTEST_SPLIT_GROUP=2
    - PYTEST_SPLIT_GROUP=3

install:
  - pip install pytest pytest-split

script:
  - pytest --splits 3 --group $PYTEST_SPLIT_GROUP
```

This creates 3 jobs, each running 1/3 of the test suite.

### Python with `knapsack`

Distribute tests by estimated runtime:

```yaml
language: python
python: "3.11"

env:
  matrix:
    - KNAPSACK_PRO_CI_NODE_INDEX=0 KNAPSACK_PRO_CI_NODE_TOTAL=2
    - KNAPSACK_PRO_CI_NODE_INDEX=1 KNAPSACK_PRO_CI_NODE_TOTAL=2

install:
  - pip install knapsack-pro

script:
  - pytest $(knapsack-pro-pytest)
```

### JavaScript with `jest --shard`

Jest 28+ supports native sharding:

```yaml
language: node_js
node_js: "18"

env:
  matrix:
    - SHARD=1/3
    - SHARD=2/3
    - SHARD=3/3

script:
  - npm test -- --shard=$SHARD
```

### Parallel Jobs with `jobs.include`

Alternative: use matrix jobs for explicit test distribution:

```yaml
language: python
python: "3.11"

jobs:
  include:
    - name: "Unit tests"
      script: pytest tests/unit/

    - name: "Integration tests"
      script: pytest tests/integration/

    - name: "E2E tests"
      script: npm run test:e2e
```

Each job runs independently and in parallel.

---

## External Service Integration

### MySQL

```yaml
language: python
python: "3.11"

services:
  - mysql

before_script:
  - mysql -u root -e "CREATE DATABASE test_db;"
  - mysql -u root test_db < schema.sql

script:
  - pytest tests/
```

Use `$MYSQL_USER` and `$MYSQL_PASSWORD` environment variables (default: root, no password).

### PostgreSQL

```yaml
language: python
python: "3.11"

services:
  - postgresql

before_script:
  - psql -U postgres -c "CREATE DATABASE test_db;"
  - psql -U postgres test_db < schema.sql

script:
  - pytest tests/
```

### Redis

```yaml
language: node_js
node_js: "18"

services:
  - redis-server

script:
  - npm test
```

Services are available on localhost with default ports (MySQL 3306, PostgreSQL 5432, Redis 6379).

### Docker Compose

For complex service setups:

```yaml
language: python
python: "3.11"

services:
  - docker

before_script:
  - docker-compose up -d
  - sleep 10  # Wait for services to start

script:
  - pytest tests/

after_script:
  - docker-compose down
```

---

## Code Coverage Upload

### Codecov

Upload coverage reports:

```yaml
language: python
python: "3.11"

install:
  - pip install pytest pytest-cov

script:
  - pytest --cov=src --cov-report=xml

after_success:
  - pip install codecov
  - codecov
```

Codecov automatically detects and uploads `coverage.xml`, `.coverage`, or `lcov.info` files.

### Coveralls

```yaml
language: python
python: "3.11"

install:
  - pip install pytest pytest-cov coveralls

script:
  - pytest --cov=src

after_success:
  - coveralls
```

### Code Climate

```yaml
language: node_js
node_js: "18"

script:
  - npm test -- --coverage

after_success:
  - npm install -g @codeclimate/codeclimate-test-reporter
  - codeclimate-test-reporter < coverage/lcov.info
```

---

## Timeout Handling

### Default Timeout

Travis CI times out if there's no output for 10 minutes. Long tests may trigger this.

### Using `travis_wait`

Extend timeout for long-running tests:

```yaml
script:
  - travis_wait 30 pytest tests/ -v
```

This waits up to 30 minutes without output before timing out.

### Verbose Output

Prevent timeout by logging frequently:

```yaml
script:
  - pytest tests/ -v --tb=short  # -v adds verbose output
```

### travis_retry for Flaky Tests

Automatically retry failed tests:

```yaml
script:
  - travis_retry pytest tests/
```

Retries up to 3 times if the command fails.

### Combined: Retry + Wait

```yaml
script:
  - travis_wait 30 travis_retry pytest tests/ -v
```

---

## Test Framework Configuration

### Python with pytest

```yaml
language: python
python: "3.11"

install:
  - pip install -r requirements-test.txt

script:
  - pytest tests/ -v --cov=src --cov-report=term-missing
```

Create `pytest.ini` in repo root for framework config:

```ini
[pytest]
testpaths = tests
python_files = test_*.py
addopts = -v --tb=short
```

### Node.js with Jest

```yaml
language: node_js
node_js: "18"

script:
  - npm test -- --coverage --detectOpenHandles
```

Configure in `jest.config.js`:

```javascript
module.exports = {
  testEnvironment: 'node',
  collectCoverageFrom: ['src/**/*.js'],
  coveragePathIgnorePatterns: ['/node_modules/'],
};
```

### Ruby with RSpec

```yaml
language: ruby
rvm: "3.2"

script:
  - bundle exec rspec spec/ --format progress --color
```

Create `.rspec` for configuration:

```text
--format progress
--color
--require spec_helper
```

---

## Reporting to External Services

### Slack Notifications

```yaml
after_failure:
  - |
    curl -X POST https://hooks.slack.com/services/YOUR/WEBHOOK/URL \
      -d '{"text": "Build failed: '$TRAVIS_BUILD_WEB_URL'"}'

after_success:
  - |
    curl -X POST https://hooks.slack.com/services/YOUR/WEBHOOK/URL \
      -d '{"text": "Build passed: '$TRAVIS_BUILD_WEB_URL'"}'
```

### Custom Webhook

```yaml
after_success:
  - |
    curl -X POST https://api.example.com/builds \
      -H "Authorization: Bearer $API_TOKEN" \
      -d '{"status": "success", "ref": "'$TRAVIS_COMMIT'"}'
```

---

## Test Isolation & Cleanup

### Database Cleanup

```yaml
before_script:
  - psql -U postgres -c "CREATE DATABASE test_db;"

after_script:
  - psql -U postgres -c "DROP DATABASE test_db;"
```

### Cache Cleanup

```yaml
after_script:
  - redis-cli FLUSHALL
  - rm -rf /tmp/cache/
```

### Service Restart

```yaml
before_script:
  - sudo service mysql restart
  - sleep 5  # Wait for service to start
```

---

## Best Practices

1. **Run fast checks first** — Linting before tests; unit before integration
2. **Log liberally** — Use verbose flags to prevent timeout false positives
3. **Parallelize when possible** — Use test sharding for large suites (>500 tests)
4. **Set service startup timeouts** — Use `sleep` after starting services
5. **Clean up after tests** — Drop databases, clear caches in `after_script`
6. **Pin versions** — Lock test framework versions to prevent flakiness
7. **Document test commands** — Include comments explaining complex test setups
