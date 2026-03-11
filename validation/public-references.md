# Public Prompt Engineering Standards

Synthesised standards from Anthropic, OpenAI, and academic research on effective
LLM skill design and prompt engineering.

---

## Standard 1: Specificity Over Generality

**Source:** Anthropic prompt engineering docs

Write concrete, specific instructions. Generic instructions lead to vague outputs.

**Principle:**

- ✓ "Run `git diff --staged` to see what's in the index"
- ✗ "Check what's staged" (too vague)

**Application to skills:**

- Use exact command-line syntax where possible
- Include flags and options relevant to the task
- Show the output format the user can expect
- Example: "Run `docker ps -a --format 'table {{.ID}}\t{{.Status}}'` to list all containers with status"

---

## Standard 2: Concrete, Diverse Examples

**Source:** Brown et al. 2020 (Few-Shot Learning); OpenAI agent/tool design docs

Examples teach the agent through demonstration. Diverse examples cover edge cases.

**Principle:**

- Provide 2–3 realistic, runnable examples per major workflow
- Cover the happy path AND common edge cases
- Show both successful and error cases (what to do when X fails)
- Examples should be copy-paste-ready or near-identical to real use

**Application to skills:**

- Example 1: common case (e.g., `git rebase` on a clean branch)
- Example 2: gotcha case (e.g., `git rebase` with merge conflicts)
- Example 3: error recovery (e.g., abort and start over)
- If a skill has 3+ major workflows, dedicate a reference file to examples

---

## Standard 3: Step-by-Step Numbered Workflows

**Source:** Wei et al. 2022 (Chain-of-Thought); Kojima et al. 2022 (Zero-Shot CoT)

Numbered steps signal sequence and provide checkpoints for verification.

**Principle:**

- Use ordered lists (1, 2, 3, ...) for multi-step procedures
- Each step is atomic and verifiable
- Include verification steps ("Confirm X succeeded before proceeding")

**Application to skills:**

```markdown
### Example Workflow: Rebase onto main

1. Fetch the latest main: `git fetch origin main`
2. Start rebase: `git rebase -i origin/main`
3. Squash or reword commits as needed
4. Force-push: `git push origin <branch> --force-with-lease`
5. Verify: `git log -p <branch>..origin/main` (should be empty)
```

---

## Standard 4: Verification Steps After Actions

**Source:** Wang et al. 2022 (Self-Consistency); OpenAI safe tool design

Always include a step after an action to verify success.

**Principle:**

- After writing data, read it back
- After executing a command, show how to check its result
- Provide explicit success/failure indicators

**Application to skills:**

```markdown
1. Create the file: `touch my-file.txt`
2. Verify it was created: `ls -la my-file.txt` (should list the file)
3. Check contents: `cat my-file.txt` (should show what you wrote)
```

---

## Standard 5: Explicit Failure Modes

**Source:** OpenAI agent/tool design; defensive programming

Document what to do when commands fail, not only when they succeed.

**Principle:**

- Describe common failure scenarios (permission denied, file not found, etc.)
- Provide recovery steps for each failure mode
- Include examples of error messages and what they mean

**Application to skills:**

```markdown
### If you get "Permission denied"

This means the file or directory is not writable. Try:
1. Check permissions: `ls -la <path>`
2. Add write permission: `chmod u+w <path>`
3. Retry the operation
```

---

## Standard 6: Single Responsibility

**Source:** OpenAI agent/tool design; Unix philosophy

Skills should have a narrow, well-defined scope.

**Principle:**

- One skill = one tool or closely-related set of operations
- Explicitly state what the skill does NOT cover
- Reference other skills for related but distinct tasks

**Application to skills:**

```markdown
## Scope

This skill covers:
- Creating and managing branches
- Rebasing and fast-forwarding
- Undoing commits

This skill does NOT cover:
- GitHub PR workflows (see `gh` skill)
- Bisecting and blame (use `git` man pages)
```

---

## Standard 7: Specify Output Format

**Source:** Anthropic prompt engineering docs

Always specify what output the agent should expect or produce.

**Principle:**

- Describe the format of command output before showing examples
- If the skill produces artifacts, specify their structure
- Use structured examples (tables, JSON, code blocks) consistently

**Application to skills:**

```markdown
### Output Format

Commands output status as:
\`\`\`
On branch main
Your branch is ahead of 'origin/main' by 3 commits
\`\`\`

Parse this to extract:
- Current branch name
- Commit count difference
```

---

## Standard 8: Context Window Efficiency

**Source:** Wei et al. 2022; Anthropic prompt engineering

Critical information must be early, not buried in the middle.

**Principle:**

- Front-load the most important information
- Use progressive disclosure: quick start → detailed workflows → edge cases
- Indent rarely-used content under collapsible sections (if the platform supports it)

**Application to skills:**

1. **Intent Router** at the very top: which reference to load when
2. **Quick Reference** next: the 80% case in <20 lines
3. **Workflows** after: detailed step-by-step for 3–4 major tasks
4. **Edge Cases / Troubleshooting** last: rare but important scenarios

---

## Integration Checklist

When designing a new skill or validating an existing one, verify:

- [ ] **Specificity:** Examples are concrete and runnable, not vague
- [ ] **Diversity:** Examples cover happy path, gotchas, and error recovery
- [ ] **Steps:** Multi-step workflows are numbered and atomic
- [ ] **Verification:** Each step includes a way to confirm success
- [ ] **Failures:** Common error modes and recovery are documented
- [ ] **Scope:** Single responsibility is clear; related-but-different tasks are referenced
- [ ] **Format:** Output format is specified and shown in examples
- [ ] **Efficiency:** Critical info is early; details are progressive

---

## Academic References

- **Wei et al. 2022** — Chain-of-Thought Prompting: Enables complex reasoning by having the model show its work step-by-step.
- **Brown et al. 2020** — Few-Shot Learning: Diverse examples teach the model more effectively than general instructions.
- **Wang et al. 2022** — Self-Consistency: Multiple paths to the same answer improve reliability; include verification steps.
- **Kojima et al. 2022** — Zero-Shot Chain-of-Thought: Simple prompt "Let's think step by step" improves reasoning.
- **Zhou et al. 2022** — Large Language Models Are Human-Level Prompt Engineers (APE): Automatically-generated prompts often outperform handwritten ones; iterative refinement is key.

---

## When to Load This File

Load this reference when:

- Designing a new skill from scratch (Step 2: Plan Bundled Resources)
- Reviewing skill quality and effectiveness (validation rubric criterion V08)
- Struggling with how to phrase a workflow or example
- Wondering whether a skill has adequate edge case coverage
