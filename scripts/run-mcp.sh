#!/usr/bin/env bash
# Wrapper invoked by .mcp.json. Resolves the WaterrAI credential from (in order):
#   1. $WATERR_API_KEY env var (legacy / power users)
#   2. ${CLAUDE_PLUGIN_DATA:-$HOME/.claude/plugins/data/waterr-ai}/key (set by /waterr-ai:setup)
#   3. No key at all → mcp-remote's native OAuth flow (discovery via
#      WWW-Authenticate → browser consent at waterr.ai → PKCE token exchange).
#
# With a key, execs mcp-remote with the bearer header; without one, OAuth.

set -euo pipefail

URL="${WATERR_MCP_URL:-https://waterr.ai/backend/mcp}"
DATA_DIR="${CLAUDE_PLUGIN_DATA:-$HOME/.claude/plugins/data/waterr-ai}"
KEY_FILE="$DATA_DIR/key"

KEY="${WATERR_API_KEY:-}"
if [ -z "$KEY" ] && [ -r "$KEY_FILE" ]; then
  KEY="$(tr -d '[:space:]' < "$KEY_FILE")"
fi

if [ -z "$KEY" ]; then
  echo "[waterr-ai] No API key configured — using the OAuth sign-in flow." >&2
  echo "[waterr-ai] (Prefer a key? Run /waterr-ai:setup or export WATERR_API_KEY.)" >&2
  exec npx -y mcp-remote "$URL"
fi

exec npx -y mcp-remote "$URL" --header "Authorization: Bearer $KEY"
