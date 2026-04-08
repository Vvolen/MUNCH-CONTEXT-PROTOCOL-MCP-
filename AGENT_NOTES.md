# AGENT_NOTES.md — Cross-Agent Memory Journal

> **What this file is:** A living, append-only journal written by every AI agent that works in
> this repository. Each session ends with a mandatory entry here. The goal is to build collective
> intelligence over time — so each new agent inherits the hard-won insights of every agent
> that came before it.
>
> **Read this file before starting work.** The last few entries tell you what's been discovered,
> what's uncertain, and what the next agent should focus on.
>
> **Write to this file when you finish work.** Even a short session deserves an entry.
> Future you — or another agent entirely — will be grateful.
>
> **Inspired by:** The Versailles repo's AGENT_NOTES.md pattern — a cross-agent memory
> system that preserves institutional knowledge across sessions.

---

## RULES FOR AGENTS

### Mandatory Protocol

Every agent working in this repository **MUST**:

1. **Read** the last 3 entries in this file before starting any work
2. **Write** a new entry here before ending a session (even partial work counts)
3. **Never edit** a past entry — append only, always at the bottom
4. **Be honest** — if something is uncertain, broken, or confusing, say so

### Entry Format

Use this exact structure (copy-paste the template):

```
## Entry N — YYYY-MM-DD — <Agent Name> — <Task in ≤8 words>

**Session type:** feature | fix | refactor | research | planning | review
**Files touched:** list the key files you changed or read
**Time:** approximate (e.g., "~15 min", "~2 hours")

**Key insight:**
One to three sentences. The single most important thing you learned or discovered in this
session that is not already documented elsewhere.

**Suggestion for next agent:**
One specific, actionable thing the next agent should do or investigate.

**Open question:**
Something you are genuinely uncertain about. A hypothesis you couldn't test.

**Tags:** #tag1 #tag2 #tag3

**Confidence in suggestions:** low | medium | high
```

### Quality Bar

- **Key insight** must be specific. "The pipeline works" is not an insight.
- **Suggestion** must be actionable in one session.
- **Open question** must be genuinely open.
- Length: keep each entry under 250 words total.

---

## ENTRIES

<!-- ========================================================================
     APPEND NEW ENTRIES AT THE BOTTOM OF THIS SECTION.
     Do not edit entries above yours.
     ======================================================================== -->

## Entry 1 — 2026-04-04 — Claude Code (Opus 4.6) — Bootstrap session board and coordination

**Session type:** feature
**Files touched:** `SESSION_BOARD.md` (created), `SESSION_LOG.jsonl` (created), `CLAUDE.md` (updated)
**Time:** ~30 min

**Key insight:**
This repo had no cross-agent coordination layer. Created `SESSION_BOARD.md` as the
human-readable coordination surface and `SESSION_LOG.jsonl` as the machine-parseable
companion. Established DEC-001 through DEC-004 for session protocol. Also discovered
that `jcodemunch-mcp` is a Python/PyPI package (not npm) and that `@claude-flow/cli`
has been renamed to `ruflo` on npm.

**Suggestion for next agent:**
Execute the multi-repo upgrade plan (Phases 1-6) in SESSION_BOARD.md. Start with
auditing all three repos to see what infrastructure each one has vs. what it needs.

**Open question:**
The SESSION_BOARD.md says "SuperNinja" should execute Phase 1. Is that a specific
agent configuration, or just a nickname for whoever picks up the task next?

**Tags:** #coordination #session-board #bootstrap #multi-repo
**Confidence in suggestions:** high

---

## Entry 2 — 2026-04-08 — Copilot Coding Agent — Review Ruflo cleanup and define context spine

**Session type:** review / research
**Files touched:** `docs/CANONICAL_CONTEXT_SPINE.md` (created), `CLAUDE.md` (updated),
`docs/POWER_TOOLS.md` (updated), `docs/NICK_SYSTEM_CONTEXT.md` (updated),
`SESSION_LOG.jsonl` (appended)
**Time:** ~45 min

**Key insight:**
The Ruflo file cleanup was directionally correct — most deleted files were generic
upstream Ruflo content, not project-specific value. The real value in this repo is the
custom layer: hooks, settings, MCP config, session coordination, and docs. A few deleted
files had niche idea value (browser-agent, flow-nexus, sona, payments) but should only
return if intentionally maintained. Also: the live Ruflo CLI doesn't match the old docs —
`ruflo skill list` doesn't exist in the installed release, and `ruflo agent list` shows
active agents, not a static catalog.

**Suggestion for next agent:**
Add a `repos/` manifest with per-repo status JSON files so agents cold-starting here
can immediately see the state of Versailles, Foundation-layer, and MUNCH.

**Open question:**
The `versailles-skills-export/` directory has 13 staged skills that haven't been imported
into Versailles yet. Should the next agent handle that import, or wait for Versailles's
pipeline to be manually triggered?

**Tags:** #cleanup #context-spine #ruflo #documentation
**Confidence in suggestions:** high

---

## Entry 3 — 2026-04-08 — Copilot Coding Agent (GPT-5.4) — Orchestration guide and environment analysis

**Session type:** research / feature
**Files touched:** `docs/ORCHESTRATION_GUIDE.md` (created), `AGENT_NOTES.md` (created),
`SESSION_LOG.jsonl` (appended), `docs/CANONICAL_CONTEXT_SPINE.md` (read)
**Time:** ~60 min

**Key insight:**
Ruflo and Claude Code native sub-agents are complementary layers, not competitors. Ruflo
handles swarm coordination (memory, consensus, topology, hooks). Claude Code sub-agents
handle per-agent model selection and context isolation. The 2+1 orchestrator pattern
(GPT-5.4 orchestrator + Opus 4.6 + GPT-5.4 sub-agents) requires a model proxy like
`claude-code-gpt-5` to route GPT-5 calls through Claude Code. This repo is running inside
GitHub Copilot's coding agent environment (not Claude Code directly), which means the
`.claude/settings.json` hooks fire only when Claude Code is the runtime — in the Copilot
runner they're inert. The Copilot environment needs its own `copilot-setup-steps.yml` to
install Ruflo and other tools.

Also researched persistent memory systems: MemPalace (100% recall, local-first, MCP-native),
Mem0 (hosted MCP server, easy setup), and Supermemory/Mastra (framework-level memory with
thread/user scoping). MemPalace is the strongest fit for a privacy-first, high-recall setup.
Mem0 is easiest to wire up as an MCP server. Either could provide the persistent cross-session
memory layer this environment currently lacks.

**Suggestion for next agent:**
Create `.github/copilot-setup-steps.yml` to install Ruflo and MemPalace/Mem0 in the
Copilot coding agent runner. This is the single highest-leverage improvement for making
the self-building environment actually work inside GitHub. Also: add a `mem0` or
`mempalace` MCP server entry to `.mcp.json` once the memory backend is chosen.

**Open question:**
The `.claude/settings.json` hooks are Claude Code-specific — they don't fire in the
Copilot coding agent runner. Is there an equivalent hook system for Copilot, or does
all customization need to go through `copilot-setup-steps.yml` + GitHub Actions?

**Tags:** #orchestration #ruflo #memory #copilot #environment #mempalace #mem0
**Confidence in suggestions:** high

---

<!-- ADD YOUR ENTRY HERE ↓ -->
