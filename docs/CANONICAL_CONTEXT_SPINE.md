# Canonical Context Spine Strategy

## Recommendation

Use `Vvolen/MUNCH-CONTEXT-PROTOCOL-MCP-` as a **context spine / control-plane repo** for the
other repositories, not as a vendored copy of every upstream Ruflo agent, skill, or command.

## What Ruflo Actually Is

Ruflo is not just "an IDE." It is an **AI agent orchestration platform** that sits on top of
Claude Code / MCP-style environments and provides:

- runtime agent coordination
- swarm topologies and routing
- memory / AgentDB
- hooks and automation
- orchestration CLI / MCP entrypoints

That distinction matters:

- **Ruflo** should provide the orchestration substrate
- **this repo** should provide the cross-repo context, operating rules, and curated overlays

So the right move is to **consume Ruflo as infrastructure** and keep MUNCH focused on the
canonical context layer above it.

That means this repo should own:

- cross-repo coordination rules
- session continuity and handoff state
- architectural decisions and operator context
- automation entrypoints for multi-repo work
- curated exports and research outputs
- repo health/status summaries

It should **not** try to own or freeze:

- Ruflo's full upstream agent library
- Ruflo's full upstream skill library
- repo-local implementation details that belong inside Versailles or Foundation-layer
- stale mirrors of external command docs

## Why This Pattern Fits

The strongest multi-repo pattern here is a lightweight **meta-repo / spine**:

- code stays in the code repos
- durable context stays here
- cross-repo orchestration starts here
- agents can cold-start here, then branch out with context

This preserves repo autonomy while solving the real problem: fragmented context across tools and repos.

## What The Cleanup Got Right

Removing duplicated `.claude/agents/`, `.claude/skills/`, and `.claude/commands/` was directionally correct.

Why:

1. Most deleted content was generic upstream-style Ruflo material, not project-specific knowledge.
2. Several deleted command docs were already stale (`claude-flow` naming, outdated subcommands).
3. The truly valuable part of this repo is the **custom layer**:
   - `.claude/helpers/`
   - `.claude/settings.json`
   - `.mcp.json`
   - `SESSION_BOARD.md`
   - `SESSION_LOG.jsonl`
   - `CLAUDE.md`
   - `docs/`
   - workflow automation

## What Was Potentially Valuable In The Deleted Set

A few deleted files had niche value, but they were still better treated as **patterns to re-author selectively**
instead of keeping the whole upstream dump:

- `test-long-runner` — useful concept, but small enough to recreate intentionally if needed
- `browser-agent.yaml` — useful browser capability map, but should live as an actual maintained browser integration, not a static orphan config
- `flow-nexus/*`, `agentic-payments`, `sona-learning-optimizer` — interesting research patterns, but not part of this repo's canonical core unless they are actively used and maintained

In other words: the cleanup removed some interesting ideas, but not core repo value.
If one of those ideas matters, reintroduce it deliberately as a maintained artifact with a clear owner.

## Best Use Of This Repo Going Forward

### 1. Cross-Repo Session Hub

Keep using this repo as the first stop for agents:

- read `SESSION_BOARD.md`
- tail `SESSION_LOG.jsonl`
- load `docs/NICK_SYSTEM_CONTEXT.md`
- branch into Versailles or Foundation-layer with context already loaded

### 2. Canonical Status Layer

Add a lightweight machine-readable inventory for the downstream repos, for example:

```text
repos/
  versailles.json
  foundation-layer.json
  munch.json
```

Each file should capture:

- repo role
- current branch / default branch
- key workflows
- known blockers
- last successful health check
- last agent action
- links to important docs

### 3. Shared Decision Layer

Keep the cross-repo ADRs, rules, and operator context here:

- naming conventions
- repo responsibilities
- handoff protocol
- trust/scoring rules
- canonical workflow patterns

### 4. Orchestration Entry Layer

This repo should be where multi-repo automations start:

- agent-dispatch
- repo health checks
- cross-repo issue creation
- skill export/import coordination
- sync jobs for shared context

### 5. Curated Research Layer

This repo is a good place for:

- external-skill research
- import/export packages (like `versailles-skills-export/`)
- notes on what is worth pulling into other repos
- evaluation of upstream tools

## Practical Rule Of Thumb

If something is:

- **upstream runtime capability** → leave it upstream
- **cross-repo context or coordination** → keep it here
- **repo-specific implementation** → move it to the target repo
- **valuable but experimental** → document it here first, then selectively operationalize it

## Next High-Value Improvements

1. Add a small `repos/` manifest layer with per-repo status JSON
2. Add a scheduled workflow that refreshes repo health summaries
3. Keep `SESSION_LOG.jsonl` actively maintained by every agent session
4. Promote this repo as the **entrypoint**, not the storage location, for upstream agent/skill catalogs
5. Reintroduce only the deleted concepts that are both:
   - unique to your workflow
   - actively maintained

## Bottom Line

This repo is most useful as the **canonical context spine** for the system:

- **MUNCH** = orchestration + memory of the whole system
- **Versailles** = genome / knowledge base / skill evolution
- **Foundation-layer** = build and ingestion pipeline

That is a stronger and more durable role than being a giant mirror of upstream Ruflo files.
