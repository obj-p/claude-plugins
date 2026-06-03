#!/usr/bin/env bash
set -euo pipefail

root="${CLAUDE_PROJECT_DIR:-$PWD}/.claude/mailbox"
who_dir="$root/.who"
watch_dir="$root/.watch"
sid="${CLAUDE_CODE_SESSION_ID:-}"

usage() {
  echo "usage: mail.sh {iam <name>|send <to> <message...>|read [name]|watch|unwatch}"
}

resolve_addr() {
  if [ -n "${1:-}" ]; then
    echo "$1"
    return
  fi
  if [ -n "$sid" ] && [ -f "$who_dir/$sid" ]; then
    cat "$who_dir/$sid"
  fi
}

drain() {
  local me="$1" box="$root/$me/inbox" arch="$root/$me/read" f base nm ts rest from
  if [ ! -d "$box" ] || [ -z "$(ls -A "$box" 2>/dev/null)" ]; then
    echo "no new mail for '$me'"
    return
  fi
  mkdir -p "$arch"
  for f in "$box"/*.txt; do
    [ -e "$f" ] || continue
    base="$(basename "$f")"
    nm="${base%.txt}"
    ts="${nm%%-*}"
    rest="${nm#*-}"
    from="${rest%-*}"
    echo "--- from ${from} at ${ts} ---"
    cat "$f"
    echo
    mv "$f" "$arch/$base"
  done
}

cmd="${1:-}"
shift || true

case "$cmd" in
  iam)
    name="${1:-}"
    [ -z "$name" ] && { echo "error: name required"; exit 1; }
    [ -z "$sid" ] && { echo "error: no session id available"; exit 1; }
    mkdir -p "$who_dir"
    printf '%s' "$name" > "$who_dir/$sid"
    echo "registered as '$name' for this session"
    ;;
  send)
    payload="$(cat)"
    to="${payload%%[[:space:]]*}"
    body="${payload#"$to"}"
    body="${body#"${body%%[![:space:]]*}"}"
    from="$(resolve_addr)"
    [ -z "$to" ] && { echo "error: recipient required"; exit 1; }
    [ -z "$from" ] && { echo "error: no identity; run /mail iam <name> first"; exit 1; }
    [ -z "$body" ] && { echo "error: message required"; exit 1; }
    box="$root/$to/inbox"
    mkdir -p "$box"
    ts="$(date -u +%Y%m%dT%H%M%SZ)"
    f="$box/${ts}-${from}-${RANDOM}.txt"
    printf '%s' "$body" > "$f"
    echo "sent to '$to'"
    ;;
  read)
    me="$(resolve_addr "${1:-}")"
    [ -z "$me" ] && { echo "error: no identity; run /mail iam <name> first"; exit 1; }
    drain "$me"
    ;;
  watch)
    [ -z "$sid" ] && { echo "error: no session id available"; exit 1; }
    mkdir -p "$watch_dir"
    : > "$watch_dir/$sid"
    echo "watching: mail will be injected at the start of each turn"
    ;;
  unwatch)
    [ -z "$sid" ] && { echo "error: no session id available"; exit 1; }
    rm -f "$watch_dir/$sid"
    echo "no longer watching"
    ;;
  *)
    usage
    exit 1
    ;;
esac
