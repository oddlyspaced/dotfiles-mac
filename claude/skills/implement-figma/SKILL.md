---
name: implement-figma
description: Use when implementing a Figma design, screen, flow, or component into code from a figma.com URL and additional context — especially when pixel-perfect fidelity, real design tokens, reusing existing components, and matching codebase conventions matter. Triggers on "implement this Figma", "build this screen from Figma", "code up this design", or a figma.com URL handed in alongside a codebase.
---

# Implementing Figma Designs (Pixel-Perfect)

## Overview

Turning a Figma design into code is not "look at the picture and rebuild it." It is: **pull ground truth from Figma → understand the codebase in parallel → resolve every ambiguity before writing → reuse before building → verify pixels instead of eyeballing.** Skipping any of these produces plausible-looking code that is subtly wrong, duplicates existing components, hardcodes values that should be tokens, or guesses interactions the design never specified.

This skill orchestrates the full workflow and enforces the discipline. It relies on **`figma:figma-design-to-code`** for the raw Figma-read mechanics (`get_design_context` parameters, node/file key extraction) — load that skill too; do not re-derive its mechanics here.

## When to Use

- A `figma.com/design/...` or `figma.com/file/...` URL is handed in with intent to build it in code.
- "Implement this screen", "build this component from the mock", "make this pixel-perfect".

**When NOT to use:** writing *to* Figma from code (use `figma:figma-generate-design`); pure Code Connect mapping (`figma:figma-code-connect`).

## The Four Non-Negotiables

These are the rules that separate a real implementation from AI slop. Each has a rationalization table because each is tempting to skip under time pressure.

### 1. Ground truth comes from Figma data, not the screenshot alone

Pull the **real tokens, node tree, and assets** via MCP. A screenshot tells you *roughly* what it looks like; the variable definitions tell you the *exact* color/spacing/radius/type tokens the designer used, and `download_assets` gives you the *real* icons instead of your recreation.

### 2. Reuse before you build

Before writing any new component, you MUST search the target codebase for an existing component, hook, or layout that already does this. Rebuilding a button/card/list-row that already exists fragments the design system and guarantees drift.

### 3. Ask before you assume

Figma is static. It cannot tell you interactions, data sources, loading/empty/error states, responsive behavior, or edge cases. When the design leaves something ambiguous that the *code* must decide, you MUST ask — **batched, before implementing**, not after a wrong build.

### 4. Verify pixels, don't eyeball code

"The tokens match, so it's correct" is not verification. You MUST render the built UI, capture a screenshot, and diff it against the Figma frame. Code that reads correct is routinely off by 4px, a wrong font weight, or a missing shadow.

### Rationalization table

| Excuse | Reality |
|--------|---------|
| "The screenshot is enough, I can see the colors" | Eyeballed hex ≠ the token. Pull `get_variable_defs`; map to the codebase token. |
| "I'll just build the card fresh, it's faster" | The codebase already has one. Fresh = drift + duplicate maintenance. Search first. |
| "The design is clear enough, I'll infer the rest" | Figma can't specify interaction/data/states. Inferring wrong wastes a full build+review cycle. Ask. |
| "I'll pick a sensible default and mention it" | For blocking ambiguities that changes behavior, a mentioned guess is still a guess. Batch the questions and ask. |
| "Tokens line up, so it's pixel-perfect" | Spacing/weight/shadow errors don't show in a token audit. Render and diff. |
| "One review round, looks fine, done" | First-round diffs are the norm. If you found *any*, run a second round. |
| "I'll recreate that icon in code" | Recreations are lossy. `download_assets` gives the real SVG/PNG. |

### Red flags — STOP

- About to write a component without having grepped the codebase for an existing one.
- About to hardcode a hex/px/radius that corresponds to a design variable.
- About to start implementing while any interaction/state/data question is unanswered.
- About to claim "done" or "pixel-perfect" without a rendered screenshot diff.
- Reaching for the screenshot because the MCP call erred — read the error, don't silently hand-draw.

## Workflow

Run the phases in order. Phases 1 and 2 are independent — start them together.

### Phase 1 — Pull ground truth from Figma

