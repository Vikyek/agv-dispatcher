# Quota Minimization, Dual-Provider & Self-Scaling Orchestration

- **Pre-Task Assessment**: Explicitly state model & effort assessment at start of task before executing first tool call.
- **Dual Quota Pool Balancing**: Utilize separate rate limits across Gemini (`flash`/`pro`) and Claude (`inherit` / Claude) in AGY CLI to prevent quota exhaustion on long sessions.
- **Subagent Tiering**: Use `flash_lite` for quick reads/indexing, `flash` for standard edits, and `pro` / Claude for complex architectural logic.
- **Coordinator Successor Pattern**: If task complexity spikes, ambiguity rises, or 2+ execution failures occur, spawn a higher-tier Coordinator Successor subagent (`Model: 'pro'` / `inherit`) with compact state handoff payload to inherit orchestration without context bloat.
- **Structured Payload Compression**: Use `toon` MCP tools (`convert_to_toon` / `convert_to_json`) for structured JSON payloads.
- **Orchestrator Activation**: For tasks with 8+ estimated tool calls, `/goal` or `/plan` invocations, or 3+ independent subtasks, activate the `agy-vispatcher` skill and delegate to tiered worker subagents instead of executing everything in the parent context.
