#!/usr/bin/env bash
# Date + 12-hour time (AM/PM) for the calendar item.
sketchybar --set "$NAME" label="$(date '+%a %d %b  %I:%M %p')"
