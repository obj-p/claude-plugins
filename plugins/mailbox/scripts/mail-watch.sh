#!/usr/bin/env bash
set -euo pipefail

root="$HOME/.claude/mailbox"
sid="${CLAUDE_CODE_SESSION_ID:-}"

me="${1:-}"
if [ -z "$me" ] && [ -n "$sid" ] && [ -f "$root/.who/$sid" ]; then
  me="$(cat "$root/.who/$sid")"
fi
[ -z "$me" ] && { echo "error: no identity; run /mail iam <name> first"; exit 1; }

box="$root/$me/inbox"
arch="$root/$me/read"
mkdir -p "$box" "$arch"

echo "watching mailbox for '$me'"
end=$((SECONDS + 1800))
while [ "$SECONDS" -lt "$end" ]; do
  for f in "$box"/*.txt; do
    [ -e "$f" ] || continue
    base="$(basename "$f")"
    nm="${base%.txt}"
    ts="${nm%%-*}"
    rest="${nm#*-}"
    from="${rest%-*}"
    echo "mail from ${from} at ${ts}: $(cat "$f")"
    mv "$f" "$arch/$base"
  done
  sleep 2
done
