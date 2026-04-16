# Anti-patterns

## Auto-fail conditions

Reject the output immediately if any of these are true:

- Mixed primitive families (e.g. Base UI imports alongside Radix imports)
- Composition patterns from the wrong family (e.g. `asChild` when using Base UI)
- Heavy data surfaces implemented with a lightweight chart library without justification
- Flashy motion that harms readability or workflow speed
- AI-generated content visually indistinguishable from factual data
- A second competing primitive layer introduced

## Enforcement

CI and review should catch:

- Imports from banned primitive libraries
- Banned composition patterns (`asChild`/`Slot` when Base UI is chosen, or vice versa)
- Chart library downgrades on data-heavy surfaces without documented justification
- Wrapper abstractions that hide forbidden primitives
- One-off colors outside the token system
- Decorative gradients in operational workflows
- Monolithic UI framework coupling
