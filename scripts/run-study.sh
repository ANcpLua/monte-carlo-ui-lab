#!/bin/zsh

# ===========================================================================
# Run N Monte Carlo UI trials in parallel.
# Each trial gets its own worktree — zero coordination needed.
#
# Usage: ./scripts/run-study.sh [--count N] [--theme NAME]
# Default: 16 parallel trials with random seeds
# ===========================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
COUNT=${2:-16}

BOLD='\033[1m'; DIM='\033[2m'; GREEN='\033[0;32m'; RED='\033[0;31m'; RESET='\033[0m'

# Parse --count flag
while [[ $# -gt 0 ]]; do
  case $1 in
    --count) COUNT="$2"; shift 2 ;;
    *) shift ;;
  esac
done

echo ""
echo "${BOLD}  Monte Carlo UI Study${RESET} ${DIM}— ${COUNT} parallel trials${RESET}"
echo ""

# Generate random seeds
seeds=()
for i in $(seq 1 $COUNT); do
  seeds+=("0x$(openssl rand -hex 4 | tr '[:lower:]' '[:upper:]')")
done

pids=()
rm -f /tmp/mc-ui-trial-*.done /tmp/mc-ui-trial-*.reported

cleanup() {
  echo ""
  echo "${RED}  Interrupted — killing all trials...${RESET}"
  kill "${pids[@]}" 2>/dev/null
  rm -f /tmp/mc-ui-trial-*.done /tmp/mc-ui-trial-*.reported
  exit 1
}
trap cleanup INT TERM

# Launch all trials in parallel
for seed in "${seeds[@]}"; do
  echo "  ${DIM}launching${RESET} ${seed}"
  ("$SCRIPT_DIR/run-trial.sh" "$seed" &>"$REPO_ROOT/results/${seed}.log"; touch "/tmp/mc-ui-trial-${seed}.done") &
  pids+=($!)
done

echo ""
echo "${DIM}  Waiting for ${COUNT} trials...${RESET}"
echo ""

# Poll for completions
completed=0
while [ $completed -lt $COUNT ]; do
  for seed in "${seeds[@]}"; do
    if [ -f "/tmp/mc-ui-trial-${seed}.done" ] && [ ! -f "/tmp/mc-ui-trial-${seed}.reported" ]; then
      completed=$((completed + 1))
      touch "/tmp/mc-ui-trial-${seed}.reported"
      if [ -f "$REPO_ROOT/results/trials/${seed}/index.html" ]; then
        size=$(wc -c < "$REPO_ROOT/results/trials/${seed}/index.html" | tr -d ' ')
        echo "  ${GREEN}●${RESET} ${seed} ${DIM}(${size}b)${RESET}  [${completed}/${COUNT}]"
      else
        echo "  ${RED}●${RESET} ${seed} ${DIM}(no output)${RESET}  [${completed}/${COUNT}]"
      fi
    fi
  done
  sleep 2
done

wait

echo ""
echo "${BOLD}${GREEN}  All ${COUNT} trials complete.${RESET}"
echo "${DIM}  Results in results/trials/{seed}/index.html${RESET}"
echo "${DIM}  Run ./scripts/gallery.sh to build the gallery${RESET}"
echo ""

# Cleanup markers
rm -f /tmp/mc-ui-trial-*.done /tmp/mc-ui-trial-*.reported
