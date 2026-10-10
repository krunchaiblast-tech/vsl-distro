#!/bin/bash
set -e

THEME_DIR="${1:-$PWD/vsl-theme}"
TARGET_DIR="${2:-$HOME/.config/xfce4/xfconf/xfce-perchannel-xml}"

mkdir -p "$TARGET_DIR"

if [ -d "$THEME_DIR" ]; then
  echo "Installing VSL LCD glass theme files..."
  cp "$THEME_DIR/xfce4-panel.css" "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/"
  echo "Theme files copied."
  echo "To apply them, restart XFCE or log out and log back in."
else
  echo "Theme directory not found: $THEME_DIR" >&2
  exit 1
fi
