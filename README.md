# agentic-ops-starter

A small, practical starter kit for running Claude Code (or similar coding agents) as a disciplined team instead of a chat window. Extracted from the setup I use to build and operate several production apps alone as a non-programmer founder.

**What it is:** specs first, agents with fixed roles, evidence before "done", cost awareness per session, lessons that persist.
**What it is not:** a framework or a library. It is a handful of files you copy and adapt.

## The loop

```
Spec (ISA)  ->  agent team  ->  gates  ->  production  ->  lessons into memory
   1 page        build/test/     done-check    CI + real      so the next session
                 review/fact-    + hooks       smoke test     starts smarter
                 check
```

## What is in here

| Path | Purpose |
|---|---|
| `templates/ISA.md` | One-page-ish spec: problem, goal, scope, design, failure modes, test plan, open questions. Written before any code. |
| `templates/ADR.md` | Architecture decision record for choices that are expensive to reverse. |
| `templates/PREMORTEM.md` | "It is six months later and this failed. Why?" for plans with a high cost of failure. |
| `skills/done-check/SKILL.md` | A skill that turns "done" into evidence: classify the diff, derive the checks, run them, report DONE / UNVERIFIED / BLOCKED. |
| `hooks/fact-check-reminder.sh` | PreToolUse hook. Before the first code commit of a session it asks for independent verification of the session's claims. |
| `hooks/cost-guard.sh` | UserPromptSubmit hook. Warns when a session gets long or an expensive model is doing routine execution. |
| `docs/agent-roles.md` | The four roles (builder, tester, reviewer, fact-checker) and when to use which. |
| `docs/cost-governance.md` | Model routing and session hygiene rules, with the reasoning. |
| `docs/honesty-rules.md` | The rules that stop agents from claiming success they did not see. |

## Install (about 10 minutes)

1. Copy `hooks/*.sh` to `~/.claude/hooks/` and `chmod +x` them.
2. Register them in `~/.claude/settings.json` (example in `docs/cost-governance.md`).
3. Copy `skills/done-check/` to `~/.claude/skills/`.
4. Copy `templates/` somewhere your agents can find it and point your project's `CLAUDE.md` at it.
5. Put the rules from `docs/honesty-rules.md` into your global `CLAUDE.md`.

Requires `bash`, `jq`, `git`. Tested on macOS.

## Honest limits

- The hooks remind and warn. They cannot prove that an agent really ran a check.
- The cost thresholds are starting points from my own usage. Tune them.
- This setup assumes you read the diffs that matter. It reduces review effort, it does not remove it.

## About

Built by Alexander Deibel. I build and operate AI products (real-time translation, document analysis with special-category data, internal back-office tools) and set up agentic engineering workflows for teams. Contact: hello@fintutto.de
