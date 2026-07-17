#!/usr/bin/env bash
# Now-playing. $INFO is JSON from the media_change event.
STATE="$(echo "$INFO" | jq -r '.state' 2>/dev/null)"

if [ "$STATE" = "playing" ]; then
  TITLE="$(echo "$INFO" | jq -r '.title // empty' 2>/dev/null)"
  ARTIST="$(echo "$INFO" | jq -r '.artist // empty' 2>/dev/null)"
  if [ -n "$ARTIST" ]; then
    LABEL="$TITLE - $ARTIST"
  else
    LABEL="$TITLE"
  fi
  sketchybar --set "$NAME" label="$LABEL" drawing=on
else
  sketchybar --set "$NAME" drawing=off
fi
