#!/usr/bin/env bash
# Wi-Fi SSID + icon. macOS 14+/26 broke `networksetup -getairportnetwork`,
# so use connectivity (getifaddr) + `ipconfig getsummary` for the SSID.
source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icons.sh"

IFACE="$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2; exit}')"
[ -z "$IFACE" ] && IFACE="en0"

if ! ipconfig getifaddr "$IFACE" >/dev/null 2>&1; then
  sketchybar --set "$NAME" icon="$ICON_WIFI_OFF" icon.color=$RED label="off"
  exit 0
fi

SSID="$(ipconfig getsummary "$IFACE" 2>/dev/null | awk -F' SSID : ' '/ SSID : / {print $2; exit}')"
# macOS 14+ hides the SSID (returns "<redacted>") unless the process has
# Location Services permission. Fall back to a generic label in that case.
case "$SSID" in
  ""|"<redacted>") SSID="Wi-Fi" ;;
esac

sketchybar --set "$NAME" icon="$ICON_WIFI" icon.color=$BLUE label="$SSID"
