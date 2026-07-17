#!/usr/bin/env bash
# Date + time (right-most item).

sketchybar --add item calendar right \
           --set calendar \
                 icon="$ICON_CALENDAR" \
                 icon.color=$PEACH \
                 label.color=$TEXT \
                 background.color=$SURFACE0 \
                 update_freq=15 \
                 script="$PLUGIN_DIR/calendar.sh" \
           --subscribe calendar system_woke
