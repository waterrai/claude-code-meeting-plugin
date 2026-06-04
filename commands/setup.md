---
description: Set up your WaterrAI API key for this plugin (validates against the server before saving)
argument-hint: "[wai_key]"
allowed-tools: "Bash"
---

You are running the WaterrAI plugin setup flow.

**Step 1 — Get the key.**

If the user passed a key as `$1` (starts with `wai_`), use it directly and skip to Step 2.

Otherwise, tell the user:

> To connect this plugin to your WaterrAI workspace, I need your API key.
>
> 1. Go to https://waterr.ai/settings/api-keys
> 2. Click **Create new key**, name it "Claude Code", copy it
> 3. Paste it as your next message (starts with `wai_live_` or `wai_test_`)
>
> Your key is stored locally at `~/.claude/plugins/data/waterr-ai/key` with 0600 permissions. It never leaves your machine except in `Authorization` headers to `waterr.ai`.

Then **wait for the user's next message** containing the key.

**Step 2 — Validate and save.**

Run this **exactly** (replace `<KEY>` with the actual key the user provided):

```bash
"${CLAUDE_PLUGIN_ROOT}/scripts/save-key.sh" "<KEY>"
```

The script prints one of:

- `OK: saved to ...` → key works, saved. Tell the user: **"Connected. Restart Claude Code (Cmd-Q then reopen) so the MCP server picks up the key. After that, try `/waterr-ai:list-scenarios`."**
- `INVALID_SHAPE: ...` → not a `wai_` key. Ask the user to paste again.
- `INVALID_KEY: ...` → key was rejected by the server. Tell the user it might be revoked or copied wrong, and ask them to try again or generate a new one.
- `NETWORK_ERROR: ...` → couldn't reach waterr.ai. Ask the user to check their connection.

**Step 3 — Do NOT** echo the key back to the user. Do NOT save it anywhere except via the script. Do NOT read the saved key file with the Read tool.
