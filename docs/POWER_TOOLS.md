# POWER_TOOLS.md — Core Agent Tools Reference
> This file is for agents. Read this to know what tools are available, how to call them, and when to use each one.

---

## Installed Tools

| Tool | Package | Purpose |
|------|---------|---------|
| **Ruflo** | `ruflo@latest` (npm) | Multi-agent swarm orchestration backbone |
| **jCodeMunch MCP** | `jcodemunch-mcp` (PyPI) | Token-efficient AST code intelligence via MCP |

---

## 1. Ruflo (claude-flow v3)

The orchestration layer. Everything plugs into it.

**Status in this repo:** Initialized. Hierarchical-mesh topology. 15 max agents.

### Core Commands

```bash
# Start the daemon
npx ruflo@latest daemon start

# Health check + auto-fix
npx ruflo@latest doctor --fix

# Initialize a new swarm
npx ruflo@latest swarm init --topology hierarchical --max-agents 8 --strategy specialized

# Spawn an agent
npx ruflo@latest agent spawn -t coder --name my-coder

# Memory operations
npx ruflo@latest memory store --key "key" --value "value" --namespace patterns
npx ruflo@latest memory search --query "authentication patterns"
npx ruflo@latest memory list --namespace patterns --limit 10
npx ruflo@latest memory retrieve --key "key" --namespace patterns

# Security scan
npx ruflo@latest security scan

# Session hooks (called automatically by .claude/settings.json)
npx ruflo@latest hook session-start --session-id "your-session"
npx ruflo@latest hook session-end --session-id "your-session" --generate-summary
```

### Agent Types (60+)

**Core Development:** `coder`, `reviewer`, `tester`, `planner`, `researcher`
**Specialized:** `security-architect`, `security-auditor`, `memory-specialist`, `performance-engineer`
**Swarm Coordination:** `hierarchical-coordinator`, `mesh-coordinator`, `adaptive-coordinator`
**GitHub & Repository:** `pr-manager`, `code-review-swarm`, `issue-tracker`, `release-manager`
**SPARC Methodology:** `sparc-coord`, `sparc-coder`, `specification`, `pseudocode`, `architecture`

### 3-Tier Model Routing (ADR-026)

| Tier | Handler | Latency | Cost | Use Cases |
|------|---------|---------|------|-----------|
| 1 | Agent Booster (WASM) | <1ms | $0 | Simple transforms — skip LLM |
| 2 | Haiku | ~500ms | $0.0002 | Simple tasks (<30% complexity) |
| 3 | Sonnet/Opus | 2–5s | $0.003–0.015 | Complex reasoning, architecture, security |

### MCP Server

Configured in `.mcp.json`. The MCP server exposes 215 tools to Claude Code.

```json
// .mcp.json excerpt
{
  "mcpServers": {
    "claude-flow": {
      "command": "npx",
      "args": ["-y", "ruflo@latest", "mcp", "start"]
    }
  }
}
```

---

## 2. jCodeMunch MCP

Token-efficient code intelligence. Uses tree-sitter AST parsing to serve symbols instead of whole files.

**Token savings:** 99% — a 6,000-token file read becomes a ~400-token symbol pull.
**Why it matters:** Running 60+ agents in swarms makes token efficiency mandatory.

```bash
# Install via pip (Python package, NOT npm)
pip install jcodemunch-mcp

# Or use via uvx (no install needed)
# uvx jcodemunch-mcp

# Index the codebase
jcodemunch index .

# Retrieve a specific symbol (via MCP tool call)
# Use via MCP: mcp__jcodemunch__get_symbol { "name": "MyClass" }
```

---

## 3. Claude Code Hooks (Auto-configured)

Hooks are configured in `.claude/settings.json` and run automatically. You do not need to call these manually.

| Hook | Trigger | What it does |
|------|---------|-------------|
| `pre-edit` | Before any file write | Validates edit, routes to agent |
| `post-edit` | After any file write | Records for learning, formats |
| `pre-bash` | Before bash commands | Safety check |
| `post-bash` | After bash commands | Logs execution, updates metrics |
| `route` | On each user prompt | Routes to optimal agent tier |
| `session-restore` | Session start | Loads previous session + NICK_SYSTEM_CONTEXT.md |
| `session-end` | Session end | Persists state, consolidates intelligence |
| `compact-manual/auto` | On compaction | Saves session before context compaction |

---

## 4. Skills System

30 skills are committed to `.claude/skills/`. Skills are SKILL.md files that define agent capabilities.

```bash
# Available skills (in .claude/skills/):
# agentdb-advanced, agentdb-learning, agentdb-memory-patterns
# agentdb-optimization, agentdb-vector-search
# browser, github-code-review, github-multi-repo
# github-project-management, github-release-management
# github-workflow-automation, hooks-automation, pair-programming
# reasoningbank-agentdb, reasoningbank-intelligence, skill-builder
# sparc-methodology, stream-chain, swarm-advanced, swarm-orchestration
# v3-cli-modernization, v3-core-implementation, v3-ddd-architecture
# v3-integration-deep, v3-mcp-optimization, v3-memory-unification
# v3-performance-optimization, v3-security-overhaul, v3-swarm-coordination
# verification-quality
```

---

## 5. Session Log Location

Persistent session logs are stored at:
```
.claude-flow/sessions/current.json   # Active session
.claude-flow/sessions/<session-id>.json  # Archived sessions
```

---

## Setup

Run `bash scripts/setup.sh` to install all tools and initialize runtime directories.
This script runs automatically in Codespaces via `.devcontainer/devcontainer.json`.

---

## Security

3 CVEs are flagged as pending. Run the security scan and address findings:

```bash
npx ruflo@latest security scan
```

Status is tracked in `.claude-flow/security/audit-status.json`.
