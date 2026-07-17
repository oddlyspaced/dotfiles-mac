#!/bin/bash

input=$(cat)

# ── ANSI helpers ──────────────────────────────────────────────────────────────
bold="\033[1m"
dim="\033[2m"
reset="\033[0m"

fg_cyan="\033[36m"
fg_blue="\033[34m"
fg_green="\033[32m"
fg_yellow="\033[33m"
fg_magenta="\033[35m"
fg_red="\033[31m"
fg_white="\033[97m"

# ── Data extraction ────────────────────────────────────────────────────────────
cwd=$(echo "$input" | jq -r '.cwd // .workspace.current_dir // ""')
folder=$(basename "$cwd")
branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null)
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
seven_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
seven_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')
model_name=$(echo "$input" | jq -r '.model.display_name // empty')
model_id=$(echo "$input" | jq -r '.model.id // empty')
output_style=$(echo "$input" | jq -r '.output_style.name // empty')
effort_level=$(jq -r '.effortLevel // empty' '/Users/hardik/.claude/settings.json' 2>/dev/null)
session_id=$(echo "$input" | jq -r '.session_id // empty')
total_in=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
total_out=$(echo "$input" | jq -r '.context_window.total_output_tokens // empty')

# ── Session-start tracking (temp file keyed on session_id) ────────────────────
session_start_file=""
session_start_ts=""
if [ -n "$session_id" ]; then
  session_start_file="/tmp/claude-session-${session_id}.start"
  if [ ! -f "$session_start_file" ]; then
    date +%s > "$session_start_file" 2>/dev/null
  fi
  session_start_ts=$(cat "$session_start_file" 2>/dev/null)
fi

# ── Helpers ────────────────────────────────────────────────────────────────────

# Gradient bar: green -> yellow -> red based on fill percentage
make_bar() {
  local pct=$1
  local width=8
  local filled=$(echo "$pct $width" | awk '{printf "%d", ($1/100)*$2 + 0.5}')
  local bar=""

  # Choose bar color based on usage level
  local color
  if awk "BEGIN {exit !($pct < 50)}"; then
    color="\033[32m"   # green
  elif awk "BEGIN {exit !($pct < 80)}"; then
    color="\033[33m"   # yellow
  else
    color="\033[31m"   # red
  fi

  bar="${color}"
  for i in $(seq 1 $width); do
    if [ "$i" -le "$filled" ]; then
      bar="${bar}◆"
    else
      bar="${bar}\033[2m◇\033[22m"
    fi
  done
  bar="${bar}${reset}"
  echo "$bar"
}

# format_reset_5h: shows just the time, e.g. "3:45 PM"
format_reset_5h() {
  local resets_at=$1
  local now=$(date +%s)
  local diff=$((resets_at - now))
  if [ "$diff" -le 0 ]; then
    echo "now"
    return
  fi
  date -r "$resets_at" +"%l:%M %p" | sed 's/^ *//'
}

# format_reset_7d: shows day + time, e.g. "Wed 3:45 PM"
format_reset_7d() {
  local resets_at=$1
  local now=$(date +%s)
  local diff=$((resets_at - now))
  if [ "$diff" -le 0 ]; then
    echo "now"
    return
  fi
  date -r "$resets_at" +"%a %l:%M %p" | sed 's/  */ /g; s/^ //'
}

# format_duration: converts elapsed seconds to "1h23m" or "45m" or "30s"
format_duration() {
  local secs=$1
  if [ "$secs" -lt 60 ]; then
    echo "${secs}s"
  elif [ "$secs" -lt 3600 ]; then
    echo "$(( secs / 60 ))m"
  else
    local h=$(( secs / 3600 ))
    local m=$(( (secs % 3600) / 60 ))
    if [ "$m" -eq 0 ]; then
      echo "${h}h"
    else
      echo "${h}h${m}m"
    fi
  fi
}

# format_tokens: converts raw token count to "42.1k" or "1.2M"
format_tokens() {
  local n=$1
  if [ "$n" -lt 1000 ]; then
    echo "${n}"
  elif [ "$n" -lt 1000000 ]; then
    awk "BEGIN {printf \"%.1fk\", $n/1000}"
  else
    awk "BEGIN {printf \"%.1fM\", $n/1000000}"
  fi
}

