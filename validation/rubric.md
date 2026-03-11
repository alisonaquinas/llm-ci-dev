# Skill Validation Rubric

An 8-criterion scoring guide for qualitative evaluation of LLM skills. Used alongside
`bash validation/validate-skill.sh` to assess skill effectiveness and prompt engineering quality.

---

## Quick Reference

| ID | Criterion | PASS Condition | WARN Condition | FAIL Condition |
|---|---|---|---|---|
| V01 | Description Effectiveness | All 4 trigger elements present and specific | Generic triggers; missing context | No triggers or extremely vague |
| V02 | Intent Router Completeness | All reference files listed with specific load conditions | Minor gaps; some conditions unclear | No Intent Router or dangling refs |
| V03 | Quick Reference Coverage | ~80% of realistic requests covered inline | 50–80% coverage; some gaps | <50% coverage; major workflows missing |
| V04 | Safety Coverage | All destructive ops documented with guardrails | Some destructive ops; inconsistent guards | Dangerous ops undocumented or unguarded |
| V05 | Example Quality | Concrete, realistic, runnable; edge cases shown | Some examples vague or missing edge cases | Few examples; mostly generic or impossible |
| V06 | Reference File Depth | Self-contained; sufficient detail to execute without main SKILL.md | Some hand-waving; minor gaps | Incomplete; refers back to SKILL.md |
| V07 | LLM Usability | Agent following SKILL.md reliably succeeds; no ambiguity | Agent mostly succeeds; occasional confusion | Agent frequently fails or gets confused |
| V08 | Public Docs Alignment | Reflects Anthropic/OpenAI/academic prompting standards | One or two gaps; mostly aligned | Misses major standards (e.g., no examples) |

**Scoring:**

- **PASS:** All criteria at PASS or WARN; V01–V07 averaged to ≥75%
- **REVISE:** Some criteria FAIL; fixable issues; resubmit after fixes
- **REJECT:** Multiple criteria FAIL; fundamental rework needed; not ready for release

---

## Detailed Criteria

### V01: Description Effectiveness

**Purpose:** The frontmatter description is how agents decide whether to use the skill.
It must be comprehensive and specific.

**PASS condition:**
All four elements present and specific:

1. **What it does** — "Git workflows, branching, rebasing" ✓ (not "Git tools")
2. **Specific user phrases** — "Use when the user wants to rebase", "mentions git flow"
3. **Concrete scenarios** — "interactive rebase with fixup", "squashing commits"
4. **Not just topic** — "Git" alone is insufficient; include trigger keywords

**WARN condition:**

- Vague triggers: "Use when users work with version control" (which tool?)
- Generic topic: "Docker containers" without specific scenarios
- Missing one element

**FAIL condition:**

- No triggers ("Provides git functionality" only)
- Extremely generic ("A utility for development")
- Fewer than 2 concrete examples or use cases

**How to Fix:**

```yaml
# WRONG:
description: Git version control

# RIGHT:
description: >
  Guide for Git workflows including branching, rebasing, squashing commits,
  and recovery. Use when the user wants to rebase onto main, create feature
  branches, amend commits, or recover lost work. Covers interactive rebase,
  force-push safety, and conflict resolution.
```

**Validation:** Read the description aloud. Does it answer "what is this for?" and
"when should I use it?" with specific keywords?

---

### V02: Intent Router Completeness

**Purpose:** The Intent Router guides agents to load the right reference file for
each type of request. It must be comprehensive and unambiguous.

**PASS condition:**

- Intent Router section exists and lists all reference files
- Each reference has a specific condition for loading:

  ```markdown
  ## Intent Router
  - `references/aws.md` — AWS deployment patterns
  - `references/gcp.md` — GCP deployment patterns
  Load only the file matching the user's chosen provider.
  ```

- No dangling references (every file listed exists)
- No missing references (every `references/*.md` is listed)

**WARN condition:**

- Intent Router exists but is vague: "Load references as needed"
- Some conditions missing: listed files but no explanation
- Reference files exist but some are not mentioned in Intent Router

**FAIL condition:**

- No Intent Router section
- Intent Router lists non-existent files
- SKILL.md mentions references that aren't in Intent Router

**How to Fix:**

```markdown
# WRONG: Vague Intent Router
## References
See references/troubleshooting.md

# RIGHT: Specific Intent Router
## Intent Router
- `references/troubleshooting.md` — Common issues and solutions; load if the agent needs to recover from errors
- `references/api-reference.md` — Comprehensive API; load if the user asks about specific flags or options
```

**Validation:** Can you tell, from the Intent Router alone, which reference to load
for each major use case?

