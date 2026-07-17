#!/usr/bin/env bash
# Total CPU usage %, normalized by thread count, with a color ramp.
source "$HOME/.config/sketchybar/colors.sh"

CORES="$(sysctl -n machdep.cpu.thread_count)"
SUM="$(ps -A -o %cpu | awk '{s+=$1} END {print s}')"
PERCENT="$(awk -v s="$SUM" -v c="$CORES" 'BEGIN {printf "%.0f", s/c}')"

COLOR=$GREEN
[ "$PERCENT" -gt 30 ] && COLOR=$YELLOW
[ "$PERCENT" -gt 60 ] && COLOR=$RED

sketchybar --set "$NAME" label="${PERCENT}%" icon.color="$COLOR"
