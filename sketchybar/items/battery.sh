#!/usr/bin/env bash
# Battery: icon + %, color ramps with charge / charging state.

sketchybar --add item battery right \
           --set battery \
                 icon.color=$GREEN \
                 label.color=$TEXT \
                 background.color=$SURFACE0 \
                 update_freq=120 \
                 script="$PLUGIN_DIR/battery.sh" \
           --subscribe battery system_woke power_source_change
