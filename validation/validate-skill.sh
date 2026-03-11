#!/bin/bash
# validation/validate-skill.sh
# Automated pre-flight: emits structured context for LLM rubric scoring.
# Usage: bash validation/validate-skill.sh skills/git

set -e

if [[ $# -ne 1 ]]; then
  echo "Usage: bash validation/validate-skill.sh <skill-dir>" >&2
  exit 1
fi

skill_dir="$1"
skill_name=$(basename "$skill_dir")
skill_md="$skill_dir/SKILL.md"

if [[ ! -f "$skill_md" ]]; then
  echo "Error: $skill_md not found" >&2
  exit 1
fi

# Extract metadata
name=$(grep '^name:' "$skill_md" | head -1 | sed 's/^name: *//')
description=$(sed -n '/^description:/,/^---$/p' "$skill_md" | sed '$d' | tail -n +2 | tr '\n' ' ')

# Count lines and sections
body_lines=$(tail -n +4 "$skill_md" | wc -l)
section_count=$(grep -c '^## ' "$skill_md" || true)
example_count=$(grep -c '^\`\`\`' "$skill_md" || true)
ref_files=$(find "$skill_dir/references" -name "*.md" 2>/dev/null | wc -l || echo 0)

# Check for Intent Router
has_intent_router=0
grep -q '^## Intent Router' "$skill_md" && has_intent_router=1

# Check for safety section
has_safety=0
grep -q -i '^## .*[Ss]afety\|^## .*[Dd]estructive\|^## .*[Gg]uardrail' "$skill_md" && has_safety=1

# Count code examples (code blocks)
code_block_count=$(grep -c '^```' "$skill_md" || echo 0)
code_block_count=$((code_block_count / 2))  # Divide by 2 for opening and closing

# Estimate coverage (rough heuristic: 80% is ideal)
if [[ $body_lines -gt 0 ]]; then
  coverage=$((body_lines * 100 / 450))  # 450 is the ideal body size
  if [[ $coverage -gt 100 ]]; then
    coverage=100
  fi
else
  coverage=0
fi

# Check for description elements
has_what=0
has_triggers=0
has_scenarios=0
has_not=0

echo "$description" | grep -qi 'use when' && has_triggers=1
echo "$description" | grep -qi 'when.*want' && has_triggers=1
echo "$description" | grep -q '[a-z]' && has_what=1
echo "$description" | grep -qi 'example\|scenario\|case' && has_scenarios=1
grep -q -i 'does not\|not.*cover\|out of scope' "$skill_md" && has_not=1

description_elements=$((has_what + has_triggers + has_scenarios))

# Print structured report
echo ""
echo "=========================================="
echo "Skill Validation Pre-Flight: $skill_name"
echo "=========================================="
echo ""

echo "## Metadata"
echo "Name: $name"
echo "Description length: ${#description} chars"
echo ""

echo "## Automated Metrics"
echo "Body line count: $body_lines"
echo "Section count: $section_count"
echo "Reference files: $ref_files"
echo "Code examples (blocks): $code_block_count"
echo "Has Intent Router: $([ $has_intent_router -eq 1 ] && echo 'Yes' || echo 'No')"
echo "Has Safety section: $([ $has_safety -eq 1 ] && echo 'Yes' || echo 'No')"
echo "Has scope boundary (\"does not cover\"): $([ $has_not -eq 1 ] && echo 'Yes' || echo 'No')"
echo ""

echo "## Coverage Estimate"
echo "Estimated quick-ref coverage: ~${coverage}%"
echo "Description completeness: ${description_elements}/3 elements (what, triggers, scenarios)"
echo ""

echo "## Description"
echo "$description"
echo ""

echo "## Intent Router Status"
if [[ $has_intent_router -eq 1 ]]; then
  echo "Intent Router found. References:"
  grep -A 20 '^## Intent Router' "$skill_md" | head -20
else
  echo "[No Intent Router detected in SKILL.md]"
fi
echo ""

echo "## First 5 Sections"
grep '^## ' "$skill_md" | head -5
echo ""

echo "## Recommendation"
if [[ $body_lines -lt 50 ]]; then
  echo "⚠ Body is very short (<50 lines); may need more detail"
elif [[ $body_lines -gt 500 ]]; then
  echo "⚠ Body is very long (>500 lines); consider moving to references/"
else
  echo "✓ Body length is reasonable"
fi

if [[ $code_block_count -lt 2 ]]; then
  echo "⚠ Few code examples (<2); add more for clarity"
elif [[ $code_block_count -gt 10 ]]; then
  echo "✓ Many code examples; good diversity"
else
  echo "✓ Code examples present and reasonable"
fi

if [[ $has_intent_router -eq 0 ]]; then
  echo "⚠ No Intent Router; add one to guide reference loading"
fi

if [[ $has_safety -eq 0 ]] && echo "$skill_md" | grep -q 'force\|rm\|delete\|destroy'; then
  echo "⚠ Skill may have destructive operations; add Safety section with guardrails"
fi

echo ""
echo "=========================================="
echo ""
echo "Next step: Load validation/rubric.md and score each V01–V08 criterion."
echo ""
