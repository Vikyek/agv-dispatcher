---
name: agv-dispatcher
description: >
  Token-efficient task orchestration system. Activates on complex multi-step tasks,
  /goal commands, or when task naturally decomposes into 3+ independent subtasks.
  Routes work to optimally-tiered worker subagents across Gemini and Claude quota pools.
  WHEN: complex task, /goal, multi-phase work, parallel subtasks, quota pressure,
  orchestrate, dispatch, delegate, coordinate workers.
---

# Dispatcher System

## Activation Criteria

Activate this skill when ANY of these conditions are met:
- User invoked `/goal` or `/plan`
- Task decomposes into 3+ independent subtasks
- Task spans multiple domains (e.g., infra + frontend + docs)
- Estimated tool calls exceed 8
- Quota pressure detected on current provider

Do NOT activate for:
- Simple Q&A (respond directly)
- Single file edits (<3 tool calls)
- Quick shell commands
- Sequential tasks with tight dependencies

## Decision Matrix

| Signal | Action | Model |
|:---|:---|:---|
| 1-2 tool calls, trivial | Execute directly, no subagent | Current model |
| Read-only recon, file listing, status check | Spawn Scout | `flash_lite` |
| Standard edits, bug fix, doc update | Spawn Worker | `flash` |
| Multi-file refactor, architecture, complex debug | Spawn Architect | `pro` or Claude |
| 2+ worker failures, complexity spike, ambiguity | Spawn Coordinator Successor | `pro` or Claude |
| Quota approaching limit on current provider | Switch to alternate provider pool | Opposite pool |

## Quota Balancing Protocol

1. Track mental estimate of tokens consumed this session per provider.
2. If approaching perceived rate limit on Gemini → route next subagent to Claude.
3. If approaching perceived rate limit on Claude → route next subagent to Gemini.
4. Orchestrator itself should run on cheapest viable model (flash preferred).

## Worker Agent Definitions

### Scout Agent
- **Model**: `flash_lite`
- **Tools**: Read-only (`enable_write_tools: false`, `enable_mcp_tools: true`)
- **MCP Config**: `scout` (loads ONLY `codegraph`)
- **System prompt**: "Return terse factual summary. No edits. No suggestions unless asked."

### Worker Agent
- **Model**: `flash`
- **Tools**: Full write access (`enable_write_tools: true`, `enable_mcp_tools: true`)
- **MCP Config**: `worker` (loads ONLY `toon`)
- **System prompt**: "Execute task surgically. Return diff summary and verification result."

### Architect Agent
- **Model**: `pro` or Claude (`inherit` when parent is Claude)
- **Tools**: Full write access + MCP tools (`enable_write_tools: true`, `enable_mcp_tools: true`)
- **MCP Config**: `architect` (loads all: `codegraph`, `context-mode`, `toon`)
- **System prompt**: "Analyze thoroughly. Propose approach before executing. Verify with tests."

## Tool Schema Pruning (MCP Token Optimization)

To reduce token overhead in subagents, the Dispatcher MUST write a pruned `.agents/mcp_config.json` inside the worker's branched workspace directory *before* calling `invoke_subagent`.

### Scout MCP Config Template (only `codegraph`)
```json
{
  "mcpServers": {
    "codegraph": {
      "command": "/home/v/.local/bin/codegraph",
      "args": ["serve", "--mcp"],
      "trust": true
    }
  }
}
```

### Worker MCP Config Template (only `toon`)
```json
{
  "mcpServers": {
    "toon": {
      "command": "/home/v/.local/share/toon-venv/bin/toon-mcp-server",
      "args": []
    }
  }
}
```

### Architect MCP Config Template (Full Suite)
Use the global `~/.gemini/config/mcp_config.json` directly (no pruning needed, or copy it verbatim).

## State Handoff Protocol (Coordinator Successor)

When spawning a Coordinator Successor, pass this structured payload:

```
## Dispatcher Handoff

### Goal
[Original user request, verbatim]

### Completed Steps
- [Step 1]: [status] [outcome summary]
- [Step 2]: [status] [outcome summary]

### Pending Steps
- [Step N]: [description] [blockers if any]

### Active Workers
- [subagent-id]: [role] [model] [current task] [status]

### Failures & Blockers
- [failure description] [root cause if known]

### Key Files Modified
- [file path]: [what changed]

### Context Notes
- [Any critical context the successor needs]
```

## Parallel Execution Rules

1. Independent subtasks → spawn workers concurrently via single `invoke_subagent` call
2. Sequential dependencies → spawn workers serially, pass output as input to next
3. Maximum concurrent workers: 4 (prevent filesystem collisions and quota spikes)
4. Workspace isolation:
   - Read-only scouts: `inherit` (safe, no writes)
   - Writers on same files: `branch` (isolated git worktree)
     * *Note: When using `branch`, write the pruned `.agents/mcp_config.json` file to the branched directory path before calling invoke_subagent.*
   - Writers on different files: `inherit` (safe, no collisions)

## Report Protocol

All workers must return reports in this format:
```
## [Role] Report
**Status**: [complete|failed|blocked]
**Actions**: [terse bullet list of what was done]
**Files Modified**: [list]
**Verification**: [test results, command output]
**Blockers**: [if any]
```

Dispatcher consumes reports and:
1. Aggregates results
2. Detects failures → triggers Coordinator Successor if 2+ failures
3. Reports final summary to user
