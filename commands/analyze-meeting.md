---
description: Fetch the post-meeting analysis for a completed WaterrAI meeting
argument-hint: "<meeting_id>"
allowed-tools: "mcp__waterr-ai__get_analysis"
---

Call the `get_analysis` tool with `meeting_id = $1`. Render:

- **Overall summary** (paragraph)
- **Goal scores** as a table: goal name, score, max
- **Highlights** as a bulleted list

If the meeting hasn't ended yet, the tool will return an error — surface it cleanly and tell the user to run `/waterr-ai:get-meeting $1` to check status.
