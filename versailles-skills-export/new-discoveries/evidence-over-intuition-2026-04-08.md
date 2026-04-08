---
name: evidence-over-intuition
description: "Replace 'I think' with 'I measured' in every technical decision. Use when making performance claims, architecture decisions, technology choices, or any claim about system behavior. Use especially when two people disagree about what's faster, better, or more reliable."
---

# Evidence Over Intuition

Technical intuition is a useful starting point but a dangerous ending point. This skill ensures every significant claim is backed by measurement, not gut feeling. The difference between a junior and senior engineer is not intuition — it's the discipline to verify intuition with evidence.

## When to Use

- When claiming one approach is "faster" than another
- When choosing between technologies or architectures
- When debugging and saying "I think the problem is..."
- When estimating time, load, or resource usage
- When someone says "in my experience..."
- When reviewing code and saying "this seems inefficient"
- Before optimizing anything

## The Process

### Step 1: Identify the Claim

Convert any intuitive statement into a testable claim:

| Intuition | Testable Claim |
|-----------|---------------|
| "This seems slow" | "This endpoint takes >500ms for p95 requests" |
| "We should use Redis" | "Redis handles our read pattern at 10k req/s with <5ms latency" |
| "This code is inefficient" | "This loop has O(n²) complexity and takes >1s for n>10000" |
| "Users won't wait that long" | "Users abandon after >3 seconds based on analytics data" |
| "That approach won't scale" | "That approach fails when concurrent users exceed X" |

### Step 2: Design the Measurement

For performance claims:
```bash
# Measure actual timing
time command_here

# Profile the code
# Python: cProfile, line_profiler
# Node: --prof, clinic.js
# Go: pprof

# Load test
# ab, wrk, k6, locust
```

For architecture claims:
- Build a minimal proof-of-concept (hours, not days)
- Test the specific scenario you're worried about
- Measure the metric that matters (latency, throughput, memory, cost)

For technology choices:
- Prototype the same feature in both technologies
- Measure development time, performance, and maintenance complexity
- Talk to people who've used both in production

### Step 3: Compare Against Baseline

A measurement without context is meaningless. Always compare:

```
BASELINE: [Current performance / current approach / alternative]
MEASUREMENT: [New performance / new approach / proposed technology]
DELTA: [Difference in concrete terms: ms, requests/sec, $/month]
SIGNIFICANCE: [Is the delta large enough to matter?]
```

### Step 4: Make the Decision Based on Evidence

```
CLAIM: [What you originally thought]
EVIDENCE: [What you actually measured]
MATCH: [Did evidence confirm or contradict intuition?]
DECISION: [What to do, based on evidence]
ACTION: [Specific next step]
```

## The Premature Optimization Trap

"We need to optimize this" — Do we? Evidence required:
1. Is there actually a performance problem? (Measure)
2. Is THIS the bottleneck? (Profile)
3. Is the optimization worth the complexity cost? (Calculate)

Most "optimization" work optimizes things that aren't bottlenecks, making code harder to read for no measurable benefit.

## The Technology Hype Trap

"We should switch to [new technology]" — Evidence required:
1. What specific problem does this solve that our current stack doesn't?
2. What's the migration cost? (Time, risk, learning curve)
3. Has anyone used it at our scale in production? What happened?
4. What do we lose by switching? (Ecosystem, tooling, team expertise)

## Red Flags

- "It's obviously faster" — Obvious to whom? Measure it.
- "Everyone knows that..." — Appeal to authority. Measure it.
- "In my experience..." — Your experience may not apply here. Measure it.
- "Benchmarks show..." — Which benchmarks? On what hardware? With what data? Under what load?
- "It should be fine" — Define "fine" with a number. Then verify.

## Quick Reference

| Phase | Action | Output |
|-------|--------|--------|
| Identify | Convert intuition to testable claim | Precise hypothesis |
| Measure | Run the measurement | Concrete numbers |
| Compare | Baseline vs. measurement | Delta and significance |
| Decide | Evidence-based choice | Defensible decision |
