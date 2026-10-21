# agentic-ops-starter

How I build and operate software with AI coding agents as a disciplined team, as a non-programmer founder working alone. Plus the evidence that it works.

## Evidence first

| What | Where |
|---|---|
| Real-time translation for guided tours, live in production | [fintutto.world](https://fintutto.world), [guide.fintutto.world](https://guide.fintutto.world) |
| Document analysis for German social-benefit notices (special-category data), live | [jobsi.me](https://jobsi.me) |
| Real code from the translation system's transport layer, extracted, hardened, 21 tests | [resilient-transport](https://github.com/alexanderdeibel-Fintutto/resilient-transport) |
| Three case studies with the honest status of each | [docs/case-studies.md](docs/case-studies.md) |
| What went wrong in production and what I changed because of it | [docs/field-notes.md](docs/field-notes.md) |
| How the transport tiers fit together | [docs/architecture.md](docs/architecture.md) |

The product repositories are private (customer logic, data model, keys). On request I walk serious prospects through them live.

## The method

```
Spec (ISA)  ->  agent team  ->  gates  ->  production  ->  lessons into memory
   1 page        build/test/     done-check    CI + real      so the next session
                 review/fact-    + hooks       smoke test     starts smarter
                 check
```

Specs come first and name the exact commands that prove each goal. Agents have fixed roles. "Done" means evidence from this session, not a claim. Cost is tracked per session. Every incident ends in a rule, a hook or a test.

## What is in this repository

| Path | Purpose |
|---|---|
| `docs/case-studies.md` | Three projects, what was built, what is proven, what is still open. |
| `docs/field-notes.md` | Six production lessons: security, data, agent behaviour. |
| `docs/architecture.md` | The four transport tiers and the agent loop as diagrams. |
| `docs/agent-roles.md` | Builder, tester, reviewer, fact-checker. |
| `docs/cost-governance.md` | Model routing and session hygiene, with the reasoning. |
| `docs/honesty-rules.md` | Rules that stop agents from claiming success they did not see. |
| `templates/` | ISA (spec), ADR (decision record), premortem. |
| `skills/done-check/` | A skill that turns "done" into evidence: DONE / UNVERIFIED / BLOCKED. |
| `hooks/` | `fact-check-reminder.sh` and `cost-guard.sh`, both tested. |

## Install the starter kit (about 10 minutes)

1. Copy `hooks/*.sh` to `~/.claude/hooks/` and `chmod +x` them.
2. Register them in `~/.claude/settings.json` (example in `docs/cost-governance.md`).
3. Copy `skills/done-check/` to `~/.claude/skills/`.
4. Copy `templates/` somewhere your agents can find it and point your project's `CLAUDE.md` at it.
5. Put the rules from `docs/honesty-rules.md` into your global `CLAUDE.md`.

Requires `bash`, `jq`, `git`. Tested on macOS.

## Honest limits

- The hooks remind and warn. They cannot prove that an agent really ran a check.
- Cost thresholds are starting points from my own usage. Tune them.
- The method reduces review effort. It does not remove the need to read the diffs that matter.
- Commercial validation of my products is still open. The case studies say so.

## About

Alexander Deibel. 30 years of project leadership in culture and events (budgets up to EUR 3.4M, grants, public procurement), since 2024 building AI products and agentic engineering setups. Available for AI implementation, process automation and for setting up agent workflows in teams. Remote (DACH), on-site possible. hello@fintutto.de
