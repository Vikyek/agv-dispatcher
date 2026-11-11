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

`agv-dispatcher` is developed and maintained independently by **[Vikyek](https://github.com/Vikyek)**. Everything is 100% open-source, telemetry-free, and public.

<div align="center">

<!-- Official GitHub Sponsors Button & Card (Rendered in web/HTML environments; GitHub markdown sanitizer strips iframes, falling back to native badges) -->
<iframe src="https://github.com/sponsors/Vikyek/button" title="Sponsor Vikyek" height="32" width="114" style="border: 0; border-radius: 6px;"></iframe>
<iframe src="https://github.com/sponsors/Vikyek/card" title="Sponsor Vikyek" height="225" width="600" style="border: 0;"></iframe>

[![Sponsor Vikyek](https://img.shields.io/badge/Sponsor-%E2%9D%A4-ea4aaa?logo=github&style=for-the-badge)](https://github.com/sponsors/Vikyek)
[![Donate on Liberapay](https://img.shields.io/badge/Donate-Liberapay-f6c915?style=for-the-badge&logo=liberapay&logoColor=black)](https://liberapay.com/Vikyek)
[![Sponsor on Polar](https://img.shields.io/badge/Sponsor-Polar-0062FF?style=for-the-badge&logo=polar&logoColor=white)](https://polar.sh/vikyek)
[![Donate with Stripe](https://img.shields.io/badge/Donate-Stripe-635BFF?style=for-the-badge&logo=stripe&logoColor=white)](https://profile.stripe.com/@vikyek)

</div>

> ### 🎯 Active Sponsorship Goal: Monthly Living Essentials
> **Target:** **2,710 PLN / ~$675 USD per month** (`630 PLN / week`) — Rent & Essential Utilities  
> Covering basic living essentials directly unlocks dedicated, sustainable full-time independent open-source engineering across AI agent tooling and developer infrastructure free from corporate telemetry, ads, or paywalls.

If `agv-dispatcher` saves quotas and optimizes agent runs in your setup, consider supporting ongoing work:

- **GitHub Sponsors**: [github.com/sponsors/Vikyek](https://github.com/sponsors/Vikyek) *(Monthly tiers and one-time tips)*
- **Liberapay**: [liberapay.com/Vikyek](https://liberapay.com/Vikyek) *(0% platform fee recurrent patronage in EUR/USD/PLN)*
- **Polar**: [polar.sh/vikyek](https://polar.sh/vikyek) *(Developer subscriptions & commercial passes)*
- **Direct Stripe Profile**: [profile.stripe.com/@vikyek](https://profile.stripe.com/@vikyek) *(Direct one-time tips & sponsorship)*

Every contribution—monthly or one-time—directly supports active maintenance, hardware testbeds, and new feature development!

---

## License

MIT License
