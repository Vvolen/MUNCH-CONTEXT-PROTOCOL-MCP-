---
name: blast-radius-estimator
description: "Estimate the impact zone of any code change before making it. Use when modifying shared code, changing interfaces, updating dependencies, deleting code, or making any change that might affect other components."
---

# Blast Radius Estimator

Every code change has a blast radius — the set of things that could break. Small changes to shared code can cascade across entire systems. This skill maps the blast radius BEFORE you make the change so you know what to test, what to monitor, and who to warn.

## When to Use

- Before modifying any function that's called by more than one place
- Before changing any interface, API, or contract
- Before updating a dependency version
- Before deleting code, files, or resources
- Before changing database schemas
- Before modifying configuration or environment variables
- Before any "quick fix" in production

## The Process

### Step 1: Identify What You're Changing

Be specific:
```
CHANGE: [Exact file, function, line range, or configuration]
CHANGE TYPE: [Signature change | Behavior change | Deletion | Addition | Config change]
```

### Step 2: Map Direct Dependents

Find everything that directly uses the thing you're changing:

```bash
# Who calls this function?
grep -rn "functionName" --include="*.ts" --include="*.py" .

# Who imports this module?
grep -rn "from.*module.*import\|require.*module" .

# Who references this config?
grep -rn "CONFIG_KEY\|config\.key" .

# Who uses this API endpoint?
grep -rn "/api/endpoint" .
```

List every direct dependent:
```
DIRECT DEPENDENTS:
  1. [file.ts:42] — calls this function with [specific usage]
  2. [other-file.py:100] — imports this module for [specific purpose]
  3. [test-file.test.ts:15] — tests this behavior
  4. [CI pipeline] — runs this as part of build
```

### Step 3: Map Indirect Dependents (The Hidden Blast Radius)

For each direct dependent, check if IT has dependents:

```
file.ts:42 → is used by → api-handler.ts → is called by → frontend → affects users
other-file.py → is imported by → worker.py → processes jobs → affects batch processing
```

The indirect blast radius is usually 3-10x larger than the direct blast radius.

### Step 4: Classify the Risk

| Blast Radius | What It Means | Action Required |
|-------------|---------------|-----------------|
| **Contained** | Only affects code you own, with tests | Make change, run tests |
| **Local** | Affects your team's code | Notify team, expand test coverage |
| **Cross-team** | Affects other teams' code | Coordinate change, get reviews |
| **External** | Affects public API, customers, partners | Version/deprecate, communicate timeline |
| **Infrastructure** | Affects deployment, CI/CD, monitoring | Schedule maintenance window |

### Step 5: Build the Test Plan

Based on the blast radius:

```
MUST TEST (direct dependents):
  - [ ] [specific test for dependent 1]
  - [ ] [specific test for dependent 2]

SHOULD TEST (indirect dependents):
  - [ ] [integration test covering path A → B → C]
  - [ ] [smoke test for affected service]

MONITOR AFTER DEPLOY:
  - [ ] [metric/log/alert for affected area]
  - [ ] [error rate for affected endpoint]
```

### Step 6: Decide — Proceed, Shrink, or Split

| Blast Radius | Decision |
|-------------|----------|
| Matches what you expected | Proceed with test plan |
| Larger than expected but manageable | Shrink change scope, or split into smaller changes |
| Alarmingly large | Reconsider approach entirely — find a way to make the change with a smaller blast radius |

## Techniques for Shrinking Blast Radius

1. **Introduce the new thing alongside the old thing** — Don't replace in-place. Add v2, migrate callers one by one, delete v1.
2. **Feature flag** — Deploy the change behind a flag. Enable for 1%, then 10%, then 100%.
3. **Adapter pattern** — Put an adapter between the change and its dependents. Dependents don't see the change.
4. **Split into smaller PRs** — One PR per dependent, not one massive PR that changes everything.

## Red Flags

- "It's just a rename" — Renames in shared code touch every caller. That's not "just."
- "I'm only changing the implementation, not the interface" — Does the implementation change timing, error behavior, or side effects? Those are implicit interfaces.
- "Tests pass so it's fine" — Tests only cover what they test. Blast radius includes things with no tests.
- "I'll fix anything that breaks" — You can't fix what you can't find. Map it first.

## Quick Reference

| Phase | Action | Output |
|-------|--------|--------|
| Identify | Describe exact change | Precise change spec |
| Direct | grep/search for all callers | Direct dependent list |
| Indirect | Trace caller chains outward | Full blast radius map |
| Classify | Contained → Local → Cross-team → External | Risk level |
| Test plan | Tests for each ring of blast radius | What to verify |
| Decide | Proceed, shrink, or split | Informed action |
