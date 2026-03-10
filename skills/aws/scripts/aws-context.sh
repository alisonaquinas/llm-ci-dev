#!/bin/bash
set -u
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"


usage() {
  cat <<'USAGE'
Usage: aws-context.sh

Shows active AWS profile, region, and discovered profile list.
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

active_profile="${AWS_PROFILE:-default}"
active_region="${AWS_REGION:-${AWS_DEFAULT_REGION:-}}"
if [[ -z "$active_region" ]]; then
  active_region="$(aws configure get region --profile "$active_profile" 2>/dev/null || true)"
fi
if [[ -z "$active_region" ]]; then
  active_region="unset"
fi

profiles="$(aws configure list-profiles 2>/dev/null || true)"
if [[ -z "$profiles" ]]; then
  profiles="none"
fi

echo "active profile: $active_profile"
echo "active region: $active_region"
echo "profiles:"
printf '%s\n' "$profiles" | sed -n '1,25p'

if [[ "$profiles" == "none" ]]; then
  exit 1
fi
exit 0
