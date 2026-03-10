# Release and Versioning

Manage releases, semantic versioning, and artifact distribution.

## GitLab Releases API

### Create a Release

Use the GitLab Releases API to create releases from CI/CD pipelines:

```bash
curl --request POST \
  --header "PRIVATE-TOKEN: $CI_JOB_TOKEN" \
  --data '{"tag_name": "v1.0.0", "name": "Version 1.0.0", "description": "Initial release"}' \
  "$CI_API_V4_URL/projects/$CI_PROJECT_ID/releases"
```

### Release Fields

- `tag_name` — Git tag (required, must exist)
- `name` — Display name for the release
- `description` — Release notes and changelog
- `milestones` — Associated project milestones
- `released_at` — Release date (ISO 8601 format)
- `assets` — Links to release artifacts

## Semantic Versioning

### Version Format

Follow semantic versioning: `MAJOR.MINOR.PATCH`

```bash
v1.0.0     → Major version (breaking changes)
v1.1.0     → Minor version (new features)
v1.0.1     → Patch version (bug fixes)
v2.0.0-rc.1 → Release candidate
v1.0.0+build.123 → Build metadata
```

### CI/CD Variables for Versioning

Extract version from git tag:

```bash
export VERSION=${CI_COMMIT_TAG#v}  # Remove 'v' prefix
echo "Version: $VERSION"
```

Store version in a file for reuse:

```yaml
build:
  script:
    - echo ${CI_COMMIT_TAG#v} > version.txt
  artifacts:
    paths:
      - version.txt
```

## Release CLI Tool

### Installation and Usage

The `release-cli` tool simplifies release creation in CI/CD pipelines:

```bash
curl --location "https://gitlab.com/api/v4/projects/gitlab-org%2Frelease-cli/releases/latest/downloads/release-cli-linux-amd64.tar.gz" | tar xz
./release-cli create --name "v1.0.0" --description "My Release" --tag-name "v1.0.0"
```

### Job Example

```yaml
release:
  stage: release
  image: registry.gitlab.com/gitlab-org/release-cli:latest
  script:
    - echo "Creating release..."
  release:
    tag_name: $CI_COMMIT_TAG
    name: "Release $CI_COMMIT_TAG"
    description: "## What's New\n\n- Feature 1\n- Feature 2"
    ref: $CI_COMMIT_SHA
  only:
    - tags
```

### Release Assets

Attach artifacts and links to releases:

```yaml
release:
  stage: release
  script:
    - ./build.sh
  release:
    tag_name: $CI_COMMIT_TAG
    name: "Release $CI_COMMIT_TAG"
    assets:
      links:
        - name: "Binary"
          url: "https://example.com/releases/app-$CI_COMMIT_TAG"
          link_type: package
        - name: "Source Code"
          url: "https://example.com/releases/src-$CI_COMMIT_TAG.tar.gz"
          link_type: source
```

## Changelog Generation

### Automatic Changelog from Commits

Generate changelog from commit messages:

```yaml
changelog:
  stage: release
  script:
    - |
      cat > CHANGELOG_ENTRY.md << EOF
      ## $CI_COMMIT_TAG

      $(git log --oneline --grep="feat\|fix" $CI_COMMIT_BEFORE_SHA..$CI_COMMIT_SHA)
      EOF
  artifacts:
    paths:
      - CHANGELOG_ENTRY.md
  only:
    - tags
```

### Conventional Commits

Structure commits for automatic parsing:

```bash
feat: add new API endpoint
fix: correct memory leak in parser
docs: update installation guide
chore: update dependencies

feat(auth): implement OAuth2 flow
fix(api): handle null responses
```

Extract changelog using conventional commit parser:

```bash
git log --format="%s" $PREV_TAG..$CI_COMMIT_TAG | grep "^feat\|^fix" > CHANGELOG_ENTRY.md
```

### Changelog Tools

Use tools like `auto-changelog` or `conventional-changelog`:

```yaml
release:
  image: node:latest
  script:
    - npm install -g conventional-changelog-cli
    - conventional-changelog -p angular -i CHANGELOG.md -s
    - git add CHANGELOG.md && git commit -m "docs: update changelog for $CI_COMMIT_TAG" || true
```

## Artifact Linking

### Attach Files to Releases

Link build artifacts in release creation:

```yaml
build:
  stage: build
  script:
    - make build
  artifacts:
    paths:
      - dist/
      - build/
    expire_in: 1 week

release:
  stage: release
  script:
    - echo "Release artifacts are ready"
  release:
    tag_name: $CI_COMMIT_TAG
    assets:
      links:
        - name: "App Binary"
          url: "$CI_PROJECT_URL/-/jobs/$CI_JOB_ID/artifacts/raw/dist/app"
          link_type: package
```

### Link to External Artifacts

Reference artifacts hosted outside GitLab:

```yaml
release:
  release:
    tag_name: $CI_COMMIT_TAG
    assets:
      links:
        - name: "Docker Image"
          url: "https://hub.docker.com/r/myorg/app:$CI_COMMIT_TAG"
          link_type: package
        - name: "Helm Chart"
          url: "https://charts.myorg.com/app-$CI_COMMIT_TAG.tgz"
          link_type: package
```

## Package Registry

### Publish to GitLab Package Registry

GitLab hosts npm, Maven, PyPI, Conan, and Go packages:

```yaml
publish_npm:
  stage: release
  image: node:latest
  script:
    - npm config set //registry.npmjs.org/:_authToken=$NPM_TOKEN
    - npm publish
  only:
    - tags

publish_pypi:
  stage: release
  image: python:latest
  script:
    - pip install twine
    - twine upload dist/* -u __token__ -p $PYPI_TOKEN
  only:
    - tags

publish_maven:
  stage: release
  image: maven:latest
  script:
    - mvn deploy -s .m2/settings.xml
  only:
    - tags
```

### Container Registry

Push container images as part of release:

```yaml
push_container:
  stage: release
  image: docker:latest
  services:
    - docker:dind
  script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
    - docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_TAG .
    - docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_TAG
    - docker tag $CI_REGISTRY_IMAGE:$CI_COMMIT_TAG $CI_REGISTRY_IMAGE:latest
    - docker push $CI_REGISTRY_IMAGE:latest
  only:
    - tags
```

## Tag-Based Deployment

### Deploy from Git Tags

Trigger deployments only for version tags:

```yaml
deploy_production:
  stage: deploy
  script:
    - ./deploy.sh
  environment:
    name: production
    url: https://app.example.com
  only:
    - tags
  except:
    - /^v.*-.*$/  # Exclude pre-release versions
```

### Version-Specific Deployment

Deploy different strategies for version patterns:

```yaml
deploy_stable:
  script: ./deploy-stable.sh
  only:
    - /^v\d+\.\d+\.\d+$/  # Stable versions only

deploy_rc:
  script: ./deploy-rc.sh
  only:
    - /^v\d+\.\d+\.\d+-rc\d+$/  # Release candidates only
```

### Rolling Back to a Previous Version

Create a deployment from a previous tag:

```bash
git checkout v1.0.0
git push origin HEAD:deploy-v1.0.0 --force-with-lease
```

Or trigger via GitLab API:

```bash
curl --request POST \
  --header "PRIVATE-TOKEN: $CI_JOB_TOKEN" \
  --form "ref=v1.0.0" \
  "$CI_API_V4_URL/projects/$CI_PROJECT_ID/pipeline"
```

## Related Topics

- See **Environments & Deployments** for deployment tracking and rollback
- See **Deployment Targets** for package registry integration
