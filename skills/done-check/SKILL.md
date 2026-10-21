---
name: done-check
description: Evidence before "done". Classifies the diff, derives the exact scoped checks from it, runs them, and returns DONE / UNVERIFIED / BLOCKED with an evidence table. Use before every commit, PR, handoff and every "done" message to the user.
---

# Done-check: evidence instead of assertion

The diff decides the checks, the checks decide the verdict. No check run means no "done".

## Step 1: scope
```bash
git status --porcelain
git diff --name-only origin/main...HEAD   # branch scope
git diff --name-only                       # plus uncommitted
```
The union of both lists is the scope.

## Step 2: classify each file (adapt this table to your repo)
| Match | Consequence |
|---|---|
| Root config, lockfiles, shared build config | STOP flag. Without documented owner approval the verdict is BLOCKED, whatever else is green. |
| Package or module code | Typecheck and tests for that package only, never the whole monorepo. |
| Database migrations | Check for number collisions and for permission changes. |
| Edge or server functions | Run scoped tests if they exist, otherwise note "verified only after deploy". |
| Anything user-visible | One real click-through of the changed path. |

## Step 3: run, and record the command plus the last relevant output line
Always add:
```bash
# lint only the changed files
# hygiene sweep on the diff, not the whole repo
git diff origin/main...HEAD | grep -nE '^\+.*(console\.log|debugger)'
git diff origin/main...HEAD | grep -nE '^\+.*(TODO|FIXME)'
grep -rn '<<<<<<<' $(git diff --name-only origin/main...HEAD) 2>/dev/null
git diff --stat origin/main...HEAD    # any file that does not belong to the task = "unexpected in diff"
```

## Step 4: verdict (exactly one)
```
## Done-check: <branch> <date>
| Check | Command | Result |
|---|---|---|
| Typecheck | ... | 0 errors |
| Tests | ... | 14 passed |
| Hygiene | grep sweep | clean |
Verdict: DONE
```
- **DONE:** all derived checks ran green in this session and no STOP flag exists.
- **UNVERIFIED:** at least one required check could not run. Format: `UNVERIFIED: <reason>, pending: <exact command>`.
- **BLOCKED:** a STOP flag, a weakened test, conflict markers, or a red check without a trivial cause.

"Tests green" is not "CI green": shared config can break packages you did not touch.
