# The Power User's Guide to This Environment

> **Date:** 2026-04-08 | **For:** Nick (Vvolen)
> **Tone:** Conversational, teaching-oriented, grounded in what actually works right now
> **Reading time:** ~20 min (but you'll want to keep this as reference)

---

## Part 1: What You've Actually Built (And Why It's More Than You Think)

Okay, let's start from the ground up, because you've been at this for six weeks on GitHub
and you've built something that most developers don't have after six *months*. I want you
to understand that.

You have three repos working together:

- **MUNCH** (this one) = the brain stem. It's the coordination layer — the place every
  agent starts, the place that knows about everything else.
- **Versailles** = the genome. Skills, discoveries, evolution pipeline. It's where agent
  capabilities live and get better over time.
- **Foundation-layer** = the build pipeline. Ingestion, processing, the eventual
  data-to-knowledge engine.

And on top of all that, you have **Ruflo** (the swarm orchestrator), **custom hooks** that
fire during sessions, an **MCP server** that exposes 215 tools, and a **self-building memory
system** via AGENT_NOTES.md. That's a legitimate multi-agent orchestration platform.

The gap isn't in what you've built. The gap is in **understanding the runtime** — what
happens when you actually trigger work, where the code runs, and how to make it smarter.

Let's fix that.

---

## Part 2: The GitHub Copilot Runtime (Where Your Code Actually Runs)

This is the single most important thing to understand, so let me teach it properly.

### What Happens When You Tag @copilot

When you write a comment on a PR or issue and tag `@copilot`, here's exactly what occurs:

1. **GitHub sees the tag** and creates a "coding agent session"
2. **A fresh Ubuntu machine spins up** — this is a GitHub Actions runner, similar to CI
3. **Your repo gets cloned** into `/home/runner/work/<repo>/<repo>`
4. **If you have `copilot-setup-steps.yml`**, those steps run first (install tools, etc.)
5. **The agent starts working** — reading files, making edits, running commands
6. **When done**, it commits changes and pushes to a PR branch
7. **The machine is destroyed** — everything not committed to git is gone

This is the key insight: **the Copilot coding agent is ephemeral**. Every session is a
clean room. No memory of last time. No running daemons. No persistent database.

### Why This Matters For You

All those Ruflo hooks in `.claude/settings.json`? They only fire when Claude Code is the
runtime. In the Copilot runner, they're inert — the Claude runtime isn't there to trigger
them.

That's not a problem — it just means you need to think about *two environments*:

| Environment | When It Runs | What It Has |
|-------------|-------------|-------------|
| **Copilot coding agent** | When you tag @copilot on GitHub | Fresh Ubuntu, tools from `copilot-setup-steps.yml`, your repo |
| **Claude Code (local/Codespace)** | When you run Claude Code in terminal or Codespace | Persistent session, hooks, MCP servers, Ruflo daemon |

The `copilot-setup-steps.yml` is your way to customize what the Copilot agent gets.
Think of it as the "onboarding checklist for a new team member who has amnesia every morning."

### Your 1,600 Premium Requests

With Copilot Pro Plus, you get 1,600 premium requests per month. Here's how the models burn them:

| Model | Requests Per Use | Best For |
|-------|-----------------|----------|
| GPT-5.4 | 1 | Fast work, implementation, research |
| Claude Sonnet 4.6 | 1 | Same tier as GPT-5.4 |
| Claude Opus 4.6 | **3** | Deep reasoning, architecture, complex analysis |
| GPT-5 mini | 1 (not premium) | Simple tasks |

So your 2+1 pattern costs **5 requests per complex task** (1 for orchestrator + 3 for
Opus + 1 for GPT-5.4 sub-agent). That gives you ~320 complex orchestrated tasks per month.
For comparison, most people burn through requests on single-agent work and get maybe 500
simple completions. You'd be getting 320 deep, adversarially-verified results. That's a
much better trade.

---

## Part 3: How Multi-Model Orchestration Actually Works

### The Models You Can Use (Right Now, In Copilot)

As of April 2026, Copilot Pro Plus gives you access to:

- **Claude Opus 4.5 and 4.6** — the heavy hitters, best SWE-bench scores
- **GPT-5, GPT-5.2, GPT-5.3, GPT-5.4** — fast, lean, great at reasoning
- **Gemini models** — available but less commonly used for code

You can **switch models mid-conversation** in Copilot Chat, or let "Auto" mode pick the
best one for each task. This is native — no proxy needed when you're in Copilot's UI.

### The Difference Between Copilot UI and Copilot Coding Agent

Here's where it gets nuanced:

**Copilot Chat (in browser/VS Code):** You pick the model from a dropdown. You can switch
between Opus, GPT-5.4, Sonnet, whatever. It's interactive. You're the orchestrator.

**Copilot Coding Agent (the @copilot tag):** The agent runs autonomously. It picks its own
model (or you can hint with `+opus` or `+model:gpt-5.4` in some configurations). But it's
one agent, one session, one model at a time.

### So How Do You Get Parallel Adversarial Agents?

There are three approaches, and I want you to understand all of them so you can pick the
right one for each situation:

#### Approach 1: Sequential Cross-Check (Simplest, Works Today)

This is the "poor man's adversarial" — and honestly, it's surprisingly effective:

1. Tag `@copilot` with a task, using Opus 4.6 as the model
2. Opus does the work, creates a PR
3. You (or another agent) reviews the PR, asking GPT-5.4 to critique it
4. If GPT-5.4 finds issues, you iterate

**Cost:** 3 + 1 = 4 requests. **Quality:** High, because two different models looked at it.
**Downside:** It's sequential, not parallel.

#### Approach 2: GitHub Actions Matrix Strategy (Parallel, Real Adversarial)

This is the power move. You create a GitHub Actions workflow that:

1. Receives a task description as input
2. Spawns two parallel jobs using a `matrix` strategy
3. Each job runs a different model on the same task
4. A final job compares the outputs and picks the best (or merges them)

Here's the concept (simplified):

```yaml
jobs:
  agent-run:
    strategy:
      matrix:
        model: [opus-4.6, gpt-5.4]
    steps:
      - name: Run agent with ${{ matrix.model }}
        # Each model independently works on the task
        # Outputs are saved as artifacts

  judge:
    needs: agent-run
    steps:
      - name: Compare outputs
        # Download both artifacts, diff them, pick winner
```

**Cost:** 3 + 1 + 1 (judge) = 5 requests. **Quality:** Highest — truly independent,
parallel, adversarial. **Downside:** Requires workflow setup (which an agent can build for you).

#### Approach 3: Agent HQ / Mission Control (GitHub's Built-In)

GitHub has been rolling out **Agent HQ** — a dashboard for managing multiple coding agents.
It lets you:

- Launch the same task to multiple agents
- See their work side-by-side
- Compare diffs
- Pick the best solution

This is GitHub's native answer to multi-agent orchestration. It's the easiest way to do
parallel adversarial work, but it's still evolving and may not be fully available on all
plans yet.

#### Approach 4: AgentCouncil (CLI Extension)

A tool called **AgentCouncil** (by Sentry01 on GitHub) lets you run three models in
parallel from the CLI, with explicit **collaborative** or **adversarial** modes:

- **Collaborative:** Models refine each other's answers
- **Adversarial:** Models attack the strongest answer, an orchestrator judges

This is the closest thing to what you described wanting.

---

## Part 4: How Memory Actually Works (And How To Make It Persist)

This is the part where it all clicks.

### The Problem

Every Copilot session starts with amnesia. The agent doesn't know what happened last time.
It doesn't know your preferences. It doesn't know what was decided. It has to figure
everything out from scratch.

### The Solution: Three Layers of Memory

Think of it like the human brain:

**Layer 1: Reflexive Memory (Git-Tracked Files)**
- `AGENT_NOTES.md` — what the last agent learned and suggests
- `SESSION_LOG.jsonl` — machine-parseable history
- `SESSION_BOARD.md` — current status and plan
- `CLAUDE.md` — the constitution, how agents should behave

This is like muscle memory. The agent reads these files first thing, and they tell it
what's going on. It works because git is the one thing that *always* persists.

**Layer 2: Semantic Memory (MCP-Accessible Database)**
This is where memory systems like MemPalace, Mem0, or Ruflo's AgentDB come in. They give
you:
- **Searchable memory** — "What did we decide about authentication?" → instant answer
- **Structured recall** — not just text files, but vector-indexed knowledge
- **Cross-session persistence** — survives ephemeral runner destruction

Here's what each option gives you:

| System | Recall Score | Local/Cloud | Setup Effort | Best For |
|--------|-------------|-------------|-------------|----------|
| **MemPalace** | 100% (benchmark leader) | 100% local | Medium | Privacy-first, highest accuracy |
| **Mem0** | ~85% | Cloud or self-hosted | Low (one-line MCP add) | Quick setup, easy integration |
| **Supermemory/Mastra** | Good | Cloud/SQL | Medium-High | Framework-level projects |
| **Ruflo AgentDB** | Good | Local | Already done | Claude Code sessions only |

**My recommendation:** Start with **Mem0** (easiest to wire up as MCP), graduate to
**MemPalace** when you want maximum recall and local control.

**Layer 3: Institutional Memory (Cross-Repo Knowledge)**
This is the MUNCH context spine pattern. MUNCH knows about all three repos. Any agent
that starts here gets the full picture. The `repos/` manifest (when you add it) will
make this machine-readable.

### How To Actually Set Up Memory

For Mem0 (the quick win), you'd add this to `.mcp.json`:

```json
{
  "mcpServers": {
    "mem0": {
      "type": "http",
      "url": "https://mcp.mem0.ai/mcp"
    }
  }
}
```

For MemPalace (the power play), in `copilot-setup-steps.yml`:

```yaml
- name: Install MemPalace
  run: |
    pip install mempalace
    mempalace init .
```

Then the agent can store and retrieve memories through MCP calls.

---

## Part 5: The Self-Building Environment Pattern

This is your favorite concept, and it's already working. Let me explain *why* it works
and how to make it work harder.

### The Loop

```
Agent N arrives → reads AGENT_NOTES.md → sees "next agent should do X"
                → does X (or adapts based on what it finds)
                → discovers Y along the way
                → writes: "I did X, discovered Y, next agent should do Z"
                → commits → leaves

Agent N+1 arrives → reads AGENT_NOTES.md → sees "next agent should do Z"
                  → and the cycle continues
```

Each agent is a worker bee that:
1. Inherits collective knowledge
2. Does useful work
3. Leaves the hive smarter than it found it

This IS the self-building pattern. The repo literally gets better every time an agent
touches it.

### How To Supercharge It

**Add AGENT_NOTES.md to every repo.** Versailles already has it (4 entries). MUNCH now
has it (just created). Foundation-layer needs it. When all three repos have it, any agent
starting in any repo gets instant context.

**Make the notes higher quality.** The template enforces:
- One specific key insight (not "the pipeline works" but "the scout routes to the wrong
  directory and here's why")
- One actionable suggestion (something the next agent can actually do in one session)
- One open question (something genuinely uncertain that needs investigation)

**Over time**, the AGENT_NOTES becomes a searchable institutional memory — you can grep
it for past decisions, past failures, past discoveries. It's a knowledge base that writes
itself.

---

## Part 6: Actions, Apps, Variables, and Scripts (The Full Toolkit)

Let me teach you what each piece of the GitHub ecosystem actually does, because once you
understand the building blocks, you can combine them in powerful ways.

### GitHub Actions (Your Automation Engine)

Actions are automated workflows that run when something happens. Think of them as:
"When X happens, do Y."

| Trigger | What Happens | Example |
|---------|-------------|---------|
| `push` | Code was pushed | Run tests, lint, deploy |
| `pull_request` | PR was opened/updated | Run code review, security scan |
| `workflow_dispatch` | Manual trigger (you click a button) | Run a research task, generate a report |
| `schedule` | Cron timer | Daily health check, weekly cleanup |
| `issue_comment` | Someone comments on an issue | Dispatch work to an agent |

**What you already have:**
- `ci.yml` — validates repo structure on every push
- `agent-dispatch.yml` — dispatches tasks to agents

**What you could add:**
- A scheduled health check that pings all three repos
- An adversarial review workflow (matrix strategy with two models)
- A memory sync workflow that indexes AGENT_NOTES into searchable format

### Secrets and Variables (Your Configuration Layer)

**Secrets** = sensitive values (API keys, tokens). Encrypted, never shown in logs.
**Variables** = non-sensitive config (URLs, mode flags, feature toggles).

Both can be scoped to:
- **Repository** — only this repo can see them
- **Environment** — only jobs in a specific environment (dev/staging/prod) can see them
- **Organization** — shared across all repos in your org

**What you should set up:**
- `ANTHROPIC_API_KEY` — for Ruflo/Claude operations (repo secret)
- `OPENAI_API_KEY` — for GPT-5 operations (repo secret)
- `MEM0_API_KEY` — for memory (if using hosted Mem0) (repo secret)

### Environment Configurations

GitHub "environments" let you create named contexts (like `production`, `staging`,
`research`) with their own:
- Secrets
- Variables
- Protection rules (require approval before running)
- Wait timers

For your use case, you might create:
- **research** environment — for exploratory work, less restrictive
- **production** environment — for changes that affect real configs, requires your approval

### `copilot-setup-steps.yml` (The Agent Onboarding Script)

This is the file that transforms a bare Ubuntu runner into your custom environment.
Everything you want every Copilot agent to have access to goes here:

- Ruflo installation
- Memory system setup
- Python + Node.js toolchains
- MCP server initialization
- Environment validation

I've created one for this repo (check `.github/copilot-setup-steps.yml`).

### `.github/copilot-instructions.md` (Teaching Copilot Your Conventions)

This file teaches Copilot how to behave in your repo. It's like CLAUDE.md but specifically
for Copilot. You can tell it:
- Always read AGENT_NOTES.md first
- Always append an entry before finishing
- Use progressive disclosure (don't dump all context at once)
- Follow the 3-tier model routing from CLAUDE.md

### MCP Servers (Your Tool Connectors)

MCP (Model Context Protocol) is how agents talk to external tools. Think of each MCP
server as a "plugin" that gives the agent new abilities:

| MCP Server | What It Does | Already Configured? |
|-----------|-------------|-------------------|
| `claude-flow` (Ruflo) | 215 orchestration tools | ✅ Yes |
| `github` | GitHub API access | ✅ Yes (in Copilot) |
| `filesystem` | Safe file operations | Depends on runtime |
| `mem0` | Persistent memory | ❌ Not yet |
| `mempalace` | Local memory palace | ❌ Not yet |
| `sequential-thinking` | Step-by-step reasoning | Configured in Versailles |

---

## Part 7: Testing and Quality Gates (Baking In Safety When You Don't Code)

This is crucial for you, because as a non-developer who directs agents to build things,
you need guardrails that catch problems automatically.

### What "Baked In" Testing Looks Like

Your `ci.yml` already does basic validation:
- Checks required files exist
- Validates JSON syntax
- Checks security audit status

But you can go much further:

**Level 1: Structure Validation (Already Have)**
- Required files present ✅
- JSON configs valid ✅
- Hook helpers have valid syntax ✅

**Level 2: Content Validation (Easy to Add)**
- AGENT_NOTES.md has entries (not empty)
- SESSION_LOG.jsonl has valid JSON on every line
- No secrets committed to any file

**Level 3: Agent-Powered Review (The Power Move)**
- On every PR, run a Copilot review that checks for:
  - Does this PR break existing behavior?
  - Does it follow the conventions in CLAUDE.md?
  - Does it have an AGENT_NOTES entry?

**Level 4: Adversarial Review (The Ultimate)**
- Two models review every PR independently
- If they disagree, the PR is flagged for your review
- If they agree it's good, it auto-passes

### How To Set This Up

The simplest version: add a required status check on your `main` branch that must pass
before any PR can merge. Your existing `ci.yml` already runs on PRs — just make it a
required check in branch protection rules.

To do this:
1. Go to Settings → Branches → Add rule for `main`
2. Check "Require status checks to pass before merging"
3. Select your CI workflow

Now no agent (or human) can merge broken code to main.

---

## Part 8: The Upgrade Plan (What To Do Next, In Order)

Here's what I'd recommend, ranked by impact and ordered so each step builds on the last:

### Phase 1: Foundation (Do This Week)
1. ✅ AGENT_NOTES.md created (done this session)
2. **Create `copilot-setup-steps.yml`** — so every Copilot session has Ruflo installed
3. **Add branch protection on main** — require CI to pass before merge
4. **Add `copilot-instructions.md`** — teach Copilot to read AGENT_NOTES first

### Phase 2: Memory + Research Tools (Next Week)
5. **Add Mem0 MCP to `.mcp.json`** — instant persistent memory
6. **Add Perplexity MCP** — real-time web-grounded research
7. **Add FireCrawl MCP** — web scraping and site crawling
8. **Store API keys as repo secrets** — `PERPLEXITY_API_KEY`, `FIRECRAWL_API_KEY`
9. **Test the research stack** — ask an agent to research a topic using all three

### Phase 3: Adversarial (Week After)
10. **Create an adversarial review workflow** — matrix strategy, two models
11. **Test it on a real task** — give both models the same complex task, compare results
12. **Refine the judge logic** — the orchestrator that picks the best output

### Phase 4: Cross-Repo (Ongoing)
13. **Add AGENT_NOTES.md to Foundation-layer**
14. **Add `repos/` status manifest** to MUNCH
15. **Add cross-repo dispatch** — MUNCH can trigger work in Versailles or Foundation-layer

---

## Part 9: What Power Users Say Works Best

Based on the research sprint, here's what the community has converged on:

### The "Obviously Right" Things
- **AGENT_NOTES / session logs** — every serious multi-agent setup has some version of this
- **copilot-setup-steps.yml** — if you're using Copilot's coding agent, this is non-negotiable
- **Branch protection + required CI** — the safety net that catches agent mistakes
- **Model routing** — use the expensive model only when it matters

### The "Not Obvious But Powerful" Things
- **Git worktrees for parallel agents** — each agent gets its own copy of the repo to
  avoid conflicts
- **AgentCouncil** — a CLI tool that runs three models adversarially on the same task
- **MCP servers as plugins** — the MCP ecosystem is exploding; every tool you connect
  gives agents new capabilities
- **Environments with approval gates** — for high-stakes changes, require your manual
  approval before the workflow proceeds

### The "Sounds Cool But Skip For Now" Things
- **Full Ruflo swarms** — 60+ agents in a mesh topology sounds amazing but is overkill
  for your current repos. Start with 2+1 and scale up as needed.
- **WASM kernels** — Ruflo's Rust-powered policy engine. Cool tech, but you'll never
  configure it directly.
- **Byzantine Fault Tolerance consensus** — designed for untrusted multi-party systems.
  Your agents aren't adversarial to *each other* — they're adversarial to *bad code*.

---

---

## Part 10: Perplexity Agent API and FireCrawl (Your Research Superpowers)

These two tools are game-changers for what you're building. Let me explain what each does
and exactly how they fit.

### Perplexity Agent API (Sonar Pro)

**What it is:** A real-time, web-grounded AI research engine with an API. It's like having
a researcher who can search the entire internet, read the results, reason about them, cite
sources, and then call custom tools — all in one API call.

**Why it's different from just "searching the web":**

Regular web search: "Here are 10 blue links, good luck."
Perplexity Sonar Pro: "Here's a synthesized answer with inline citations, I checked 47
sources, cross-referenced the data, and here's my confidence level."

**Key capabilities:**

| Feature | What It Means For You |
|---------|----------------------|
| 200K token context window | Can digest entire research papers, not just snippets |
| Real-time web search | Always current — no training data cutoff issues |
| Function/tool calling | Can trigger your custom functions mid-research |
| Multi-model council | Can route to different models per query type |
| OpenAI-compatible API | Drop-in replacement — works with existing tooling |
| Citation tracking | Every claim has a source URL you can verify |

**How it fits in your environment:**

Perplexity becomes your **research MCP server**. When an agent needs to understand something
about the outside world — a new library, a security vulnerability, a market trend, a
competitor's approach — it calls Perplexity instead of relying on its training data.

**Concrete integration:**

Add it to `.mcp.json` as an MCP server, or call it directly via API from within agent
workflows. The OpenAI-compatible API means any tool that can call OpenAI can call Perplexity
with just a URL change.

```json
{
  "mcpServers": {
    "perplexity": {
      "command": "npx",
      "args": ["-y", "perplexity-mcp"],
      "env": {
        "PERPLEXITY_API_KEY": "${PERPLEXITY_API_KEY}"
      }
    }
  }
}
```

**The real power move:** Use Perplexity as the research arm of your adversarial setup.
One agent (Opus) builds the solution. The other agent (GPT-5.4) uses Perplexity to
fact-check the solution against current best practices. The orchestrator synthesizes.

**Cost:** ~$5 per 1,000 searches for Sonar Pro. For research-heavy tasks, this is
incredibly cost-effective compared to burning Opus tokens on web search.

### FireCrawl

**What it is:** An AI-native web scraping and crawling engine, available as an MCP server.
It turns any website into clean, structured data that agents can consume.

**The difference between Perplexity and FireCrawl:**

- **Perplexity** = asks a question, gets a synthesized answer with citations
- **FireCrawl** = points at a URL (or whole site), gets the raw content back as clean markdown

They're complementary, not competing.

**Key capabilities:**

| Feature | What It Does |
|---------|-------------|
| `firecrawl_scrape` | Scrape a single URL to markdown |
| `firecrawl_batch_scrape` | Scrape many URLs at once |
| `firecrawl_crawl` | Crawl an entire website, follow links |
| `firecrawl_extract` | LLM-powered structured data extraction |
| `firecrawl_agent` | Autonomous research agent that navigates sites |

**How it fits in your environment:**

FireCrawl is your agent's **eyes on the web**. When Versailles's scout needs to analyze a
GitHub repo's documentation, or when a research agent needs to read a blog post, or when
you need to extract structured data from a competitor's site — FireCrawl handles it.

**Concrete integration:**

```json
{
  "mcpServers": {
    "firecrawl": {
      "command": "npx",
      "args": ["-y", "firecrawl-mcp"],
      "env": {
        "FIRECRAWL_API_KEY": "${FIRECRAWL_API_KEY}"
      }
    }
  }
}
```

**Use cases in your system:**

1. **Versailles skill scouting:** FireCrawl reads GitHub readmes and docs → agent evaluates
   → skill enters pipeline
2. **Research sprints:** Perplexity finds the best sources → FireCrawl scrapes the full
   content → agent synthesizes
3. **Competitive intelligence:** FireCrawl maps a competitor's entire docs site → agent
   extracts key patterns and approaches
4. **Keeping up to date:** Scheduled workflow crawls key sites weekly → results feed into
   AGENT_NOTES as fresh context

### The Research Stack (How They Work Together)

Here's the full picture of how Perplexity, FireCrawl, and your existing tools combine:

```
You ask: "Research the best approaches to X"
         │
         ▼
    Orchestrator (GPT-5.4)
         │
         ├── Perplexity Sonar Pro
         │     "What are the top 5 approaches to X? Give me citations."
         │     → Returns: synthesized answer + 15 source URLs
         │
         ├── FireCrawl
         │     "Scrape these 5 most relevant URLs to full markdown"
         │     → Returns: complete content from each source
         │
         ├── Deep Analyzer (Opus 4.6)
         │     "Given this research, what's the best approach for our system?"
         │     → Returns: architectural recommendation with reasoning
         │
         ├── Efficient Builder (GPT-5.4)
         │     "Critique this recommendation. What did the analyzer miss?"
         │     → Returns: adversarial review
         │
         └── Orchestrator synthesizes → final recommendation
```

**Total cost for this entire pipeline:**
- 1 Perplexity search (~$0.005)
- 5 FireCrawl scrapes (~$0.01)
- 1 orchestrator request (1 premium)
- 1 Opus request (3 premium)
- 1 GPT-5.4 request (1 premium)
- **Total: 5 premium requests + ~$0.015 in API costs**

That's a deeply researched, adversarially verified, web-grounded recommendation for
about a nickel in API costs and 5 of your 1,600 monthly requests.

---

## The One-Paragraph Summary

You're running a multi-repo orchestration platform on GitHub with Copilot Pro Plus.
Every Copilot session is ephemeral (fresh machine, no memory), so your persistent
memory lives in git-tracked files (AGENT_NOTES.md, SESSION_LOG.jsonl) plus optional
MCP-accessible databases (Mem0, MemPalace). To run parallel adversarial agents, use
GitHub Actions matrix strategies or AgentCouncil. To make the environment self-building,
every agent reads the last agent's notes and writes its own. For research, Perplexity
Sonar Pro gives you real-time web-grounded answers with citations, and FireCrawl gives
you full-site scraping as an MCP tool. The most impactful next steps are: (1) the
`copilot-setup-steps.yml` so sessions start pre-configured, (2) Mem0 for persistent
semantic memory, (3) Perplexity + FireCrawl as MCP servers for research, and (4) the
adversarial review workflow. You've come impressively far for six weeks on GitHub — the
system you're building is architecturally sound, and now it's about filling in the
operational details that make it sing.
