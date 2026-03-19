#!/usr/bin/env node
/**
 * check-security-status.js — Read and report security audit status.
 *
 * Exit codes:
 *   0 — OK (status is not FAILED)
 *   1 — FAILED (security scan has failed status)
 *
 * Output (stdout):
 *   <STATUS>:<cvesFixed>/<totalCves>
 *   e.g. "PENDING:0/3" or "PASSED:3/3"
 */

const path = require('path');
const auditPath = path.join(process.cwd(), '.claude-flow', 'security', 'audit-status.json');

let status = 'UNKNOWN';
let cvesFixed = 0;
let totalCves = 0;

try {
  const audit = JSON.parse(require('fs').readFileSync(auditPath, 'utf-8'));
  status = audit.status || 'UNKNOWN';
  cvesFixed = audit.cvesFixed || 0;
  totalCves = audit.totalCves || 0;
} catch (e) {
  // File missing or unreadable — not fatal
}

console.log(`${status}:${cvesFixed}/${totalCves}`);

if (status === 'FAILED') {
  process.exitCode = 1;
}
