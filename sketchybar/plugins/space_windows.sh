#!/usr/bin/env bash
# Repaints each space chip's label with the app icons of the windows on it.
# Triggered by the space_windows_change event (yabai signals) and front_app_switched.
# Written for bash 3.2 (macOS system bash) — no associative arrays.
source "$HOME/.config/sketchybar/plugins/icon_map.sh"

args=()
for sid in 1 2 3 4 5 6 7 8 9 10; do
  icons=""
  seen=" "
  while IFS= read -r app; do
    [ -z "$app" ] && continue
    __icon_map "$app"
    case "$seen" in
      *" $icon_result "*) ;;                       # already added this glyph
      *) icons="$icons$icon_result "; seen="$seen$icon_result " ;;
    esac
  done < <(yabai -m query --windows --space "$sid" 2>/dev/null | python3 -c "
import sys, json
try:
    wins = json.load(sys.stdin)
except Exception:
    wins = []
for w in wins:
    if w.get('is-minimized'):
        continue
    print(w.get('app',''))
")

  if [ -n "$icons" ]; then
    args+=(--set space."$sid" label="${icons% }" label.drawing=on)
  else
    args+=(--set space."$sid" label.drawing=off)
  fi
done

[ ${#args[@]} -gt 0 ] && sketchybar "${args[@]}"
