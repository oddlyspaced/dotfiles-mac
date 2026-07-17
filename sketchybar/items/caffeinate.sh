#!/usr/bin/env bash
# Caffeinate toggle: left-click on/off (indefinite), right-click cycles a timer.
# Keeps the display awake via `caffeinate -d`. Repaints itself every 30s so a
# timed session counts down and reverts to inactive when it expires.
# The coffee glyph is used for both states; colour signals on/off.

sketchybar --add item caffeinate left \
           --set caffeinate \
                 icon="$ICON_COFFEE" \
                 icon.color=$SUBTEXT \
                 icon.padding_right=10 \
                 label.color=$PEACH \
                 label.drawing=off \
                 background.color=$SURFACE0 \
                 update_freq=30 \
                 script="$PLUGIN_DIR/caffeinate.sh" \
           --subscribe caffeinate mouse.clicked
