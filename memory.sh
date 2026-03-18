#!/usr/bin/env bash
# memory.sh — Launch Claude with full project memory context
# Usage: bash memory.sh [optional prompt]

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PRIMER="/root/.claude/primer.md"
LESSONS="$PROJECT_DIR/tasks/lessons.md"
MEMORY="$PROJECT_DIR/.claude-memory.md"

# ── 1. Primer (global) ────────────────────────────────────────────────────────
PRIMER_CONTENT=""
if [ -f "$PRIMER" ]; then
  PRIMER_CONTENT="$(cat "$PRIMER")"
else
  PRIMER_CONTENT="(no global primer found at $PRIMER)"
fi

# ── 2. Git context ────────────────────────────────────────────────────────────
cd "$PROJECT_DIR" || exit 1

BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")

LAST_COMMITS=$(git log --oneline -5 2>/dev/null || echo "(no commits yet)")

MODIFIED_FILES=$(git status --short 2>/dev/null || echo "(git status unavailable)")

# ── 3. Lessons ────────────────────────────────────────────────────────────────
LESSONS_CONTENT=""
if [ -f "$LESSONS" ]; then
  LESSONS_CONTENT="$(cat "$LESSONS")"
else
  LESSONS_CONTENT="(tasks/lessons.md not found)"
fi

# ── 4. Memory log ─────────────────────────────────────────────────────────────
MEMORY_CONTENT=""
if [ -f "$MEMORY" ]; then
  MEMORY_CONTENT="$(cat "$MEMORY")"
else
  MEMORY_CONTENT="(no .claude-memory.md yet)"
fi

# ── 5. Assemble system prompt ─────────────────────────────────────────────────
SYSTEM_PROMPT="$(cat <<SYSPROMPT
$PRIMER_CONTENT

---

## PROJECT MEMORY — SarahConsult

### Current Branch
$BRANCH

### Last 5 Commits
$LAST_COMMITS

### Modified / Untracked Files
$MODIFIED_FILES

### Lessons Learned (tasks/lessons.md)
$LESSONS_CONTENT

### Commit History Log (.claude-memory.md)
$MEMORY_CONTENT
SYSPROMPT
)"

# ── 6. Launch Claude ──────────────────────────────────────────────────────────
echo "Launching Claude with project memory context..."
echo "Branch: $BRANCH"
echo "Project: $PROJECT_DIR"
echo ""

claude \
  --permission-mode acceptEdits \
  --allowedTools "Bash(git:*) Bash(npm:*) Edit Write Read" \
  --system-prompt "$SYSTEM_PROMPT" \
  "$@"
