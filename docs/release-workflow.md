# Release Workflow

This document describes how to cut a release for this skill package.

## Overview

Releases are tag-driven. Pushing a `vX.Y.Z` tag to `main` triggers the
[`release.yml`](../.github/workflows/release.yml) workflow which:

1. Validates the tag matches the version in `.claude-plugin/plugin.json`
2. Extracts the matching changelog entry from `CHANGELOG.md`
3. Creates a GitHub Release with those notes
4. Fires a `repository_dispatch` event to the
   [Claude Plugin Marketplace](https://github.com/alisonaquinas/llm-skills),
   triggering an automatic rebuild and republish

The marketplace at `https://alisonaquinas.github.io/llm-skills/` will reflect
the new version within ~2 minutes of tagging.

---

## Step-by-step release guide

### 1. Update the version in `plugin.json`

Edit `.claude-plugin/plugin.json` and bump the `version` field following
[Semantic Versioning](https://semver.org/):

```json
{
  "name": "llm-ci-cd-skills",
  "version": "1.5.0",
  ...
}
```

| Change type | When to use | Example |
|-------------|-------------|---------|
| **patch** `1.4.4 → 1.4.5` | Bug fixes, typo corrections | Fixed a broken reference link |
| **minor** `1.4.4 → 1.5.0` | New skills added, non-breaking changes | Added `ripgrep` skill |
| **major** `1.4.4 → 2.0.0` | Breaking changes to skill format/structure | Restructured all SKILL.md frontmatter |

### 2. Update `CHANGELOG.md`

Add a new section at the top of the changelog (above the previous release):

```markdown
## [1.5.0] — 2026-03-15

### Added
- `ripgrep` skill with search patterns reference

### Fixed
- Corrected broken link in `git` references
```

The `awk` step in the workflow extracts everything between
`## [1.5.0]` and the next `## [` heading — so keep the format consistent.

### 3. Commit

```bash
git add .claude-plugin/plugin.json CHANGELOG.md
git commit -m "chore: release v1.5.0"
```

### 4. Tag and push

```bash
git tag v1.5.0
git push
git push --tags
```

That's it. The workflow runs automatically.

---

## What happens if the tag doesn't match `plugin.json`?

The workflow will fail immediately at the validation step with:

```text
ERROR: tag v1.5.0 does not match plugin.json version 1.4.4
```

Fix: delete the tag, update `plugin.json`, recommit, and re-tag.

```bash
git tag -d v1.5.0
git push origin :refs/tags/v1.5.0
# fix plugin.json, commit, then:
git tag v1.5.0
git push --tags
```

---

## Required secret: `MARKETPLACE_DISPATCH_TOKEN`

The workflow needs a secret named `MARKETPLACE_DISPATCH_TOKEN` to be set in
this repo's GitHub settings (**Settings → Secrets and variables → Actions**).

This is a fine-grained Personal Access Token (PAT) belonging to
`alisonaquinas` with **Contents: write** permission scoped to the
`alisonaquinas/llm-skills` repository only.

It is **not** the default `GITHUB_TOKEN` — that only has access to this repo.
Contact the repo owner if you need this token rotated.
