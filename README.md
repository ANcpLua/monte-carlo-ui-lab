# monte-carlo-ui-lab

Monte Carlo applied to UI design — an empirical playground for discovering trends through constrained random sampling.

## The idea

Randomizing raw axes (colors, fonts, layouts) produces chaos. This lab samples *combinations of known cohesive systems* instead, using the LLM as a regularizer that interprets even unusual combinations as coherent designs. Every result is at-minimum shippable; the outliers are trend candidates.

## How it works

- **Themes** are cohesive design languages — palette, typography, motion, components, rules. Examples: `liquid-glass`, `swiss-editorial`, `practical-baseline`.
- **Samplers** draw random variations within a theme or hybridize across compatible themes (`uniform`, `latin-hypercube`, `pity-system`).
- **Agents** (`sampler` → `analyst` → `scribe` → `auditor` → `curator` → `copywriter`) run the pipeline: sample → generate → audit → archive.
- Each trial emits a self-contained `index.html` with inline CSS/JS.
- A **pity system** rerolls with tightened constraints until output meets the quality floor — every result is guaranteed shippable.

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

| Phase    | n       | Method                                   | Goal                     |
|----------|---------|------------------------------------------|--------------------------|
| Pilot    | 50      | Uniform, intra-theme only                | Calibrate thresholds     |
| Coverage | 500     | Latin Hypercube, intra-theme             | Maximize axis coverage   |
| Hybrid   | 200     | Cross-theme with compatibility graph     | Discover stable hybrids  |
| Active   | ongoing | Over-sample high-novelty + high-cohesion | Surface trend candidates |

## Requirements

- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code/overview)
- zsh
- Any git repository (worktrees need one)
- Node.js 18+ (for samplers)
