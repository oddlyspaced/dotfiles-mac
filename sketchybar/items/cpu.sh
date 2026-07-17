#!/usr/bin/env bash
# CPU usage: %, color ramps with load (left-most of the right group).

sketchybar --add item cpu right \
           --set cpu \
                 icon="$ICON_CPU" \
                 icon.color=$MAROON \
                 label.color=$TEXT \
                 background.color=$SURFACE0 \
                 update_freq=2 \
                 script="$PLUGIN_DIR/cpu.sh"
