---
name: reverse-engineer-intent
description: "Reconstruct the original intent behind existing code, configurations, and decisions before modifying them. Use when inheriting code, debugging unfamiliar systems, modifying code you didn't write, or when someone asks 'why is it done this way?'"
---

# Reverse-Engineer Intent

The most dangerous thing you can do in a codebase is change something you don't understand. Before changing ANY existing code, reconstruct WHY it was written that way. The previous developer may have been an idiot — or they may have known something you don't.

## When to Use

- Before modifying any code you didn't write
- Before "cleaning up" or "simplifying" existing code
- When a piece of code seems wrong, overcomplicated, or unnecessary
- When you're about to remove something that "isn't used"
- When inheriting a project or joining a team
- Before any refactoring

## The Process

### Step 1: Read Before You Judge

Read the code completely before forming opinions. Not skimming — reading.

- Read the function/class/module entirely
- Read the tests for it (if they exist)
- Read the comments (especially "weird" comments — they're often explaining non-obvious decisions)
- Read the git blame — who wrote each line, when, and what was the commit message?

### Step 2: Reconstruct the Decision History

```bash
# Who wrote this and when?
git blame path/to/file.ext

# What was the context of this change?
git log --follow -p path/to/file.ext

# Was there a PR with discussion?
git log --oneline path/to/file.ext
# Then look up the PR numbers in the commit messages
```

Look for:
- Bug fix commits ("fix: prevent race condition when...")
- Revert commits (someone tried removing this before and it broke)
- Comments referencing tickets, issues, or incidents
- Links to external documentation or standards

### Step 3: Identify the Constraints

Code that looks "wrong" often exists because of constraints you can't see:

**Performance constraints:** The "ugly" code might be an optimization that handles 10x more load than the "clean" version.

**Compatibility constraints:** The "weird" check might handle a browser bug, OS quirk, or legacy API behavior.

**Business constraints:** The "unnecessary" code path might handle a rare but critical business case (like end-of-year accounting).

**Regulatory constraints:** The "redundant" validation might be required by PCI, HIPAA, GDPR, or SOX compliance.

**Concurrency constraints:** The "overcomplicated" locking might prevent a race condition that only manifests under specific load patterns.

### Step 4: Test Your Understanding

Before modifying, verify your understanding:

1. Can you explain WHY every non-obvious line exists?
2. Can you explain what would break if you removed it?
3. Can you write a test that demonstrates the behavior this code handles?

If you can't answer all three → you don't understand it well enough to change it.

### Step 5: Document What You Found

```
CODE: [What the code does]
ORIGINAL INTENT: [Why it was written this way]
CONSTRAINTS: [What constraints shaped this decision]
EVIDENCE: [Commit messages, PRs, comments, tests that confirm your understanding]
SAFE TO CHANGE: [Yes/No/Partially — and what would need to be preserved]
```

## The Chesterton's Fence Rule

> "Don't remove a fence until you know why it was put there."

Before removing or simplifying ANYTHING:
1. Understand why it exists
2. Verify the reason still applies
3. If the reason still applies, the code stays (or gets replaced with something that serves the same purpose)
4. If the reason no longer applies, document why before removing

## Red Flags

- "This code is obviously wrong" — Maybe. Or maybe it handles something you haven't seen yet.
- "This is dead code" — Search for dynamic references, reflection, config-based loading, and external callers before deleting.
- "Let me clean this up" — Clean is good. Understanding first is mandatory.
- "I'll simplify this" — Simple is good. Accidentally removing edge case handling is not.
- "Nobody knows why this is here" — That's a reason to investigate harder, not a reason to delete.

## Common Traps

| What You See | What It Might Be |
|-------------|-----------------|
| Empty catch block | Intentional swallowing of known, harmless exception |
| Duplicate code | Deliberate independence (changing one shouldn't affect the other) |
| Magic number | Performance-tuned constant based on production data |
| Commented-out code | Reference for a pattern that's needed seasonally |
| Sleep/delay | Workaround for a timing issue in an external dependency |
| Redundant check | Defense against a bug in a dependency that was never fixed |
| Overly broad exception handler | Protection against an unstable third-party library |

## Quick Reference

| Phase | Action | Output |
|-------|--------|--------|
| Read | Read code, tests, comments completely | Full picture, not assumptions |
| Reconstruct | Git blame, commit history, PR discussions | Decision timeline |
| Constraints | Identify invisible constraints | Why "wrong" code is right |
| Verify | Explain every line, identify what breaks | Confidence to change |
| Document | Record intent, constraints, evidence | Knowledge preserved |
