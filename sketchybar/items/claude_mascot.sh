#!/usr/bin/env bash
# Claude spark — a twinkling mascot that animates whenever any Claude Code
# session is actively working. The glyph is swapped in place by the animator
# daemon (plugins/claude_mascot.sh), which reads per-session state written by
# the claude-island-state hook to /tmp/claude-mascot/<session_id>.
#
# Idle = one dim spark. Active = twinkle loop (✧ ✦ ❈ ✦) in bright Claude orange.

sketchybar --add item claude_mascot left \
           --set claude_mascot \
                 icon="✧" \
                 icon.font="$FONT:Bold:16.0" \
                 icon.color=$CLAUDE_DIM \
                 icon.padding_left=8 \
                 icon.padding_right=8 \
                 label.drawing=off \
                 background.drawing=off
