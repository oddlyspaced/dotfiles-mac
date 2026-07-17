#!/usr/bin/env bash
# Highlights the selected space chip. $SELECTED is provided by the space component.
source "$HOME/.config/sketchybar/colors.sh"

if [ "$SELECTED" = "true" ]; then
  sketchybar --set "$NAME" \
    background.color=$MAUVE \
    icon.color=$BASE \
    label.color=$BASE
else
  sketchybar --set "$NAME" \
    background.color=$SURFACE0 \
    icon.color=$SUBTEXT \
    label.color=$SUBTEXT
fi
