#!/usr/bin/env bash
# RAM usage %, color ramps with pressure (sits next to CPU).

sketchybar --add item memory right \
           --set memory \
                 icon="$ICON_MEMORY" \
                 icon.color=$GREEN \
                 label.color=$TEXT \
                 background.color=$SURFACE0 \
                 update_freq=2 \
                 script="$PLUGIN_DIR/memory.sh"
