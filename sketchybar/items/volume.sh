#!/usr/bin/env bash
# System volume: icon by level + %.

sketchybar --add item volume right \
           --set volume \
                 icon= \
                 icon.color=$SKY \
                 label.color=$TEXT \
                 background.color=$SURFACE0 \
                 script="$PLUGIN_DIR/volume.sh" \
           --subscribe volume volume_change
