# Release Automation

Automate releases using git tags, semantic versioning, and multi-step deployment pipelines. Combine CI and CD in a single `.travis.yml` for end-to-end release workflows.

---

## Tag-Triggered Release Pipeline

Deploy automatically when a git tag is pushed.

### Basic Tag-Triggered Deployment

```yaml
# .travis.yml
script:
  - npm test
  - npm run build

deploy:
  provider: releases
  api_key:
    secure: <encrypted-github-token>
  file: dist/bundle.tar.gz
  skip_cleanup: true
  on:
    tags: true
    repo: owner/repo
```

### Workflow

```bash
# Increment version in package.json
npm version minor

# Push tag to GitHub
git push origin main --tags

# Travis CI detects tag, runs tests, builds, uploads release
```

---

## Semantic Versioning with Conventional Commits

Automate version bumping and changelog generation using `semantic-release`.

### Install semantic-release

```bash
npm install --save-dev semantic-release @semantic-release/git @semantic-release/github
```

### .travis.yml with semantic-release

```yaml
language: node_js
node_js:
  - 18

script:
  - npm test
  - npm run build

# Release after successful build
after_success:
  - npx semantic-release

env:
  global:
    - secure: <encrypted-github-token>
```

### .releaserc.json Configuration

```json
{
  "branches": [
    "main",
    {"name": "next", "prerelease": true}
  ],
  "plugins": [
    "@semantic-release/commit-analyzer",
    "@semantic-release/release-notes-generator",
    "@semantic-release/github",
    [
      "@semantic-release/git",
      {
        "assets": ["package.json", "CHANGELOG.md"],
        "message": "chore(release): ${nextRelease.version} [skip ci]"
      }
    ]
  ]
}
```

### Workflow

1. Merge PR with conventional commit message: `feat: add login UI`
2. Travis CI runs tests and build
3. `semantic-release` analyzes commits
4. Version bumps to 1.1.0, creates CHANGELOG.md
5. Commits updated package.json and CHANGELOG.md
6. Creates GitHub Release with auto-generated notes
7. Pushes new tag `v1.1.0` back to repo

---

## GitHub Releases Asset Upload

Create releases on GitHub with build artifacts.

### Basic Release

```yaml
script:
  - npm test
  - npm run build

deploy:
  provider: releases
  api_key:
    secure: <encrypted-github-token>
  file: dist/app.tar.gz
  skip_cleanup: true
  on:
    tags: true
```

### Multiple Asset Files

```yaml
deploy:
  provider: releases
  api_key:
    secure: <encrypted-github-token>
  file:
    - dist/app.tar.gz
    - dist/app.zip
    - dist/checksums.txt
  skip_cleanup: true
  on:
    tags: true
```

### Draft and Pre-Release

```yaml
deploy:
  provider: releases
  api_key:
    secure: <encrypted-github-token>
  file: dist/app.tar.gz
  draft: false
  prerelease: $TRAVIS_TAG =~ ^v[0-9]+\.[0-9]+\.[0-9]+-rc\.[0-9]+$
  skip_cleanup: true
  on:
    tags: true
```

---

## Changelog Generation

Automatically generate CHANGELOG.md from commit history.

### Using conventional-changelog

```bash
npm install --save-dev conventional-changelog-cli
```

### Generate in Before Deploy

```yaml
script:
  - npm test
  - npm run build

before_deploy:
  - npx conventional-changelog -p angular -i CHANGELOG.md -s

deploy:
  - provider: releases
    api_key:
      secure: <github-token>
    file: dist/app.tar.gz
    skip_cleanup: true
    on:
      tags: true

  - provider: github-pages
    skip_cleanup: true
    on:
      tags: true
```

### Manual CHANGELOG.md Update

```bash
# Generate full changelog
npx conventional-changelog -p angular > CHANGELOG.md

# Or append to existing
npx conventional-changelog -p angular >> CHANGELOG.md
```

---

## Docker Image Tagging from Git Tags

Automatically tag and push Docker images based on git tags.

### Dockerfile

```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY . .
RUN npm ci --production
CMD ["npm", "start"]
```

### .travis.yml

```yaml
language: generic
services:
  - docker

script:
  - docker build -t myregistry/myapp:$TRAVIS_COMMIT .
  - docker tag myregistry/myapp:$TRAVIS_COMMIT myregistry/myapp:latest

after_success:
  - echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
  - docker push myregistry/myapp:$TRAVIS_COMMIT
  - |
    if [[ ! -z "$TRAVIS_TAG" ]]; then
      docker tag myregistry/myapp:$TRAVIS_COMMIT myregistry/myapp:$TRAVIS_TAG
      docker push myregistry/myapp:$TRAVIS_TAG
    fi

env:
  global:
    - secure: <encrypted-docker-username>
    - secure: <encrypted-docker-password>
```

### Image Tags Generated

```bash
docker push myregistry/myapp:abc1234  # Commit SHA
docker push myregistry/myapp:latest   # Always on main
docker push myregistry/myapp:v1.2.3   # Git tag
```

