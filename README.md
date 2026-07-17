# dotfiles-mac

My macOS setup — a tiling window manager rice plus shell, editor, and Claude Code
config. Everything is symlinked from this repo into place by [`install.sh`](install.sh),
and every package is captured in the [`Brewfile`](Brewfile).

**The stack:** [yabai](https://github.com/koekeishiya/yabai) (tiling WM) ·
[skhd](https://github.com/koekeishiya/skhd) (hotkeys) ·
[Hyperkey](https://hyperkey.app) (Caps Lock → Hyper) ·
[JankyBorders](https://github.com/FelixKratz/JankyBorders) (active-window borders) ·
[SketchyBar](https://github.com/FelixKratz/SketchyBar) (menu bar) ·
[Ghostty](https://ghostty.org) (terminal) ·
[fish](https://fishshell.com) + [starship](https://starship.rs) (shell) ·
[Neovim](https://neovim.io)/[LazyVim](https://www.lazyvim.org) (editor) ·
[Claude Code](https://claude.com/claude-code).

Theme throughout: **Catppuccin Mocha**. UI font: **FantasqueSansM Nerd Font**.

---

## What's inside

| Path | Symlinks to | What it is |
|------|-------------|------------|
| `yabai/yabairc` | `~/.yabairc` | Tiling window manager config + sketchybar/borders integration |
| `skhd/skhdrc` | `~/.skhdrc` | Keybindings (i3-style, driven by Hyperkey) |
| `borders/bordersrc` | `~/.config/borders/bordersrc` | JankyBorders — border around the focused window |
| `sketchybar/` | `~/.config/sketchybar/` | Floating Catppuccin menu bar (spaces, media, system stats, caffeinate) |
| `ghostty/config` | `~/.config/ghostty/config` | Terminal — borderless, translucent, Catppuccin Mocha |
| `fish/` | `~/.config/fish/` | Shell config, git aliases, project helpers |
| `nvim/` | `~/.config/nvim/` | LazyVim-based Neovim (TS/React/RN/Next/Go) |
| `claude/` | `~/.claude/` | Claude Code settings, statusline, skills, commands, agents, hooks |
| `Brewfile` | — | All Homebrew taps, formulae, and casks |
| `install.sh` | — | Idempotent symlink installer (backs up what it replaces) |

---

## Fresh-machine setup

### 0. Prerequisites

Install [Homebrew](https://brew.sh), then clone this repo:

```sh
git clone git@github.com:oddlyspaced/dotfiles-mac.git ~/dotfiles-mac
cd ~/dotfiles-mac
```

### 1. Install packages

```sh
brew bundle --file=Brewfile
```

This installs everything: yabai, skhd, sketchybar, borders, fish, neovim, the nerd
fonts, Ghostty, Hyperkey, and all apps. (Only top-level packages are listed;
dependencies resolve automatically.)

### 2. Symlink the configs

```sh
DRY_RUN=1 ./install.sh   # preview
./install.sh             # apply
```

Existing files are moved to `~/.dotfiles-backup/<timestamp>/` before linking, so it's
safe to re-run.

### 3. Secrets (fish)

Machine-local credentials are **not** tracked. Create your own from the template:

```sh
cp fish/secrets.fish.example ~/.config/fish/secrets.fish
$EDITOR ~/.config/fish/secrets.fish
```

`config.fish` sources it automatically if present.

### 4. Make fish the default shell

```sh
echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/fish
```

### 5. Start the desktop services

```sh
yabai      --start-service
skhd       --start-service
brew services start sketchybar
# borders is launched by yabairc (`borders &`), so it starts with yabai
```

Grant **Accessibility** (and for yabai, **Screen Recording**) permissions when macOS
prompts: System Settings → Privacy & Security.

### 6. Configure Hyperkey

The keybindings rely on a **Hyper** key (`⌘⌥⌃⇧`). Open the **Hyperkey** app and set
**Caps Lock → Hyper**. skhd's built-in `hyper` alias then matches, and bindings that
use `cmd + alt + ctrl` are "Hyper without Shift". See [Keybindings](#keybindings).

### 7. (Optional) yabai scripting addition

The current config keeps `window_animation_duration 0` and doesn't require the
scripting addition for day-to-day use. If you later want space/window features that
need it, follow the yabai wiki to load the scripting addition and add a passwordless
`sudo` entry (the commented header in `yabai/yabairc` links the steps). This is the
only part that involves partially disabling SIP — skip it unless you need it.

---

## Keybindings

Defined in [`skhd/skhdrc`](skhd/skhdrc). `Hyper` = `⌘⌥⌃⇧` (Caps Lock, via Hyperkey);
`⌘⌥⌃` is Hyper **without** Shift.

| Keys | Action |
|------|--------|
| `⌘⌥⌃ + return` | Open a new Ghostty window |
| `⌘⌥⌃ + h / j / k / l` | Focus window west / south / north / east |
| `⌘⌥⌃ + 1…9, 0` | Focus space 1…9, 10 |
| `Hyper + 1…9, 0` | Send focused window to space (and follow) |
| `Hyper + h / j / k / l` | Set where the **next** window opens (insert west/south/north/east) |
| `Hyper + s` | Stack the next window on the focused one |
| `Hyper + c` | Cancel the pending insertion point |
| `⌘⌥⌃ + e` | Toggle split orientation (h ↔ v) |
| `⌘⌥⌃ + d` | Toggle zoom (fill parent) |
| `⌘⌥⌃ + f` | Toggle fullscreen zoom |

Mouse (via yabai): hold **fn** + left-drag to move a window, fn + right-drag to
resize, drop on another window to swap.

---

## Component notes

### yabai — `yabai/yabairc`
BSP tiling, 10px gaps/padding, `external_bar all:46:0` reserves room for SketchyBar.
Emits signals on every window/space change so SketchyBar can repaint per-space app
icons, and launches JankyBorders. Comes from the `asmvik/formulae` tap.

### SketchyBar — `sketchybar/`
Floating rounded-pill bar, Catppuccin Mocha. Structure:
- `sketchybarrc` — bar appearance + item load order
- `colors.sh` / `icons.sh` — the palette and nerd-font glyph variables
- `items/*.sh` — widget definitions (spaces, front app, media, calendar, battery,
  volume, wifi, network, cpu, memory, and a **caffeinate** toggle tile)
- `plugins/*.sh` — the event scripts each widget runs
- `plugins/icon_map.sh` + the `sketchybar-app-font` cask map running apps to glyphs on
  the per-space chips.

Requires the `font-sketchybar-app-font` and `font-fantasque-sans-mono-nerd-font` casks
(both in the Brewfile).

### JankyBorders — `borders/bordersrc`
6px square border; pink (`0xfff5c2e7`) when focused, grey when not.

### Ghostty — `ghostty/config`
Borderless, 60% opacity with 32px blur, FantasqueSansM Nerd Font 13, Catppuccin Mocha.

### fish — `fish/`
- `config.fish` — PATH (brew, openjdk@17, ruby@4.0, go, `~/.local/bin`), starship,
  `EDITOR=nvim`, `ANDROID_HOME`, OrbStack init, and sources `secrets.fish`.
- `functions/` — git shortcuts (`ga gc gd gl gp gs gu`), `emulator` (Android AVD
  launcher), `mercuric` (multi-repo git helper), `jn` (pretty-print JSON in nvim),
  and `claude` / `claude-swish` (switch `CLAUDE_CONFIG_DIR`).
- `conf.d/flashlight.fish` — adds Flashlight to PATH.

### Neovim — `nvim/`
LazyVim starter with a Catppuccin Mocha theme and language extras for
TypeScript/Tailwind/Go/JSON/Markdown + Prettier, plus `nvim-colorizer` for inline
color swatches. `lazy-lock.json` is committed for reproducible plugin versions —
run `:Lazy restore` to match it.

### Claude Code — `claude/`
- `settings.json` — model, permissions, statusline, enabled plugins
  (superpowers, figma, frontend-design, vercel, …), and hooks.
- `statusline-command.sh` — custom statusline (dir, git branch, context %, rate
  limits, token count, cost).
- `skills/`, `commands/`, `agents/` — custom skills, slash commands, and subagents.
- `hooks/claude-island-state.py` — pushes session state to the **Claude Island** app
  (the `claude-island` cask) over a Unix socket.

`settings.local.json` (machine-local permission grants) is intentionally **not**
tracked.

---

## Fonts

Installed via the Brewfile: `font-fantasque-sans-mono-nerd-font` (bar + terminal),
`font-sketchybar-app-font` (space app glyphs), `font-jetbrains-mono[-nerd-font]`,
`font-hack-nerd-font`.

---

## Maintenance

```sh
# Refresh the Brewfile from the current machine
brew bundle dump --force --file=Brewfile

# Update the Neovim plugin lock after upgrading plugins
nvim --headless "+Lazy! sync" +qa   # then commit nvim/lazy-lock.json

# Reload a service after editing its config
yabai --restart-service
skhd  --restart-service
sketchybar --reload
brew services restart sketchybar
```

Because configs are symlinked, edits under `~/.config` **are** edits to this repo —
just `git commit` them here.

> **Note:** never commit real secrets. `fish/secrets.fish` and
> `claude/settings.local.json` are gitignored; keep it that way.
