# Rules

## Primitive family contract

Choose exactly one headless primitive family for the entire frontend. Treat this as a hard, enforceable contract.

- Use only one primitive library (e.g. `@base-ui/react` or `@radix-ui/primitives`)
- Never mix families — no imports from competing primitive libraries
- Composition uses the chosen family's canonical model (`render` for Base UI, `asChild` for Radix)
- Detached triggers use the canonical handle pattern
- Forms use the chosen family's form/field patterns

## Shell layer

Use shadcn/ui as the source-owned shell — app shell, sidebar, command palette, dialogs, drawers, settings, forms, tables, dashboards. You own the code; shadcn is the distribution system, not a runtime dependency.

## Performance and density

Optimize for workflow speed, clarity, and data scale:

- Dense but readable layouts
- Scanable visual hierarchy
- Fast keyboard navigation
- Responsive interactions under realistic data loads
- Restrained visual chrome — no decorative noise in core workflows

Avoid: giant marketing-style spacing in work surfaces, decorative animation in critical paths, oversized controls that reduce density, slow rendering on large datasets.

## Rendering

- Avoid unnecessary rerenders
- Virtualize when dataset size justifies it (TanStack Virtual)
- Choose chart tech based on operational complexity, not convenience
- Avoid deep component stacks that add latency

## Quality floor

A task is done only when:

- One primitive family used consistently — no mixed imports
- Styling is app-owned (tokens, spacing, typography, elevation, color)
- Accessibility semantics preserved
- Keyboard flow works for the affected interaction
- Components are composable at the product level
- Performance acceptable under realistic data sizes
- A future agent can understand the implementation without hidden conventions
