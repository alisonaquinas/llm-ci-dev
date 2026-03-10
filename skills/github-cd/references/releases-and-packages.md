# Releases & Packages

Publish releases, artifacts, and packages using GitHub Actions workflows.
Includes release management, container image publishing, and package registry integrations.

## GitHub Releases

### softprops/action-gh-release

Create GitHub releases with assets using `softprops/action-gh-release`:

```yaml
name: Create Release

on:
  push:
    tags:
      - 'v*'

jobs:
  release:
    runs-on: ubuntu-latest
    permissions:
      contents: write
    steps:
      - uses: actions/checkout@v4

      - name: Build Artifacts
        run: |
          mkdir -p release
          echo "binary-${{ github.ref_name }}" > release/app-linux
          echo "binary-${{ github.ref_name }}" > release/app-darwin
          echo "binary-${{ github.ref_name }}" > release/app-windows.exe

      - name: Create Release
        uses: softprops/action-gh-release@v1
        with:
          files: release/*
          draft: false
          prerelease: false
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

### Release Workflow Triggers

Trigger releases on tag push:

```yaml
on:
  push:
    tags:
      - 'v*'           # Match v1.0.0, v2.0.0-beta, etc.
      - 'release/*'    # Match release/1.0.0
```

Or manually create releases:

```yaml
on:
  workflow_dispatch:
    inputs:
      tag:
        description: 'Release tag (e.g., v1.0.0)'
        required: true
```

## Semantic Versioning

Adopt semantic versioning for releases:

```bash
MAJOR.MINOR.PATCH

