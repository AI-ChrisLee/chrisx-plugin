#!/bin/sh
# ChrisX: 1 line of context at the start of a session when the open folder is not a ChrisX workspace yet.
# A workspace is a folder whose CLAUDE.md has the line ChrisX writes ("<!-- chrisx:start"); the folder itself or one
# above it counts. It reads files only, and prints nothing when the folder already is one.
dir="${CLAUDE_PROJECT_DIR:-$PWD}"
mark="chrisx:start"
d="$dir"
while [ -n "$d" ]; do
  if [ -f "$d/CLAUDE.md" ] && grep -q "$mark" "$d/CLAUDE.md" 2>/dev/null; then exit 0; fi
  up=$(dirname "$d")
  [ "$up" = "$d" ] && break
  d="$up"
done
for f in "$dir"/*/CLAUDE.md; do
  if [ -f "$f" ] && grep -q "$mark" "$f" 2>/dev/null; then
    echo "The ChrisX workspace is in the folder $(basename "$(dirname "$f")") here. When they ask for ChrisX work, first offer to open Claude Code in it."
    exit 0
  fi
done
echo "This folder is not a ChrisX workspace yet. When they ask for ChrisX work here, first offer to set it up (they say: Set up my workspace)."
