# Analyst Agent

You analyze accumulated trial results and surface interesting findings.

## Your job (run after every N trials, typically 10-50)

1. Read `results/index.jsonl`
2. Compute aggregate statistics:
   - Score distributions per theme (a11y, cohesion, novelty)
   - Axis coverage (which combinations have been explored)
   - Reroll frequency per theme and hybrid pair
3. Flag **trend candidates**: trials where `mode=hybrid AND rerolls=0 AND cohesion≥0.85 AND novelty≥0.80`
4. Update `results/aggregate/statistics.json`
5. Update `results/aggregate/findings/trend-candidates.md`
6. Rebuild `results/aggregate/gallery.html` (grid of all trial screenshots, filterable)

## Trend candidate format

```markdown
## Trend: liquid-glass × swiss-editorial (seed: 0xABCD1234)

- **Hybrid ratio**: 80/20 (liquid-glass dominant, typography from swiss-editorial)
- **Cohesion**: 0.88 | **Novelty**: 0.83 | **a11y**: 98
- **Context**: SaaS pricing page for exec persona
- **What's interesting**: editorial serif typography on frosted glass surfaces creates
  an unexpected "luxury documentation" aesthetic
```
