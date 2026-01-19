#!/usr/bin/env bash

# ANSI color codes
CYAN='\033[36m'
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
MAGENTA='\033[35m'
RESET='\033[0m'

# Read JSON from stdin
json=$(cat)

# Extract values using jq
session_id=$(echo "$json" | jq -r '.session_id // "Unknown"')
cwd=$(echo "$json" | jq -r '.cwd // "Unknown"' | sed 's|.*/||')
model=$(echo "$json" | jq -r '.model.display_name // "Unknown"')
used_pct=$(echo "$json" | jq -r '.context_window.used_percentage // 0')
context_size=$(echo "$json" | jq -r '.context_window.context_window_size // 0')

# Calculate remaining tokens
remaining=$(echo "scale=0; $context_size * (100 - $used_pct) / 100" | bc)

# Format tokens with K suffix
format_tokens() {
    local tokens=$1
    if [ "$tokens" -ge 1000 ]; then
        printf "%.1fK" "$(echo "scale=1; $tokens / 1000" | bc)"
    else
        echo "$tokens"
    fi
}

remaining_display=$(format_tokens "$remaining")

# Color based on usage
pct_int=${used_pct%.*}
if [ "$pct_int" -lt 50 ]; then
    pct_color=$GREEN
elif [ "$pct_int" -lt 80 ]; then
    pct_color=$YELLOW
else
    pct_color=$RED
fi

pct_display=$(printf "%.0f" "$used_pct")

printf "${MAGENTA}%s${RESET} | ${CYAN}%s${RESET} | %s | Context ${pct_color}%s%%${RESET} | Tokens ~%s\n" \
    "$session_id" "$cwd" "$model" "$pct_display" "$remaining_display"