---

### V03: Quick Reference Coverage

**Purpose:** ~80% of realistic requests should be answerable from SKILL.md alone,
without loading references. This keeps the context window tight.

**PASS condition:**

- SKILL.md inline covers the common cases: "the happy path" + 1 variant
- Examples in SKILL.md are runnable without reference files
- Workflows in SKILL.md are self-contained (references are for depth, not prerequisites)
- ~80% of realistic requests can be answered without loading references

**WARN condition:**

- 50–80% of requests require references
- Some workflows half-complete without reference context
- Common variants missing from SKILL.md (e.g., error recovery only in references)

**FAIL condition:**

- <50% of realistic requests covered inline
- Major workflows absent from SKILL.md
- SKILL.md is mostly "see references/X.md" with no actual content

**How to Fix:**

```markdown
# WRONG: Underspecified SKILL.md
For detailed workflows, see references/workflows.md

# RIGHT: Self-contained with pointers to depth
Quick example:
  git rebase -i HEAD~3

For complex rebasing scenarios with merge conflicts, see references/troubleshooting.md
```

**Validation:** Pick 3 realistic requests. How many can be answered from SKILL.md only?

---

### V04: Safety Coverage

**Purpose:** Destructive operations (force-push, rebase in progress, rm -rf) must
have explicit guardrails. The agent must understand the risks.

**PASS condition:**

- All destructive operations are documented in SKILL.md or in a Safety section
- Each destructive op includes:
  1. What could go wrong
  2. How to prevent it (flag, check, backup)
  3. How to recover if it goes wrong
- Examples show safe variants (e.g., `--force-with-lease` instead of `--force`)

**WARN condition:**

- Some destructive ops documented; others mentioned casually
- Safety guidance exists but is scattered or brief
- Recovery steps are vague ("you can fix it" without specifics)

**FAIL condition:**

- Dangerous operations documented without guards (e.g., "rm -rf /" without warning)
- No mention of common failure modes
- No recovery instructions for destructive actions

**How to Fix:**

```markdown
# WRONG: Unsafe
git push origin <branch> --force

# RIGHT: Safe with guardrails
git push origin <branch> --force-with-lease
This is safer than --force because it aborts if someone pushed to the branch
while you were rebasing. Always use --force-with-lease unless you have a specific reason.

If something goes wrong: git reflog to find the old commit, then git reset.
```

**Validation:** Can the agent execute the skill safely without accidentally deleting
or overwriting data?

---

### V05: Example Quality

**Purpose:** Examples teach the agent by demonstration. They must be concrete,
realistic, and cover edge cases.

**PASS condition:**

- 2–3 examples per major workflow
- Each example is copy-paste-ready (or near-identical to real use)
- Examples cover happy path, 1 gotcha, 1 error case
- Example output is shown (so agent knows what success looks like)

**WARN condition:**

- 1 example per workflow (insufficient for learning)
- Some examples generic ("run command X") without context
- Example output missing or vague
- No edge case examples

**FAIL condition:**

- No examples, or examples are pseudocode/impossible
- Examples don't match actual command syntax
- Examples don't show output or how to verify success

**How to Fix:**

```markdown
# WRONG: No examples or pseudocode
To rebase, use the rebase command.

# RIGHT: Concrete, runnable, with output
Example 1 (happy path):
$ git rebase -i origin/main
# editor opens; reorder and squash commits

Example 2 (with conflicts):
$ git rebase origin/main
CONFLICT (content): Merge conflict in foo.py
# resolve foo.py, then:
$ git add foo.py && git rebase --continue

Example 3 (recovery):
$ git rebase --abort  # back to before rebase started
```

**Validation:** Can you copy the examples and run them (or read through them and
understand exactly what happens)?

---

### V06: Reference File Depth

**Purpose:** Reference files should be self-contained encyclopedias. The agent should
not need to switch back to SKILL.md while reading a reference.

**PASS condition:**

- Each reference file is self-contained
- Enough detail to execute the task without external docs (e.g., curl man page)
- References don't say "see SKILL.md for context"
- Examples in references are complete and runnable

**WARN condition:**

- Some hand-waving: "configure your API key" without showing how
- Minor forward-references: "discussed in SKILL.md" (should not be needed)
- One reference could absorb content from another

**FAIL condition:**

- References are incomplete (e.g., "see the docs for flag details")
- References refer back to SKILL.md for essential context
- Assumes knowledge from other references without linkage

**How to Fix:**

