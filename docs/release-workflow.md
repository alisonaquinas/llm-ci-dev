# Release Workflow

This document describes how to cut a release for this skill package.

## Overview

Releases are tag-driven. Pushing a `vX.Y.Z` tag to `main` triggers the
[`release.yml`](../.github/workflows/release.yml) workflow, which:

1. Provisions its own release prerequisites on the GitHub runner
2. Reads `.claude-plugin/plugin.json` and validates that the tag matches the plugin version
3. Runs `make test`
4. Runs `make all` to build fresh ZIP bundles in `built/`
5. Extracts the matching changelog entry from `CHANGELOG.md`
6. Creates a GitHub Release and attaches `built/*.zip`
7. Dispatches a marketplace rebuild only when `MARKETPLACE_DISPATCH_TOKEN` is configured

If the marketplace token is absent, the release still succeeds and the dispatch step is skipped cleanly.

## Release Steps

### 1. Update the version in `plugin.json`

Edit `.claude-plugin/plugin.json` and bump the `version` field following
[Semantic Versioning](https://semver.org/):

```json
{
  "name": "llm-ci-dev",
  "version": "1.5.0",
  ...
}
```

### 2. Update `CHANGELOG.md`

Move the pending `Unreleased` notes into a new release section:

```markdown
## [1.5.0] - 2026-03-15

### Added
- Example release note
```

The workflow extracts everything between `## [1.5.0]` and the next `## [` heading, so keep release headings consistent.

### 3. Commit the release metadata

```bash
git add .claude-plugin/plugin.json CHANGELOG.md
git commit -m "chore(release): cut v1.5.0"
```

### 4. Tag and push

```bash
git tag v1.5.0
git push
git push --tags
```

The workflow handles runner setup, testing, ZIP builds, and release publishing automatically.

## Workflow Behavior

The release workflow provisions the tools it needs before testing, including:

- `make`, `zip`, `unzip`, and `jq`
- Python plus `ruff` and `yamllint`
- Node 20 and `markdownlint-cli2`

After setup it runs:

```bash
make test
make all
```

The resulting `built/*.zip` files are attached to the GitHub release.

## Tag / Version Mismatch

If the tag does not match `.claude-plugin/plugin.json`, the workflow fails during validation.

```text
ERROR: tag v1.5.0 does not match plugin.json version v1.4.4
```

Fix the version mismatch, recommit, and recreate the tag.

## Optional Secret: `MARKETPLACE_DISPATCH_TOKEN`

`MARKETPLACE_DISPATCH_TOKEN` is optional. When configured in
**Settings -> Secrets and variables -> Actions**, the workflow sends a
`repository_dispatch` event to `alisonaquinas/llm-skills` after the GitHub release is created.

If the secret is missing, the workflow logs that marketplace dispatch is being skipped and still publishes the release normally.
