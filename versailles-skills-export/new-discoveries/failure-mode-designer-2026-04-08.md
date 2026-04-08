---
name: failure-mode-designer
description: "Design how your system fails before you design how it succeeds. Use when building any new service, API, integration, workflow, or distributed component. Use before writing the happy path."
---

# Failure Mode Designer

Most systems are designed for success and fail by accident. This skill flips that: design how the system fails FIRST, then make the happy path work within those constraints.

Systems that handle failure gracefully are 10x more valuable than systems that only handle success beautifully.

## When to Use

- Before implementing any API endpoint or service
- Before building any integration with external systems
- Before designing any multi-step workflow or pipeline
- When reviewing architecture for production readiness
- When a system works "most of the time" but nobody trusts it

## The Process

### Step 1: Enumerate Failure Modes

For every component, connection, and data flow, list what can go wrong:

**Network failures:**
- Connection refused (service down)
- Connection timeout (service slow)
- Partial response (connection dropped mid-transfer)
- DNS resolution failure
- TLS certificate expired

**Data failures:**
- Input validation: empty, null, wrong type, too large, malicious
- Encoding: wrong charset, BOM issues, mixed encodings
- Schema: missing fields, extra fields, wrong types, version mismatch
- Volume: 10x normal load, 100x normal load, zero records

**Dependency failures:**
- API returns 429 (rate limited)
- API returns 500 (internal error)
- API returns 200 with error in body (the silent killer)
- Database connection pool exhausted
- File system full
- Memory exhaustion

**Timing failures:**
- Race condition between concurrent operations
- Stale cache serving outdated data
- Clock skew between servers
- Operation takes 10x longer than expected
- Retry storm (all retries fire at once)

**Human failures:**
- Deploying wrong version
- Misconfigured environment variable
- Running the same operation twice
- Canceling mid-operation

### Step 2: Classify Each Failure

For each failure mode, decide the handling strategy:

| Strategy | When to Use | Example |
|----------|------------|---------|
| **Retry** | Transient failures that will resolve | Network timeout, 503 |
| **Fallback** | Degraded service is better than no service | Cache when API is down |
| **Circuit break** | Prevent cascading failures | Stop calling dead service |
| **Fail fast** | Bad input should never proceed | Validation errors |
| **Fail safe** | Failure should leave system in safe state | Rollback on error |
| **Ignore** | Failure doesn't affect core functionality | Analytics event lost |

### Step 3: Design the Failure Responses

For each classified failure, specify:

```
FAILURE: [What goes wrong]
DETECTION: [How do you know it happened? Error code? Timeout? Health check?]
RESPONSE: [What does the system do? Retry? Fallback? Alert?]
USER IMPACT: [What does the user see? Error message? Degraded experience? Nothing?]
RECOVERY: [How does the system return to normal? Automatic? Manual?]
LOGGING: [What gets logged for diagnosis?]
```

### Step 4: Implement Failure Handling FIRST

Before writing the happy path:

1. Write the error types and error responses
2. Write the retry logic with backoff
3. Write the circuit breaker
4. Write the fallback behavior
5. Write the health check
6. THEN write the happy path that uses all of the above

This guarantees failure handling isn't an afterthought bolted on later.

### Step 5: Test the Failures

For each failure mode, write a test that:
1. Simulates the failure condition
2. Verifies the system responds correctly
3. Verifies the user sees the right thing
4. Verifies the system recovers

Failure tests are MORE important than happy-path tests. A system that handles 0 failures gracefully is a system nobody trusts.

## The 80/20 of Failure Design

If you only do three things:
1. **Timeouts on every external call** — Never let a slow dependency hang your system forever
2. **Retry with exponential backoff and jitter** — Don't thundering-herd yourself
3. **Idempotent operations** — If it runs twice, the result is the same

These three patterns prevent 80% of production incidents.

## Red Flags

- "We'll add error handling later" — It won't happen, and the outage will be your fault
- "That service never goes down" — It will, on the worst possible day
- "Users won't do that" — Users will do exactly that, in production, at scale
- "We can just retry" — Retry without backoff is a DDoS attack on yourself

## Quick Reference

| Phase | Action | Output |
|-------|--------|--------|
| Enumerate | List every failure for every component | Failure mode catalog |
| Classify | Assign handling strategy to each | Strategy map |
| Design | Specify detection → response → recovery | Failure response specs |
| Implement | Build failure handling before happy path | Resilient code |
| Test | Simulate each failure, verify handling | Failure test suite |
