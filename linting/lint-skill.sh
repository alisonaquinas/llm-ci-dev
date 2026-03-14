#!/bin/bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ $# -ne 1 ]]; then
  echo "Usage: bash linting/lint-skill.sh <skill-dir>" >&2
  exit 1
fi

skill_dir="$1"
skill_name="$(basename "$skill_dir")"

if [[ ! -d "$skill_dir" ]]; then
  echo "Error: skill directory '$skill_dir' not found" >&2
  exit 1
fi

exec python3 "$REPO_ROOT/scripts/lint_skills.py" "$skill_name"
