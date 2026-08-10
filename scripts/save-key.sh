#!/usr/bin/env bash
# Validate + persist a wai_ API key. Invoked by /waterr-ai:setup.
#
# Usage: save-key.sh <key>
#   - Validates shape (must start with `wai_`)
#   - Validates against the prod MCP server (initialize handshake)
#   - On success: writes to $CLAUDE_PLUGIN_DATA/key with 0600 perms
#   - Prints a structured single-line result the model can parse:
#       OK              — key valid + saved
#       INVALID_SHAPE   — doesn't start with wai_
#       INVALID_KEY     — server rejected (401)
#       NETWORK_ERROR   — couldn't reach the server
#       WRITE_ERROR     — couldn't save

set -euo pipefail

KEY="${1:-}"
URL="${WATERR_MCP_URL:-https://waterr.ai/backend/mcp}"
DATA_DIR="${CLAUDE_PLUGIN_DATA:-$HOME/.claude/plugins/data/waterr-ai}"

if [ -z "$KEY" ]; then
  echo "INVALID_SHAPE: empty key"
  exit 1
fi

case "$KEY" in
  wai_*) ;;
  *) echo "INVALID_SHAPE: key must start with wai_"; exit 1 ;;
esac

# Response body lands in a 0600 temp file under the plugin data dir (never
# world-readable /tmp — the response may echo account details).
mkdir -p "$DATA_DIR" || { echo "WRITE_ERROR: cannot create $DATA_DIR"; exit 1; }
umask 077
RESP_FILE=$(mktemp "$DATA_DIR/.setup-resp.XXXXXX") || { echo "WRITE_ERROR: cannot create temp file"; exit 1; }
trap 'rm -f "$RESP_FILE"' EXIT

HTTP_CODE=$(curl -sS -o "$RESP_FILE" -w "%{http_code}" \
  -X POST "$URL" \
  -H "Authorization: Bearer $KEY" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  --max-time 10 \
  -d '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"waterr-setup","version":"1"}}}' \
  2>/dev/null) || { echo "NETWORK_ERROR: could not reach $URL"; exit 1; }

BODY=$(cat "$RESP_FILE" 2>/dev/null || echo "")

case "$HTTP_CODE" in
  200)
    mkdir -p "$DATA_DIR" || { echo "WRITE_ERROR: cannot create $DATA_DIR"; exit 1; }
    umask 077
    printf '%s' "$KEY" > "$DATA_DIR/key" || { echo "WRITE_ERROR: cannot write $DATA_DIR/key"; exit 1; }
    chmod 600 "$DATA_DIR/key" 2>/dev/null || true
    echo "OK: saved to $DATA_DIR/key"
    ;;
  401)
    echo "INVALID_KEY: server rejected key (HTTP 401)"
    exit 1
    ;;
  *)
    echo "NETWORK_ERROR: unexpected HTTP $HTTP_CODE from $URL"
    exit 1
    ;;
esac
