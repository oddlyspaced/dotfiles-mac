# Pixel-Perfect Review Loop — Phase 6

The goal: prove the built UI matches the Figma frame, not assert it. Reading code is not verification — **render, capture, diff.**

## The loop

1. **Render the built UI** in the same state the Figma frame shows.
   - Web: use `claude-in-chrome` browser tooling (navigate to the running app, screenshot the component/route).
   - Native (React Native / iOS / Android): use the mobile/simulator tooling (`mcp__mobile-mcp__mobile_take_screenshot`) or launch the app via the `run` skill.
   - No runnable environment? Ask the user to run it and paste a screenshot. Do not skip to "looks right."
2. **Capture** the rendered screenshot.
3. **Diff** it against the Figma frame screenshot (from Phase 1) across the checklist below. Overlay mentally or side-by-side; look for *deltas*, not general vibes.
4. **List discrepancies** with the specific value (expected vs. actual) and the token/style to change.
5. **Fix** them.
6. **Re-run** the loop.

**Default cadence:** one round. **If a round finds *any* discrepancy, run another round after fixing** — first-pass diffs almost always exist and the fix can introduce a new one. Stop only when a round is clean.

## Diff checklist

Compare every axis — subtle misses hide here:

- **Dimensions** — width/height of frame and key elements match.
- **Spacing** — padding, margins, gaps between elements (the most common miss; check every gap, not just the obvious ones).
- **Color** — background, text, border, icon fills match the *token*, not an approximate hex.
- **Typography** — font family, size, **weight**, line-height, letter-spacing, text-align, truncation.
- **Radius** — corner radii on cards, buttons, images, inputs.
- **Borders** — width, color, style, presence/absence.
- **Shadows / effects** — elevation, blur, spread, opacity (frequently dropped entirely).
- **Alignment** — vertical and horizontal alignment within containers; baseline alignment of text+icon.
- **Iconography** — the real downloaded asset is used, at the right size, not a recreation or a wrong icon.
- **States** — pressed/hover/focus, loading, empty, error, disabled render as designed (test each, not just the default).
- **Responsive/overflow** — behavior at the confirmed breakpoints / long-content / small-screen cases.

## Completion

Only after a clean round: claim completion **with the screenshot as evidence** (per `superpowers:verification-before-completion`). "Pixel-perfect" without an attached rendered diff is an unverified claim — don't make it.
