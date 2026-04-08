# SESSION BOARD — Cross-Agent Coordination

> **Purpose:** Persistent communication layer between Claude Code, SuperNinja, and any future AI agent.
> **Format:** Human-readable markdown. Machine-readable companion: `SESSION_LOG.jsonl`.
> **Location:** Root of MUNCH-CONTEXT-PROTOCOL-MCP- repo (the orchestration harness).
> **Protocol:** Any agent starting a session reads this file first. Before ending, appends to `SESSION_LOG.jsonl`.

---

## CURRENT STATUS

| Field | Value |
|-------|-------|
| **Phase** | 0 — Session Board initialized, multi-repo upgrade plan drafted |
| **Last Agent** | Claude Code (Opus 4.6) via GitHub agent session |
| **Last Updated** | 2026-04-04 |
| **Blocking** | Nothing — SuperNinja can begin Phase 1 immediately |
| **Next Action** | SuperNinja reads this file, executes Phase 1 of the upgrade plan |

---

## ACTIVE PLAN: Multi-Repo Architecture Upgrade

### Goal
Upgrade Versailles, Foundation-layer, and MCP repos to use GitHub's agentic workflow infrastructure — devcontainer environments, agent-dispatch Actions, cross-repo session coordination — so that any AI agent can spin up in any repo and immediately have full context + tools.

### The Three Repos

| Repo | Role | Current Agentic Infra | Target State |
|------|------|-----------------------|-------------|
| `Vvolen/MUNCH-CONTEXT-PROTOCOL-MCP-` | Orchestration harness | Full: devcontainer, agent-dispatch, hooks, skills, 60+ agents | Reference implementation — other repos inherit from this |
| `Vvolen/Versailles` | Brain / knowledge base (the genome) | Minimal or none | devcontainer + agent-dispatch + CLAUDE.md + session board |
| `Vvolen/Foundation-layer` | Build / ingestion pipeline | Minimal or none | devcontainer + agent-dispatch + CLAUDE.md + session board |

### Phase 1: Audit Current State
**Owner:** SuperNinja
**Actions:**
- [ ] Clone all three repos
- [ ] Inventory each repo: what files exist in `.devcontainer/`, `.github/workflows/`, `.claude/`, `CLAUDE.md`
- [ ] Document findings in this section (replace this checklist with results)
- [ ] Identify what MCP has that the other repos lack

### Phase 2: Create Devcontainer for Versailles
**Owner:** SuperNinja
**Actions:**
- [ ] Create `.devcontainer/devcontainer.json` based on MCP's template
- [ ] Adapt `postCreateCommand` to Versailles' needs (knowledge base tools, not code tools)
- [ ] Set appropriate environment variables for Versailles' role
- [ ] Test: Codespace launches, tools install, agent can read the repo

### Phase 3: Create Devcontainer for Foundation-layer
**Owner:** SuperNinja
**Actions:**
- [ ] Create `.devcontainer/devcontainer.json` based on MCP's template
- [ ] Adapt for Foundation-layer's needs (Python pipeline, node stubs)
- [ ] Set appropriate environment variables
- [ ] Test: Codespace launches, pipeline tools install

### Phase 4: Add Agent-Dispatch Workflows
**Owner:** SuperNinja
**Actions:**
- [ ] Copy MCP's `.github/workflows/agent-dispatch.yml` to Versailles (adapt agent types)
- [ ] Copy to Foundation-layer (adapt agent types for pipeline work)
- [ ] Add CI workflow if not present
- [ ] Test: `workflow_dispatch` triggers, creates task issue

### Phase 5: Add CLAUDE.md and Context Files
**Owner:** SuperNinja
**Actions:**
- [ ] Create `CLAUDE.md` for Versailles (knowledge-base-specific build instructions)
- [ ] Create `CLAUDE.md` for Foundation-layer (pipeline-specific build instructions)
- [ ] Add `SESSION_BOARD.md` to each repo (pointing back to MCP as coordination hub)
- [ ] Add `SESSION_LOG.jsonl` to each repo

### Phase 6: Cross-Repo Session Coordination
**Owner:** SuperNinja + Claude Code
**Actions:**
- [ ] Define protocol: how agents in one repo reference work in another
- [ ] Add cross-repo links in each SESSION_BOARD.md
- [ ] Test: Agent in Versailles can read MCP's session board via GitHub API
- [ ] Document the full protocol in MCP's docs/

---

## SESSION LOG (Recent)

> Full machine-readable log: `SESSION_LOG.jsonl`
> This section shows the last 5 entries for quick human scanning.

| # | Agent | Date | Action | Outcome |
|---|-------|------|--------|---------|
| 001 | Claude Code (Opus 4.6) | 2026-04-04 | Created Session Board, SESSION_LOG.jsonl, updated CLAUDE.md | Success |

---

