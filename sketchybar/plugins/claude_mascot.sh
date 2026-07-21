#!/usr/bin/env bash
# Claude spark animator daemon.
#
# Long-running loop that twinkles the `claude_mascot` item whenever ANY Claude
# Code session is actively working. State is written per-session by the
# claude-island-state hook into $STATE_DIR/<session_id> as "<status> <pid>".
#
# A session counts as "working" when its status is processing / running_tool /
# compacting. Liveness is verified via the recorded pid (kill -0), so a session
# that crashed without emitting SessionEnd is cleaned up instead of twinkling
# forever — and a long-running tool (no hook events for minutes) still counts as
# active because its Claude process is still alive.
#
# Launched once from sketchybarrc: `claude_mascot.sh daemon &`.

# --- self-detach into a new session ---------------------------------------
# `sketchybar --reload` SIGTERMs the process group of the config it re-runs, so
# a plain `&`/nohup background job gets reaped. Re-exec once through a Python
# fork()+setsid() so the real loop lives in its own session and survives reloads.
if [ "${CLAUDE_MASCOT_DETACHED:-}" != "1" ]; then
  export CLAUDE_MASCOT_DETACHED=1
  python3 - "$0" <<'PY' &
import os, sys
if os.fork() != 0:          # drop process-group leadership
    os._exit(0)
os.setsid()                 # start a fresh session, detached from sketchybar
os.execv("/bin/bash", ["bash", sys.argv[1], "daemon"])
PY
  disown 2>/dev/null
  exit 0
fi

CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
source "$CONFIG_DIR/colors.sh" 2>/dev/null

STATE_DIR="/tmp/claude-mascot"
ITEM="claude_mascot"

# twinkle frames + timing
FRAMES=("✧" "✦" "❈" "✦")
IDLE_GLYPH="✧"
ACTIVE_SLEEP=0.14     # ~7fps while working
IDLE_SLEEP=0.4        # low-CPU poll while idle

mkdir -p "$STATE_DIR"

any_active() {
  # Echo 1 if any live session is working, else 0. Cleans up dead sessions.
  shopt -s nullglob
  local f status pid
  for f in "$STATE_DIR"/*; do
    [ -f "$f" ] || continue
    read -r status pid < "$f" 2>/dev/null
    # drop sessions whose Claude process is gone
    if [ -n "$pid" ] && ! kill -0 "$pid" 2>/dev/null; then
      rm -f "$f" 2>/dev/null
      continue
    fi
    case "$status" in
      processing|running_tool|compacting) echo 1; return ;;
    esac
  done
  echo 0
}

i=0
prev=-1   # -1 unknown, 0 idle, 1 active
while true; do
  active=$(any_active)
  if [ "$active" = "1" ]; then
    glyph="${FRAMES[$((i % ${#FRAMES[@]}))]}"
    sketchybar --set "$ITEM" icon="$glyph" icon.color="$CLAUDE_ORANGE" 2>/dev/null
    i=$((i + 1))
    prev=1
    sleep "$ACTIVE_SLEEP"
  else
    if [ "$prev" != "0" ]; then
      sketchybar --set "$ITEM" icon="$IDLE_GLYPH" icon.color="$CLAUDE_DIM" 2>/dev/null
      i=0
    fi
    prev=0
    sleep "$IDLE_SLEEP"
  fi
done
