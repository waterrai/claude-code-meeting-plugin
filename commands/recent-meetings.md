---
description: List recent WaterrAI meetings, most recent first
argument-hint: "[limit]"
allowed-tools: "mcp__waterr-ai__list_meetings"
---

Call the `list_meetings` tool. If `$1` is provided and is a number between 1 and 100, pass it as the `limit` argument; otherwise omit `limit`.

Render the result as a table: id, status, participant, scenario_id, started_at.
