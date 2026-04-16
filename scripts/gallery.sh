#!/bin/zsh

# ===========================================================================
# Build a gallery HTML page from all trial results.
# Outputs to results/aggregate/gallery.html
#
# Usage: ./scripts/gallery.sh
# ===========================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
RESULTS="$REPO_ROOT/results/trials"
OUTPUT="$REPO_ROOT/results/aggregate/gallery.html"

mkdir -p "$(dirname "$OUTPUT")"

TRIALS=()
if [ -d "$RESULTS" ]; then
  for dir in "$RESULTS"/*/; do
    [ -f "${dir}index.html" ] && TRIALS+=("$dir")
  done
fi

COUNT=${#TRIALS[@]}

cat > "$OUTPUT" << 'HTML'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Monte Carlo UI Lab — Gallery</title>
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  body { font-family: system-ui, sans-serif; background: #0a0a0a; color: #fafafa; padding: 2rem; }
  h1 { font-size: 1.5rem; margin-bottom: 0.5rem; }
  .meta { color: #737373; margin-bottom: 2rem; font-size: 0.875rem; }
  .grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(400px, 1fr)); gap: 1.5rem; }
  .trial { background: #171717; border: 1px solid #262626; border-radius: 8px; overflow: hidden; }
  .trial iframe { width: 100%; height: 300px; border: none; background: white; }
  .trial-info { padding: 1rem; font-size: 0.8rem; color: #a3a3a3; }
  .trial-info strong { color: #fafafa; }
  a { color: #3b82f6; text-decoration: none; }
  a:hover { text-decoration: underline; }
</style>
</head>
<body>
<h1>Monte Carlo UI Lab — Gallery</h1>
HTML

echo "<p class=\"meta\">${COUNT} trials</p>" >> "$OUTPUT"
echo '<div class="grid">' >> "$OUTPUT"

for dir in "${TRIALS[@]}"; do
  seed=$(basename "$dir")
  theme="unknown"
  industry="unknown"
  page="unknown"

  if [ -f "${dir}manifest.json" ]; then
    theme=$(grep -o '"theme_primary":"[^"]*"' "${dir}manifest.json" 2>/dev/null | cut -d'"' -f4 || echo "unknown")
    industry=$(grep -o '"industry":"[^"]*"' "${dir}manifest.json" 2>/dev/null | cut -d'"' -f4 || echo "unknown")
    page=$(grep -o '"page_archetype":"[^"]*"' "${dir}manifest.json" 2>/dev/null | cut -d'"' -f4 || echo "unknown")
  fi

  cat >> "$OUTPUT" << CARD
<div class="trial">
  <iframe src="../trials/${seed}/index.html" loading="lazy"></iframe>
  <div class="trial-info">
    <strong>${seed}</strong> — ${theme} · ${industry} · ${page}<br>
    <a href="../trials/${seed}/index.html" target="_blank">open full</a>
    · <a href="../trials/${seed}/manifest.json" target="_blank">manifest</a>
  </div>
</div>
CARD
done

echo '</div></body></html>' >> "$OUTPUT"

echo "Gallery built: ${OUTPUT}"
echo "${COUNT} trials included."
