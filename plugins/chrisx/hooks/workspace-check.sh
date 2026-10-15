#!/bin/sh
# ChrisX: 1 line of context at the start of a session when the open folder is not a ChrisX workspace yet.
# A workspace is a folder whose AGENTS.md or CLAUDE.md has the line ChrisX writes ("<!-- chrisx:start"); the folder
# itself or one above it counts. It reads files only, and prints nothing when the folder already is one.
dir="${CLAUDE_PROJECT_DIR:-$PWD}"
mark="chrisx:start"
has() { for n in AGENTS.md CLAUDE.md; do [ -f "$1/$n" ] && grep -q "$mark" "$1/$n" 2>/dev/null && return 0; done; return 1; }
d="$dir"
while [ -n "$d" ]; do
  has "$d" && exit 0
  up=$(dirname "$d")
  [ "$up" = "$d" ] && break
  d="$up"
done
for f in "$dir"/*/; do
  if has "${f%/}"; then
    echo "The ChrisX workspace is in the folder $(basename "$f") here. When they ask for ChrisX work, first offer to open this AI in it."
    exit 0
  fi
done
echo "This folder is not a ChrisX workspace yet. When they ask for ChrisX work here, first offer to set it up (they say: Set up my workspace)."
