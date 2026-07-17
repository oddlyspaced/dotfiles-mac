#!/usr/bin/env bash
# Live network throughput (down / up), sits next to Wi-Fi.

sketchybar --add item network right \
           --set network \
                 icon="$ICON_DOWN" \
                 icon.color=$SAPPHIRE \
                 label.color=$TEXT \
                 label.font="$FONT:Bold:12.0" \
                 background.color=$SURFACE0 \
                 update_freq=2 \
                 script="$PLUGIN_DIR/network.sh"