```markdown
# WRONG: Incomplete reference
To use the API, set your token in your environment.
See main SKILL.md for setup instructions.

# RIGHT: Self-contained reference
To use the API, set your token:
  export API_TOKEN="your-token-here"

To generate a token:
  1. Visit https://example.com/settings/tokens
  2. Click "New Token"
  3. Copy the token and paste into your shell
```

**Validation:** Can the agent read and execute a reference file without loading
SKILL.md or other references?

---

### V07: LLM Usability

**Purpose:** A skill is only useful if agents can follow it and succeed.

**PASS condition:**

- Agent following SKILL.md instructions succeeds at the core task
- No ambiguity or contradictions in the text
- Instructions are in imperative form ("Run X") not questions ("Should you run X?")
- Examples are clear and unambiguous

**WARN condition:**

- Agent mostly succeeds but occasionally gets stuck
- One or two places where interpretation is unclear
- Some instructions are wordy or could be more direct

**FAIL condition:**

- Agent frequently fails or gets confused
- Instructions are contradictory
- Ambiguous wording leads to incorrect execution

**How to Fix:**

```markdown
# WRONG: Ambiguous
You might want to rebase or merge depending on the situation.
Check your branch and decide.

# RIGHT: Imperative and clear
If your feature branch has 3–5 commits, squash them with:
  git rebase -i origin/main
If you're integrating with main, merge instead:
  git merge origin/main
```

**Validation:** Ask an agent to follow the skill on a real task. Does it succeed
without confusion?

---

### V08: Public Docs Alignment

**Purpose:** Skills should reflect industry best practices in prompt engineering
(Anthropic, OpenAI, academic research).

**PASS condition:**

- Reflects 6+ of the 8 standards in `validation/public-references.md`:
  1. Specificity over generality ✓
  2. Concrete, diverse examples ✓
  3. Step-by-step workflows ✓
  4. Verification steps ✓
  5. Explicit failure modes ✓
  6. Single responsibility ✓
  7. Specify output format ✓
  8. Context window efficiency ✓

**WARN condition:**

- Reflects 4–5 standards; missing 1–2
- Examples exist but aren't diverse (e.g., only happy path, no edge cases)
- Workflows exist but lack verification steps

**FAIL condition:**

- Reflects <4 standards
- No examples or examples are generic/impossible
- Instructions are second-person ("You should") instead of imperative
- No attempt at single responsibility; scope is sprawling

**How to Fix:**
Use `validation/public-references.md` as a checklist. Before submission, verify:

- [ ] Specific examples (not generic instructions)
- [ ] 2–3 examples per workflow
- [ ] Numbered, atomic steps
- [ ] Verification after each step
- [ ] Error recovery documented
- [ ] Scope is clear (single responsibility)
- [ ] Output format specified
- [ ] Critical info is early in SKILL.md

**Validation:** Check each of the 8 standards. How many are satisfied?

---

## Report Template

Use this template when submitting a skill for validation:

```markdown
# Skill Validation Report: [skill-name]

## Automated Checks
- Line count: [N] lines
- Section count: [N] sections
- Reference files: [N]
- Examples: [N]
- Estimated coverage: [%]

## Qualitative Scoring

| Criterion | Score | Rationale |
|-----------|-------|-----------|
| V01: Description | PASS / WARN / FAIL | [1–2 sentences] |
| V02: Intent Router | PASS / WARN / FAIL | [1–2 sentences] |
| V03: Quick Ref | PASS / WARN / FAIL | [1–2 sentences] |
| V04: Safety | PASS / WARN / FAIL | [1–2 sentences] |
| V05: Examples | PASS / WARN / FAIL | [1–2 sentences] |
| V06: References | PASS / WARN / FAIL | [1–2 sentences] |
| V07: Usability | PASS / WARN / FAIL | [1–2 sentences] |
| V08: Public Docs | PASS / WARN / FAIL | [1–2 sentences] |

## Summary

**Overall:** APPROVE / REVISE / REJECT

**Strengths:**
- [Up to 3 things the skill does well]

**Issues:**
- [List FAIL items and how to fix them]
- [List WARN items that should be addressed]

**Recommendation:**
[APPROVE if ready for release / REVISE if fixable / REJECT if fundamental rework needed]
```

---

## Threshold Guidelines

- **APPROVE:** ≥7 criteria at PASS; ≤1 at FAIL
- **REVISE:** 3–6 criteria at PASS; 1–3 at FAIL (fixable issues)
- **REJECT:** <3 criteria at PASS; ≥3 at FAIL (needs major rework)

---

## When to Load This File

Load this rubric when:

- Evaluating a new skill before merging to main
- Scoring an existing skill for quality improvements
- Reviewing a skill PR
- Self-checking a skill before submission
