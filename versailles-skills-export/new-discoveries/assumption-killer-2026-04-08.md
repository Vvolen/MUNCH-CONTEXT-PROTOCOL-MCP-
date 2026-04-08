---
name: assumption-killer
description: "Identify and challenge hidden assumptions before they become bugs. Use when starting any new feature, debugging a stubborn issue, reviewing architecture decisions, or when someone says 'obviously' or 'just' in a technical discussion."
---

# Assumption Killer

Every bug that took more than an hour to fix was caused by an unexamined assumption. This skill systematically surfaces assumptions hiding in requirements, architecture, code, and conversation — then kills them with evidence.

## When to Use

- Before implementing any feature
- When debugging takes longer than 30 minutes
- When reviewing any design document
- When someone says "obviously," "just," "simply," "should work," or "it's straightforward"
- When two people disagree about how something works
- When moving code between environments

## The Process

### Step 1: Surface Hidden Assumptions

For any statement, plan, or piece of code, ask these questions:

**About Data:**
- What shape is the input? Have you seen it, or are you assuming?
- Can it be null, empty, negative, or extremely large?
- What encoding? What timezone? What locale?
- Is it fresh or cached? How stale could it be?

**About Environment:**
- What OS, runtime version, and configuration?
- What permissions does the process have?
- What's the network like? Latency? Reliability?
- What else is running concurrently?

**About Behavior:**
- Does that API actually return what you think? Check the docs, not your memory.
- Does that library handle edge cases the way you expect?
- What happens when this fails? Not "if" — "when."
- Is the order of operations guaranteed?

**About People:**
- Who will use this? Not who you imagine — who actually will.
- What will they misunderstand?
- What will they try that you didn't intend?
- What error messages will confuse them?

### Step 2: Rank by Danger

For each surfaced assumption, score it:

| Factor | Score |
|--------|-------|
| If wrong, causes data loss or security breach | Critical |
| If wrong, causes incorrect results silently | High |
| If wrong, causes a visible error | Medium |
| If wrong, causes cosmetic issues | Low |

Attack critical and high assumptions first.

### Step 3: Kill with Evidence

For each dangerous assumption, do ONE of:

1. **Read the source**: Not the docs — the actual source code or API response
2. **Write a test**: A test that would fail if your assumption is wrong
3. **Log it**: Add logging that proves the assumption at runtime
4. **Ask the owner**: The person who wrote that code or API

"I'm pretty sure it works like X" is not evidence. Evidence is output you can read.

### Step 4: Document What You Found

For each killed assumption, record:

```
ASSUMPTION: [What you assumed]
REALITY: [What you found]
IMPACT: [What would have gone wrong]
ACTION: [What you changed]
```

## Examples

### Dangerous assumption: "The API returns timestamps in UTC"
**Kill it:** Make an actual API call. Read the response. Check headers.
**Reality found:** API returns timestamps in the server's local timezone (PST).
**Impact:** Every scheduled task would fire 8 hours late.

### Dangerous assumption: "This field is always present"
**Kill it:** Query production data. Count nulls.
**Reality found:** 12% of records have null for this field.
**Impact:** NullPointerException in production for 1 in 8 users.

### Dangerous assumption: "The list is sorted"
**Kill it:** Log the actual order. Or read the query — is there an ORDER BY?
**Reality found:** No ORDER BY. Database returns in insertion order, which happens to be sorted... until a migration shuffles things.

## Red Flags — Stop and Kill

When you hear or think:
- "That should work"
- "It's always been like that"
- "The docs say..."  (docs can be wrong or outdated)
- "I tested it once and it worked"
- "That edge case won't happen"
- "Users won't do that"

These are assumptions wearing a disguise. Strip the disguise. Find evidence.

## Quick Reference

| Phase | Action | Output |
|-------|--------|--------|
| Surface | Ask the 16 questions above | List of assumptions |
| Rank | Score by danger | Priority order |
| Kill | Get evidence (source, test, log, ask) | Facts, not beliefs |
| Document | Record assumption → reality → impact | Knowledge for the team |