# estimate_cost: compute USD cost from token counts and model id
# Rates (per million tokens, USD):
#   opus-4 / claude-opus-4*       : $15 input,  $75 output
#   sonnet-4* / claude-sonnet-4*  : $3 input,   $15 output
#   haiku-3-5* / haiku-3*         : $0.80 input, $4 output
#   default fallback              : $3 input,   $15 output
estimate_cost() {
  local in_tok=$1
  local out_tok=$2
  local mid=$3
  awk -v in_tok="$in_tok" -v out_tok="$out_tok" -v mid="$mid" 'BEGIN {
    in_rate  = 3.00
    out_rate = 15.00
    if (mid ~ /opus-4|claude-opus-4/)      { in_rate =  15.00; out_rate =  75.00 }
    else if (mid ~ /opus/)                 { in_rate =  15.00; out_rate =  75.00 }
    else if (mid ~ /sonnet-4|claude-sonnet-4/) { in_rate =   3.00; out_rate =  15.00 }
    else if (mid ~ /haiku-3-5|haiku-3/)    { in_rate =   0.80; out_rate =   4.00 }
    cost = (in_tok * in_rate + out_tok * out_rate) / 1000000
    if (cost < 0.01)      printf "$0.00"
    else if (cost < 10)   printf "$%.2f", cost
    else                  printf "$%.1f", cost
  }'
}

# ── Segment builder ────────────────────────────────────────────────────────────
SEP=$(printf "${dim} ╱ ${reset}")
OUT=$(printf "\033[34;1mHardik\033[0m")

append() {
  if [ -z "$OUT" ]; then
    OUT="$1"
  else
    OUT="${OUT}${SEP}$1"
  fi
}

# 1. Folder + git branch
loc=$(printf "${fg_cyan}${bold}%s${reset}" "$folder")
if [ -n "$branch" ]; then
  loc="${loc}$(printf " ${dim}on${reset} ${fg_magenta}%s${reset}" "$branch")"
fi
append "$loc"

# 2. Context window bar
if [ -n "$used_pct" ]; then
  bar=$(make_bar "$used_pct")
  pct_rounded=$(printf "%.0f" "$used_pct")
  seg=$(printf "${dim}ctx${reset} %s ${fg_white}%s%%${reset}" "$bar" "$pct_rounded")
  append "$seg"
fi

# 3. 5-hour rate limit
if [ -n "$five_pct" ]; then
  bar=$(make_bar "$five_pct")
  pct_rounded=$(printf "%.0f" "$five_pct")
  seg=$(printf "${dim}5h${reset} %s ${fg_white}%s%%${reset}" "$bar" "$pct_rounded")
  if [ -n "$five_reset" ]; then
    seg="${seg}$(printf " ${dim}↺${reset}${bold}${fg_white}%s${reset}" "$(format_reset_5h "$five_reset")")"
  fi
  append "$seg"
fi

# 4. 7-day rate limit
if [ -n "$seven_pct" ]; then
  bar=$(make_bar "$seven_pct")
  pct_rounded=$(printf "%.0f" "$seven_pct")
  seg=$(printf "${dim}7d${reset} %s ${fg_white}%s%%${reset}" "$bar" "$pct_rounded")
  if [ -n "$seven_reset" ]; then
    seg="${seg}$(printf " ${dim}↺${reset}${bold}${fg_white}%s${reset}" "$(format_reset_7d "$seven_reset")")"
  fi
  append "$seg"
fi

# 5. Model + effort + output style
model_str=""
if [ -n "$model_name" ]; then
  model_str=$(printf "${fg_blue}%s${reset}" "$model_name")
fi
if [ -n "$effort_level" ]; then
  badge=$(printf "${dim}[%s]${reset}" "$effort_level")
  model_str="${model_str} ${badge}"
fi
if [ -n "$output_style" ] && [ "$output_style" != "default" ]; then
  badge=$(printf "${dim}(%s)${reset}" "$output_style")
  model_str="${model_str} ${badge}"
fi
if [ -n "$model_str" ]; then
  append "$model_str"
fi

# 6. Session duration
if [ -n "$session_start_ts" ]; then
  now_ts=$(date +%s)
  elapsed=$(( now_ts - session_start_ts ))
  if [ "$elapsed" -ge 0 ]; then
    dur=$(format_duration "$elapsed")
    seg=$(printf "${dim}⏱${reset} ${fg_white}${bold}%s${reset}" "$dur")
    append "$seg"
  fi
fi

# 7. Token count (cumulative session totals)
if [ -n "$total_in" ] && [ -n "$total_out" ]; then
  total_tok=$(( total_in + total_out ))
  if [ "$total_tok" -gt 0 ]; then
    tok_fmt=$(format_tokens "$total_tok")
    seg=$(printf "${dim}tok${reset} ${fg_white}${bold}%s${reset}" "$tok_fmt")
    append "$seg"
  fi
fi

# 8. Cost estimate
if [ -n "$total_in" ] && [ -n "$total_out" ] && [ -n "$model_id" ]; then
  if [ "$total_in" -gt 0 ] || [ "$total_out" -gt 0 ]; then
    cost=$(estimate_cost "$total_in" "$total_out" "$model_id")
    seg=$(printf "${dim}cost${reset} ${fg_yellow}${bold}%s${reset}" "$cost")
    append "$seg"
  fi
fi

printf "%b\n" "$OUT"
