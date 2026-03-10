---
name: glab
description: Operate GitLab CLI (`glab`) for authentication checks, host and repository context inspection, merge request/issue/CI workflows, and safe command planning. Use when tasks mention `glab`, GitLab merge requests/issues/pipelines/releases, or GitLab API operations from the terminal.
---

# GitLab CLI

## Intent Router

| Request | Reference | Load When |
| --- | --- | --- |
| Install tool, first-time setup | `references/install-and-setup.md` | User needs to install glab or do initial authentication |
| Command patterns, workflows | `references/command-cookbook.md` | User needs MR/issue/CI/release patterns or workflow examples |
| GitLab concepts, organization | `references/gitlab-concepts.md` | User asks about groups/projects, namespaces, runners, visibility, or CI variables |

## Workflow

1. Run preflight before GitLab CLI workflows.
2. Check auth status and active host context.
3. Choose a core command track and begin with inspect commands.
4. Require explicit confirmation before write/delete actions.
5. Re-check status and summarize outcomes.

## Preflight

Use bundled scripts:

- `scripts/glab-preflight.sh`
- `scripts/glab-auth-status.sh`
- `scripts/glab-context.sh`
- `scripts/glab-diagnostics.sh [--json] [--out <file>]`

If the environment cannot access the default config location, set:

```bash
export GLAB_CONFIG_DIR=/tmp/glab-config
```

## Core Command Tracks

- Auth and host checks:
`glab auth status`, `glab auth login`
- Repository, issue, and MR inspection:
`glab repo view`, `glab issue list`, `glab mr list`, `glab mr view <id>`
- CI and release inspection:
`glab ci list`, `glab ci view`, `glab release list`
- API calls:
`glab api <path>` for focused GitLab API reads.

## Safety Guardrails

- Inspect first with `list`/`view` commands.
- Ask for explicit confirmation before commands that create/edit/close/delete resources.
- Confirm active host and project before mutating operations.
- Never print tokens or secrets.

## Troubleshooting

- If auth fails, run `glab auth login` then re-run `scripts/glab-auth-status.sh`.
- If host context is wrong, verify config and re-check with `scripts/glab-context.sh`.
- If network/API calls fail, collect `scripts/glab-diagnostics.sh --json` output before retry.

## References

- `references/command-cookbook.md`
- GitLab CLI docs: <https://docs.gitlab.com/cli/>
