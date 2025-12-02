#!/usr/bin/env bash
set -e

NOTES_DIR="./notes"

if [ -d "$NOTES_DIR" ]; then
  for note in "$NOTES_DIR"/*.sh; do
    [ -f "$note" ] || continue
    chmod +x "$note"
    "$note"
  done
fi

echo ""
echo "-------------------------------------------"
echo "To view notes again later, run this script:"
echo "  ./install-notes.sh"
echo "-------------------------------------------"
