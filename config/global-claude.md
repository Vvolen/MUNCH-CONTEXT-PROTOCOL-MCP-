# Environment: Power User Setup

## User Profile
- Non-developer who builds complex systems with AI (2.5 years experience)
- Intuitive AI understanding, never written code manually
- Works from iPad via Claude Code web interface
- Has Copilot Pro+, $300 Google Cloud credits, Obsidian on iPad

## Active Repositories
- **Versailles** (`/home/user/Versailles`) — Main project
- **Foundation-layer** (`/home/user/Foundation-layer`) — Infrastructure
- **MUNCH-CONTEXT-PROTOCOL-MCP-** (`/home/user/MUNCH-CONTEXT-PROTOCOL-MCP-`) — MCP tools

## Supabase Backend (Connected via MCP)
Complex backend with: raptor trees, BM25 search, half-vec deduplication, nightly consolidation, 9 cron jobs + edge functions, self-evolving skill system, flywheel effect

## Installed Token-Saving Tools
- **jCodeMunch** (`jcodemunch-mcp`) — Tree-sitter AST parsing, 95% token reduction on code navigation
- **Graphify** (`graphifyy`) — Karpathy LLM Wiki pattern, 71.5x token savings via BFS knowledge graph queries. Run `/graphify` to build graph from any folder.
- **Hermes-CCC** — 46 native skills for self-improving memory, persona switching, context compression, model routing

## Key Skills Available
- `/graphify` — Build knowledge graph from code/docs (Karpathy LLM Wiki)
- `/hermes-memory` — Persistent project memory across sessions
- `/hermes-compress` — Compress context when conversation gets long
- `/hermes-route` — Route tasks by complexity (decide Opus vs Sonnet vs Haiku)
- `/hermes-persona` — Switch specialized modes (researcher, coder, analyst)
- `/hermes-search` — Search past sessions and project history
- `/honcho` — Cross-session user modeling
- `/subagent-driven-development` — Decompose into parallel subagents

## Token Conservation Rules
1. Use jCodeMunch for code navigation — fetch symbols, not full files
2. Use Graphify knowledge graph before reading raw source files
3. Use `/hermes-compress` when context grows large
4. Prefer subagents for independent research tasks
5. Keep responses concise unless detailed explanation is requested

## Development Branches
- All repos: develop on branch `claude/research-dev-environments-lLUMY`

## Future Setup (Pending)
- GitHub Codespace or Google Cloud VM for full Hermes Agent + Honcho + Ruflo daemon
- Obsidian vault synced via git for Graphify knowledge graph visualization
- Anthropic Managed Agents exploration
