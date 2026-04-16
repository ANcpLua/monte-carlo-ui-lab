#!/bin/zsh

# ===========================================================================
# Reproduce a specific trial by seed.
# Reads the original manifest to ensure the same sample is drawn.
#
# Usage: ./scripts/reproduce.sh <seed>
# ===========================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SEED="${1:?Usage: reproduce.sh <seed>}"

MANIFEST="$REPO_ROOT/results/trials/${SEED}/manifest.json"
if [ ! -f "$MANIFEST" ]; then
  echo "No trial found for seed ${SEED}. Run a new trial instead:"
  echo "  ./scripts/run-trial.sh ${SEED}"
  exit 1
fi

echo "Reproducing trial ${SEED} from archived manifest..."
echo "Note: LLM generation is stochastic — the HTML will differ but the sample is identical."
echo ""

"$SCRIPT_DIR/run-trial.sh" "$SEED"
