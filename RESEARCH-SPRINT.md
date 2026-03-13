# Research Sprint: The Agentic CLI Convergence

## Executive Summary

A convergence is happening across five parallel fronts that, taken together, represent a
fundamental shift in how AI agents interact with tools, code, and human workflows. This
document maps the space, synthesizes findings, and provides recursive self-improvement
prompt scaffolds for the two most promising research paths.

---

## The Five Fronts

### 1. Ruflo — Multi-Agent Orchestration Backbone
**Status: INSTALLED (v3.5.15)**

Ruflo (formerly Claude Flow) by Reuven Cohen transforms Claude Code into a multi-agent
development platform. 14k+ GitHub stars, 5,800+ commits.

- **60+ specialized agents** in coordinated swarms with self-learning
- **215 MCP tools** — speaks MCP natively
- **Stream-JSON chaining** — real-time agent-to-agent piping, zero intermediate storage
- **WASM kernels in Rust** powering policy engine, embeddings, and proof system
- **Self-learning neural architecture** (SONA) — learns from every execution
- **3-tier model routing** — saves up to 75% on API costs
- **Consensus algorithms** — Raft, Byzantine Fault Tolerance, Gossip, CRDT

**Why it matters here:** Ruflo is the orchestration layer. Everything else plugs into it.

