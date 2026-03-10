#!/bin/bash
# skills/yaml-lsp/scripts/start-server.sh
# Wrapper script to start the YAML Language Server in Docker.
# Usage: bash start-server.sh --stdio
#        bash start-server.sh --socket=7998

set -euo pipefail

MODE="${1:---stdio}"

case "$MODE" in
  --stdio)
    docker run --rm -i -v "$(pwd):/workspace" node:lts-alpine \
      npx --yes yaml-language-server --stdio
    ;;
  --socket=*)
    PORT="${MODE#--socket=}"
    docker run --rm -p "$PORT:$PORT" -v "$(pwd):/workspace" node:lts-alpine \
      npx --yes yaml-language-server --socket="$PORT"
    ;;
  *)
    echo "Usage: $0 [--stdio | --socket=PORT]" >&2
    exit 1
    ;;
esac
