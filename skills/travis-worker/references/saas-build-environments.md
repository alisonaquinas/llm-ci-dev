# Travis CI SaaS Build Environments

Configure build environments for jobs running on travis-ci.com (SaaS).

---

## Operating System Selection

Specify the base operating system for your build VM via the `os:` keyword in `.travis.yml`:

```yaml
os: linux      # Default; Linux-based VMs (Ubuntu)
os: osx        # macOS VMs
os: windows    # Windows VMs
```

### Linux Distributions (dist)

When `os: linux`, select the Ubuntu distribution:

```yaml
os: linux
dist: focal    # Ubuntu 20.04 LTS
dist: jammy    # Ubuntu 22.04 LTS (recommended)
dist: noble    # Ubuntu 24.04 LTS
dist: bionic   # Ubuntu 18.04 LTS (older)
```

### Architecture Selection (arch)

Select CPU architecture for the build VM:

```yaml
arch: amd64    # x86-64 (Intel/AMD, default)
arch: arm64    # ARM 64-bit (Apple M1+, graviton)
arch: ppc64le  # PowerPC 64-bit (IBM systems)
arch: s390x    # IBM System z (mainframe)
```

### OS and Distribution Availability Matrix

| OS | Distributions | Architectures |
| --- | --- | --- |
| Linux | focal, jammy, noble, bionic | amd64, arm64, ppc64le, s390x |
| macOS | 11, 12, 13 (Xcode versions) | amd64, arm64 |
| Windows | Server 2019, 2022 | amd64 |

**Note**: Not all dist/arch combinations are available. Check Travis CI status page for availability.

---

## Build VM Specifications

### Standard Hardware (SaaS)

Typical Travis CI SaaS build VM resources:

- **CPU**: 2 vCPU cores
- **Memory**: 7.5 GB RAM
- **Disk**: 30 GB (varies by plan)
- **Network**: Shared, subject to rate limits

Larger or specialized resources (GPU, high-mem) available with premium plans.

---

## Build Environment Customization

### System Package Installation (apt)

Install additional packages via `addons.apt` on Linux:

```yaml
os: linux
dist: jammy
addons:
  apt:
    packages:
      - postgresql
      - redis-server
      - docker.io
```

Alternatively, use `apt_sources` for custom repositories:

```yaml
addons:
  apt:
    sources:
      - sourceline: "ppa:ubuntu-toolchain-r/test"
    packages:
      - gcc-11
```

### Homebrew Packages (macOS)

Install packages via Homebrew on macOS:

```yaml
os: osx
addons:
  homebrew:
    packages:
      - postgresql
      - redis
      - graphviz
    casks:
      - google-chrome
```

### Before Script Setup

Use `before_install` to customize the environment further:

```yaml
before_install:
  - wget https://example.com/custom-tool.tar.gz
  - tar xzf custom-tool.tar.gz
  - export PATH=$PWD/custom-tool:$PATH
```

---

## Service Containers

### Docker Service Containers

Use `services: docker` to enable Docker and run service containers:

```yaml
os: linux
services:
  - docker

script:
  - docker run --rm postgres:15 --version
  - docker pull myregistry.azurecr.io/myimage:latest
```

### Legacy Service Addons

Some services are available via legacy addons (deprecated, use Docker instead):

```yaml
addons:
  postgresql: "15"  # Start PostgreSQL 15 server
  redis:            # Start Redis server
    version: 7
```

---

## Environment Variables

Set environment variables for build customization:

```yaml
env:
  - NODE_ENV=test
  - CI_COMMIT_BRANCH=$TRAVIS_BRANCH

script:
  - echo $NODE_ENV
```

### Secure Variables

Store sensitive data (tokens, passwords) using encrypted variables:

```bash
# Encrypt variable with Travis CLI
travis encrypt SECRET_TOKEN=xxxx --add env

# Or manually in .travis.yml
env:
  - secure: "encrypted_value_here"
```

---

## Language and Version Matrix

