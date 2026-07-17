# Figma MCP Playbook — pulling ground truth

The exact call sequence for Phase 1. Every tool is `mcp__plugin_figma_figma__*`. Load `figma:figma-design-to-code` first — it owns the parameter mechanics (nodeId / fileKey / branchKey extraction from the URL, `format`/`query` options, response shape). This file is the *orchestration*: which calls, in what order, and what to extract from each.

## Prerequisite: a node-specific URL

The URL must contain a `node-id`. A file-only URL (`figma.com/design/<key>/<name>` with no `?node-id=`) is not enough — **ask the user to select the frame and copy its link.** Never guess a node id or pass an empty one.

## Call sequence

Run in this order. Each row says why and what to harvest.

| # | Tool | Why | Extract |
|---|------|-----|---------|
| 1 | `get_metadata` | Orient: the node tree, names, node ids, sizes, positions | Component hierarchy; child node ids (for per-component asset/context calls); frame dimensions |
| 2 | `get_screenshot` | Visual ground truth — the pixel target you diff against later | Save/keep the frame image; note states shown, overflow, real content |
| 3 | `get_variable_defs` | The **real tokens** the designer bound: colors, spacing, radii, typography, effects | Every variable name → value. This is your token-mapping source, not eyeballed hex |
| 4 | `get_code_connect_map` | Whether Figma nodes already map to real codebase components | Any mapped component → use it directly (highest-priority hint) |
| 5 | `get_design_context` | The primary reference: React+Tailwind code enriched with hints | Reference structure + hint layers (Code Connect > docs > annotations > tokens > raw hex). **Reference, not final code.** |
| 6 | `download_assets` | The **real** icons/images — never recreate them in code | SVG/PNG files; note intended path in the target project |

Optional, when relevant:
- `get_motion_context` — if the node is animated (or `get_design_context` returns motion data). Pair with `figma:figma-implement-motion`.
- `search_design_system` / `get_libraries` — to locate the design-system component behind a node when Code Connect is absent.
- `get_context_for_code_connect` — when you intend to add a Code Connect mapping.

## Notes

- **Big frames:** if `get_design_context` times out, call it per child node id (from step 1) rather than the whole frame.
- **Errors:** STOP and read the message before retrying. Do not silently fall back to hand-drawing from the screenshot — the data calls carry information the screenshot cannot.
- **Tokens with no codebase equivalent:** record them; they become a Phase 4 decision (add a token vs. reuse the nearest existing one), not a silent hardcode.
