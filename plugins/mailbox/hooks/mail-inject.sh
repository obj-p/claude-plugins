#!/usr/bin/env bash
set -euo pipefail

input="$(cat)"
sid="$(printf '%s' "$input" | tr -d '\n' | sed -n 's/.*"session_id"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')"
[ -z "$sid" ] && exit 0

root="$HOME/.claude/mailbox"
[ -f "$root/.watch/$sid" ] || exit 0
[ -f "$root/.who/$sid" ] || exit 0
me="$(cat "$root/.who/$sid")"
[ -z "$me" ] && exit 0

box="$root/$me/inbox"
[ -d "$box" ] || exit 0
[ -z "$(ls -A "$box" 2>/dev/null)" ] && exit 0

arch="$root/$me/read"
mkdir -p "$arch"
out=""
for f in "$box"/*.txt; do
  [ -e "$f" ] || continue
  base="$(basename "$f")"
  nm="${base%.txt}"
  ts="${nm%%-*}"
  rest="${nm#*-}"
  from="${rest%-*}"
  out="${out}from ${from} at ${ts}: $(cat "$f")"$'\n'
  mv "$f" "$arch/$base"
done

[ -z "$out" ] && exit 0
printf 'Unread mailbox messages for %s:\n%s' "$me" "$out"
