---
name: make
description: Run make commands, write Makefiles, and automate build tasks with GNU Make. Use when tasks mention make, Makefile, build targets, build automation, or GNU Make.
---

# Make

## Intent Router

| Request | Reference | Load When |
| --- | --- | --- |
| Install tool, first-time setup | `references/install-and-setup.md` | Install or verify GNU Make |
| Makefile syntax, variables, targets | `references/makefile-syntax.md` | Write or debug a Makefile |
| CLI commands, flags, dry run | `references/command-cookbook.md` | Run make with specific options |
| Patterns, functions, conditionals | `references/patterns-and-functions.md` | Use advanced Make features |

## Quick Start

```bash
# Run default target (usually 'all')
make

# Preview what would run (dry run — no changes)
make -n

# Run specific target
make build

# Run with parallel jobs
make -j4

# Clean build artifacts
make clean
```

## Core Command Tracks

- **Default target:** `make` — runs the first target or `.DEFAULT_GOAL`
- **Dry run:** `make -n` — prints commands without executing them
- **Specific target:** `make <target>` — runs a named target
- **Parallel:** `make -j N` — run N jobs in parallel
- **Force rebuild:** `make -B` — treat all targets as out of date
- **Different file:** `make -f <file>` — use a non-default Makefile
- **Change directory:** `make -C <dir>` — run make in another directory
- **Verbose:** `make V=1` — show full compiler commands (when supported)

## Safety Guardrails

- Always run `make -n` before running an unknown Makefile — review the commands it would execute.
- Declare `.PHONY` targets for any target that is not a real file (e.g., `clean`, `install`, `all`).
- Use `$(MAKE)` instead of `make` for recursive invocations — preserves flags and job count.
- Be explicit about target dependencies to avoid incorrect incremental builds.
- Avoid spaces in Makefile recipe lines — **recipes must be indented with a tab**, not spaces.

## Related Skills

- **cmake** — cross-platform build system generator that can emit Makefiles
- **ci-architecture** — integrating Make targets into CI/CD pipelines

## References

- `references/install-and-setup.md`
- `references/makefile-syntax.md`
- `references/command-cookbook.md`
- `references/patterns-and-functions.md`
- Official manual: <https://www.gnu.org/software/make/manual/>
- GNU Make reference card: <https://www.gnu.org/software/make/manual/make.html>
