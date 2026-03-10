#!/bin/bash
set -u
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"


usage() {
  cat <<'USAGE'
Usage: glab-context.sh

Shows GitLab CLI host and repository context.
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

auth_snapshot="$(GLAB_CONFIG_DIR="$effective_config" GLAB_CHECK_UPDATE=0 glab auth status 2>&1 | sed -E '/[Tt]oken:/d')"
hosts="$(printf '%s\n' "$auth_snapshot" | awk '/^[A-Za-z0-9.-]+$/ {print $1}')"
if [[ -z "$hosts" ]]; then
  hosts="none"
fi

configured_host="$(GLAB_CONFIG_DIR="$effective_config" GLAB_CHECK_UPDATE=0 glab config get host 2>/dev/null || true)"
if [[ -z "$configured_host" ]]; then
  configured_host="unset"
fi

origin_url=""
if command -v git >/dev/null 2>&1; then
  origin_url="$(git remote get-url origin 2>/dev/null || true)"
fi
if [[ -z "$origin_url" ]]; then
  origin_url="none"
fi

echo "requested config dir: $requested_config"
echo "effective config dir: $effective_config"
echo "configured host: $configured_host"
echo "authenticated hosts:"
printf '%s\n' "$hosts"
echo "origin remote: $origin_url"

if [[ "$hosts" == "none" ]]; then
  exit 1
fi
exit 0