---

## PyPI Versioning

Automatically publish Python packages with version matching git tags.

### setup.py with Dynamic Version

```python
from setuptools import setup
import os

# Get version from tag or dev version
version = os.getenv('TRAVIS_TAG', '0.0.0.dev0')
if version.startswith('v'):
    version = version[1:]  # Remove 'v' prefix

setup(
    name='mypackage',
    version=version,
    description='My package',
    packages=['mypackage'],
)
```

### .travis.yml

```yaml
language: python
python:
  - '3.10'

install:
  - pip install build twine

script:
  - pytest

before_deploy:
  - python -m build

deploy:
  provider: pypi
  username: __token__
  password:
    secure: <encrypted-pypi-token>
  distributions: sdist bdist_wheel
  skip_existing: true
  on:
    tags: true
    condition: $TRAVIS_TAG =~ ^v[0-9]+\.[0-9]+\.[0-9]+$
```

### Build and Upload

```bash
# Tag and push
git tag v1.2.3
git push origin main --tags

# Travis CI:
# 1. Detects tag v1.2.3
# 2. Sets $TRAVIS_TAG=v1.2.3
# 3. setup.py extracts version as 1.2.3
# 4. Builds sdist and wheel
# 5. Uploads to PyPI
```

---

## Combined CI+CD in Single .travis.yml

Complete pipeline: test → build → release.

```yaml
language: node_js
node_js:
  - 18

stages:
  - test
  - build
  - release

script:
  - npm test

jobs:
  include:
    - stage: build
      script:
        - npm run build
        - npm run docs

    - stage: release
      if: tag IS present
      script:
        - npm run build
      deploy:
        - provider: npm
          email: user@example.com
          api_key:
            secure: <npm-token>
          skip_cleanup: true
          on:
            tags: true

        - provider: releases
          api_key:
            secure: <github-token>
          file: dist/app.tar.gz
          skip_cleanup: true
          on:
            tags: true

        - provider: script
          script: ./deploy-docs.sh
          skip_cleanup: true
          on:
            tags: true
```

---

## Post-Deploy Verification

Verify deployments succeeded before considering release complete.

### Health Check Script

```bash
#!/bin/bash
# verify-deploy.sh
set -e

echo "Waiting for deployment..."
sleep 10

# Check npm package published
if npm view my-package@$TRAVIS_TAG > /dev/null; then
  echo "Package published successfully"
else
  echo "Package not found on npm"
  exit 1
fi

# Check Docker image pushed
if docker pull myregistry/myapp:$TRAVIS_TAG; then
  echo "Docker image available"
else
  echo "Docker image not found"
  exit 1
fi

# Check live site
curl -f https://myapp.example.com/health || exit 1

echo "All verifications passed"
```

### Integration in .travis.yml

```yaml
after_deploy:
  - ./verify-deploy.sh

notifications:
  slack:
    on_success: change
    on_failure: always
    secure: <slack-webhook>
```

---

## Complete Release Workflow Example

```yaml
language: node_js
node_js:
  - 18

env:
  global:
    - secure: <encrypted-github-token>
    - secure: <encrypted-npm-token>
    - secure: <encrypted-docker-password>

script:
  - npm test
  - npm run build
  - npm run docs

before_deploy:
  - npx conventional-changelog -p angular -i CHANGELOG.md -s

deploy:
  # Publish to npm
  - provider: npm
    email: user@example.com
    api_key:
      secure: <npm-token>
    skip_cleanup: true
    on:
      tags: true
      condition: $TRAVIS_TAG =~ ^v[0-9]+\.[0-9]+\.[0-9]+$

  # Create GitHub Release
  - provider: releases
    api_key:
      secure: <github-token>
    file: dist/app.tar.gz
    skip_cleanup: true
    on:
      tags: true
      condition: $TRAVIS_TAG =~ ^v[0-9]+\.[0-9]+\.[0-9]+$

  # Push Docker image
  - provider: script
    script: |
      echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
      docker build -t myregistry/myapp:$TRAVIS_TAG .
      docker push myregistry/myapp:$TRAVIS_TAG
    skip_cleanup: true
    on:
      tags: true
      condition: $TRAVIS_TAG =~ ^v[0-9]+\.[0-9]+\.[0-9]+$

  # Deploy docs
  - provider: script
    script: ./deploy-docs.sh
    skip_cleanup: true
    on:
      tags: true

after_deploy:
  - ./verify-deploy.sh

notifications:
  email:
    on_success: never
    on_failure: always
```

---

## Tips

- **Semantic versioning:** Use tools like `semantic-release` to automate version bumps
- **Tag formats:** Use consistent formats (`v1.2.3`) for easy pattern matching
- **Changelog:** Generate from conventional commits for readable release notes
- **Multiple targets:** Deploy to npm, GitHub, Docker, and custom endpoints in one pipeline
- **Verification:** Always verify deployments succeeded before declaring release complete
- **Skip on CI:** Use `[skip ci]` in commit messages to avoid unnecessary rebuilds after release commits
