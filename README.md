# agv-dispatcher

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Sponsor Vikyek](https://img.shields.io/badge/Sponsor-GitHub-ea4aaa?logo=github-sponsors&logoColor=white)](https://github.com/sponsors/Vikyek)

A token-efficient, self-scaling multi-agent orchestration plugin for the Google Antigravity (AGY) CLI.

## Overview

The `agv-dispatcher` system acts as a lightweight dispatcher that:
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
agv-dispatcher/
├── plugin.json                 # Manifest declaring plugin name
├── rules/
│   └── dispatcher_rule.md      # Pre-task and Quota activation rules
└── skills/
    └── dispatcher/
        └── SKILL.md            # Execution and Tool Schema Pruning logic
```

## Setup & Installation

### Global Plugin Installation

1. Install or clone this plugin to your global customizations directory:
   ```bash
   mkdir -p ~/.gemini/config/plugins/
   git clone https://github.com/Vikyek/agv-dispatcher.git ~/.gemini/config/plugins/agv-dispatcher
   ```

2. Register the plugin in `~/.gemini/config/plugins.json`:
   ```json
   {
     "entries": [
       { "path": "~/.gemini/config/plugins/agv-dispatcher" }
     ]
   }
   ```

## Tool Schema Pruning (MCP Optimization)

To reduce token overhead, the dispatcher dynamically creates custom `.agents/mcp_config.json` configurations in branched workspaces before spawning worker subagents:
- **Scout Config**: Exposes only `codegraph` (`codegraph_explore`).
- **Worker Config**: Exposes only `toon` for structured payloads.
- **Architect Config**: Full suite (codegraph, context-mode, toon).

---

## 💖 Support & Sponsorship

`agv-dispatcher` is developed and maintained independently by **[Vikyek](https://github.com/Vikyek)**.

> ### 🎯 Active Sponsorship Goal: Monthly Living Essentials
> **Target:** **2,710 PLN / ~$675 USD per month** (Rent & Utilities)  
> Covering basic living essentials directly unlocks dedicated, sustainable full-time independent open-source engineering across AI agent tooling and developer infrastructure.

If `agv-dispatcher` saves quotas and optimizes agent runs in your setup, consider supporting ongoing work:

- **GitHub Sponsors**: [github.com/sponsors/Vikyek](https://github.com/sponsors/Vikyek)

---

## License

MIT License
