#!/usr/bin/env bash
# PostToolUse(Write|Edit): view mistakes that are cheap to catch and annoying to debug.
#
#   1. An .erb template under app/views. Views here are HAML.
#   2. HAML dot-class shorthand containing '[', which HAML parses as a Ruby array
#      and fails on at render time. This site leans on Tailwind arbitrary values
#      (leading-[1.78], aspect-[4/3]), so the trap is close at hand.
#   3. A raw hex colour in a view, where an hw-* token from the Tailwind theme
#      belongs.
#
# Advisory: warns, never blocks.

set -uo pipefail

command -v jq >/dev/null 2>&1 || exit 0
path=$(jq -r '.tool_input.file_path // empty')
[ -n "$path" ] || exit 0

repo=$(cd "$(dirname "$0")/../.." && pwd)
case "$path" in
  /*) abs="$path" ;;
  *)  abs="$repo/$path" ;;
esac
rel=${abs#"$repo"/}

notes=""

case "$rel" in
  app/views/*.erb)
    notes+="  Views in this app are HAML. Prefer ${rel%.erb}.haml.
"
    ;;
esac

if [ -f "$abs" ]; then
  case "$rel" in
    app/views/*.haml)
      # grep -m, not | head: under pipefail, head closing the pipe early can
      # SIGPIPE grep and turn a match into a silent pass.
      if bad=$(grep -m 3 -nE '^[[:space:]]*[%.#][A-Za-z0-9_-]*[^ ]*\.[a-zA-Z0-9_:/-]*\[' "$abs"); then
        notes+="  HAML parses '[' in dot-class shorthand as a Ruby array and raises at render time.
  Use the attribute hash instead:  %p{ class: \"leading-[1.78]\" }
"
        while IFS= read -r line; do
          notes+="    line ${line%%:*}
"
        done <<< "$bad"
      fi

      # The placeholder gradients on the home page are the known exception:
      # they stand in for photographs and go when the photographs arrive.
      if hex=$(grep -nE '#[0-9A-Fa-f]{6}\b' "$abs" | grep -v 'linear-gradient' | grep -m 3 .); then
        notes+="  Raw hex colour in a view. Use an hw-* token from app/assets/tailwind/application.css,
  or add one there if the palette genuinely lacks it.
"
        while IFS= read -r line; do
          notes+="    line ${line%%:*}
"
        done <<< "$hex"
      fi
      ;;
  esac
fi

[ -n "$notes" ] || exit 0

printf 'View conventions — %s\n%s  See .claude/rules/frontend.md.\n' "$rel" "$notes" >&2
exit 2
