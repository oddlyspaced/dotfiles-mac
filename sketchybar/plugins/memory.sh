#!/usr/bin/env bash
# Memory usage % (100 - system-wide free), with a color ramp.
source "$HOME/.config/sketchybar/colors.sh"

FREE="$(memory_pressure 2>/dev/null | awk -F': ' '/free percentage/ {gsub(/%/,"",$2); print $2}')"
[ -z "$FREE" ] && exit 0
USED=$((100 - FREE))

COLOR=$GREEN
[ "$USED" -gt 60 ] && COLOR=$YELLOW
[ "$USED" -gt 85 ] && COLOR=$RED

sketchybar --set "$NAME" label="${USED}%" icon.color="$COLOR"
