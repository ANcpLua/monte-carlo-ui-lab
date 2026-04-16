# Rules

## Surface model

Every interactive surface is a frosted glass panel:
- `backdrop-filter: blur(20px) saturate(180%)`
- Semi-transparent background (rgba with 0.6–0.85 alpha)
- Subtle border (1px solid rgba white at 0.15–0.25)
- Layered depth through stacked blur levels

## Depth hierarchy

- Background: gradient mesh or soft image (never flat color)
- Layer 1: heavy blur (24px), low opacity — navigation, sidebars
- Layer 2: medium blur (16px), medium opacity — cards, panels
- Layer 3: light blur (8px), higher opacity — modals, popovers
- Each layer casts a subtle shadow for spatial separation

## Light and refraction

- Surfaces catch a subtle specular highlight that follows the cursor
- Edge highlights simulate glass refraction (1px gradient border)
- Color bleeds through from the background, tinted by the surface

## Typography on glass

- Text must maintain WCAG AA contrast against the WORST-CASE background bleed
- Use text-shadow or subtle backdrop for readability insurance
- Prefer medium weight (500) over thin (300) — thin text on blur is illegible

## Interaction states

- Hover: increase opacity slightly, brighten specular
- Active: compress surface (scale 0.98), deepen shadow
- Focus: bright ring outside the glass border (not inside — it gets lost in blur)
