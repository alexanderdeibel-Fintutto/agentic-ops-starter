# Case studies

Each one says what exists, what is proven, and what is not.

## 1. GuideTranslator: real-time translation for guided tours

**Problem.** Guides, museums and cruise excursion providers serve groups in many languages, but visitors will not install an app and venues often have no reliable internet.

**What I built.** A guide speaks. Visitors open a QR code in the browser (no app) and hear and read the tour in their own language. Speech recognition, translation and speech output run in a pipeline with its own language-qualification lab: a language pack is only released after it passes measured checks. Four transport tiers fit different venues: cloud, local network or Wi-Fi hotspot run by the guide's phone, Bluetooth Low Energy for small groups, and on-device engines as an optional translation backend. The guide picks the tier before the tour. During a tour the system switches between cloud and local network by itself when the connection drops ([resilient-transport](https://github.com/alexanderdeibel-Fintutto/resilient-transport) is the extracted and hardened core of that mechanism). Android app via Capacitor. 29 apps for different industries (city guides, authorities, museums, trade fairs, clinics, schools, hotels) on shared packages.

**Proven.** Live in production. Automated outreach to prospective customers runs with a delivery ledger and a circuit breaker on bounce and complaint rates.

**Open.** Pilot phase. No public customer case with revenue figures yet. Outreach response has been weak so far.

**Stack.** React, TypeScript, Vite, Supabase, Vercel, Capacitor, Google and Azure speech, WebAssembly.

## 2. jobsi: analysis of social-benefit notices (special-category data)

**Problem.** In 2025 more than 500,000 objections were filed against job-centre notices in Germany and about 31 % succeeded. Affected people struggle to read their notices; advice centres are overloaded.

**What I built.** Upload a notice, OCR, rule-based review against the relevant social code, a draft objection with statutory references. Health and social data are handled as special-category data under GDPR Art. 9: application-layer encryption, an isolated AI service, row-level security. Subscription checkout with the legally required order button and cancellation button.

**Proven.** Live. I ran my own compliance audit (legal-services law, EU AI Act Art. 50, GDPR) and found real gaps, among them missing AI-labelling and price statements without a VAT notice. They went on the fix list. The audit also showed that a consumer-only model runs into the legal-services boundary, so the go-to-market moved towards partners who are allowed to advise.

**Open.** Commercial validation. At my last measurement (August 2026) there were no paying external customers, and the checkout was deliberately kept closed while the audit findings were open.

**Stack.** React, TypeScript, Supabase (RLS, Edge Functions), Stripe, Claude API.

## 3. The agent operating system

**Problem.** One founder, no team, three product lines.

**What I built.** A working method for coding agents: a spec for every task, agents with fixed roles (build, test, review, fact-check), hooks that block false completion reports, per-session cost warnings, persistent memory of lessons, premortems before big decisions. The starter kit in this repository is the generic part.

**Proven.** Roughly 50 apps and about 300,000 lines of production code in 18 months, built this way. Every production incident ended in a rule, a hook or a regression test; see [field-notes.md](field-notes.md).

**Open.** It has been proven by me on my own products. Transferring it to a team is the next step, and the reason this repository exists.