Follow **[references/figma-mcp-playbook.md](references/figma-mcp-playbook.md)** for the exact call sequence. In short: `get_metadata` (structure) → `get_screenshot` (visual truth) → `get_variable_defs` (real tokens) → `get_code_connect_map` (existing component mappings) → `get_design_context` (reference code) → `download_assets` (icons/images). If the URL has no `node-id`, ask for a node-specific URL — never guess.

### Phase 2 — Parallel research fan-out (codebase)

Dispatch research agents **concurrently** (see `superpowers:dispatching-parallel-agents`). Send them in one message. Typical set:

- **Reuse scout** — find existing components/hooks/layouts that match pieces of this design (buttons, cards, rows, headers, sheets). Return `file:line` + how to use each. Use `codebase-pattern-finder`.
- **Token/theme mapper** — how the codebase defines colors, spacing, typography, radii, shadows; produce the mapping target for Figma variables. Use `codebase-locator`/`codebase-analyzer`.
- **Convention scout** — how similar screens are structured (folder layout, navigation, state management, data-fetching/services, styling system). Return the pattern to mirror.
- **Design decomposer** (optional) — break the Figma node tree into a component hierarchy with states/variants noted.

Wait for all results before planning.

### Phase 3 — Mandatory clarifying questions

From Phases 1–2, list every ambiguity the code must resolve that the design does not specify: interactions, navigation targets, data source/shape, loading/empty/error/pressed states, responsive/overflow behavior, permissions/auth gating, animation, missing assets, copy that looks like a placeholder. **Batch them into one `AskUserQuestion` and ask before implementing.** If genuinely nothing is ambiguous, say so and proceed — but the default is to ask.

### Phase 4 — Plan

Produce a short plan the user can eyeball:
- **Reuse map:** reuse X (as-is) / extend Y (new variant) / build new Z (nothing exists).
- **Token map:** each Figma variable → codebase token. Flag any Figma value with no matching token (needs a new token or a decision).
- **Asset list:** downloaded assets and where they'll live.
- **File plan:** which files, following the convention scout's pattern.

### Phase 5 — Implement (reuse-first)

- Adapt the `get_design_context` reference output into the project's real stack — never paste it verbatim.
- Reuse the components from the reuse map. Only build new when nothing fits.
- Use mapped tokens for every color/space/radius/type/shadow. **No raw hex/px** that corresponds to a token.
- Honor Figma hints by priority: Code Connect > component docs > design annotations > design tokens > raw hex.
- Match the surrounding code's naming, structure, and idioms. Build the states you confirmed in Phase 3.

### Phase 6 — Pixel-perfect review loop

Run **[references/pixel-perfect-review.md](references/pixel-perfect-review.md)**. In short: render the built UI, capture a screenshot (browser tooling for web, mobile/simulator tooling for native, or ask the user to run it and share a screenshot), and diff against the Figma frame across the checklist (dimensions, spacing, color, typography, radius, borders, shadows, alignment, iconography, states). **Default: one round; if it finds *any* discrepancy, fix and run a second round.** Repeat until a round is clean. Only then claim completion — with the screenshot as evidence (`superpowers:verification-before-completion`).

## Quick Reference

| Phase | Do | Skill / Tool |
|-------|-----|------|
| 1 Ground truth | Metadata, screenshot, variables, code-connect, context, assets | `figma:figma-design-to-code`, `references/figma-mcp-playbook.md` |
| 2 Research | Parallel: reuse / tokens / conventions / decomposition | `superpowers:dispatching-parallel-agents`, `codebase-pattern-finder` |
| 3 Questions | Batch every code-blocking ambiguity, ask once | `AskUserQuestion` |
| 4 Plan | Reuse map + token map + asset list + file plan | — |
| 5 Implement | Reuse-first, mapped tokens, match conventions, build states | — |
| 6 Review | Render → screenshot → diff → fix → repeat until clean | `references/pixel-perfect-review.md`, `superpowers:verification-before-completion` |

## Common Mistakes

- **Building from the screenshot only** — you miss real tokens and real assets. Pull the data.
- **Skipping the reuse scout** — you ship a duplicate button/card. Grep first.
- **Implementing before asking** — you build the wrong interaction/state and redo it. Ask in Phase 3.
- **Hardcoding values** — eyeballed hex/px drift from the system. Map to tokens.
- **Declaring "pixel-perfect" from a code read** — render and diff, or it isn't verified.
- **Doing the research serially** — Phases 1 and 2 are independent; run them in parallel.
