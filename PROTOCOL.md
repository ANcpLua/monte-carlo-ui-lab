# Experimental Protocol

## Research question

Can constrained random sampling over cohesive UI/UX design systems produce novel but shippable design directions that humans would not have conceived independently?

## Independent variables

- **Theme** — a cohesive design language with locked rules, palette, typography, motion, and component preferences
- **Variation point** — a bounded parameter within a theme (palette shade, layout variant, component subset, density tier, motion intensity)
- **Hybrid ratio** — when crossing themes, the proportion of axes from each parent
- **Business context** — industry, persona, page archetype

## Dependent variables

- **a11y score** — axe-core automated accessibility audit (floor: 95)
- **Contrast ratio** — minimum text/background contrast (floor: 4.5:1 WCAG AA)
- **LCP** — Largest Contentful Paint on simulated 3G (floor: ≤ 2500ms)
- **CLS** — Cumulative Layout Shift (floor: ≤ 0.1)
- **Cohesion score** — perceptual hash distance from theme reference (floor: 0.70)
- **Novelty score** — perceptual hash distance from all prior trials (interest threshold: 0.80)
- **Copy realism** — is the text plausible for the given industry/persona? (floor: 0.60)

## Sampling methods

### Phase 1 — Pilot (n=50)
Uniform random sampling, intra-theme only. Purpose: calibrate thresholds and baseline score distributions.

### Phase 2 — Coverage (n=500)
Latin Hypercube sampling across all variation points within each theme. Purpose: maximize coverage of the bounded parameter space.

### Phase 3 — Hybrid (n=200)
Cross-theme sampling respecting the compatibility graph. One theme provides the skeleton (70-90%), the other injects 1-2 axes. Purpose: discover stable hybrid directions.

### Phase 4 — Active Learning (n=ongoing)
Over-sample regions where `cohesion ≥ 0.85 AND novelty ≥ 0.80`. Purpose: find and refine trend candidates.

## Bad luck protection (pity system)

Every trial must pass ALL floors before archival. On failure:

1. **Attempt 1** — hybrid ratio 70/30 (or intra-theme with full variation)
2. **Attempt 2** — hybrid ratio 85/15 (or intra-theme with reduced variation)
3. **Attempt 3** — pure intra-theme, minimal variation (guaranteed pass)

Reroll count is recorded in the manifest. Trials with 0 rerolls on hybrid mode are flagged as "hot hybrids" for trend analysis.

## Reproducibility

A trial is defined by: `seed + protocol_version + model_id + temperature + top_p`.
The manifest records all parameters. `reproduce.sh <seed>` regenerates the sample deterministically; the LLM generation step is stochastic but bounded by the recorded parameters.

## Trend promotion

When the analyst detects a cluster of hybrids with consistently high cohesion + novelty, the curator agent proposes a new theme. Promoted themes get their own folder in `study/themes/` and enter the compatibility graph. This is the feedback loop: the study generates its own new design languages.
