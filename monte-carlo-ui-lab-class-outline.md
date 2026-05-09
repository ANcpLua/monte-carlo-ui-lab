# Monte Carlo UI Lab — Student Summary

## 1) What this repo is

This repository is an empirical UI design lab. It uses constrained random sampling to generate many self-contained UI
trials, then audits and archives the results so recurring design directions can be studied.

The goal is not to build one production app. The goal is to run repeatable UI experiments: choose a seed, sample a
theme and business context, generate an `index.html`, audit it against quality floors, archive the result, and later
analyze which visual directions are both novel and usable.

## 2) Core entry points

- [README.md](README.md): short project overview, quick-start commands, repo structure, study phases, and requirements.
- [PROTOCOL.md](PROTOCOL.md): research question, variables, sampling phases, quality floors, pity system, and trend
  promotion loop.
- [AGENTS.md](AGENTS.md): repo-local working rules and architecture notes for agents.
- [study/laws.yaml](study/laws.yaml): UX laws, Nielsen heuristics, and WCAG floors every generated trial must respect.
- [study/thresholds.yaml](study/thresholds.yaml): numeric pass/fail floors for audit results and trend-interest
  thresholds.

## 3) Running and scripts

- [scripts/run-trial.sh](scripts/run-trial.sh): runs one seed through sampling, generation, and archival.
- [scripts/run-study.sh](scripts/run-study.sh): launches multiple trials in parallel.
- [scripts/reproduce.sh](scripts/reproduce.sh): reruns a previously archived seed from its manifest.
- [scripts/gallery.sh](scripts/gallery.sh): builds `results/aggregate/gallery.html` from archived trials.
- [scripts/propose-theme.sh](scripts/propose-theme.sh): scaffolds a new theme folder under `study/themes/`.

Typical commands:

```bash
./scripts/run-trial.sh 0xC0FFEE42
./scripts/run-study.sh --count 16
./scripts/reproduce.sh 0xC0FFEE42
./scripts/gallery.sh
```

## 4) Study architecture

### Methodology

- [study/](study/): locked, versioned study design.
- [study/themes/_compatibility-graph.yaml](study/themes/_compatibility-graph.yaml): which theme pairs can be hybridized.
- [study/samplers/uniform.ts](study/samplers/uniform.ts): seeded baseline sampler.
- [study/samplers/latin-hypercube.ts](study/samplers/latin-hypercube.ts): coverage-oriented sampler.
- [study/samplers/pity-system.ts](study/samplers/pity-system.ts): bad-luck protection that tightens constraints on failed
  attempts.

### Business context

- [study/business/industries.yaml](study/business/industries.yaml): industries such as SaaS, fintech, healthcare, and
  developer tools.
- [study/business/personas.yaml](study/business/personas.yaml): target user types such as exec, developer, admin, and
  operator.
- [study/business/page-archetypes.yaml](study/business/page-archetypes.yaml): page types such as dashboard, pricing,
  onboarding, documentation, and checkout.
- [study/business/compatibility.yaml](study/business/compatibility.yaml): which themes fit which industries.
- [study/business/brand-constraints.yaml](study/business/brand-constraints.yaml): optional hard brand constraints.

### Component lexicon

- [study/patterns/navigation.yaml](study/patterns/navigation.yaml): navigation primitives.
- [study/patterns/hero.yaml](study/patterns/hero.yaml): hero-section patterns.
- [study/patterns/data-display.yaml](study/patterns/data-display.yaml): tables, cards, charts, timelines, badges, and lists.
- [study/patterns/input.yaml](study/patterns/input.yaml): form and input primitives.
- [study/patterns/feedback.yaml](study/patterns/feedback.yaml): toasts, dialogs, drawers, alerts, skeletons, and loading
  states.

## 5) Agent pipeline

- [agents/orchestrator.md](agents/orchestrator.md): coordinates the full trial pipeline.
- [agents/sampler.md](agents/sampler.md): turns a seed into `manifest.json` and `prompt.md`.
- [agents/copywriter.md](agents/copywriter.md): writes realistic copy for the sampled industry, persona, and page type.
- [agents/generator.md](agents/generator.md): generates one self-contained `index.html` with inline CSS and JS.
- [agents/auditor.md](agents/auditor.md): measures accessibility, contrast, LCP, CLS, cohesion, compliance, and copy quality.
- [agents/scribe.md](agents/scribe.md): archives trial artifacts under `results/trials/{seed}/`.
- [agents/analyst.md](agents/analyst.md): computes aggregate statistics and surfaces trend candidates.
- [agents/curator.md](agents/curator.md): proposes new themes when repeated high-quality hybrids appear.

## 6) Outputs and result flow

- [results/trials/](results/trials/): append-only trial folders, one per seed.
- [results/aggregate/](results/aggregate/): generated gallery, statistics, and findings.
- [analysis/](analysis/): place for later notebooks and reports.

Each successful trial is expected to archive:

```text
manifest.json
prompt.md
index.html
audit.json
screenshot.png
copy.json
trace.log
```

## 7) Learning path for students

1. Start with [README.md](README.md) to understand the purpose and command surface.
2. Read [PROTOCOL.md](PROTOCOL.md) to understand the experiment: variables, floors, sampling phases, and trend promotion.
3. Study [scripts/run-trial.sh](scripts/run-trial.sh) to see how one seed moves through the pipeline.
4. Read [agents/sampler.md](agents/sampler.md), [agents/generator.md](agents/generator.md), and
   [agents/auditor.md](agents/auditor.md) as the main sample-generate-measure loop.
5. Inspect `study/business/` and `study/patterns/` to understand the bounded design space.
6. Compare [study/thresholds.yaml](study/thresholds.yaml) with [agents/auditor.md](agents/auditor.md) to see what makes a
   trial archivable.
7. Use [scripts/gallery.sh](scripts/gallery.sh) and [agents/analyst.md](agents/analyst.md) to understand how many trials
   become trend evidence.

## 8) Notes

- This repo is closer to a research harness than a finished UI application.
- Generated `index.html` files must be self-contained: inline CSS and JS, no external dependencies.
- `study/` is the methodology layer and should stay stable during runs.
- `results/` is append-only output and should preserve seed-level reproducibility.
- The current scripts call the Claude CLI directly for sampling and generation; the `agents/` files define the intended
  narrower agent responsibilities.
- The current tree has a theme compatibility graph, but concrete theme folders still need to be added before normal
  sampling can produce useful trials.
