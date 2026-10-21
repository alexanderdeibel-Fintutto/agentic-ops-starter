# Cost governance

Most of the money goes into context that is replayed on every turn, not into output. Long sessions get expensive because the whole history is re-read each time, and cache entries expire after a few minutes of idle time.

## Routing
- **Strongest model:** design, architecture decisions, hard synthesis, premortems. Short sessions.
- **Mid model:** execution, edits, debugging loops. Default for daily work.
- **Smallest model / read-only sub-agent:** reading many files or long logs and returning only the distilled facts.
- Audits, reviews and analyses are read-and-judge work. They rarely need the most expensive model.

## Session hygiene
- Roughly 35 edits or a few hours in one session: save state to a handoff file and start fresh.
- Do not keep a session open all day for babysitting CI. Poll with a small model or a scheduled check.
- Keep tool output small: scoped grep and head instead of reading whole files into the main context.

## Registering the hooks (`~/.claude/settings.json`)
```json
{
  "hooks": {
    "UserPromptSubmit": [
      { "hooks": [ { "type": "command", "command": "$HOME/.claude/hooks/cost-guard.sh" } ] }
    ],
    "PreToolUse": [
      { "matcher": "Bash", "hooks": [ { "type": "command", "command": "$HOME/.claude/hooks/fact-check-reminder.sh" } ] }
    ]
  }
}
```
Check the current hook schema in the Claude Code documentation before relying on this snippet. `cost-guard.sh` also needs a small PostToolUse hook that increments `~/.claude/.ops-state/edit-count` on every Edit/Write, and a SessionStart hook that writes the current epoch to `~/.claude/.ops-state/session-start-epoch` and clears the counters.

## Measure, do not guess
Any claim about cost, bundle size or latency needs a measured before/after value from the same session. If a change shows no gain, revert only your own change.
