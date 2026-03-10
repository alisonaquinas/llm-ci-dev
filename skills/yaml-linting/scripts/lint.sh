#!/bin/bash
# skills/yaml-linting/scripts/lint.sh
# Wrapper script to lint YAML files using yamllint in Docker.
# Usage: bash lint.sh <path>
#        bash lint.sh .         # Lint current directory
#        bash lint.sh file.yml  # Lint single file

set -euo pipefail

TARGET="${1:-.}"

if [[ ! -e "$TARGET" ]]; then
  echo "Error: path '$TARGET' does not exist" >&2
  exit 2
fi

ABSOLUTE_PATH="$(cd "$(dirname "$TARGET")" && pwd)/$(basename "$TARGET")"

docker run --rm -v "$ABSOLUTE_PATH:/data" pipelinecomponents/yamllint yamllint /data
