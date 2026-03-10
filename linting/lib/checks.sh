#!/bin/bash
# linting/lib/checks.sh
# Core linting functions for skill validation.
# Each function sets RESULT_<ID> and MSG_<ID> following a standard contract.

# Helper: emit a result with ID and severity
_emit() {
  local severity=$1 id=$2 msg=$3
  eval "RESULT_${id}='${severity}'"
  eval "MSG_${id}='${msg}'"
}

# Helper: strip YAML frontmatter from file (lines after line 3 until end)
_strip_frontmatter() {
  local file=$1
  tail -n +4 "$file"
}

# Check L01: Frontmatter fields (exactly name + description, no extras)
check_L01_frontmatter_fields() {
  local skill_dir=$1
  local skill_md="$skill_dir/SKILL.md"

  if [[ ! -f "$skill_md" ]]; then
    _emit FAIL L01 "SKILL.md not found"
    return
  fi

  # Count YAML fields in frontmatter
  local name_count=$(sed -n '2,/^---$/p' "$skill_md" | grep -c '^name:' || echo 0)
  local desc_count=$(sed -n '2,/^---$/p' "$skill_md" | grep -c '^description:' || echo 0)
  local other_count=$(sed -n '2,/^---$/p' "$skill_md" | grep -c '^[a-z_]*:' || echo 0)
  other_count=$((other_count - name_count - desc_count))

  if [[ $name_count -eq 1 && $desc_count -eq 1 && $other_count -eq 0 ]]; then
    _emit PASS L01 "Frontmatter has exactly 'name' and 'description'"
  else
    _emit FAIL L01 "Frontmatter must have only 'name' and 'description'; found name=$name_count desc=$desc_count other=$other_count"
  fi
}

