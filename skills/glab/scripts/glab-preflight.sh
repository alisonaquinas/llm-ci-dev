#!/bin/bash
set -u
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"


usage() {
  cat <<'USAGE'
Usage: glab-preflight.sh

Checks GitLab CLI availability, version, and config directory accessibility.
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
  echo "hint: install GitLab CLI and ensure 'glab' is on PATH"
  exit 127
fi

bin_path="$(command -v glab)"
requested_config="${GLAB_CONFIG_DIR:-$HOME/.config/glab-cli}"
effective_config="$requested_config"
config_note=""

if [[ -d "$requested_config" ]]; then
  if [[ ! -w "$requested_config" ]]; then
    effective_config="${TMPDIR:-/tmp}/glab-config-${USER:-user}"
    mkdir -p "$effective_config"
    config_note="requested config directory is not writable; using $effective_config for this check"
  fi
else
  parent_dir="$(dirname "$requested_config")"
  if [[ ! -w "$parent_dir" ]]; then
    effective_config="${TMPDIR:-/tmp}/glab-config-${USER:-user}"
    mkdir -p "$effective_config"
    config_note="cannot create requested config directory; using $effective_config for this check"
  fi
fi

version_output="$(GLAB_CONFIG_DIR="$effective_config" GLAB_CHECK_UPDATE=0 glab version 2>&1 | sed -n '1,20p')"
version_rc=$?

echo "glab binary: $bin_path"
echo "requested config dir: $requested_config"
echo "effective config dir: $effective_config"
if [[ -n "$config_note" ]]; then
  echo "note: $config_note"
fi

if [[ $version_rc -ne 0 ]]; then
  echo "version check status: failed"
  printf '%s\n' "$version_output"
  exit 1
fi

echo "version check status: ok"
printf '%s\n' "$version_output"
