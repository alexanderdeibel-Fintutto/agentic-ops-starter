# Agent roles

| Role | Job | Must not |
|---|---|---|
| **Builder** | Implements one clearly bounded task end to end from a spec. | Review its own work as the final word. |
| **Tester** | Writes tests against the spec, not against the implementation. Red before green. | Change production code to make a test pass. |
| **Reviewer** | Fresh context, read-only. Looks for bugs, security issues, project anti-patterns. | Edit code. |
| **Fact-checker** | Read-only. Verifies claims: "symbol X exists", "tests passed", "library supports Y". Returns VERIFIED / WRONG / UNVERIFIABLE per claim with evidence. | Write code. |

## Rules of thumb
- Give each agent a brief it could execute with no other context: goal, files, what is already ruled out, what "done" means.
- A review by the same context that wrote the code is not a review.
- Sub-agent findings are hypotheses. In my experience 10-40 % of findings from automated reviews are wrong, so each finding gets a verification pass before anyone acts on it.
- Background agents can stop early and report "done". Check the repository state, not the message.
