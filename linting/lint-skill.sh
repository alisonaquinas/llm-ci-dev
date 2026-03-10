#!/bin/bash
# linting/lint-skill.sh
# Entry point: lint one skill directory.
# Exits 0 if zero FAILs, 1 if any FAILs found.
# Usage: bash linting/lint-skill.sh skills/git

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/checks.sh"

if [[ $# -ne 1 ]]; then
  echo "Usage: bash linting/lint-skill.sh <skill-dir>" >&2
  exit 1
fi

skill_dir="$1"

if [[ ! -d "$skill_dir" ]]; then
  echo "Error: skill directory '$skill_dir' not found" >&2
  exit 1
fi

skill_name=$(basename "$skill_dir")

# Run all checks
run_all_checks "$skill_dir"

# Print summary table
echo ""
echo "Lint Results for: $skill_name"
echo "=================================================="
printf "%-6s %-6s %s\n" "Rule" "Result" "Message"
echo "--------------------------------------------------"

for id in L01 L02 L03 L04 L05 L06 L07 L08 L09 L10 L11 L12; do
  result_var="RESULT_${id}"
  msg_var="MSG_${id}"
  result=${!result_var:-SKIP}
  msg=${!msg_var:-"(no message)"}
  printf "%-6s %-6s %s\n" "$id" "$result" "$msg"
done

# Count FAILs
fail_count=0
for id in L01 L02 L03 L04 L05 L06 L07 L08 L09 L10 L11 L12; do
  result_var="RESULT_${id}"
  [[ "${!result_var}" == "FAIL" ]] && ((fail_count++))
done

echo "--------------------------------------------------"
[[ $fail_count -eq 0 ]] && echo "✓ All checks passed" || echo "✗ $fail_count check(s) failed"
echo ""

exit $(( fail_count > 0 ? 1 : 0 ))
