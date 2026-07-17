#!/usr/bin/env bash
# Wi-Fi: SSID + icon (red when disconnected).

sketchybar --add item wifi right \
           --set wifi \
                 icon="$ICON_WIFI" \
                 icon.color=$BLUE \
                 label.color=$TEXT \
                 background.color=$SURFACE0 \
                 update_freq=10 \
                 script="$PLUGIN_DIR/wifi.sh" \
           --subscribe wifi wifi_change
