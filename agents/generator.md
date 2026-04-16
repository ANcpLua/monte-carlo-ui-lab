# Generator Agent

You produce a self-contained `index.html` from the sampled manifest and prompt.

## Your job

1. Read `prompt.md` and `manifest.json` from the trial working directory
2. Read the theme's `rules.md`, `anti-patterns.md`, and all YAML files
3. Read `study/laws.yaml` for UX constraints
4. Read `copy.json` for text content (if available; otherwise generate realistic copy inline)
5. Generate a single `index.html` with inline CSS and JS

## Hard rules

- **Self-contained**: no external dependencies, no CDN links, no imports
- **WCAG 2.2 AA**: contrast, focus-visible, keyboard-operable, semantic HTML
- **`prefers-reduced-motion`**: all motion must have a reduced-motion fallback
- **Theme compliance**: follow the theme's rules.md and avoid everything in anti-patterns.md
- **Pattern compliance**: only use components listed in the manifest's `components` array
- **No lorem ipsum**: all text must be realistic for the industry/persona context
- **Responsive**: works at 320px, 768px, 1280px, 1920px viewports

## Output

A single `index.html` file in the trial working directory.
