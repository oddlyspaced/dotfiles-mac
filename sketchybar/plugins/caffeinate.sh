#!/usr/bin/env bash
# Caffeinate tile brain. Two jobs:
#   - repaint on every routine tick (SENDER=routine/forced) so timed sessions
#     count down and revert when the caffeinate process exits.
#   - handle clicks (SENDER=mouse.clicked): left = on/off indefinite,
#     right = cycle timer off -> 30m -> 1h -> 2h -> off.
# We track only the caffeinate PID we launched, so an externally-started
# caffeinate is never touched.
source "$HOME/.config/sketchybar/icons.sh"
source "$HOME/.config/sketchybar/colors.sh"

STATE_FILE="/tmp/sketchybar_caffeinate.state"   # format: PID:END_EPOCH:DUR  (END=0/DUR=0 => indefinite)

PID="" ; END=0 ; DUR=0
if [ -f "$STATE_FILE" ]; then
  IFS=':' read -r PID END DUR < "$STATE_FILE"
fi

now() { date +%s; }
pid_alive() { [ -n "$PID" ] && kill -0 "$PID" 2>/dev/null; }

stop() {
  pid_alive && kill "$PID" 2>/dev/null
  rm -f "$STATE_FILE"
  PID="" ; END=0 ; DUR=0
}

# start <dur_secs>  (0 = indefinite)
start() {
  local dur="$1" end=0
  stop
  if [ "$dur" -gt 0 ]; then
    end=$(( $(now) + dur ))
    nohup caffeinate -d -t "$dur" >/dev/null 2>&1 &
  else
    nohup caffeinate -d >/dev/null 2>&1 &
  fi
  PID="$!" ; END="$end" ; DUR="$dur"
  printf '%s:%s:%s\n' "$PID" "$END" "$DUR" > "$STATE_FILE"
}

# icon-only inactive look: dim + centred (symmetric padding)
inactive_look() {
  sketchybar --set "$NAME" icon="$ICON_COFFEE" icon.color="$SUBTEXT" \
             icon.padding_right=10 label.drawing=off
}
# active look: warm + normal icon->label spacing
active_look() {
  sketchybar --set "$NAME" icon="$ICON_COFFEE" icon.color="$PEACH" \
             icon.padding_right=4 label.drawing=on label="$1"
}

render() {
  if pid_alive; then
    if [ "$END" -eq 0 ]; then
      active_look "∞"
    else
      local remaining=$(( END - $(now) ))
      if [ "$remaining" -le 0 ]; then           # timer just expired; process about to exit
        stop
        inactive_look
        return
      fi
      local mins=$(( (remaining + 59) / 60 ))
      active_look "${mins}m"
    fi
  else
    rm -f "$STATE_FILE"                          # clean up stale/expired state
    inactive_look
  fi
}

if [ "$SENDER" = "mouse.clicked" ]; then
  case "$BUTTON" in
    left)
      if pid_alive; then stop; else start 0; fi
      ;;
    right)
      # cycle: off -> 30m -> 1h -> 2h -> off  (indefinite counts as "off" slot -> 30m)
      if ! pid_alive; then
        start 1800
      else
        case "$DUR" in
          1800) start 3600 ;;
          3600) start 7200 ;;
          7200) stop ;;
          *)    start 1800 ;;   # indefinite (DUR=0) or anything else -> 30m
        esac
      fi
      ;;
  esac
fi

render
