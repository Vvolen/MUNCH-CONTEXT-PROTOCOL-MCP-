# How This Environment Works — And How To Upgrade It

> **Date:** 2026-04-08 | **Written for:** Nick (Vvolen)
> **Style:** Conversational, grounded, current as of April 8 2026

---

## The Two Layers You're Working With

### Layer 1: Ruflo (formerly Claude Flow) — The Swarm Coordinator

Ruflo is **not** an IDE. It's a multi-agent orchestration platform that runs *on top of*
Claude Code. Think of it as the swarm coordinator — it takes a single Claude Code session
and turns it into 60+ specialized agents working in parallel, with persistent memory,
consensus protocols, and self-learning.

**What Ruflo gives you right now:**
- Swarm topologies (mesh, hierarchical, star)
- Agent spawning and lifecycle management
- AgentDB (persistent vector memory with HNSW search)
- 215 MCP tools exposed to Claude Code
- Self-learning hooks that get better with use
- 3-tier model routing (WASM → Haiku → Sonnet/Opus)
- Consensus algorithms (Raft, BFT, Gossip, CRDT)
- Session persistence and cross-session memory

**What Ruflo's native routing covers:** Haiku/Sonnet/Opus tiers within the Claude ecosystem.
For mixed-model routing (adding GPT-5 into the mix), you need a model proxy layer — see below.

### Layer 2: Claude Code Native Sub-Agents — The Model-Per-Agent Layer

As of April 2026, Claude Code has **built-in sub-agent support** that works *alongside* Ruflo.
You define agents as markdown files with YAML frontmatter, place them in `.claude/agents/`,
and Claude Code can spawn them on demand with:

- Isolated context windows (no cross-pollution)
- Per-agent tool restrictions
- **Model override** — you can specify which model each sub-agent uses
- Parallel execution

**How they work together:** Ruflo handles swarm-level coordination (memory, consensus,
topology, hooks). Claude Code sub-agents handle per-agent model selection and context
isolation. You use both — Ruflo as infrastructure, sub-agents as the individual workers.

---

## Your Specific Question: The 2+1 Orchestrator Pattern

You want:
- **GPT-5.4** as the orchestrator (1 premium request)
- **Opus 4.6** as sub-agent #1 (3 premium requests — the heavy hitter)
- **GPT-5.4** as sub-agent #2 (1 premium request — the efficient workhorse)
- Total cost per complex task: 5 premium requests
- The two sub-agents doing adversarial checks on each other's work

### How This Works With Ruflo

Ruflo already handles swarm orchestration, but its built-in routing is Claude-tier only
(Haiku/Sonnet/Opus). To get your specific mixed-model setup, you layer Claude Code's native
sub-agent system on top of Ruflo:

- **Ruflo** provides: memory, hooks, session persistence, consensus, the MCP tool surface
- **Claude Code sub-agents** provide: per-agent model selection, context isolation

**Claude Code sub-agents support a `model:` parameter in YAML frontmatter.** Example:

```markdown
---
name: deep-analyzer
description: Handles complex architectural reasoning and security review
model: opus
---
You are a senior architect. You do deep analysis, find hidden flaws, 
and challenge assumptions. When another agent's work is handed to you,
your first instinct is to find what's wrong with it.
```

```markdown
---
name: efficient-builder  
description: Handles implementation, research, and rapid iteration
model: gpt-5
---
You are a fast, efficient implementation specialist. You build things 
quickly and correctly. When handed analysis from another agent, you 
verify it against reality and flag any theoretical-but-impractical conclusions.
```

**The catch:** Running GPT-5 through Claude Code requires a **model proxy** like
`claude-code-gpt-5` (by teremterem). This translates Claude model requests to OpenAI API
calls. Without it, Claude Code only routes to Claude models natively.

### The Adversarial Check Pattern

Here's how the two sub-agents communicate and cross-check:

```
Orchestrator (GPT-5.4)
    │
    ├── Spawns: deep-analyzer (Opus 4.6)
    │      └── Returns: analysis + recommendations
    │
    ├── Spawns: efficient-builder (GPT-5.4)  
    │      └── Returns: implementation + validation
    │
    ├── Cross-check Phase:
    │      ├── Sends builder's output → deep-analyzer for review
    │      ├── Sends analyzer's review → builder for response
    │      └── Collects both perspectives
    │
    └── Orchestrator synthesizes final result
```

**Sub-agents don't talk directly to each other.** Communication goes through the orchestrator.
The orchestrator passes Agent A's output as context to Agent B and vice versa. This is by
design — it prevents runaway agent-to-agent loops and keeps the orchestrator in control.

### What You Actually Need To Set Up

1. **Install `claude-code-gpt-5` proxy** to enable GPT-5 models in Claude Code
2. **Create two sub-agent files** in `.claude/agents/` with the model overrides
3. **Create an orchestrator skill** that knows when to spawn which agent and how to
   run the adversarial cross-check loop

---

## What's Currently Set Up In Your Environment

### MUNCH Repo (This One)

| Component | Status | Notes |
|-----------|--------|-------|
| Ruflo v3.5 | Configured | `.mcp.json` points to Ruflo MCP server |
| Claude hooks | 30+ helpers | `.claude/helpers/` — session lifecycle, routing, learning |
| MCP server | Configured | 215 tools exposed via Ruflo |
| Session coordination | Working | `SESSION_BOARD.md` + `SESSION_LOG.jsonl` |
| Devcontainer | Working | Node 20 image, Ruflo auto-installs |
| Agent-dispatch workflow | Working | GitHub Actions `workflow_dispatch` |
| Sub-agent definitions | **Removed** | This was the cleanup — Ruflo provides these at runtime |