Specify language and versions to test multiple versions simultaneously:

```yaml
language: node_js
node_js:
  - "18"
  - "20"
  - "21"

# Creates matrix of 3 parallel jobs
```

### Language-Specific Versions

| Language | Versions Example | Keyword |
| --- | --- | --- |
| Node.js | 18, 20, 21 | `node_js:` |
| Python | 3.9, 3.10, 3.11 | `python:` |
| Ruby | 3.0, 3.1, 3.2 | `rvm:` |
| Go | 1.19, 1.20, 1.21 | `go:` |
| Java | 8, 11, 17, 21 | `jdk:` |

---

## Build Job Lifecycle

### Standard Job Phases

Travis CI runs jobs in this order:

1. **Setup environment** — Boot VM, install OS packages
2. **before_install** — Custom setup (install tools, clone repos)
3. **install** — Install language dependencies (npm install, pip install, etc.)
4. **before_script** — Pre-test setup (start services, migrations, etc.)
5. **script** — Run main build commands (tests, builds)
6. **after_success/after_failure** — Post-test actions (upload artifacts)
7. **after_script** — Final cleanup (always runs)

### Job Output and Artifacts

By default, job logs are captured and displayed. Configure artifact storage:

```yaml
# No native artifact storage in SaaS (logs only in UI)
# Use external storage:
after_success:
  - tar czf coverage.tar.gz coverage/
  - curl -F "file=@coverage.tar.gz" https://storage.example.com/upload
```

---

## Build Timing and Timeouts

### Job Timeout

Jobs have a maximum execution time (default 1 hour). Long-running tests may timeout:

```yaml
# No explicit timeout configuration in .travis.yml
# Jobs timeout after ~60 minutes of no output
# Keep output active to prevent timeout:
script:
  - npm test -- --reporter json | tee test-output.json
```

### Quiet Job Detection

If no output is produced for 20 minutes, the job is terminated. To keep jobs active:

```yaml
script:
  - npm run test -- --coverage
  - echo "Test complete"  # Ensure final output before end
```

---

## Build Cache

Improve build speed by caching dependencies:

```yaml
cache:
  directories:
    - node_modules
  npm: true  # Cache npm packages
```

Caching is shared per branch.

---

## Common Build Environment Configurations

### Node.js + Testing

```yaml
os: linux
dist: jammy
language: node_js
node_js:
  - "18"
  - "20"
cache:
  npm: true
script:
  - npm test
```

### Python + PostgreSQL

```yaml
os: linux
dist: jammy
language: python
python:
  - "3.10"
  - "3.11"
addons:
  postgresql: "15"
services:
  - postgresql
before_script:
  - psql -c "CREATE DATABASE test;"
script:
  - pytest
```

### macOS + Xcode

```yaml
os: osx
osx_image: xcode15.1  # Specify Xcode version
xcode_scheme: "MyApp"
xcode_destination: generic/platform=iOS
script:
  - xcodebuild -scheme MyApp -destination 'generic/platform=iOS' test
```

---

## Troubleshooting Build Environment Issues

### Package Installation Fails

Ensure the distribution has the package and sources are correct:

```yaml
addons:
  apt:
    packages:
      - nonexistent-pkg  # Will fail
    sources:
      - sourceline: "deb https://example.com/repo focal main"  # Add custom repo
```

### Disk Space Issues

Builds with large artifacts may fail due to disk space:

```bash
# Check available disk in build logs
df -h
```

Optimize by clearing caches or reducing artifact size.

### Service Startup Failures

If services fail to start (Docker, PostgreSQL):

```yaml
services:
  - docker
  - postgresql

before_script:
  - docker ps  # Verify Docker is running
  - psql --version  # Verify PostgreSQL is available
```

### Timeout Issues

If builds timeout frequently, optimize test speed:

```yaml
script:
  - npm test -- --parallel=4  # Run tests in parallel
  - npm run coverage -- --timeout=10000  # Increase test timeout
```
