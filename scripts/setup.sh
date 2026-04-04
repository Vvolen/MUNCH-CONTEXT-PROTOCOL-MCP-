#!/usr/bin/env bash
# setup.sh — Install core agent tools for MUNCH-CONTEXT-PROTOCOL-MCP-
# Run on: Codespaces postCreate, CI, or fresh environment
# Usage: bash scripts/setup.sh

set -euo pipefail

# Colors
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
RESET='\033[0m'

log()     { echo -e "${CYAN}[setup] $*${RESET}"; }
success() { echo -e "${GREEN}[setup] ✓ $*${RESET}"; }
warn()    { echo -e "${YELLOW}[setup] ⚠ $*${RESET}"; }
error()   { echo -e "${RED}[setup] ✗ $*${RESET}"; }

log "Starting MUNCH Context Protocol environment setup..."

# ---------------------------------------------------------------------------
# Node.js version check
# ---------------------------------------------------------------------------
NODE_VERSION=$(node --version 2>/dev/null || echo "not found")
log "Node.js: ${NODE_VERSION}"
if [[ "$NODE_VERSION" == "not found" ]]; then
  error "Node.js is required. Please install Node.js 20+."
  exit 1
fi

# Enforce Node.js major version >= 20
NODE_MAJOR=""
if [[ "${NODE_VERSION}" =~ ^v?([0-9]+)\. ]]; then
  NODE_MAJOR="${BASH_REMATCH[1]}"
else
  warn "Unable to parse Node.js version '${NODE_VERSION}'. Continuing, but Node.js 20+ is recommended."
fi

if [[ -n "${NODE_MAJOR}" && "${NODE_MAJOR}" -lt 20 ]]; then
  error "Detected Node.js ${NODE_VERSION}. Please upgrade to Node.js 20+."
  exit 1
fi

# ---------------------------------------------------------------------------
# Install core global tools
# ---------------------------------------------------------------------------
log "Installing core agent tools globally..."

NPM_TOOLS=(
  "ruflo@latest"
)

for tool in "${NPM_TOOLS[@]}"; do
  log "  Installing ${tool}..."
  if npm install -g "${tool}" --quiet 2>/dev/null; then
    success "  ${tool} installed"
  else
    warn "  ${tool} install failed (non-fatal)"
  fi
done

# jCodeMunch is a Python/PyPI package — install via pip or uvx
log "  Installing jcodemunch-mcp (Python)..."
if command -v pip &>/dev/null; then
  if pip install jcodemunch-mcp --quiet 2>/dev/null; then
    success "  jcodemunch-mcp installed via pip"
  else
    warn "  jcodemunch-mcp pip install failed (non-fatal)"
  fi
elif command -v uvx &>/dev/null; then
  success "  jcodemunch-mcp available via uvx (no install needed)"
else
  warn "  jcodemunch-mcp requires pip or uvx — skipping"
fi

# ---------------------------------------------------------------------------
# Initialize claude-flow runtime directories
# ---------------------------------------------------------------------------
log "Initializing claude-flow runtime directories..."
mkdir -p \
  .claude-flow/data \
  .claude-flow/sessions \
  .claude-flow/neural \
  .claude-flow/metrics

success "Runtime directories created"

# ---------------------------------------------------------------------------
# Validate committed configs
# ---------------------------------------------------------------------------
log "Validating committed configurations..."

REQUIRED_FILES=(
  ".mcp.json"
  ".claude/settings.json"
  "CLAUDE.md"
  "docs/NICK_SYSTEM_CONTEXT.md"
)

ALL_OK=true
for f in "${REQUIRED_FILES[@]}"; do
  if [[ -f "$f" ]]; then
    success "  $f present"
  else
    warn "  $f missing"
    ALL_OK=false
  fi
done

if [[ "$ALL_OK" = false ]]; then
  warn "Some required files are missing. Check the list above."
fi

# ---------------------------------------------------------------------------
# Make hook helpers executable
# ---------------------------------------------------------------------------
log "Setting permissions on hook helpers..."
if [[ -d ".claude/helpers" ]]; then
  find .claude/helpers -type f \( -name "*.sh" -o -name "*.cjs" -o -name "*.js" -o -name "*.mjs" \) \
    -exec chmod +x {} \;
  success "Hook helpers are executable"
fi

# ---------------------------------------------------------------------------
# Security audit reminder
# ---------------------------------------------------------------------------
AUDIT_STATUS=$(node scripts/check-security-status.js 2>/dev/null || echo "UNKNOWN")
log "Security audit status: ${AUDIT_STATUS}"
if [[ "$AUDIT_STATUS" == "PENDING"* ]]; then
  warn "Security CVEs pending. Run: npx ruflo@latest security scan"
fi

# ---------------------------------------------------------------------------
# Done
# ---------------------------------------------------------------------------
echo ""
success "Setup complete!"
echo ""
echo -e "  ${CYAN}Quick start:${RESET}"
echo "    npx ruflo@latest daemon start"
echo "    npx ruflo@latest doctor --fix"
echo "    npx ruflo@latest swarm init --v3-mode"
echo ""
echo -e "  ${CYAN}Context:${RESET}  docs/NICK_SYSTEM_CONTEXT.md"
echo -e "  ${CYAN}Power tools:${RESET} docs/POWER_TOOLS.md"
echo -e "  ${CYAN}Build guide:${RESET} CLAUDE.md"
echo ""