### Versailles Repo

| Component | Status | Notes |
|-----------|--------|-------|
| Devcontainer | ✅ Exists | Has a `devcontainer.json` |
| `.claude/` config | ✅ Exists | `settings.json` + `context.md` |
| `CLAUDE.md` | ✅ Comprehensive | Full cold-start checklist, 3-tier routing, swarm rules |
| `AGENT_NOTES.md` | ✅ Active | 4 entries, last updated 2026-04-03 |
| Skill pipeline | ✅ Infra ready | But pipeline is starved — 1 skill in evaluated, 3 in quarantine |
| Scout/Explorer workflows | ✅ Exist | But haven't been run recently |
| MCP config | ✅ Configured | claude-flow, context7, filesystem, github, sequential-thinking |

**Versailles has agentic infrastructure.** It's more set up than you might think.
The gap is content, not infrastructure — the pipeline is built but hasn't been fed recently.

---

## How To Upgrade This Environment (Ranked By Impact)

### Upgrade 1: Add Native Sub-Agent Definitions (High Impact, Low Effort)

Create `.claude/agents/` in this repo with two purpose-built sub-agents:

```
.claude/agents/
  deep-analyzer.md     # Opus 4.6 — deep reasoning, adversarial review
  efficient-builder.md # GPT-5.4 — fast implementation, reality-checking
```

These are NOT the same as the Ruflo agent definitions that were deleted. Those were
upstream mirrors. These would be **your custom agents** with your specific workflow baked in.

### Upgrade 2: Install GPT-5 Model Proxy (High Impact, Medium Effort)

Add `claude-code-gpt-5` to your devcontainer setup so sub-agents can route to OpenAI models.
This unlocks the mixed-model orchestration you described.

### Upgrade 3: Create an Orchestrator Skill (High Impact, Medium Effort)

Write a SKILL.md that teaches the orchestrator how to:
1. Decompose a task into analyzer vs. builder subtasks
2. Spawn both sub-agents
3. Run the adversarial cross-check loop
4. Synthesize the final result

This skill goes in Versailles's `skills/discovered/` and enters the evolution pipeline.

### Upgrade 4: Cross-Repo Session Coordination (Medium Impact, Medium Effort)

The `SESSION_BOARD.md` pattern is working but only in MUNCH. Add lightweight session boards
to Versailles and Foundation-layer that point back here. The protocol:
- Agent starts in MUNCH → reads `SESSION_BOARD.md` → gets cross-repo context
- Agent branches into target repo → does work → returns findings
- Agent appends to MUNCH's `SESSION_LOG.jsonl` on completion

### Upgrade 5: Feed the Versailles Pipeline (Medium Impact, Low Effort)

The 13 skills sitting in `versailles-skills-export/` in this repo need to be imported into
Versailles. The pipeline is ready but starved. This is the easiest high-value action.

### Upgrade 6: Add `repos/` Status Manifest (Medium Impact, Low Effort)

Add a machine-readable status layer to MUNCH:

```
repos/
  versailles.json        # Role, state, blockers, last agent action
  foundation-layer.json  # Role, state, blockers, last agent action
  munch.json             # Self-referential status
```

Any agent cold-starting in MUNCH instantly knows the state of the whole system.

---

## The Canonical Repo Question

You asked: *"How do we make this repo useful as a canonical repo that agents can go to for
context on everything?"*

The answer: **Context spine, not content warehouse.**

Your MUNCH repo is most powerful as the **entry point and coordination layer** for the system:

| Role | Repo |
|------|------|
| **Context spine / control plane** | MUNCH (this repo) |
| **Genome / knowledge base / skill evolution** | Versailles |
| **Build / ingestion pipeline** | Foundation-layer |

MUNCH should own:
- ✅ Cross-repo session state (`SESSION_BOARD.md`, `SESSION_LOG.jsonl`)
- ✅ System context (`docs/NICK_SYSTEM_CONTEXT.md`)
- ✅ Orchestration config (`.mcp.json`, `.claude/`, devcontainer)
- ✅ Research outputs (`RESEARCH-SPRINT.md`, skill exports)
- ✅ Repo health summaries (the `repos/` manifest)
- ✅ Cross-repo ADRs and operating rules

MUNCH should NOT own:
- ❌ Vendored copies of Ruflo's upstream agents/skills (this was the correct cleanup)
- ❌ Repo-specific implementation details
- ❌ Stale mirrors of external docs

This is called the **"spine pattern"** in multi-repo architecture — a lightweight meta-repo
that provides durable context and coordination without trying to contain everything.

---

## Bottom Line

1. **Ruflo** = your swarm coordinator (already installed, working) — handles memory, hooks, topology, consensus
2. **Claude Code native sub-agents** = the built-in way to do orchestrator + 2 sub-agents with model overrides — layered on top of Ruflo
3. **The 2+1 pattern you want** is doable right now: GPT-5.4 orchestrator → Opus 4.6 + GPT-5.4 sub-agents with adversarial cross-checking
4. **You need a model proxy** (`claude-code-gpt-5`) to enable GPT-5 in Claude Code sub-agents
5. **MUNCH is best as a context spine**, not a content warehouse — the cleanup was correct
6. **Versailles has more infrastructure than you might think** — the gap is feeding the pipeline, not building it
