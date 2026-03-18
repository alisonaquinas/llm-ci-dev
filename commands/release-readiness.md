# CI/CD release readiness

Check release readiness for `llm-ci-dev`.

- Inspect `CHANGELOG.md` for the latest unreleased changes.
- Confirm `.claude-plugin/plugin.json` version matches the intended tag and matches release process in `AGENTS.md`.
- Run:
  - `make test`
  - `make build`
  - `make verify`
- Confirm all modified skill metadata is updated (`SKILL.md`, `agents/openai.yaml`, and optional `agents/claude.yaml`).
