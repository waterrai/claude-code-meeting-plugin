---
description: Show a WaterrAI scenario in full — prompt, persona, goals
argument-hint: "<scenario_id>"
allowed-tools: "mcp__waterr-ai__get_scenario"
---

Call the `get_scenario` tool with `scenario_id = $1`. Render the result as:

- **Name** and description
- **Persona** (one line)
- **Goals** (bulleted)
- **Prompt** in a fenced block

If `$1` is missing or doesn't look like a UUID, tell the user the expected argument format instead of calling the tool.
