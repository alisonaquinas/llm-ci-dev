# Caching Strategies

Travis CI provides built-in caching to speed up builds by reusing dependencies and build artifacts.
This reference covers cache configuration, branch-specific behavior, and optimization strategies.

---

## Built-In Cache Shortcuts

Travis CI provides language-specific cache defaults that work out-of-the-box:

### Python (pip)

```yaml
language: python
python: "3.11"
cache: pip
```

Caches the pip package directory (`~/.cache/pip`).

### Node.js (npm)

```yaml
language: node_js
node_js: "18"
cache: npm
```

Caches npm modules (`node_modules` and `~/.npm`).

### Ruby (bundler)

```yaml
language: ruby
rvm: "3.2"
cache: bundler
```

Caches gems installed by Bundler (`vendor/bundle`).

### Java (Maven)

```yaml
language: java
jdk: openjdk17
cache: maven
```

Caches Maven repository (`~/.m2`).

### Java (Gradle)

```yaml
language: java
jdk: openjdk17
cache: gradle
```

Caches Gradle cache (`~/.gradle`).

### Multiple Caches

Combine multiple cache types:

```yaml
language: node_js
node_js: "18"
cache:
  - npm
  - yarn

install:
  - npm install
  - yarn install
```

---

## Custom Directory Caching

Cache arbitrary directories:

```yaml
language: python
python: "3.11"
cache:
  directories:
    - ~/.cache/pip
    - venv/
    - .tox/
```

### Path Expansion

Use `~` for home directory; absolute paths are supported:

```yaml
cache:
  directories:
    - ~/.cache/pip
    - ~/.m2
    - ./build/
    - /tmp/my-cache/
```

### Multiple Custom Directories

```yaml
language: python
python: "3.11"
cache:
  pip: true
  directories:
    - venv/
    - .tox/
    - docs/_build/
```

---

## Cache Keys

Travis caches per branch by default. Customize with explicit `key`:

### Static Key

```yaml
cache:
  pip: true
  key: "python-dependencies"
```

All builds on all branches share this cache. Useful for globally stable dependencies.

### Branch-Specific Key

```yaml
cache:
  pip: true
  key: "python-$TRAVIS_BRANCH"
```

Different branches maintain separate caches. Use when branches have different dependencies.

### Hash-Based Key

Invalidate cache when dependencies change:

```yaml
cache:
  pip: true
  key: "python-$(cat requirements.txt | md5sum)"
```

Or with `lock` files:

```yaml
cache:
  npm: true
  key: "node-$TRAVIS_OS_NAME-$(cat package-lock.json | md5sum)"
```

Changes to `package-lock.json` automatically invalidate the cache.

---

## Disabling Cache

### Per-Job

Disable cache for a specific job while keeping it for others:

```yaml
jobs:
  include:
    - name: "Build with cache"
      cache: npm
      script: npm test

    - name: "Clean build (no cache)"
      cache: false
      script: npm test
```

### Branch-Specific Disable

Disable cache on specific branches:

```yaml
language: python
python: "3.11"
cache:
  pip: true
  on:
    branches:
      - exclude:
          - release  # No cache on release branch
```

Or enable only on specific branches:

```yaml
cache:
  pip: true
  on:
    branches:
      - main
      - develop
```

---

## Docker Layer Caching

Travis supports layer caching for Docker builds:

```yaml
language: generic
services:
  - docker

script:
  - docker build -t my-image .
  - docker run my-image npm test
```

Docker automatically caches layers between builds. Layers invalidate when the Dockerfile changes or base image is updated.

### Optimize Docker Caching

Order Dockerfile commands strategically:

```dockerfile
FROM node:18-alpine

# Layer 1: Base dependencies (rarely changes)
RUN apk add --no-cache python3

# Layer 2: Install package dependencies (medium change frequency)
COPY package*.json ./
RUN npm ci

# Layer 3: Application code (changes frequently)
COPY . .

# Layer 4: Build
RUN npm run build
```

