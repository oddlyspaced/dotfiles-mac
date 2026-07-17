#!/usr/bin/env bash
# Currently focused application: real app icon + name.

sketchybar --add item front_app left \
           --set front_app \
                 icon.font="$APP_FONT:Regular:16.0" \
                 icon.color=$LAVENDER \
                 label.color=$TEXT \
                 background.color=$SURFACE0 \
                 script="$PLUGIN_DIR/front_app.sh" \
           --subscribe front_app front_app_switched
