# llm-ci-cd-skills

A collection of cross-compatible LLM agent skills for **CI/CD pipeline automation**, extending both
**Claude Code** and **Codex** with domain-specific knowledge for continuous integration and deployment workflows.

> **Status:** Active CI/CD skills collection. Seven skills implemented: two Docker-based utilities (YAML linting & LSP),
> four documentation lookup skills (GitLab, GitHub, Jenkins, Travis CI), and one architecture knowledge skill.
> All skills use the shared `SKILL.md` format, making them loadable by either agent without modification.

## Skills

### Documentation Lookup Skills

| Skill | Status | Description |
|---|---|---|
| **gitlab-docs** | ✅ Implemented | Navigate docs.gitlab.com; URL patterns, CI/CD, runners, API, administration |
| **github-docs** | ✅ Implemented | Navigate docs.github.com/en; GitHub Actions, REST API, Packages, Security |
| **jenkins-docs** | ✅ Implemented | Navigate jenkins.io/doc; Declarative Pipeline, Shared Libraries, plugins, steps |
| **travis-ci-docs** | ✅ Implemented | Navigate docs.travis-ci.com; .travis.yml reference, build stages, deployment |

### Architecture & Best Practices

| Skill | Status | Description |
|---|---|---|
| **ci-architecture** | ✅ Implemented | Design CI/CD pipelines using proven best practices (DORA, DevSecOps, SLSA, platform engineering) |

### Utility Skills

| Skill | Status | Description |
|---|---|---|
| **yaml-linting** | ✅ Implemented | Docker-based YAML linting with yamllint (pipelinecomponents/yamllint) |
| **yaml-lsp** | ✅ Implemented | YAML Language Server via Docker for editor integration (node:lts-alpine + npx) |

## Quick Start

See [INSTALL.md](INSTALL.md) for full installation instructions.

**Claude Code (as local plugin):**

```json
// In ~/.claude/settings.json, add to enabledPlugins:
"llm-ci-cd-skills@local": true
```

Then point Claude Code at this directory as a local plugin source.

## Repository Structure

```text
llm-ci-cd-skills/
├── .claude-plugin/
│   └── plugin.json                  # Claude Code plugin registration
├── skills/                          # One subdirectory per skill (empty for now)
├── AGENTS.md                        # Guidance for AI agents working in this repo
├── CHANGELOG.md                     # Release history
├── INSTALL.md                       # Installation instructions
├── LICENSE.md                       # MIT
└── README.md                        # This file
```

## Adding Skills

To add a new CI/CD skill:

1. Create `skills/<name>/` with the exact skill name in kebab-case
2. Write `SKILL.md` with valid YAML frontmatter (`name` and `description`)
3. Create `agents/openai.yaml` with `display_name`, `short_description`, and `default_prompt`
4. Add reference documentation in `references/` and scripts in `scripts/` as needed
5. Update the skill table in this README

For detailed guidance, see [AGENTS.md](AGENTS.md).

## License

[MIT](LICENSE.md)
