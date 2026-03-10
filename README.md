# llm-ci-cd-skills

A collection of cross-compatible LLM agent skills for **CI/CD pipeline automation**, extending both
**Claude Code** and **Codex** with domain-specific knowledge for continuous integration and deployment workflows.

> **Status:** This is an empty plugin template ready for skill development. All skills use the shared `SKILL.md`
> format, making them loadable by either agent without modification.

## Skills

| Skill | Status | Description |
|---|---|---|
| (None yet) | 🔄 Coming Soon | CI/CD pipeline skills under development |

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
