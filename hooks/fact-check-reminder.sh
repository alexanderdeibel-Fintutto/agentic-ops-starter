#!/usr/bin/env bash
# PreToolUse(Bash): before the FIRST code commit of a session, remind the agent
# to have its central claims verified independently (e.g. by a read-only
# fact-checker sub-agent). Blocks at most once per session (exit 2), then lets
# everything through. Silent for non-commit commands and markdown-only commits.
# Honest limit: it reminds, it cannot verify that a check really ran.
set -uo pipefail
IN="$(cat 2>/dev/null || true)"
CMD=$(printf '%s' "$IN" | jq -r '.tool_input.command // empty' 2>/dev/null)
SID=$(printf '%s' "$IN" | jq -r '.session_id // "nosid"' 2>/dev/null)
CWD=$(printf '%s' "$IN" | jq -r '.cwd // empty' 2>/dev/null)
[ -n "$CWD" ] || CWD="$PWD"

printf '%s' "$CMD" | grep -Eq 'git( +-C +[^ ]+)? +commit' || exit 0
ROOT=$(git -C "$CWD" rev-parse --show-toplevel 2>/dev/null) || exit 0

git -C "$ROOT" diff --cached --name-only 2>/dev/null \
  | grep -Eq '\.(ts|tsx|js|jsx|mjs|cjs|py|rs|go)$' || exit 0

MARKER="${TMPDIR:-/tmp}/.factcheck-${SID}"
[ -f "$MARKER" ] && exit 0
touch "$MARKER"

{
  echo "Code commit detected. Self-check before it goes out:"
  echo "  Did you independently verify this session's central claims"
  echo "  (do the symbols and imports exist? did the tests really pass?)"
  echo ""
  echo "  If not: run a fact-checker sub-agent on the code claims, then commit."
  echo "  If already verified or trivial: run the commit again."
  echo "  (This block appears once per session.)"
} >&2
exit 2
