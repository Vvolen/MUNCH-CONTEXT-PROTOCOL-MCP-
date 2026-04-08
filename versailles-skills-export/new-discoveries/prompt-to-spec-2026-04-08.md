---
name: prompt-to-spec
description: "Convert vague, conversational, or stream-of-consciousness user requests into precise, unambiguous technical specifications. Use when receiving any task description that contains ambiguity, multiple requests, implicit requirements, or natural language that needs translation into concrete deliverables."
---

# Prompt-to-Spec Translator

Users rarely specify what they want with engineering precision. They speak in intent, emotion, and references to things in their head. This skill translates messy human communication into structured, actionable specifications that an agent or developer can execute without asking 20 follow-up questions.

## When to Use

- When receiving any task request that is longer than 3 sentences
- When a request contains words like "kinda," "maybe," "something like," "you know what I mean"
- When a request references multiple different tasks in one message
- When a request mixes requirements with commentary, excitement, or tangents
- When you need to upgrade a prompt before running it

## The Process

### Step 1: Extract the Core Requests

Read the entire input. Identify every distinct request, ignoring:
- Emotional reactions ("Holy shit that's great")
- Meta-commentary about the process ("Use your common sense")
- Permission/budget context ("I have $1600/month")
- Encouragement ("Let's do this shit")

For each distinct request, write one sentence:
```
REQUEST 1: [Precise statement of what is being asked]
REQUEST 2: [Precise statement of what is being asked]
REQUEST 3: [Precise statement of what is being asked]
```

### Step 2: Resolve Ambiguities

For each request, identify words that could mean different things:

| Vague Word | Ask Yourself | Resolution |
|-----------|-------------|------------|
| "fix it" | Fix what? All errors? A specific behavior? | Identify specific symptoms |
| "make it work" | What does "working" look like? What's the test? | Define success criteria |
| "put X in Y" | Copy? Move? Reference? Transform format? | Identify exact operation |
| "check" | Read? Validate? Audit? Report? Fix? | Identify depth of checking |
| "something like" | Exactly like? Inspired by? The same category? | Identify degree of similarity |
| "the best" | Best by what metric? Speed? Quality? Popularity? | Define ranking criteria |

If you CAN resolve it from context, do so. If you genuinely can't, note it as an assumption.

### Step 3: Identify Implicit Requirements

Things the user expects but didn't say:

- **Quality bar**: If they show excitement about existing work, they want the new work to match that quality
- **Scope**: If they mention constraints (time, money), they want efficiency, not exhaustiveness
- **Audience**: Who is the work for? The user? Their team? End users?
- **Format**: What format should the output be in? File? PR? Report? Conversation?
- **Dependencies**: What needs to happen first? What blocks what?

### Step 4: Organize Into Execution Order

Arrange the requests by dependency:

```
PHASE 1 (no dependencies):
  - [Request that can start immediately]
  - [Request that can start immediately]

PHASE 2 (depends on Phase 1):
  - [Request that needs Phase 1 output]

PHASE 3 (depends on Phase 2):
  - [Request that needs Phase 2 output]
```

### Step 5: Write the Spec

For each request, produce:

```
## Task: [Clear title]
**Input:** [What you start with]
**Output:** [What you deliver]
**Success criteria:** [How to know it's done]
**Assumptions:** [What you're assuming, that the user didn't explicitly state]
**Risks:** [What could go wrong or what you might get wrong]
```

### Step 6: Run the Upgraded Version

Execute the spec, not the original prompt. The spec is the "upgraded prompt" — it contains all the same intent but with precision added.

## Example

**Original prompt (messy):**
> "Can you go look at what's failing in the other repo and fix it? Oh and also find some new skills and put them in there. And while you're doing that, check if agents are writing notes like they should be."

**Translated spec:**

```
## Task 1: Diagnose failures in target repo
Input: Access to target repo's CI/Actions logs
Output: Root cause analysis of each failing workflow
Success criteria: Each failure has an identified cause and a proposed fix

## Task 2: Fix identified failures
Input: Root cause analysis from Task 1
Output: Code changes (PRs or commits) that resolve each failure
Success criteria: All previously-failing workflows pass

## Task 3: Discover new high-quality skills
Input: Web research + GitHub search
Output: 5-10 new SKILL.md files meeting quality criteria
Success criteria: Each skill has proper YAML frontmatter, clear instructions, and examples

## Task 4: Import skills into target repo
Input: Skills from Task 3
Output: Files deposited in skills/discovered/ directory
Success criteria: Files exist, follow naming convention, and don't break existing pipeline

## Task 5: Audit agent note-taking compliance
Input: AGENT_NOTES.md or SESSION_LOG.jsonl
Output: Report on which agents are/aren't writing entries, with specific gaps identified
Success criteria: Clear list of compliant vs non-compliant sessions
```

## Guidelines

- The user is ALWAYS right about what they want. Your job is to make their intent precise, not to change it.
- When in doubt, bias toward action over clarification. Make an assumption, state it, and proceed.
- The best specs are short. If your spec is longer than the original request, you're over-specifying.
- This skill pairs well with ANY other skill — use it as a preprocessor before executing any task.
