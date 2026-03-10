#!/bin/bash
set -u
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"


usage() {
  cat <<'USAGE'
Usage: aws-auth-status.sh

Checks AWS authentication by calling sts get-caller-identity.
USAGE
}

if [[ "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ -n "${1:-}" ]]; then
  echo "Unknown argument: $1" >&2
  usage >&2
  exit 2
fi

if ! command -v aws >/dev/null 2>&1; then
  echo "aws binary: missing"
  exit 127
fi

identity_output="$(aws sts get-caller-identity --output json --no-cli-pager 2>&1)"
identity_rc=$?

if [[ $identity_rc -eq 0 ]]; then
  echo "auth status: authenticated"
  printf '%s\n' "$identity_output"
  exit 0
fi

echo "auth status: not-authenticated-or-unreachable"
printf '%s\n' "$identity_output" | sed -n '1,30p'
exit 1