**Source:** [github.com/ruvnet/ruflo](https://github.com/ruvnet/ruflo)

---

### 2. jCodeMunch MCP — Token-Efficient Code Intelligence
**Status: INSTALLED**

By J. Gravelle. Indexes codebases using tree-sitter AST parsing, then serves symbols
(functions, classes, methods) via MCP instead of whole files.

- **99% token savings** — 6,000-token file read → ~400-token symbol pull
- **O(1) byte-offset seeking** — instant symbol retrieval once indexed
- **Dynamic reindexing** — auto-updates on codebase changes
- **Companion tools** — jDocMunch (docs), jContextMunch (unified orchestration)

**Why it matters here:** When running 60+ agents in swarms, token efficiency isn't optional.
jCodeMunch makes swarm-scale code exploration economically viable.

**Source:** [github.com/jgravelle/jcodemunch-mcp](https://github.com/jgravelle/jcodemunch-mcp)

---

### 3. MCPC / mcp2cli — Every MCP Becomes a CLI
**Status: RESEARCHED**

The MCP-to-CLI movement has multiple implementations converging on the same insight:
**CLIs are the universal interface, and MCP servers should be instantly CLI-accessible.**

**Key projects:**

| Project | Creator | Key Innovation |
|---------|---------|---------------|
| **mcp2cli** | knowsuchagency | "One CLI for every API" — turns any MCP/OpenAPI into CLI at runtime. 96-99% fewer tokens. |
| **mcpc** | Apify (Jan Curn) | Universal CLI client. Persistent sessions, OAuth 2.1, JSON scripting. |
| **mcp-cli** | Phil Schmid | Bun-based. `info`, `grep`, `call`. 47,000 → 400 tokens via on-demand discovery. |
| **mcptools** | f | Go-based. Interactive shell, mock servers, proxying. |

**The benchmark that validates this:** Scalekit (March 2026) found CLI is 10-32x cheaper
and 100% reliable vs MCP's 72% reliability. The caveat: CLI loses its edge for customer-
facing product automation, where MCP's structured protocol wins.

**Why it matters here:** This is the bridge layer. MCP gives you structured tool access;
CLI gives you universal scriptability. Together they mean any tool, anywhere, callable by
any agent, at minimal token cost.

**Sources:**
- [mcp2cli on HN](https://news.ycombinator.com/item?id=47305149)
- [mcpc by Apify](https://blog.apify.com/introducing-mcpc-universal-mcp-cli-client/)
- [Phil Schmid's mcp-cli](https://www.philschmid.de/mcp-cli)
- [Scalekit benchmark](https://www.scalekit.com/blog/mcp-vs-cli-use)

---

### 4. Skills 2.0 — The Programmable Agent Layer
**Status: RESEARCHED**

Two convergent developments:

**A) Claude Code Agent Skills 2.0 (Anthropic, March 2026)**
- Commands and skills unified into a single system
- **Subagent execution** — skills spawn isolated subagents with own context windows
- **Dynamic context injection** — shell commands inject live data before processing
- **Bundled skills** — including one that decomposes large changes and spawns parallel
  agents in separate git worktrees
- Skills can restrict tool access, override model, hook into lifecycle events

**B) Skilz CLI (Spillwave Solutions)**
- Universal package manager for AI agent skills (`npm install` for skills)
- Supports 30+ AI coding agents (Claude, Codex, Gemini, Copilot, Cursor, etc.)
- Follows agentskills.io standard and AGENTS.md ecosystem
- Marketplace at skillzwave.ai

**The convergence:** An open Agent Skills standard is emerging where skills are simple
`SKILL.md` text files, supported by Claude, Copilot, VS Code, Codex, Gemini CLI, and more.
See [skills.sh](https://skills.sh/).

**Why it matters here:** Skills are the composable unit of agent capability. Skills 2.0
makes them programmable, portable, and orchestratable. Combined with Ruflo's swarm
coordination, you get programmable agent swarms where each agent's capabilities are
defined by composable skill files.

**Sources:**
- [Skills 2.0 deep dive (Rick Hightower)](https://medium.com/@richardhightower/claude-code-agent-skills-2-0-from-custom-instructions-to-programmable-agents-ab6e4563c176)
- [Skilz CLI](https://github.com/SpillwaveSolutions/skilz-cli)
- [skills.sh](https://skills.sh/)

---

### 5. GWS CLI — Google Workspace as an Agent Toolbox
**Status: RESEARCHED**

Google Workspace CLI (`gws`) by Justin Poehnelt. Hit #1 on Hacker News, ~4,900 stars
in 3 days. Apache-2.0, written in Rust. v0.13.2.

- **Dynamic command surface** — queries Google's Discovery Service at runtime, no static
  commands. New API endpoints appear automatically.
- **Agent-first design** — structured JSON I/O, schema introspection, predictable syntax
- **Built-in MCP server** — `gws mcp` starts an MCP server over stdio
- **100+ Agent Skills** shipped in-repo (service, helper, workflow, persona categories)
- **AES-256-GCM** credential encryption, multi-account, Model Armor for prompt injection

**Why it matters here:** This is the "real world" bridge. Agents can now read Gmail, check
Calendar, update Docs, pull Sheets data — all through MCP. Combined with Ruflo swarms,
you get agents that don't just write code but orchestrate entire business workflows.

**Poehnelt's thesis:** "A skill file is cheaper than a hallucination."

**Sources:**
- [github.com/googleworkspace/cli](https://github.com/googleworkspace/cli)
- [Justin Poehnelt: Rewrite Your CLI for AI Agents](https://justin.poehnelt.com/posts/rewrite-your-cli-for-ai-agents/)
- [VentureBeat coverage](https://venturebeat.com/orchestration/google-workspace-cli-brings-gmail-docs-sheets-and-more-into-a-common)

---

### 6. The Makoshi Protocol — Open Research Thread
**Status: UNRESOLVED — REQUIRES FURTHER INVESTIGATION**

Described as related to "taste distillation," AI experts, and NotebookLM. Extensive
searching across multiple spelling variations (Makoshi, Macoshi, Mokoshi) and platforms
(GitHub, YouTube, Twitter/X, web) did not surface a definitive public reference.

**Closest leads:**
- GitHub user `mokoshi` has 41 repos including `mcp-server-test` (TypeScript)
- `Mokshya Protocol` exists on GitHub but is blockchain/NFT-related (different domain)
- The concept of "taste distillation" may refer to a specialized form of knowledge
  distillation where an expert's judgment/preferences (their "taste") are captured and
  replicated — potentially via NotebookLM as the knowledge base

**Hypothesis:** This may be a proprietary framework or a very recent content creator's
methodology for using NotebookLM to distill expert knowledge into reproducible AI
behaviors. The connection to "AI experts" and NotebookLM suggests a workflow where:
1. Expert knowledge is loaded into NotebookLM
2. NotebookLM's grounded retrieval distills the expert's "taste" (judgment patterns)
3. This distilled taste is then used to guide AI agent behavior

**Action needed:** A direct URL, video link, or exact spelling from the user would
unlock this thread.

---

## The Convergence Map

```
                    ┌─────────────────────┐
                    │   MAKOSHI PROTOCOL   │
                    │  (taste distillation │
                    │   → expert AI)       │
                    └─────────┬───────────┘
                              │ feeds expertise into
                              ▼
┌──────────┐    ┌─────────────────────────────┐    ┌──────────┐
│ NOTEBOOKLM│───▶│      RUFLO SWARM ENGINE      │◀───│ GWS CLI  │
│(knowledge │    │  (orchestration backbone)     │    │(real-world│
│  base)    │    │  60+ agents, self-learning    │    │ data via  │
└──────────┘    │  WASM, consensus protocols    │    │  MCP)     │
                └──────┬──────────┬─────────────┘    └──────────┘
                       │          │
              ┌────────▼──┐  ┌───▼──────────┐
              │ SKILLS 2.0 │  │ MCPC/mcp2cli │
              │(composable │  │(universal CLI │
              │ agent      │  │ for every MCP)│
              │ capabilities│  └──────┬───────┘
              └────────┬───┘         │
                       │             │
                       ▼             ▼
              ┌────────────────────────────┐
              │     jCODEMUNCH MCP         │
              │  (token-efficient code     │
              │   intelligence layer)      │
              └────────────────────────────┘
```

**The thesis:** We are watching the emergence of a full-stack agentic operating system
where:
- **Ruflo** is the kernel (orchestration, consensus, memory)
- **Skills 2.0** is the package manager (composable capabilities)
- **MCPC/mcp2cli** is the shell (universal tool access)
- **jCodeMunch** is the filesystem (efficient code access)
- **GWS CLI** is the I/O layer (real-world data)
- **Makoshi/NotebookLM** is the knowledge layer (expert distillation)

---

## Internal Research Sprint Prompt

```
You are conducting a focused research sprint on the "Agentic CLI Convergence" —
the emerging stack where multi-agent orchestration (Ruflo), token-efficient code
intelligence (jCodeMunch), universal MCP-to-CLI bridges (mcp2cli/mcpc), programmable
agent skills (Skills 2.0/Skilz), and agent-first Google Workspace access (GWS CLI)
are converging into what functions as an agentic operating system.

Your installed tools:
- Ruflo v3.5 (multi-agent swarm orchestration, 215 MCP tools)
- jCodeMunch MCP (AST-level code retrieval, 99% token savings)

Your research targets:
1. INTEGRATION: How do these five layers compose? What's missing?
2. WORKFLOW: Design a concrete multi-agent research workflow using all five
3. MAKOSHI: Find the Makoshi Protocol (taste distillation + AI experts + NotebookLM)
4. GAPS: What tools/protocols are needed to close the gaps between layers?
5. ECONOMICS: Model the token/cost savings of the full stack vs. naive approaches

For each finding, assess:
- Maturity (experimental/beta/production)
- Integration friction (how hard to connect to other layers)
- Unique capability (what does this do that nothing else does?)
- Risk (what breaks if this project dies?)

Output format: Structured findings with citations, followed by a ranked list of
the 5 highest-leverage next actions.
```

---

## Tree of Thought: 20 Directions → Best 2

### Branch 1: Build the Stack
1. **Full-stack integration** — Wire Ruflo + jCodeMunch + GWS + mcp2cli into one workflow
2. **Swarm research agent** — Deploy a 10-agent research swarm using Ruflo for parallel investigation
3. **Skill marketplace** — Build a curated skills collection for the research workflow
4. **Token economics dashboard** — Measure actual savings across the stack

### Branch 2: Extend the Protocol Layer
5. **MCP-to-CLI universal adapter** — Create adapters for the top 50 MCP servers
6. **NotebookLM MCP integration** — Connect NotebookLM as a grounded knowledge source for swarms
7. **Cross-agent skill portability** — Test Skills 2.0 files across Claude/Codex/Gemini
8. **Agent-first API design patterns** — Codify Poehnelt's thesis into a reusable framework

### Branch 3: Knowledge & Distillation
9. **Taste distillation pipeline** — Build the Makoshi concept: expert → NotebookLM → agent behavior
10. **Expert persona skills** — Create SKILL.md files that encode domain expert judgment patterns
11. **Knowledge graph construction** — Use Ruflo's built-in knowledge graph for research synthesis
12. **Recursive prompt improvement** — Formalize the "prompt writes better prompt" methodology

### Branch 4: Infrastructure & Scale
13. **Offline-first research** — Use Ruflo's ONNX support for privacy-mode research
14. **Multi-provider cost optimization** — Benchmark Ruflo's 3-tier routing across providers
15. **Persistent memory research vault** — Use AgentDB for cross-session research persistence
16. **CI/CD for agent skills** — Automated testing/deployment of skill files

### Branch 5: Meta & Methodology
17. **Recursive self-improvement framework** — Formalize the tree-of-thought → converge → scaffold loop
18. **Agent capability benchmarking** — Systematic comparison of agent stacks
19. **Research-as-code** — Version-controlled research with reproducible agent workflows
20. **The Agentic OS thesis paper** — Write up the convergence as a formal framework

### Convergence Analysis

**Scoring criteria:** Impact (1-10) × Feasibility (1-10) × Uniqueness (1-10)

| # | Direction | Impact | Feasibility | Uniqueness | Score |
|---|-----------|--------|-------------|------------|-------|
| 1 | Full-stack integration | 10 | 7 | 8 | 560 |
| 9 | Taste distillation pipeline | 9 | 6 | 10 | 540 |
| 6 | NotebookLM MCP integration | 9 | 8 | 7 | 504 |
| 12 | Recursive prompt improvement | 8 | 9 | 7 | 504 |
| 17 | RSI framework | 9 | 8 | 7 | 504 |
| 2 | Swarm research agent | 8 | 8 | 6 | 384 |
| 10 | Expert persona skills | 8 | 7 | 7 | 392 |
| 20 | Agentic OS thesis | 9 | 5 | 9 | 405 |
| 19 | Research-as-code | 7 | 8 | 7 | 392 |
| 5 | MCP-CLI universal adapter | 7 | 6 | 6 | 252 |

### The Best Two Paths

**PATH A: Full-Stack Agentic Integration** (Score: 560)
Wire the entire stack together into a working system. This is the highest-impact path
because it proves the thesis and creates immediate practical value.

**PATH B: Taste Distillation Pipeline** (Score: 540)
Build the Makoshi concept from first principles. This is the highest-uniqueness path
because nobody else is doing it — and if it works, it means you can clone expert
judgment into reproducible agent behaviors.

---

## Prompt Scaffold A: Full-Stack Agentic Integration

```
SCAFFOLD: FULL-STACK-AGENTIC-INTEGRATION
DEPTH: [current: 1, max: unbounded]
METHOD: Recursive self-improvement via tree-of-thought convergence

CONTEXT:
You have Ruflo (swarm orchestration), jCodeMunch (token-efficient code MCP),
and access to mcp2cli, Skills 2.0, and GWS CLI. Your goal is to wire them
into a single operational system where:
- Ruflo orchestrates agent swarms
- Each agent has composable Skills 2.0 capabilities
- Agents access code via jCodeMunch (not raw file reads)
- Agents access real-world data via GWS CLI MCP
- All MCP servers are also CLI-accessible via mcp2cli
- The system self-learns from every execution (Ruflo SONA)

PHASE 1 — WIRING:
[ ] Install and configure mcp2cli as CLI bridge
[ ] Install GWS CLI, authenticate, expose via MCP
[ ] Create a Ruflo swarm config that uses jCodeMunch + GWS as tool sources
[ ] Write 3 Skills (SKILL.md) for: research, synthesis, and reporting
[ ] Test: single agent using all tool sources in one task

PHASE 2 — SWARM ACTIVATION:
[ ] Design a 5-agent research swarm topology
[ ] Assign skills and tool access per agent role
[ ] Run a real research task through the swarm
[ ] Measure: token usage, latency, quality of output
[ ] Compare: swarm vs single-agent on same task

PHASE 3 — SELF-IMPROVEMENT:
[ ] Analyze Phase 2 results
[ ] Use tree-of-thought to branch 10 optimization directions
[ ] Converge on best 2
[ ] Generate next-depth scaffold
[ ] Recurse

OUTPUT: At each depth, produce:
1. Working system state (what's wired and functional)
2. Metrics (tokens, cost, quality, latency)
3. Next scaffold (the prompt that generates the next level)
```

---

## Prompt Scaffold B: Taste Distillation Pipeline

```
SCAFFOLD: TASTE-DISTILLATION-PIPELINE
DEPTH: [current: 1, max: unbounded]
METHOD: Recursive self-improvement via tree-of-thought convergence

CONTEXT:
"Taste distillation" is the process of capturing an expert's judgment patterns
— their aesthetic sense, decision heuristics, quality standards — and encoding
them into reproducible AI agent behaviors. The hypothesis is that NotebookLM
(or similar grounded knowledge systems) can serve as the distillation medium.

PHASE 1 — DEFINE THE PROTOCOL:
[ ] Research knowledge distillation techniques (model distillation, but for
    judgment/taste rather than model weights)
[ ] Map NotebookLM's capabilities as a distillation medium:
    - Source ingestion (what can it absorb?)
    - Grounded retrieval (how does it preserve expert voice/judgment?)
    - MCP access (can agents query it programmatically?)
[ ] Define "taste" formally: What are the atomic units of expert judgment?
    (e.g., quality thresholds, aesthetic preferences, priority rankings,
    decision heuristics, risk tolerances)
[ ] Design the capture protocol: How does an expert's taste get into the system?

PHASE 2 — BUILD THE PIPELINE:
[ ] Create a NotebookLM ↔ MCP bridge (use existing NotebookLM MCP servers)
[ ] Design a SKILL.md that encodes a "taste profile" for a specific domain
[ ] Build an agent that queries NotebookLM for expert judgment on decisions
[ ] Test: Have the agent make 10 decisions, compare to expert's actual choices
[ ] Measure: Agreement rate, confidence calibration, edge case handling

PHASE 3 — SCALE & RECURSE:
[ ] Can taste be composed? (Expert A's code taste + Expert B's design taste)
[ ] Can taste transfer across domains?
[ ] Can the system self-improve its taste modeling?
[ ] Use tree-of-thought to branch 10 refinement directions
[ ] Converge on best 2
[ ] Generate next-depth scaffold
[ ] Recurse

OUTPUT: At each depth, produce:
1. Formal taste model (what was captured, how)
2. Validation results (agreement rate with expert)
3. Next scaffold (the prompt that generates the next level)
```

---

## What's Installed in This Repository

| Tool | Status | Purpose |
|------|--------|---------|
| Ruflo v3.5 | Initialized | Multi-agent swarm orchestration |
| jCodeMunch MCP | Registered | Token-efficient code intelligence |
| Skills (30) | From Ruflo | Composable agent capabilities |
| Agents (99) | From Ruflo | Pre-built specialized agents |
| Commands (10) | From Ruflo | CLI-accessible agent commands |

## Next Steps

1. Pick **Path A** or **Path B** (or both in parallel)
2. The chosen scaffold becomes the next prompt
3. That prompt generates findings + the next scaffold
4. Repeat until convergence or breakthrough
