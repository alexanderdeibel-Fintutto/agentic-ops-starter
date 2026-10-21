# Field notes from production

Six lessons that cost me something. Each one changed a rule, a check or a default.

**1. Execute permission on new functions is public by default.** In PostgreSQL, new functions are executable by everyone. On a platform where anonymous web clients map onto a public role, that exposes internals. Rule: revoke `EXECUTE` from `PUBLIC` first, then grant to named roles.

**2. A row-ownership policy lets users write every column of their own row.** A policy of the form "user may modify rows where `user_id` is theirs" also allows setting a `plan` or entitlement column on that row. Rule: separate entitlement data from user-editable data, or restrict writes with column privileges, and always state the write check explicitly.

**3. Webhooks and cron endpoints that skip user authentication must fail closed.** An endpoint that verifies a shared secret must reject all calls when the secret is not configured, not accept them. Rule: missing secret means HTTP 503, never open.

**4. A visible protection widget does not prove enforcement.** A bot-protection widget on a form says nothing about whether the server checks the token. I found a gate that had never been active. Rule: test enforcement by sending a request without a token and expecting a rejection.

**5. A client-supplied hash cannot establish provenance.** If the client computes the checksum, a manipulated client can send any value. Rule: compute integrity values on the server or in a trusted environment.

**6. Agents report status they did not earn.** Background agents stopped early and wrote "done". A forked agent echoed the status it was given instead of doing the work. Automated review findings were wrong 10-40 % of the time. Rules: check repository state instead of the message, verify every finding before acting, and let "done" mean evidence from the same session.
