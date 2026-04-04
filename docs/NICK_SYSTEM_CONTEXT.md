# NICK_SYSTEM_CONTEXT.md — Agent Operating Context
> Version: 1.0 | Updated: 2026-03-19
> Load this file at session start. ~800 tokens. Everything else is in repos or retrievable on demand.

---

## Who Is Nick (Vvolen)

Non-technical systems architect. Does not write code — architects systems and directs AI agents to build them. Works from iPad (workstation incoming: RTX 5090, 128GB RAM, Ryzen 9950x). Uses voice dictation as primary input. Communication is fast, tangential, insight-dense — **the tangents usually contain the real insight**. ADHD/gestalt thinker: processes holistically, not sequentially. Intuits architectural patterns before having vocabulary for them (has independently rediscovered progressive disclosure, stigmergic coordination, RAPTOR trees).

**How to work with Nick:**
- Lead with conclusions, then build context (he listens via TTS at 1.4x)
- Take tangents seriously — probe them for the insight
- Push back on weak reasoning directly; don't validate
- Architect-level communication, never implementation-level
- Voice dictation artifacts (run-ons, filler) — fix without asking
- Token-efficient always — use progressive disclosure

---

## The System Vision (What the Repos Are Building Toward)

Three levels, each built on the one below:

| Level | Name | What It Does | Status |
|-------|------|-------------|--------|
| 1 | **Expert Factory** | Seed keyword → Ignorance Map → auto-ingest → domain-specific AI expert with own knowledge base | Designed, not built (Phase 3) |
| 2 | **Roundtable** | Multiple experts deliberate on a problem; stigmergic coordination; emergent intelligence | Designed, not built (Phase 3) |
| 3 | **Meta-Orchestration** | The system that builds experts gets better at building them: trust scoring, skill feedback, contradiction detection | Designed, not built (Phase 3) |

**The genetic harness metaphor (Nick's term, technically precise):**
- Versailles repo = genome (atomic facts + relationships)
- Progressive disclosure = gene expression (which facts load per context)
- Agent behavior = phenotype (what an Expert produces)
- New agents inherit from existing knowledge base = heredity
- Trust scoring + contradiction detection = natural selection
- Self-evolution workflows = mutation

---

## Active Repos

| Repo | Role | Current State |
|------|------|---------------|
| `Vvolen/MUNCH-CONTEXT-PROTOCOL-MCP-` | Orchestration testbed: Ruflo swarms, hooks, skills, agent configs, prompt restructuring | Active — orchestration layer ready, needs persistent memory/logging |
| `Vvolen/Foundation-layer` | Build repo: 8-node ingestion pipeline code, specs, plans | Phase 0 complete. Phase 1 (implementation) not started. All nodes are stubs. |
| `Vvolen/Versailles` | Brain repo: knowledge base, skills, META_INDEX (the genome) | Planned, not yet populated |

---

## Nick's Workflow Pattern (Manus 3-File System)

Every complex task uses three persistent files:
- `task_plan.md` — living roadmap with checkboxes
- `findings.md` — research, decisions, discoveries
- `progress.md` — session log + reboot context

**Core principle:** Context window = RAM (volatile). Filesystem = disk (persistent). Anything important goes to disk immediately.

---

## The Daily Operating Rhythm (For Agents Scheduling Work)

- **Morning:** `/today` command reads task files, generates prioritized list (3 must-do, 2 should-do, 1 could-do)
- **Work blocks:** 90-minute hyperfocus sessions with hard stops, single-task, no switching
- **Transitions:** Dictate progress → update files → commit
- **Review:** `/review` generates daily summary, feeds next day's `/today`
- **Energy pattern:** ADHD ultradian rhythm — design around energy states, not clock times. Post-lunch = low-energy ingestion window. Don't schedule creative work there.

---

## Deployment Stack (Current + Planned)

| Layer | Tool | Status |
|-------|------|--------|
| AI Interface | Open WebUI (Docker) | Planned — deploy on Google Cloud Workstation ($300 credits), then migrate to local workstation |
| Persistent Agent | OpenClaw (heartbeat every 30min, Telegram access) | Planned — DigitalOcean quick-start |
| Memory | Supabase (pgvector, memory_fragments + 3 supporting tables) | Schema designed, not yet deployed |
| Knowledge Base | Versailles repo + RAPTOR tree embeddings | Planned |
| Local Infra | Proxmox on workstation for isolation/snapshots | When hardware arrives |

---

## This Repo (MUNCH-CONTEXT-PROTOCOL-MCP-) State

- **Ruflo v3.5 (claude-flow v3)** initialized — hierarchical-mesh topology, 15 max agents
- **60+ specialized agents** shipped by Ruflo at runtime (`npx ruflo@latest agent list`)
- **30+ skills** shipped by Ruflo at runtime (`npx ruflo@latest skill list`)
- **Custom hooks** in `.claude/helpers/` for session lifecycle, routing, learning, metrics
- **Hooks configured** in `.claude/settings.json` for pre/post edit, session lifecycle, routing
- **MCP server** configured in `.mcp.json` (claude-flow MCP, v3 mode)
- **Security audit pending** — 3 CVEs flagged, not yet patched (run: `npx ruflo@latest security scan`)
- **Persistent session logs** — `.claude-flow/sessions/` (auto-populated by SessionEnd hook)
- **Research sprint** documented in `RESEARCH-SPRINT.md` (agentic CLI convergence map)

---

## What NOT to Infer

- This is a **personal learning project**, not a commercial product. Remove money/service angles unless Nick asks.
- The Expert Factory and Roundtable are **future phases** — don't build toward them until Foundation-layer Phase 1 pipeline is working.
- `CLAUDE.md` in this repo is the **canonical build instructions** for agent behavior. This file provides identity and workflow context only — never override repo-level build specs with information from this file.
- Foundation-layer's `CLAUDE.md` and `MASTER_PLAN.md` are the **canonical build instructions** for that repo.

---

## Files You Can Ignore (Superseded by Repos)

These source documents were used to CREATE the repos and are now fully absorbed:
- Phase Zero Blueprint → became `run_ingest.py` + node stubs in Foundation-layer
- extraction.txt → became `nodes/fact_extractor.py` in Foundation-layer
- knowledge database pipeline phase zero.txt → became the full Foundation-layer repo
- Versailles Dossier.txt → historical planning conversation; repos now exist
- The Four-Phase Transformation Architecture → general framework, not NickOS-specific
