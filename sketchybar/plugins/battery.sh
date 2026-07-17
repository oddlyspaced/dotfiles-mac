#!/usr/bin/env bash
# Battery icon/label with color ramp; charging state overrides the icon.
source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icons.sh"

PERCENTAGE="$(pmset -g batt | grep -Eo '\d+%' | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

[ -z "$PERCENTAGE" ] && exit 0

case "${PERCENTAGE}" in
  9[0-9]|100) ICON="$ICON_BAT_FULL"; COLOR=$GREEN ;;
  [6-8][0-9])  ICON="$ICON_BAT_75";  COLOR=$GREEN ;;
  [3-5][0-9])  ICON="$ICON_BAT_50";  COLOR=$YELLOW ;;
  [1-2][0-9])  ICON="$ICON_BAT_25";  COLOR=$PEACH ;;
  *)           ICON="$ICON_BAT_LOW"; COLOR=$RED ;;
esac

if [ -n "$CHARGING" ]; then
  ICON="$ICON_BAT_CHARGE"
  COLOR=$GREEN
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="${PERCENTAGE}%"
