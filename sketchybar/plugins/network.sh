#!/usr/bin/env bash
# Live up/down throughput for the Wi-Fi interface.
# Rate = byte delta since last run / elapsed seconds (state cached in /tmp).
source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icons.sh"

IFACE="$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2; exit}')"
[ -z "$IFACE" ] && IFACE="en0"
CACHE="/tmp/sketchybar_net_${IFACE}"

read -r RX TX < <(netstat -ib | awk -v i="$IFACE" '$1==i {print $7, $10; exit}')
NOW="$(date +%s)"

DRX=0
DTX=0
if [ -f "$CACHE" ]; then
  read -r PT PRX PTX < "$CACHE"
  DT=$((NOW - PT))
  [ "$DT" -lt 1 ] && DT=1
  d=$(((RX - PRX) / DT)); [ "$d" -ge 0 ] && DRX=$d
  u=$(((TX - PTX) / DT)); [ "$u" -ge 0 ] && DTX=$u
fi
echo "$NOW $RX $TX" > "$CACHE"

human() {
  b=$1
  if [ "$b" -ge 1048576 ]; then
    printf "%d.%d MB/s" $((b / 1048576)) $(((b % 1048576) * 10 / 1048576))
  elif [ "$b" -ge 1024 ]; then
    printf "%d KB/s" $((b / 1024))
  else
    printf "%d B/s" "$b"
  fi
}

sketchybar --set "$NAME" \
  icon="$ICON_DOWN" \
  label="$(human "$DRX")  ${ICON_UP} $(human "$DTX")"
