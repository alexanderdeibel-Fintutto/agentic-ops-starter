#!/usr/bin/env bash
# UserPromptSubmit: cost guard for long sessions. Fires each warning once per
# session. Thresholds are starting points, tune them to your usage.
#   1. expensive model + many edits  -> execution belongs on a cheaper model
#   2. many edits, any model         -> context accumulation, start fresh
#   3. long wall time                -> cache expiry surcharge
# Needs a counter file written by a PostToolUse hook that increments on every
# Edit/Write (see docs/cost-governance.md), and a session-start epoch file.
set -uo pipefail

STDIN_JSON="$(cat 2>/dev/null || true)"
STATE="${AGENTIC_OPS_STATE:-$HOME/.claude/.ops-state}"
mkdir -p "$STATE"
EDITS=$(cat "$STATE/edit-count" 2>/dev/null || echo 0)
case "$EDITS" in ''|*[!0-9]*) EDITS=0 ;; esac
START=$(cat "$STATE/session-start-epoch" 2>/dev/null || echo 0)
case "$START" in ''|*[!0-9]*) START=0 ;; esac
HOURS=0
[ "$START" -gt 0 ] && HOURS=$(( ( $(date +%s) - START ) / 3600 ))

MODEL=$(printf '%s' "$STDIN_JSON" | jq -r '(.model | if type=="object" then .id else . end) // empty' 2>/dev/null || true)
EXPENSIVE=0
printf '%s' "$MODEL" | grep -qiE 'opus|fable' && EXPENSIVE=1

FIRED="$STATE/fired"; touch "$FIRED"
fired() { grep -qxF "$1" "$FIRED" 2>/dev/null; }
mark()  { echo "$1" >> "$FIRED"; }

MSG=""
if [ "$EXPENSIVE" = 1 ] && [ "$EDITS" -ge 15 ] && ! fired exp15; then
  MSG="Cost guard: expensive model and ${EDITS} edits looks like execution work. Design and strategy belong on the strongest model, implementation on a cheaper one. Consider switching models or delegating edits to a cheaper sub-agent."
  mark exp15
elif [ "$EDITS" -ge 35 ] && ! fired len35; then
  MSG="Cost guard: ${EDITS} edits in this session. Long sessions replay a large context on every turn. Save a handoff and start a fresh session."
  mark len35
elif [ "$HOURS" -ge 6 ] && ! fired wall6; then
  MSG="Cost guard: this session has been open for about ${HOURS}h. Idle time expires the cache, so each turn gets more expensive. Save state and start fresh, split big jobs into focused blocks."
  mark wall6
fi

[ -z "$MSG" ] && exit 0
jq -nc --arg c "$MSG" '{hookSpecificOutput:{hookEventName:"UserPromptSubmit",additionalContext:$c}}' 2>/dev/null || printf '%s\n' "$MSG"
exit 0
