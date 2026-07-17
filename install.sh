#!/usr/bin/env bash
#
# install.sh — symlink every config in this repo into place.
#
# Existing files/dirs are moved to a timestamped backup dir before linking,
# so this is safe to re-run. Nothing is deleted.
#
# Usage:
#   ./install.sh            # link everything
#   DRY_RUN=1 ./install.sh  # print what would happen, change nothing

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
DRY_RUN="${DRY_RUN:-0}"

info() { printf '  \033[36m%s\033[0m %s\n' "$1" "$2"; }

# link SRC DEST — back up an existing DEST, then symlink SRC -> DEST.
link() {
  local src="$1" dest="$2"

  # Already the correct symlink? skip.
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    info "ok    " "$dest"
    return
  fi

  if [ "$DRY_RUN" = "1" ]; then
    info "link  " "$dest -> $src"
    return
  fi

  mkdir -p "$(dirname "$dest")"
  # Back up anything currently at DEST (real file, dir, or stale symlink).
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    mkdir -p "$BACKUP/$(dirname "${dest#$HOME/}")"
    mv "$dest" "$BACKUP/${dest#$HOME/}"
    info "backup" "${dest} -> $BACKUP/${dest#$HOME/}"
  fi
  ln -s "$src" "$dest"
  info "link  " "$dest -> $src"
}

echo "Dotfiles: $DOTFILES"
[ "$DRY_RUN" = "1" ] && echo "(dry run — no changes)"

echo; echo "▸ Window manager, keybindings, borders, terminal"
link "$DOTFILES/yabai/yabairc"      "$HOME/.yabairc"
link "$DOTFILES/skhd/skhdrc"        "$HOME/.skhdrc"
link "$DOTFILES/borders/bordersrc"  "$HOME/.config/borders/bordersrc"
link "$DOTFILES/ghostty/config"     "$HOME/.config/ghostty/config"

echo; echo "▸ SketchyBar + Neovim (whole config dirs)"
link "$DOTFILES/sketchybar"         "$HOME/.config/sketchybar"
link "$DOTFILES/nvim"               "$HOME/.config/nvim"

echo; echo "▸ Fish (per-item, so fish_variables stays local)"
link "$DOTFILES/fish/config.fish"   "$HOME/.config/fish/config.fish"
link "$DOTFILES/fish/conf.d"        "$HOME/.config/fish/conf.d"
link "$DOTFILES/fish/functions"     "$HOME/.config/fish/functions"
link "$DOTFILES/fish/completions"   "$HOME/.config/fish/completions"

echo; echo "▸ Claude Code (settings, statusline, skills, commands, agents, hooks)"
link "$DOTFILES/claude/settings.json"         "$HOME/.claude/settings.json"
link "$DOTFILES/claude/statusline-command.sh" "$HOME/.claude/statusline-command.sh"
link "$DOTFILES/claude/skills"                "$HOME/.claude/skills"
link "$DOTFILES/claude/commands"              "$HOME/.claude/commands"
link "$DOTFILES/claude/agents"                "$HOME/.claude/agents"
link "$DOTFILES/claude/hooks"                 "$HOME/.claude/hooks"

echo
echo "Done.$([ "$DRY_RUN" = "1" ] && echo ' (dry run)')"
echo "Next: cp fish/secrets.fish.example ~/.config/fish/secrets.fish and fill it in."
echo "Then restart yabai/skhd/sketchybar/borders (see README)."
