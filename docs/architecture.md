# Architecture notes

## Transport tiers (real-time translation)

The operator chooses the tier before a session starts, because the right choice depends on the venue. Only one switch is automatic: between cloud and local network when the connection drops.

```
                      speaker (guide)
                            │
        ┌───────────────────┼─────────────────────────┐
        │                   │                         │
   Tier 1: Cloud     Tier 2: Local network     Tier 3: Bluetooth LE
   global, needs     LAN or hotspot on the     small groups, ~10-30 m,
   internet          guide's phone, ~50-80 m   no Wi-Fi
        │                   │                         │
        └───────────────────┴─────────────────────────┘
                            │
                    visitors' phones (browser, QR code)

   Tier 4: on-device engines (speech recognition, translation in the browser).
   Today an optional translation backend, not yet a transport.

   automatic during a session:   Tier 1  <──►  Tier 2    (debounced, no duplicate messages)
```

Why choose instead of cascade: a cruise group in a harbour, a museum hall and a bus have different failure profiles. A silent cascade through four modes hides what the guide actually needs to know: which mode the visitors are on.

## Agent loop

```
 owner           spec                  builder          tester         reviewer       fact-checker
   │   idea       │                      │                │               │               │
   ├─────────────▶│ goals + commands     │                │               │               │
   │              ├─────────────────────▶│ implements     │               │               │
   │              ├──────────────────────┼───────────────▶│ tests vs spec │               │
   │              │                      ├───────────────────────────────▶│ read-only     │
   │              │                      │                │               ├──────────────▶│ claims
   │◀─────────────┴──────── done-check: DONE / UNVERIFIED / BLOCKED, with evidence ───────┤
   │  decides open questions                                                              │
   └─▶ lessons -> memory, rules, hooks, regression tests
```
