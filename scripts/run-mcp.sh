#!/usr/bin/env bash
# Wrapper invoked by .mcp.json. Resolves the WaterrAI API key from (in order):
#   1. $WATERR_API_KEY env var (legacy / power users)
#   2. ${CLAUDE_PLUGIN_DATA:-$HOME/.claude/plugins/data/waterr-ai}/key (set by /waterr-ai:setup)
#
# Then execs mcp-remote against the prod MCP endpoint with the bearer header.

set -euo pipefail

URL="${WATERR_MCP_URL:-https://waterr.ai/backend/mcp}"
DATA_DIR="${CLAUDE_PLUGIN_DATA:-$HOME/.claude/plugins/data/waterr-ai}"
KEY_FILE="$DATA_DIR/key"

KEY="${WATERR_API_KEY:-}"
if [ -z "$KEY" ] && [ -r "$KEY_FILE" ]; then
  KEY="$(tr -d '[:space:]' < "$KEY_FILE")"
fi

if [ -z "$KEY" ]; then
  cat >&2 <<EOF
[waterr-ai] No API key found.
  Run /waterr-ai:setup inside Claude Code, or:
  export WATERR_API_KEY=wai_live_xxx
EOF
  exit 1
fi

exec npx -y mcp-remote "$URL" --header "Authorization: Bearer $KEY"
