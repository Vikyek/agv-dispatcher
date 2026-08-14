# agy-vispatcher

A token-efficient, self-scaling multi-agent orchestration plugin for the Google Antigravity (AGY) CLI.

## Overview

The `agy-vispatcher` system acts as a lightweight dispatcher that:
1. **Assesses Task Complexity** before any execution.
2. **Routes Tasks** to optimally-tiered worker subagents (model & effort matched to subtask).
3. **Optimizes Quota Pools** across Gemini and Claude pools dynamically.
4. **Limits Context Window Bloat** using dynamic Tool Schema Pruning and compact payload state handoffs.
5. **Escalates Automatically** through a 5-tier ladder:
   - **T0 (Direct)**: Trivial tasks (1-2 tools).
   - **T1 (Scout)**: `flash_lite` read-only recon agent.
   - **T2 (Worker)**: `flash` surgical editing agent.
   - **T3 (Architect)**: `pro` or Claude complex reasoning agent.
   - **T4 (Successor)**: `pro` or Claude orchestration coordinator taking over on failure/bloat.
   - **T5 (`/teamwork-preview`)**: Massive greenfield projects (full parallel autonomous team).

## Plugin Structure

```text
agy-vispatcher/
├── plugin.json                 # Manifest declaring plugin name
├── rules/
│   └── vispatcher_rule.md      # Pre-task and Quota activation rules
└── skills/
    └── vispatch/
        └── SKILL.md            # Execution and Tool Schema Pruning logic
```

## Setup & Installation

### Local Global Install

1. Link or copy this plugin to your global customizations directory:
   ```bash
   mkdir -p ~/.gemini/config/plugins/
   ln -s ~/Projects/agy-vispatcher ~/.gemini/config/plugins/agy-vispatcher
   ```

2. Register the plugin in `~/.gemini/config/plugins.json`:
   ```json
   {
     "entries": [
       { "path": "~/.gemini/config/plugins/agy-vispatcher" }
     ]
   }
   ```

## Tool Schema Pruning (MCP Optimization)

To reduce token overhead, the vispatcher dynamically creates custom `.agents/mcp_config.json` configurations in branched workspaces before spawning worker subagents:
- **Scout Config**: Exposes only `codegraph` (`codegraph_explore`).
- **Worker Config**: Exposes only `toon` for structured payloads.
- **Architect Config**: Full suite (codegraph, context-mode, toon).

## License

MIT License