v1.0.0  — Breaking changes, major version increment
v1.1.0  — New features, minor version increment
v1.0.1  — Bug fixes, patch version increment
v2.0.0-beta.1  — Pre-release versions
```

### Auto-Generate Version

```yaml
jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Determine Version
        id: version
        run: |
          LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")
          MAJOR=$(echo $LATEST_TAG | cut -d. -f1 | sed 's/v//')
          MINOR=$(echo $LATEST_TAG | cut -d. -f2)
          PATCH=$(echo $LATEST_TAG | cut -d. -f3)
          NEW_PATCH=$((PATCH + 1))
          echo "version=v$MAJOR.$MINOR.$NEW_PATCH" >> $GITHUB_OUTPUT

      - name: Create Release
        uses: softprops/action-gh-release@v1
        with:
          tag_name: ${{ steps.version.outputs.version }}
          files: dist/*
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

## Release Drafting

### release-drafter/release-drafter

Auto-generate release notes from pull requests:

```yaml
name: Draft Release

on:
  push:
    branches: [main]

jobs:
  draft:
    runs-on: ubuntu-latest
    permissions:
      contents: write
      pull-requests: read
    steps:
      - uses: release-drafter/release-drafter@v6
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

Configure release-drafter in `.github/release-drafter.yml`:

```yaml
autolabeler:
  - label: enhancement
    title:
      - '/^feat/i'

  - label: bug
    title:
      - '/^fix/i'

change-template: '- $TITLE (#$NUMBER) @$AUTHOR'

categories:
  - title: 'Features'
    labels:
      - enhancement
  - title: 'Bug Fixes'
    labels:
      - bug
  - title: 'Maintenance'
    labels:
      - chore

exclude-labels:
  - reverted
```

## Container Image Publishing

### GitHub Container Registry (GHCR)

Push images to GHCR on release:

```yaml
name: Publish Docker Image

on:
  release:
    types: [published]

jobs:
  push:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write
    steps:
      - uses: actions/checkout@v4

      - name: Log in to GHCR
        uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Extract Metadata
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ghcr.io/${{ github.repository }}
          tags: |
            type=semver,pattern={{version}}
            type=semver,pattern={{major}}.{{minor}}
            type=sha
            type=ref,event=branch

      - name: Build and Push
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
```

### Docker Hub

Push images to Docker Hub:

```yaml
name: Publish to Docker Hub

on:
  release:
    types: [published]

jobs:
  push:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Log in to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

      - name: Extract Metadata
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ${{ secrets.DOCKERHUB_USERNAME }}/myapp
          tags: |
            type=semver,pattern={{version}}
            type=semver,pattern={{major}}.{{minor}}
            type=ref,event=branch

      - name: Build and Push
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
```

### docker/metadata-action

Generate image tags and labels automatically:

```yaml
- name: Extract Metadata
  id: meta
  uses: docker/metadata-action@v5
  with:
    images: |
      ghcr.io/${{ github.repository }}
      docker.io/${{ secrets.DOCKERHUB_USERNAME }}/myapp
    tags: |
      type=semver,pattern={{version}}
      type=semver,pattern={{major}}.{{minor}}
      type=semver,pattern={{major}}
      type=ref,event=branch
      type=sha,prefix={{branch}}-
      type=raw,value=latest,enable={{is_default_branch}}
```

## NPM Publishing

### Publish to NPM Registry

```yaml
name: Publish to npm

on:
  release:
    types: [published]

jobs:
  publish:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      id-token: write
    steps:
      - uses: actions/checkout@v4

      - name: Set up Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
          registry-url: 'https://registry.npmjs.org'

      - name: Install Dependencies
        run: npm install

      - name: Build
        run: npm run build

      - name: Publish to npm
        run: npm publish
        env:
          NODE_AUTH_TOKEN: ${{ secrets.NPM_TOKEN }}
```

### Scoped Packages

```yaml
# Publish to scoped registry
- name: Publish Scoped Package
  run: npm publish --access public
  env:
    NODE_AUTH_TOKEN: ${{ secrets.NPM_TOKEN }}
```

## PyPI Publishing

### Trusted Publishing (Recommended)

Use trusted publishing with OIDC instead of API tokens:

```yaml
name: Publish to PyPI

on:
  release:
    types: [published]

jobs:
  publish:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
    steps:
      - uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'

      - name: Build Distribution
        run: |
          pip install build
          python -m build

      - name: Publish to PyPI
        uses: pypa/gh-action-pypi-publish@release/v1
```

### API Token Method

```yaml
- name: Publish to PyPI
  uses: pypa/gh-action-pypi-publish@release/v1
  with:
    password: ${{ secrets.PYPI_API_TOKEN }}
```

### Test PyPI First

```yaml
- name: Publish to TestPyPI
  uses: pypa/gh-action-pypi-publish@release/v1
  with:
    repository-url: https://test.pypi.org/legacy/
    password: ${{ secrets.TEST_PYPI_API_TOKEN }}
```

## Artifact Signing

### Sigstore/cosign

Sign container images with Sigstore:

```yaml
name: Build, Sign, and Publish

on:
  release:
    types: [published]

jobs:
  build-sign:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write
      id-token: write
    outputs:
      image-digest: ${{ steps.build.outputs.digest }}
    steps:
      - uses: actions/checkout@v4

      - name: Log in to GHCR
        uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Build and Push
        id: build
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: ghcr.io/${{ github.repository }}:${{ github.ref_name }}

      - name: Install cosign
        uses: sigstore/cosign-installer@v3

      - name: Sign Image
        env:
          COSIGN_EXPERIMENTAL: 1
        run: |
          cosign sign --yes ghcr.io/${{ github.repository }}@${{ steps.build.outputs.digest }}
```

### Verify Signatures

```bash
# Verify signature using GitHub OIDC
cosign verify \
  --certificate-identity https://github.com/owner/repo/.github/workflows/publish.yml@refs/tags/v1.0.0 \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com \
  ghcr.io/owner/repo:v1.0.0
```

## NuGet Publishing

### Publish .NET Packages

```yaml
name: Publish to NuGet

on:
  release:
    types: [published]

jobs:
  publish:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Set up .NET
        uses: actions/setup-dotnet@v4
        with:
          dotnet-version: '7.x'

      - name: Build
        run: dotnet build --configuration Release

      - name: Pack
        run: dotnet pack --configuration Release --output nupkg

      - name: Publish to NuGet
        run: dotnet nuget push nupkg/*.nupkg --api-key ${{ secrets.NUGET_API_KEY }} --source https://api.nuget.org/v3/index.json
```

## Release Checklist

Before publishing a release:

```yaml
jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Run Tests
        run: npm test

      - name: Run Security Audit
        run: npm audit --audit-level=moderate

      - name: Build Artifacts
        run: npm run build

      - name: Verify Version
        run: |
          PKG_VERSION=$(grep '"version"' package.json | grep -o '[0-9][^"]*')
          TAG_VERSION=${{ github.ref_name }}
          if [[ "v$PKG_VERSION" != "$TAG_VERSION" ]]; then
            echo "Version mismatch: package.json is v$PKG_VERSION but tag is $TAG_VERSION"
            exit 1
          fi

      - name: Create Release
        uses: softprops/action-gh-release@v1
        with:
          files: dist/*
          draft: false
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

## Best Practices

- **Tag releases semantically** — Use `v1.0.0` format consistently
- **Include build artifacts** — Ship binaries, compiled code, source maps
- **Sign releases** — Use Sigstore/cosign for container image signatures
- **Test before publishing** — Run full test suite before release
- **Document changes** — Include release notes with breaking changes highlighted
- **Automate version bumps** — Use tools like `release-please` for automated versioning
- **Publish to multiple registries** — Push to Docker Hub, GHCR, and private registries
- **Verify checksums** — Include SHA256 checksums for downloaded artifacts
