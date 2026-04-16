# monte-carlo-ui-lab

## What this repo is

An empirical playground for UI trend discovery through constrained Monte Carlo sampling. Themes define cohesive design languages. Samplers draw random variations. Agents orchestrate the full pipeline.

## Architecture

- `study/` is the methodology — locked, versioned, never auto-modified
- `results/` is append-only output — one folder per seed
- `agents/` define narrow-scope prompts for the pipeline stages
- `scripts/` are the entry points — everything runs via shell scripts with worktree isolation

## Rules

- Every generated `index.html` must be self-contained: inline CSS + JS, no external dependencies
- WCAG 2.2 AA accessible, support `prefers-reduced-motion`
- Components must come from `study/patterns/*.yaml` — never invent new patterns
- Theme rules are law — the generator must follow the active theme's `rules.md` and `anti-patterns.md`
- No lorem ipsum — use the copywriter agent for realistic copy
- Results are reproducible by seed — always record all generation parameters in `manifest.json`

## Conventions

- YAML for data, Markdown for prose, TypeScript for logic
- Theme folders are self-contained design-language packages
- Business context (industry, persona, page-type) is always specified, never defaulted
- The pity system guarantees every trial produces archivable output
