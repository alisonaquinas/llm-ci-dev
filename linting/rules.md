# Linting Rules for CI/CD Skills

This document outlines the automated quality checks applied to all skills in this collection.

## Overview

The linting system validates structural correctness, YAML syntax, markdown formatting, and
cross-platform compatibility. All skills **must pass** all FAIL-level checks before commit.

## Rule Reference

(Linting rules will be defined as skills are added.)

## Running Linting

To lint a single skill:

```bash
bash linting/lint-skill.sh skills/<name>
```

To lint all skills:

```bash
bash linting/lint-all.sh
```

## Override Mechanism

To skip a linting rule for a specific file, add a comment:

```yaml
---
name: example
description: >
  Example skill description.

  <!-- lint-skip: L01 -->
---
```

Use this sparingly and document why the rule is skipped.
