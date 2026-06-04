---
description: Fetch a WaterrAI meeting by id — status, join URL, timing
argument-hint: "<meeting_id>"
allowed-tools: "mcp__waterr-ai__get_meeting"
---

Call the `get_meeting` tool with `meeting_id = $1`. Show:

- **Status** and timestamps (created/started/ended)
- **Participant** name
- **Scenario** id (clickable hint: run `/waterr-ai:get-scenario <id>` for details)
- **Join URL** if the meeting hasn't ended

If `$1` is missing, ask the user for a meeting id instead of calling the tool.
