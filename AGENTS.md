# AGENTS.md — Guide for AI Agents Working in This Repo

This file tells AI agents (Claude Code, Codex, or any LLM tool) how to navigate,
use, and contribute to this repository effectively.

---

## What This Repo Is

A collection of cross-compatible **skills** — modular knowledge packages in `SKILL.md`
format — that extend LLM agent capabilities for **CI/CD pipelines and deployment automation**.
Skills work identically in both **Claude Code** and **Codex** without modification.

---

## Repo Layout

```text
llm-ci-cd-skills/
├── .claude-plugin/plugin.json   # Claude Code plugin registration (ignored by Codex)
├── linting/                     # Skill linting system (lint-skill.sh, lint-all.sh)
├── validation/                  # Skill validation system (rubric, public-references, validate-skill.sh)
├── skills/                      # One subdirectory per skill
│   └── <skill-name>/
│       ├── SKILL.md             # Required: frontmatter + instructions
│       ├── agents/
│       │   ├── openai.yaml      # Codex UI metadata (ignored by Claude Code)
│       │   └── claude.yaml      # Claude Code UI metadata (ignored by Codex)
│       ├── references/          # Deep docs, loaded on demand
│       ├── scripts/             # Executable helpers
│       └── assets/              # Templates and output files
├── AGENTS.md                    # This file
├── INSTALL.md                   # Installation instructions
├── LICENSE.md                   # MIT
└── README.md                    # Human-facing overview
```

---

## Reading Skills

- Start with a skill's `SKILL.md` — it contains the trigger description and core instructions.
- Load `references/*.md` only when the task requires depth on a specific sub-topic. Each
  skill's SKILL.md has an **Intent Router** section that tells you which reference to load.
- `scripts/` files are executable — run them rather than reading them when possible.
- `assets/` files are output templates — copy or adapt them; do not load them into context.

---

## Modifying Skills

### Editing an existing skill

1. Read `skills/<name>/SKILL.md` before making any changes.
2. Keep the SKILL.md body under ~500 lines. Move new content to `references/` if needed.
3. Update the Intent Router in SKILL.md when adding a new reference file.
4. If the `description` changes materially, update `agents/openai.yaml` to match
   (`short_description` and `default_prompt`).
5. Do not add platform-specific language ("Claude", "Codex") to SKILL.md body text.
   Use "the agent" instead.

### Adding a new skill

1. Create `skills/<name>/` with the exact skill name in kebab-case.
2. Write `SKILL.md` with valid YAML frontmatter (`name` and `description` only — no other fields).
3. Create `agents/openai.yaml` with `display_name`, `short_description`, and `default_prompt`.
4. Add to the skill table in `README.md`.
5. Create `agents/claude.yaml` with equivalent Claude Code metadata if needed.

### Removing a skill

Remove the entire `skills/<name>/` directory and delete its row from the `README.md` table.

---

## Invariants — Do Not Violate

- Every skill directory **must** contain `SKILL.md` with `name` and `description` frontmatter.
- Every skill **must** contain `agents/openai.yaml` with `display_name`, `short_description`,
  and `default_prompt` — this is what makes skills cross-compatible with Codex.
- SKILL.md frontmatter **must not** contain fields other than `name` and `description`.
- `references/` files must be linked from the SKILL.md Intent Router section.
- Do not create `README.md`, `CHANGELOG.md`, or other auxiliary docs inside skill directories.
- Do not commit sensitive data (tokens, passwords, keys) anywhere in this repo.

---

## Cross-Compatibility Rules

| Concern | Rule |
| --- | --- |
| Body text | Use "the agent", not "Claude" or "Codex" |
| Platform scripts | Include both `.sh` (bash) and `.ps1` (PowerShell) where relevant |
| SKILL.md format | Identical for both systems — no system-specific frontmatter |
| `agents/openai.yaml` | Required in every skill; silently ignored by Claude Code |
| `.claude-plugin/plugin.json` | At repo root only; silently ignored by Codex |

---

## Linting and Validation

Before committing any new or modified skill, run:

```bash
make lint
```

When you need a tighter loop for one skill, use:

```bash
python scripts/lint_skills.py <skill-name>
python scripts/validate_skills.py <skill-name>
```

Compatibility wrappers remain available for one release cycle:

```bash
bash linting/lint-skill.sh skills/<name>
bash linting/lint-all.sh
bash validation/validate-skill.sh skills/<name>
```

