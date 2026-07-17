#!/usr/bin/env bash
# Sets the front_app item to the focused app's real icon + name.
# Handles the front_app_switched event and the initial (no-event) invocation.
source "$HOME/.config/sketchybar/plugins/icon_map.sh"

if [ "$SENDER" = "front_app_switched" ]; then
  APP="$INFO"
else
  APP="$(yabai -m query --windows 2>/dev/null | python3 -c "
import sys, json
try:
    w = [x for x in json.load(sys.stdin) if x.get('has-focus')]
except Exception:
    w = []
print(w[0]['app'] if w else '')" 2>/dev/null)"
fi

[ -z "$APP" ] && exit 0
__icon_map "$APP"
sketchybar --set "$NAME" label="$APP" icon="$icon_result"
