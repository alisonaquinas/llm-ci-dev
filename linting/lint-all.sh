#!/bin/bash
# linting/lint-all.sh
# Batch runner: iterate skills/*/ and lint each one.
# Exits 0 if all skills have zero FAILs, 1 if any skill has FAILs.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

total_fails=0
total_skills=0

echo "Linting all skills in: $REPO_ROOT/skills"
echo ""

for skill_dir in "$REPO_ROOT/skills"/*; do
  if [[ -d "$skill_dir" && -f "$skill_dir/SKILL.md" ]]; then
    skill_name=$(basename "$skill_dir")
    ((total_skills++))

    # Run lint-skill.sh and capture exit code
    if bash "$SCRIPT_DIR/lint-skill.sh" "$skill_dir" 2>&1 | tail -20; then
      :
    else
      ((total_fails++))
    fi
    echo ""
  fi
done

echo "=================================================="
echo "Summary: $total_skills skill(s) checked"
[[ $total_fails -eq 0 ]] && echo "✓ All skills passed linting" || echo "✗ $total_fails skill(s) have lint failures"
echo ""

exit $(( total_fails > 0 ? 1 : 0 ))
