#!/usr/bin/env bash
set -e

THEME_NAME="catppuccin-mocha-grub-theme"
THEME_DIR="/boot/grub/themes/$THEME_NAME"
REPO_DIR="$HOME/catppuccin-grub"

echo "Installing Catppuccin GRUB theme..."

# --- Clone only if not present ---
if [ ! -d "$REPO_DIR" ]; then
  git clone https://github.com/catppuccin/grub.git "$REPO_DIR"
else
  echo "Repo already exists, pulling latest..."
  git -C "$REPO_DIR" pull
fi

# --- Create themes directory if missing ---
sudo mkdir -p /boot/grub/themes

# --- Copy theme ---
echo "Copying theme to $THEME_DIR..."
sudo rm -rf "$THEME_DIR"
sudo cp -r "$REPO_DIR/src/catppuccin-mocha-grub-theme" "$THEME_DIR"

echo "Catppuccin GRUB theme installed successfully!"