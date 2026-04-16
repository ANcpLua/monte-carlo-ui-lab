#!/bin/zsh

# ===========================================================================
# Run a single Monte Carlo UI trial.
# Deterministic by seed — the sampler draws the same values for the same seed.
# The generator (LLM) is stochastic — record model/temp in manifest.
#
# Usage: ./scripts/run-trial.sh <seed> [--theme <name>] [--hybrid <name>]
# ===========================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SEED="${1:?Usage: run-trial.sh <seed>}"
TRIAL_DIR="/tmp/mc-ui-trial-${SEED}"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[0;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; DIM='\033[2m'; RESET='\033[0m'

echo ""
echo "${BOLD}  Monte Carlo UI Trial${RESET} ${DIM}seed=${SEED}${RESET}"
echo ""

# Clean up any leftover worktree
git -C "$REPO_ROOT" worktree remove --force "$TRIAL_DIR" 2>/dev/null || true
rm -rf "$TRIAL_DIR"
git -C "$REPO_ROOT" worktree prune 2>/dev/null
git -C "$REPO_ROOT" branch -D "trial-${SEED}" 2>/dev/null || true

# Create isolated worktree
git -C "$REPO_ROOT" worktree add "$TRIAL_DIR" -b "trial-${SEED}"

echo "  ${CYAN}●${RESET} ${BOLD}sample${RESET} ${DIM}— drawing from axes...${RESET}"

# Step 1: Sampler — build the prompt from the seed
# (In production this calls the sampler agent; for now, claude does it inline)
cd "$TRIAL_DIR"
cp "$REPO_ROOT/CLAUDE.md" "$TRIAL_DIR/CLAUDE.md"

claude -p "You are the sampler agent for monte-carlo-ui-lab.

Read the study configuration:
- study/themes/ (pick a theme based on seed $SEED)
- study/patterns/*.yaml (available components)
- study/business/*.yaml (industry, persona, page archetype)
- study/laws.yaml (UX constraints)

Generate TWO files in the repo root:
1. manifest.json — the sampled values (seed, theme, palette, typography, layout, density, motion_intensity, industry, persona, page_archetype, components array)
2. prompt.md — a detailed generation prompt that combines all sampled values into clear instructions for the generator agent

Use seed '$SEED' to make deterministic choices. Be creative but stay within the theme's rules." \
  --dangerously-skip-permissions </dev/null &>"${TRIAL_DIR}/sampler.log"

echo "  ${CYAN}●${RESET} ${BOLD}generate${RESET} ${DIM}— building index.html...${RESET}"

# Step 2: Generator — produce the HTML
claude -p "You are the generator agent for monte-carlo-ui-lab.

Read manifest.json and prompt.md in this directory.
Read the theme files in study/themes/ for the selected theme.
Read study/laws.yaml for UX constraints.

Generate a single self-contained index.html with:
- Inline CSS and JS (no external dependencies)
- WCAG 2.2 AA accessible
- prefers-reduced-motion support
- Responsive (320px to 1920px)
- Realistic copy (no lorem ipsum)
- ONLY components from the manifest's components array
- Follow the theme's rules.md exactly
- Avoid everything in the theme's anti-patterns.md

Output: one index.html file in the repo root." \
  --dangerously-skip-permissions </dev/null &>"${TRIAL_DIR}/generator.log"

# Step 3: Check if index.html was created
if [ -f "$TRIAL_DIR/index.html" ]; then
  SIZE=$(wc -c < "$TRIAL_DIR/index.html" | tr -d ' ')
  echo "  ${GREEN}●${RESET} ${BOLD}done${RESET} ${DIM}(${SIZE}b)${RESET} → ${TRIAL_DIR}/index.html"
else
  echo "  ${RED}●${RESET} ${BOLD}failed${RESET} — no index.html generated"
  exit 1
fi

# Step 4: Archive to results (scribe step)
RESULTS_DIR="$REPO_ROOT/results/trials/${SEED}"
mkdir -p "$RESULTS_DIR"
for f in manifest.json prompt.md index.html; do
  [ -f "$TRIAL_DIR/$f" ] && cp "$TRIAL_DIR/$f" "$RESULTS_DIR/$f"
done
cp "$TRIAL_DIR/sampler.log" "$RESULTS_DIR/trace.log" 2>/dev/null || true
cat "$TRIAL_DIR/generator.log" >> "$RESULTS_DIR/trace.log" 2>/dev/null || true

echo "  ${GREEN}●${RESET} ${BOLD}archived${RESET} → results/trials/${SEED}/"
echo ""
