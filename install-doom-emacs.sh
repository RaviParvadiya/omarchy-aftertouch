#!/usr/bin/env bash
set -e

echo "Installing Emacs + Doom dependencies..."
yay -Sy --needed --noconfirm emacs git ripgrep fd

echo "Cloning Doom Emacs..."
DOOM_DIR="$HOME/.config/emacs"

if [ ! -d "$DOOM_DIR" ]; then
    git clone --depth 1 https://github.com/doomemacs/doomemacs "$DOOM_DIR"
else
    echo "Doom Emacs already exists, pulling latest..."
    git -C "$DOOM_DIR" pull
fi

echo "Running Doom install..."
"$DOOM_DIR/bin/doom" install

echo "Doom Emacs installation complete."