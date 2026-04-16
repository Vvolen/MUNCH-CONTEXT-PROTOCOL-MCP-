#!/bin/bash
# bootstrap-env.sh — Re-installs the power user environment in a new Claude Code web session
# Run this at the start of any new session to restore your tools and skills.
#
# Usage: bash scripts/bootstrap-env.sh

set -e

echo "=== Power User Environment Bootstrap ==="
echo ""

# Step 1: Install jCodeMunch (Tree-sitter token compression)
echo "[1/4] Installing jCodeMunch..."
pip install --quiet --ignore-installed pyjwt jcodemunch-mcp 2>/dev/null && \
  echo "  ✓ jCodeMunch installed" || \
  echo "  ✗ jCodeMunch install failed (non-blocking)"

# Step 2: Install Graphify (Karpathy LLM Wiki knowledge graph)
echo "[2/4] Installing Graphify..."
pip install --quiet graphifyy 2>/dev/null && \
  echo "  ✓ Graphify installed" || \
  echo "  ✗ Graphify install failed (non-blocking)"

# Step 3: Install Graphify skill into Claude Code
echo "[3/4] Setting up Graphify skill..."
if command -v graphify &>/dev/null; then
  graphify install --platform claude 2>/dev/null && \
    echo "  ✓ Graphify skill installed" || \
    echo "  ✗ Graphify skill install failed (non-blocking)"
else
  echo "  ⊘ Graphify CLI not found, skipping skill install"
fi

# Step 4: Install hermes-CCC skills (46 self-improving memory skills)
echo "[4/4] Installing hermes-CCC skills..."
HERMES_DIR="/tmp/hermes-ccc"
if [ ! -d "$HERMES_DIR" ]; then
  git clone --quiet https://github.com/AlexAI-MCP/hermes-CCC.git "$HERMES_DIR" 2>/dev/null
fi
if [ -f "$HERMES_DIR/install.sh" ]; then
  cd "$HERMES_DIR" && bash install.sh 2>/dev/null && \
    echo "  ✓ hermes-CCC skills installed" || \
    echo "  ✗ hermes-CCC install failed (non-blocking)"
  cd - >/dev/null
else
  echo "  ✗ hermes-CCC repo not found"
fi

# Step 5: Restore global CLAUDE.md if not present
echo ""
echo "[+] Checking global CLAUDE.md..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
GLOBAL_CLAUDE="/root/.claude/CLAUDE.md"
BACKUP="$REPO_DIR/config/global-claude.md"

if [ ! -f "$GLOBAL_CLAUDE" ] && [ -f "$BACKUP" ]; then
  mkdir -p /root/.claude
  cp "$BACKUP" "$GLOBAL_CLAUDE"
  echo "  ✓ Global CLAUDE.md restored from backup"
elif [ -f "$GLOBAL_CLAUDE" ]; then
  echo "  ✓ Global CLAUDE.md already exists"
else
  echo "  ⊘ No backup found at $BACKUP"
fi

echo ""
echo "=== Bootstrap Complete ==="
echo ""
echo "Available commands:"
echo "  /graphify          — Build knowledge graph from code/docs"
echo "  /hermes-memory     — Persistent project memory"
echo "  /hermes-compress   — Compress context when conversation grows"
echo "  /hermes-route      — Route tasks by complexity"
echo "  /hermes-search     — Search past sessions"
echo "  /honcho            — Cross-session user modeling"
echo ""
