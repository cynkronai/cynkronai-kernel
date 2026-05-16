#!/bin/bash
set -euo pipefail

# Only run in remote Claude Code environments
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

KERNEL_DIR="${CLAUDE_PROJECT_DIR:-.}"

# Verify required kernel files are present
REQUIRED_FILES=("AGENTS.md" "CLAUDE.md" "COVEX_AGENT_LOADER.md")
for f in "${REQUIRED_FILES[@]}"; do
  if [ ! -f "$KERNEL_DIR/$f" ]; then
    echo "ERROR: Required kernel file missing: $f" >&2
    exit 1
  fi
done

# Export kernel path for the session
{
  echo "export CYNKRONAI_KERNEL_DIR=\"$KERNEL_DIR\""
  echo "export CYNKRONAI_AGENTS_FILE=\"$KERNEL_DIR/AGENTS.md\""
  echo "export CYNKRONAI_COVEX_FILE=\"$KERNEL_DIR/COVEX_AGENT_LOADER.md\""
} >> "${CLAUDE_ENV_FILE:-/dev/null}"

echo "CYNKRONAI Kernel loaded: $KERNEL_DIR"
