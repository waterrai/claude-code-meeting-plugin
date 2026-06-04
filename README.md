# waterr-ai — Claude Code plugin

Pulls your WaterrAI workspace into Claude Code: scenarios, meetings, and post-meeting analyses, plus a `meeting-coach` subagent that gives honest critique.

## Install

```bash
# 1. Set your API key (grab it from waterr.ai → Settings → API keys)
export WATERR_API_KEY=wai_live_xxx

# 2. Add the marketplace + install the plugin (run inside Claude Code)
/plugin marketplace add waterrai/claude-code-meeting-plugin
/plugin install waterr-ai@waterr-ai
```

After install, restart Claude Code so the MCP server boots with your key in the environment.

## What you get

### Slash commands

| Command | What it does |
|---|---|
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

- **"Missing Authorization header" / 401**: `WATERR_API_KEY` wasn't set when Claude Code launched. Set it in your shell rc and reopen.
- **`npx` not found**: install Node.js ≥ 18.
- **Slash commands don't appear**: run `/plugin` and confirm `waterr-ai` is enabled.

## Local development

The plugin is the folder itself. To test against your local CoreBackend, edit `.mcp.json` and change the URL to `http://127.0.0.1:3000/mcp`.
