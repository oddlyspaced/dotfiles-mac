# Caffeinate toggle tile — design

Date: 2026-07-06
Config: `~/.config/sketchybar` ("jankybar" — SketchyBar, Catppuccin Mocha floating pills)

## Goal

A toggle tile that keeps the Mac's **display awake** via `caffeinate -d`.

- **Left-click** — plain on/off toggle, indefinite.
- **Right-click** — cycle a timer: `off → 30m → 1h → 2h → off` (`caffeinate -d -t <secs>`, auto-expires).
- Lives on the **right side** of the bar.

## Files

- `items/caffeinate.sh` — declares the item, wires click + periodic refresh.
- `plugins/caffeinate.sh` — the brain: handles clicks, manages the caffeinate process, repaints.
- `icons.sh` — add `ICON_COFFEE` (`󰅶`, U+F0176) and `ICON_COFFEE_OFF` (`󰾪`, U+F0FAA). Both verified present in FantasqueSansM Nerd Font Mono Bold.
- `sketchybarrc` — source the item in the right-side group.

## State tracking

State file `/tmp/sketchybar_caffeinate.state` holds a single line `PID:END_EPOCH`:

- `PID` — the caffeinate process **we** started (so we never kill a caffeinate started elsewhere).
- `END_EPOCH` — unix epoch when a timed session ends; `0` = indefinite.

Starting a new session first kills the previously-tracked PID. On stop, kill the PID and remove the file.

## Interaction (branch on `$BUTTON` in click script)

State machine — `inactive`, `active-indefinite`, `active-timed(remaining)`:

- **Left-click**: inactive → start indefinite; active (either mode) → stop.
- **Right-click**: advance the timer cycle. inactive/indefinite → 30m; 30m → 1h; 1h → 2h; 2h → off.

## Visual states (plugin repaints)

| State | Icon | Color | Label |
|---|---|---|---|
| Inactive | `󰾪` coffee-off | `SUBTEXT` (dim) | — (empty) |
| Active, indefinite | `󰅶` coffee | `PEACH` | `∞` |
| Active, timed | `󰅶` coffee | `PEACH` | e.g. `45m` (counts down) |

## Live countdown / auto-revert

Item gets `update_freq=30`. Every 30s the plugin reconciles:

- Tracked PID no longer alive (timer expired, killed, or stale after reboot) → repaint dim inactive, remove state file.
- Alive + `END_EPOCH == 0` → indefinite look.
- Alive + timed → label shows remaining minutes (rounded up), min `1m`.

Countdown resolution is ~30s, which is fine for a minute-granularity label.

## Edge cases

- Stale state file after reboot: PID not alive → treated as inactive, cleaned up.
- Right-click while indefinite is on: enters the timer cycle at 30m.
- Left-click while a timer runs: stops it.