Then score against the 8-criterion rubric. Each criterion is rated **PASS / WARN / FAIL**.

| ID | Criterion | PASS | WARN | FAIL |
| --- | --- | --- | --- | --- |
| V01 | Description Effectiveness | All 4 trigger elements present and specific | Generic triggers; missing context | No triggers or extremely vague |
| V02 | Intent Router Completeness | All reference files listed with specific load conditions | Minor gaps; some conditions unclear | No Intent Router or dangling refs |
| V03 | Quick Reference Coverage | ~80% of realistic requests covered inline | 50–80% coverage; some gaps | <50% coverage; major workflows missing |
| V04 | Safety Coverage | All destructive ops documented with guardrails | Some destructive ops; inconsistent guards | Dangerous ops undocumented or unguarded |
| V05 | Example Quality | Concrete, realistic, runnable; edge cases shown | Some examples vague or missing edge cases | Few examples; mostly generic or impossible |
| V06 | Reference File Depth | Self-contained; sufficient detail to execute without SKILL.md | Some hand-waving; minor gaps | Incomplete; refers back to SKILL.md |
| V07 | LLM Usability | Agent following SKILL.md reliably succeeds; no ambiguity | Agent mostly succeeds; occasional confusion | Agent frequently fails or gets confused |
| V08 | Public Docs Alignment | Reflects ≥6 of 8 prompt engineering standards | Reflects 4–5 standards | Reflects <4 standards |

### Scoring Thresholds

- **APPROVE:** ≥7 criteria at PASS; ≤1 at FAIL
- **REVISE:** 3–6 criteria at PASS; 1–3 at FAIL (fixable issues)
- **REJECT:** <3 criteria at PASS; ≥3 at FAIL (needs major rework)

Full rubric with per-criterion detail and report template: `validation/rubric.md`

### Prompt Engineering Standards (V08 Checklist)

Skills should reflect these 8 standards (from `validation/public-references.md`):

- [ ] **Specificity** — Exact command syntax; not "check what's staged" but `git diff --staged`
- [ ] **Diverse examples** — 2–3 examples per workflow: happy path, gotcha, error recovery
- [ ] **Numbered steps** — Multi-step workflows use ordered lists; each step is atomic
- [ ] **Verification** — Every action has a follow-up check to confirm success
- [ ] **Failure modes** — Common errors documented with recovery instructions
- [ ] **Single responsibility** — Skill states explicitly what it does NOT cover
- [ ] **Output format** — Command output format described before examples
- [ ] **Context efficiency** — Intent Router first; Quick Reference second; details last

---

## Commit Conventions

- Use conventional commits: `feat:`, `fix:`, `docs:`, `refactor:`
- Scope to the skill name when relevant: `feat(gitlab-docs): add runner autoscaling reference` or `feat(ci-architecture): add blue-green deployment pattern`
- Do not amend published commits — create new ones.
- Do not commit without running the baseline quality gate:
  - `make test`
  - `make build`
  - `make verify`
  - or the narrow Python equivalents when changing one skill in isolation

---

## Release Process

Before tagging a release, complete these steps in order:

1. **Update `.claude-plugin/plugin.json`** — set `"version"` to match the release tag (e.g., tag `v1.2.0` → `"version": "1.2.0"`).
2. **Update `CHANGELOG.md`** — rename `## [Unreleased]` to `## [<version>] - <YYYY-MM-DD>` and ensure all changes since the last release are documented under the correct subsections (`### Added`, `### Improved`, `### Fixed`).
3. **Commit both files** with a `chore(release):` commit: `chore(release): bump to v<version>`.
4. **Create an annotated tag**: `git tag -a v<version> -m "Release v<version>"`.
5. **Push branch and tag**: `git push && git push origin v<version>`.

The `CHANGELOG.md` must always be updated when cutting a release — never tag without it.
- The release workflow runs `make test`, then `make all`, attaches `built/*.zip`, and skips marketplace dispatch cleanly when the token is absent.

---

## Installing Skills (for agents setting up a new environment)

See `INSTALL.md` for full instructions. The short version:

**Codex** — create directory junctions/symlinks from `~/.codex/skills/<name>` pointing
into `skills/<name>` in this repo.

**Claude Code** — register this directory as a local plugin source in `~/.claude/settings.json`.