# Check L02: name format (kebab-case, ≤64 chars, matches folder)
check_L02_name_format() {
  local skill_dir=$1
  local skill_md="$skill_dir/SKILL.md"
  local folder=$(basename "$skill_dir")

  if [[ ! -f "$skill_md" ]]; then
    _emit FAIL L02 "SKILL.md not found"
    return
  fi

  local name=$(grep '^name:' "$skill_md" | head -1 | sed 's/^name:[[:space:]]*//; s/[[:space:]]*$//')

  # Check kebab-case and length
  if ! [[ "$name" =~ ^[a-z0-9]([a-z0-9-]*[a-z0-9])?$ ]] || [[ ${#name} -gt 64 ]]; then
    _emit FAIL L02 "name must be kebab-case, ≤64 chars; got: '$name'"
    return
  fi

  # Check matches folder
  if [[ "$name" != "$folder" ]]; then
    _emit FAIL L02 "name '$name' does not match folder '$folder'"
    return
  fi

  _emit PASS L02 "name is valid kebab-case and matches folder"
}

# Check L03: Required files (SKILL.md, agents/openai.yaml, agents/claude.yaml)
check_L03_required_files() {
  local skill_dir=$1

  local files_missing=()
  [[ ! -f "$skill_dir/SKILL.md" ]] && files_missing+=("SKILL.md")
  [[ ! -f "$skill_dir/agents/openai.yaml" ]] && files_missing+=("agents/openai.yaml")
  [[ ! -f "$skill_dir/agents/claude.yaml" ]] && files_missing+=("agents/claude.yaml")

  if [[ ${#files_missing[@]} -eq 0 ]]; then
    _emit PASS L03 "All required files present"
  else
    _emit FAIL L03 "Missing files: ${files_missing[*]}"
  fi
}

# Check L04: Agent YAML fields
check_L04_agent_yaml_fields() {
  local skill_dir=$1

  local missing_openai=0
  local openai="$skill_dir/agents/openai.yaml"

  if [[ -f "$openai" ]]; then
    grep -q '^[[:space:]]*display_name:' "$openai" || ((missing_openai++))
    grep -q '^[[:space:]]*short_description:' "$openai" || ((missing_openai++))
    grep -q '^[[:space:]]*default_prompt:' "$openai" || ((missing_openai++))
  else
    missing_openai=3
  fi

  local missing_claude=0
  local claude="$skill_dir/agents/claude.yaml"

  if [[ -f "$claude" ]]; then
    grep -q '^[[:space:]]*display_name:' "$claude" || ((missing_claude++))
    grep -q '^[[:space:]]*short_description:' "$claude" || ((missing_claude++))
    grep -q '^[[:space:]]*default_prompt:' "$claude" || ((missing_claude++))
  else
    missing_claude=3
  fi

  if [[ $missing_openai -eq 0 && $missing_claude -eq 0 ]]; then
    _emit PASS L04 "Both agent YAML files have required fields"
  else
    local msg="missing fields: openai=$missing_openai claude=$missing_claude"
    _emit FAIL L04 "$msg"
  fi
}

# Check L05: short_description length (25–64 chars)
check_L05_short_description_length() {
  local skill_dir=$1

  local openai="$skill_dir/agents/openai.yaml"
  local claude="$skill_dir/agents/claude.yaml"

  local worst_severity=PASS worst_msg=""

  for yaml in "$openai" "$claude"; do
    if [[ -f "$yaml" ]]; then
      # Extract short_description value
      local desc=$(grep '^[[:space:]]*short_description:' "$yaml" | head -1 | sed 's/.*short_description:[[:space:]]*//; s/^"//; s/"$//')
      local len=${#desc}

      if [[ -n "$desc" ]]; then
        if [[ $len -lt 25 ]]; then
          worst_severity=WARN
          worst_msg="short_description too short ($len chars)"
        elif [[ $len -gt 64 ]]; then
          worst_severity=FAIL
          worst_msg="short_description too long ($len chars)"
        fi
      fi
    fi
  done

  if [[ "$worst_severity" == "PASS" ]]; then
    _emit PASS L05 "short_description within 25–64 chars"
  else
    _emit "$worst_severity" L05 "$worst_msg"
  fi
}

# Check L06: Body line count
check_L06_body_line_count() {
  local skill_dir=$1
  local skill_md="$skill_dir/SKILL.md"

  if [[ ! -f "$skill_md" ]]; then
    _emit FAIL L06 "SKILL.md not found"
    return
  fi

  local lines=$(tail -n +4 "$skill_md" | wc -l)

  if [[ $lines -ge 500 ]]; then
    _emit FAIL L06 "Body has $lines lines (max 500)"
  elif [[ $lines -ge 450 ]]; then
    _emit WARN L06 "Body has $lines lines (approaching 500-line limit)"
  else
    _emit PASS L06 "Body has $lines lines"
  fi
}

# Check L07: No dangling references
check_L07_no_dangling_references() {
  local skill_dir=$1
  local skill_md="$skill_dir/SKILL.md"

  if [[ ! -f "$skill_md" ]]; then
    _emit FAIL L07 "SKILL.md not found"
    return
  fi

  # Count reference files mentioned vs exist
  local mentioned=$(grep -o 'references/[a-z0-9._-]*\.md' "$skill_md" 2>/dev/null | sort -u | wc -l || echo 0)
  local existing=0
  [[ -d "$skill_dir/references" ]] && existing=$(find "$skill_dir/references" -name "*.md" 2>/dev/null | wc -l || echo 0)

  if [[ $mentioned -eq 0 ]]; then
    _emit PASS L07 "No dangling reference files"
  elif [[ $mentioned -eq $existing ]]; then
    _emit PASS L07 "No dangling reference files"
  else
    _emit FAIL L07 "Dangling references: mentioned=$mentioned existing=$existing"
  fi
}

# Check L08: Script syntax
check_L08_script_syntax() {
  local skill_dir=$1

  local bad_scripts=0
  if [[ -d "$skill_dir/scripts" ]]; then
    while IFS= read -r script; do
      if ! bash -n "$script" 2>/dev/null; then
        ((bad_scripts++))
      fi
    done < <(find "$skill_dir/scripts" -name "*.sh" -type f 2>/dev/null || true)
  fi

  if [[ $bad_scripts -eq 0 ]]; then
    _emit PASS L08 "All shell scripts have valid syntax"
  else
    _emit FAIL L08 "Script syntax errors found in $bad_scripts file(s)"
  fi
}

# Check L09: No platform language
check_L09_no_platform_language() {
  local skill_dir=$1
  local skill_md="$skill_dir/SKILL.md"

  if [[ ! -f "$skill_md" ]]; then
    _emit FAIL L09 "SKILL.md not found"
    return
  fi

  # Check for platform language in body (skip code fences)
  local body=$(tail -n +4 "$skill_md" | sed '/^```/,/^```$/d')

  if echo "$body" | grep -i "claude code\|\\bcodex\\b" > /dev/null 2>&1; then
    _emit FAIL L09 "Body mentions 'Claude Code' or 'Codex' (use 'the agent' instead)"
  else
    _emit PASS L09 "No platform-specific language in body"
  fi
}

# Check L10: No forbidden files
check_L10_no_forbidden_files() {
  local skill_dir=$1

  local forbidden=0
  [[ -f "$skill_dir/README.md" ]] && ((forbidden++))
  [[ -f "$skill_dir/CHANGELOG.md" ]] && ((forbidden++))
  [[ -f "$skill_dir/INSTALLATION_GUIDE.md" ]] && ((forbidden++))
  [[ -f "$skill_dir/QUICK_REFERENCE.md" ]] && ((forbidden++))
  [[ -f "$skill_dir/IMPLEMENTATION.md" ]] && ((forbidden++))

  if [[ $forbidden -eq 0 ]]; then
    _emit PASS L10 "No forbidden auxiliary files"
  else
    _emit FAIL L10 "Found $forbidden forbidden file(s) (README.md, CHANGELOG.md, etc.)"
  fi
}

# Check L11: No second-person language
check_L11_no_second_person() {
  local skill_dir=$1
  local skill_md="$skill_dir/SKILL.md"

  if [[ ! -f "$skill_md" ]]; then
    _emit FAIL L11 "SKILL.md not found"
    return
  fi

  local body=$(tail -n +4 "$skill_md" | sed '/^```/,/^```$/d')

  if echo "$body" | grep 'ou (should' > /dev/null 2>&1 || \
     echo "$body" | grep 'ou (can' > /dev/null 2>&1 || \
     echo "$body" | grep 'ou (need' > /dev/null 2>&1 || \
     echo "$body" | grep 'ou (must' > /dev/null 2>&1 || \
     echo "$body" | grep 'ou (will' > /dev/null 2>&1 || \
     echo "$body" | grep 'ou (are' > /dev/null 2>&1; then
    _emit WARN L11 "Body contains second-person language"
  else
    _emit PASS L11 "No second-person language"
  fi
}

# Check L12: Markdownlint compliance
check_L12_markdownlint() {
  local skill_dir=$1

  if ! command -v markdownlint-cli2 &>/dev/null; then
    _emit WARN L12 "markdownlint-cli2 not installed; skipping"
    return
  fi

  if markdownlint-cli2 "$skill_dir/**/*.md" 2>/dev/null; then
    _emit PASS L12 "Markdown linting passes"
  else
    _emit FAIL L12 "Markdown linting errors found"
  fi
}

# Run all checks
run_all_checks() {
  local skill_dir=$1

  check_L01_frontmatter_fields "$skill_dir"
  check_L02_name_format "$skill_dir"
  check_L03_required_files "$skill_dir"
  check_L04_agent_yaml_fields "$skill_dir"
  check_L05_short_description_length "$skill_dir"
  check_L06_body_line_count "$skill_dir"
  check_L07_no_dangling_references "$skill_dir"
  check_L08_script_syntax "$skill_dir"
  check_L09_no_platform_language "$skill_dir"
  check_L10_no_forbidden_files "$skill_dir"
  check_L11_no_second_person "$skill_dir"
  check_L12_markdownlint "$skill_dir"
}
