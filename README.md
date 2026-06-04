# waterr-ai — Claude Code plugin

Pulls your WaterrAI workspace into Claude Code: scenarios, meetings, and post-meeting analyses, plus a `meeting-coach` subagent that gives honest critique.

## Install

Inside Claude Code:

```
/plugin marketplace add waterrai/claude-code-meeting-plugin
/plugin install waterr-ai@waterr-ai
/waterr-ai:setup
```

`/waterr-ai:setup` will:

1. Walk you through generating an API key at https://waterr.ai/settings/api-keys
2. Validate the key against the server (rejects typos / revoked keys)
3. Save it to `~/.claude/plugins/data/waterr-ai/key` with `0600` perms

Then **restart Claude Code** (Cmd-Q + reopen) so the MCP server boots with the key.

### Alternative: env var (for power users / CI)

If you'd rather skip the setup flow, export the key before launching Claude Code:

```bash
export WATERR_API_KEY=wai_live_xxx
```

The wrapper checks `WATERR_API_KEY` first, then falls back to the saved key file.

## What you get

### Slash commands

| Command | What it does |
| --- | --- |
| `/waterr-ai:setup` | One-time API key configuration (validates against the server) |
| `/waterr-ai:list-scenarios` | List all scenarios in your workspace |
| `/waterr-ai:get-scenario <id>` | Full scenario details |
| `/waterr-ai:recent-meetings [limit]` | Recent meetings, most recent first |
| `/waterr-ai:get-meeting <id>` | Status + join URL of a single meeting |
| `/waterr-ai:analyze-meeting <id>` | Post-meeting analysis (scores, highlights) |

### Subagent

`meeting-coach` — invoke with *"review meeting `<id>`"* and it pulls the analysis, transcript, and original scenario, then gives a direct critique. No platitudes.

### MCP tools (used by the above)

The plugin registers a `waterr-ai` MCP server bridged from `https://waterr.ai/backend/mcp`. Tools: `list_scenarios`, `get_scenario`, `list_meetings`, `get_meeting`, `get_analysis`.

## Troubleshooting

- **"Missing Authorization header" / 401**: Run `/waterr-ai:setup` to (re)save the key, then restart Claude Code.
- **"No API key found"** at MCP startup: setup wasn't run yet, or the saved key file was deleted. Run `/waterr-ai:setup`.
- **`npx` not found**: install Node.js ≥ 18.
- **Slash commands don't appear**: run `/plugin` and confirm `waterr-ai` is enabled.

## Local development

The plugin is the folder itself. To test against your local CoreBackend, edit `.mcp.json` and change the URL to `http://127.0.0.1:3000/mcp`.
