#!/bin/bash
set -u
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"


usage() {
  cat <<'USAGE'
Usage: glab-auth-status.sh

Checks GitLab CLI authentication status.
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

if ! command -v glab >/dev/null 2>&1; then
  echo "glab binary: missing"
  exit 127
fi

requested_config="${GLAB_CONFIG_DIR:-$HOME/.config/glab-cli}"
effective_config="$requested_config"
if [[ -d "$requested_config" && ! -w "$requested_config" ]]; then
  effective_config="${TMPDIR:-/tmp}/glab-config-${USER:-user}"
  mkdir -p "$effective_config"
elif [[ ! -d "$requested_config" ]]; then
  parent_dir="$(dirname "$requested_config")"
  if [[ ! -w "$parent_dir" ]]; then
    effective_config="${TMPDIR:-/tmp}/glab-config-${USER:-user}"
    mkdir -p "$effective_config"
  fi
fi

status_output="$(GLAB_CONFIG_DIR="$effective_config" GLAB_CHECK_UPDATE=0 glab auth status 2>&1)"
status_rc=$?
clean_output="$(printf '%s\n' "$status_output" | sed -E '/[Tt]oken:/d')"

echo "requested config dir: $requested_config"
echo "effective config dir: $effective_config"

if [[ $status_rc -eq 0 ]]; then
  echo "auth status: authenticated"
  printf '%s\n' "$clean_output"
  exit 0
fi

echo "auth status: not-authenticated-or-unreachable"
printf '%s\n' "$clean_output" | sed -n '1,40p'
exit 1
