#!/bin/bash
set -u
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"


usage() {
  cat <<'USAGE'
Usage: aws-preflight.sh

Checks AWS CLI availability, version, and local profile/config visibility.
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
  echo "hint: install AWS CLI v2 and ensure 'aws' is on PATH"
  exit 127
fi

bin_path="$(command -v aws)"
version_output="$(aws --version 2>&1)"
version_rc=$?
config_file="${AWS_CONFIG_FILE:-$HOME/.aws/config}"
credentials_file="${AWS_SHARED_CREDENTIALS_FILE:-$HOME/.aws/credentials}"
active_profile="${AWS_PROFILE:-default}"
active_region="${AWS_REGION:-${AWS_DEFAULT_REGION:-unset}}"
profiles="$(aws configure list-profiles 2>/dev/null || true)"
profile_count="$(printf '%s\n' "$profiles" | sed '/^$/d' | wc -l | tr -d ' ')"

echo "aws binary: $bin_path"
echo "aws config file: $config_file"
echo "aws credentials file: $credentials_file"
echo "active profile: $active_profile"
echo "active region: $active_region"
echo "discovered profiles: $profile_count"

if [[ $version_rc -ne 0 ]]; then
  echo "version check status: failed"
  printf '%s\n' "$version_output"
  exit 1
fi

echo "version check status: ok"
printf '%s\n' "$version_output"
