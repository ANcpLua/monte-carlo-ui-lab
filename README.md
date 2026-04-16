# monte-carlo-ui-lab

Empirical playground for discovering UI design trends through constrained random sampling.

## How it works

1. **Themes** define cohesive design languages (palette, typography, motion, components, rules)
2. **Samplers** draw random variations within themes or hybridize across compatible themes
3. **Agents** orchestrate the pipeline: sample → generate → audit → archive
4. Each trial produces a self-contained `index.html` with inline CSS/JS
5. A **pity system** guarantees every result is shippable — rerolls tighten constraints until the floor is met

## Why themes, not random axes

Random colors + random fonts + random layouts = chaos. Instead, we sample **combinations of known, cohesive design systems**. The LLM acts as a regularizer — it interprets even unusual combinations as coherent designs. Every result is at minimum acceptable; the interesting ones are trend candidates.

## Quick start

```bash
# Single trial with a specific seed
./scripts/run-trial.sh 0xC0FFEE42

# 16 parallel trials (one worktree each)
./scripts/run-study.sh --count 16

# Reproduce a specific trial
./scripts/reproduce.sh 0xC0FFEE42

# Rebuild the gallery from all results
./scripts/gallery.sh
```

## Repo structure

```
study/          methodology (locked, versioned)
  themes/       cohesive design languages (the unit of sampling)
  patterns/     shared component lexicon (all themes draw from here)
  business/     industry, persona, page-type context
  samplers/     sampling strategies (uniform, latin-hypercube, pity-system)

agents/         agent definitions (narrow-scope prompts)
scripts/        orchestration scripts (worktree-based parallelism)
results/        append-only trial data (one folder per seed)
analysis/       post-hoc notebooks and reports
```

## Adding a theme

```bash
./scripts/propose-theme.sh my-new-theme
# Edit the generated files in study/themes/my-new-theme/
# Add compatibility edges in study/themes/_compatibility-graph.yaml
```

## Study phases

| Phase | n | Method | Goal |
|-------|---|--------|------|
| Pilot | 50 | Uniform, intra-theme only | Calibrate thresholds |
| Coverage | 500 | Latin Hypercube, intra-theme | Maximize axis coverage |
| Hybrid | 200 | Cross-theme with compatibility graph | Discover stable hybrids |
| Active | ongoing | Over-sample high-novelty + high-cohesion | Surface trend candidates |

## Requirements

- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code/overview)
- zsh
- Any git repository (worktrees need one)
- Node.js 18+ (for samplers)