This ordering ensures frequent changes (code) don't invalidate stable layers (base, dependencies).

---

## Clearing Cache

### Via Web UI

1. Go to build settings
2. Click "Restart build without cache"

### Via API

```bash
curl -X DELETE \
  -H "Authorization: token $TRAVIS_TOKEN" \
  https://api.travis-ci.com/v3/cache/repo-id
```

### Force Cache Invalidation

Change the cache key to force a fresh cache:

```yaml
cache:
  pip: true
  key: "python-v2"  # Increment when invalidation needed
```

---

## Cache Size Limits

Travis CI enforces cache size limits:

- **Free tier:** 100 MB per repository
- **Pro:** 1 GB per repository

If cache exceeds limits, Travis automatically evicts old entries.

### Monitor Cache Size

Cache usage is visible in build logs and repository settings.

To reduce cache size:

1. Exclude large generated files
2. Increase cache key granularity (branch-specific)
3. Clear cache periodically via UI

### Exclude Large Files

Use `.travis-ci-cache-exclude` to skip files:

```yaml
cache:
  directories:
    - node_modules/
  before_cache:
    - find node_modules -name "*.d.ts" -delete
```

---

## Branch-Specific Caching

### Cache Per Branch

```yaml
cache:
  pip: true
  key: "$TRAVIS_BRANCH-cache"
```

Each branch maintains its own cache. Useful when branches have different dependencies.

### Merge Behavior

When a branch is merged, the cache is retained. Subsequent builds on the target branch use the merged code's cache.

### Clean Up Old Caches

Use `cache: false` on old branches to prevent cache accumulation.

---

## Cache Best Practices

1. **Cache package managers** — Always cache pip, npm, bundler, Maven, Gradle
2. **Use hash-based keys** — Invalidate cache automatically when dependencies change
3. **Exclude build artifacts** — Don't cache compiled files; rebuild instead
4. **Monitor size** — Check cache usage in repository settings
5. **Branch strategy** — Use `$TRAVIS_BRANCH` in key for multi-branch development
6. **Test without cache** — Periodically do clean builds to catch cache issues
7. **Document cache intent** — Comments explaining why directories are cached

---

## Common Caching Patterns

### Python Project with Virtualenv

```yaml
language: python
python: "3.11"
cache:
  pip: true
  directories:
    - venv/
  key: "python-$TRAVIS_BRANCH-$(cat requirements.txt | md5sum)"
install:
  - python -m venv venv
  - source venv/bin/activate
  - pip install -r requirements.txt
script:
  - source venv/bin/activate
  - pytest
```

### Node.js with Multiple Package Managers

```yaml
language: node_js
node_js: "18"
cache:
  npm: true
  key: "node-$TRAVIS_OS_NAME-$(cat package-lock.json | md5sum)"
install:
  - npm ci
script:
  - npm test
```

### Java Project with Dependencies

```yaml
language: java
jdk: openjdk17
cache:
  maven: true
  directories:
    - ~/.gradle  # If using Gradle too
  key: "java-$TRAVIS_OS_NAME"
script:
  - mvn clean verify
```

### Docker with Layer Caching

```yaml
language: generic
services:
  - docker
script:
  - docker build --cache-from my-image:latest -t my-image:$TRAVIS_COMMIT .
  - docker run my-image npm test
after_success:
  - docker push my-image:$TRAVIS_COMMIT
```

---

## Cache Troubleshooting

| Problem | Solution |
| --- | --- |
| Cache not being used | Check `cache:` directive; ensure directory exists |
| Cache invalidates too often | Use broader cache key (remove hash) or increase key specificity |
| Cache grows too large | Exclude generated files; use branch-specific keys |
| Builds fail with stale cache | Clear cache via web UI and rebuild |
| Different behavior with/without cache | Cache may hide cleanup issues; test both paths |
