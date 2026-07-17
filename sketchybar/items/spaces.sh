#!/usr/bin/env bash
# yabai/mission-control spaces 1..10 as rounded chips.
# Each chip shows its number + real app icons of the windows on that space.

SPACE_ICONS=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10")

for i in "${!SPACE_ICONS[@]}"; do
  sid=$(($i + 1))
  space=(
    space="$sid"
    icon="${SPACE_ICONS[i]}"
    icon.color=$SUBTEXT
    icon.highlight_color=$BASE
    icon.padding_left=9
    icon.padding_right=9
    label.font="$APP_FONT:Regular:14.0"
    label.color=$SUBTEXT
    label.padding_right=12
    label.y_offset=-1
    label.drawing=off
    background.color=$SURFACE0
    background.corner_radius=9
    background.height=26
    background.drawing=on
    script="$PLUGIN_DIR/space.sh"
    click_script="yabai -m space --focus $sid 2>/dev/null"
  )
  sketchybar --add space space."$sid" left --set space."$sid" "${space[@]}"
done

# Invisible observer: repaints per-space app icons when the window layout changes.
sketchybar --add item space_observer left \
           --set space_observer \
                 drawing=off \
                 updates=on \
                 script="$PLUGIN_DIR/space_windows.sh" \
           --subscribe space_observer space_windows_change front_app_switched
