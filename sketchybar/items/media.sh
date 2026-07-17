#!/usr/bin/env bash
# Now-playing (title - artist). Hidden when nothing is playing. No chip.

sketchybar --add item media left \
           --set media \
                 icon= \
                 icon.color=$GREEN \
                 label.color=$SUBTEXT \
                 label.max_chars=30 \
                 scroll_texts=on \
                 background.drawing=off \
                 drawing=off \
                 script="$PLUGIN_DIR/media.sh" \
           --subscribe media media_change