## DECISIONS

### DEC-001: Session Board lives in MCP repo
**Date:** 2026-04-04
**Decision:** The primary Session Board lives in the MCP (orchestration harness) repo. Other repos get lightweight session boards that point back here.
**Rationale:** MCP is the harness repo — it's where cross-agent infrastructure belongs. Versailles is knowledge, Foundation-layer is pipeline code. Neither should own coordination.
**Status:** Accepted

### DEC-002: Dual format — Markdown + JSONL
**Date:** 2026-04-04
**Decision:** Human-readable SESSION_BOARD.md + machine-parseable SESSION_LOG.jsonl.
**Rationale:** Nick reads markdown (via TTS at 1.4x). Agents parse JSONL (tail last N entries). Both formats serve their audience without compromise.
**Status:** Accepted

### DEC-003: Agent-agnostic protocol
**Date:** 2026-04-04
**Decision:** Any agent (Claude Code, SuperNinja, Copilot, future tools) can read/write the session board. No tool-specific dependencies.
**Rationale:** Nick works with multiple AI tools. Lock-in to any one would break the workflow.
**Status:** Accepted

### DEC-004: Git-tracked coordination
**Date:** 2026-04-04
**Decision:** All session state is git-tracked. No external databases for coordination (memory/search can use external stores, but the coordination layer is git).
**Rationale:** Full audit trail. Rollback is trivial. Works offline. Every agent understands git.
**Status:** Accepted

---

## NOTES FOR NEXT AGENT

### Context You Need
1. **Nick is non-technical.** He architects systems and directs AI agents. Don't explain implementation details unless asked. Lead with conclusions.
2. **Three-repo system:** MCP = harness, Versailles = brain/genome, Foundation-layer = build pipeline. Read `docs/NICK_SYSTEM_CONTEXT.md` for the full vision.
3. **The genetic harness metaphor** is technically precise — treat it seriously. Versailles is the genome, agents are phenotypes, trust scoring is natural selection.
4. **This is a personal learning project,** not a commercial product. Don't add money/service angles.

### What's Working
- MCP repo has a full agentic harness: devcontainer, agent-dispatch workflow, custom hooks, MCP server config
- Ruflo ships 60+ agents and 30+ skills at runtime (no longer duplicated in this repo)
- GitHub Actions can spin up agent tasks via `workflow_dispatch`
- Session Board system is now live for cross-agent coordination

### What's Not Working
- `jcodemunch-mcp` is a **Python/PyPI** package, not npm — install via `pip install jcodemunch-mcp` or `uvx jcodemunch-mcp`
- Ruflo (formerly claude-flow) is now `ruflo` on npm — all references updated from `@claude-flow/cli` to `ruflo`
- Versailles and Foundation-layer repos lack agentic infrastructure (that's what the upgrade plan fixes)

### What You Should Do
If you're **SuperNinja**: Read the Active Plan above, execute Phases 1-6 in order. Append your work to `SESSION_LOG.jsonl` after each phase.
If you're **Claude Code** in a new session: Check `SESSION_LOG.jsonl` (last 5 entries) to see what's happened since this board was created. Then pick up where things left off.
If you're **any other agent**: Read this board, understand the multi-repo architecture, and coordinate through `SESSION_LOG.jsonl`.

---

## REPO ARCHITECTURE QUICK REFERENCE

```
MUNCH-CONTEXT-PROTOCOL-MCP-/
├── CLAUDE.md                    # Build instructions for Claude Code
├── SESSION_BOARD.md             # THIS FILE — cross-agent coordination
├── SESSION_LOG.jsonl            # Machine-readable session log
├── RESEARCH-SPRINT.md           # Agentic CLI convergence research
├── .devcontainer/               # GitHub Codespaces config
│   └── devcontainer.json        # Node 20, Ruflo, jCodeMunch
├── .github/workflows/
│   ├── ci.yml                   # CI pipeline
│   └── agent-dispatch.yml       # Agentic task dispatch via workflow_dispatch
├── .claude/
│   ├── helpers/                 # 30+ custom hook helper scripts
│   └── settings.json            # Hook configuration
├── .claude-flow/
│   ├── config.yaml              # Ruflo V3 configuration
│   ├── sessions/                # Persistent session logs
│   ├── metrics/                 # Learning, swarm, progress metrics
│   └── security/                # Security audit status
├── .mcp.json                    # MCP server configuration
├── docs/
│   ├── NICK_SYSTEM_CONTEXT.md   # Nick's identity + workflow context
│   └── POWER_TOOLS.md           # Tool reference for agents
└── scripts/
    ├── setup.sh                 # Environment setup (postCreate)
    └── check-security-status.js # Security audit checker

NOTE: Agents, skills, and commands are NOT stored in this repo.
      They ship with Ruflo at runtime: npx ruflo@latest agent list
```
