#!/bin/zsh

# ===========================================================================
# Scaffold a new theme folder with all required files.
#
# Usage: ./scripts/propose-theme.sh <theme-name>
# ===========================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
THEME="${1:?Usage: propose-theme.sh <theme-name>}"
THEME_DIR="$REPO_ROOT/study/themes/$THEME"

if [ -d "$THEME_DIR" ]; then
  echo "Theme '$THEME' already exists at $THEME_DIR"
  exit 1
fi

mkdir -p "$THEME_DIR"

cat > "$THEME_DIR/manifest.yaml" << 'YAML'
name: THEME_NAME
tagline: TODO — one-line identity
year: 2026
maturity: draft
influences: []
identity: |
  TODO — describe the visual identity in 2-3 sentences.
YAML
sed -i '' "s/THEME_NAME/$THEME/" "$THEME_DIR/manifest.yaml"

for file in rules.md anti-patterns.md; do
  echo "# $(echo $file | sed 's/.md//' | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')" > "$THEME_DIR/$file"
  echo "" >> "$THEME_DIR/$file"
  echo "TODO — define the ${file%.md} for this theme." >> "$THEME_DIR/$file"
done

for file in components.yaml motion.yaml palette.yaml typography.yaml layout-grammar.yaml copy-voice.yaml; do
  echo "# TODO — define ${file%.yaml} for $THEME" > "$THEME_DIR/$file"
done

echo ""
echo "Created theme scaffold at: $THEME_DIR"
echo ""
echo "Files to edit:"
ls -1 "$THEME_DIR"
echo ""
echo "Don't forget to add compatibility edges in:"
echo "  study/themes/_compatibility-graph.yaml"
