#!/usr/bin/env bash
set -e

echo "Installing Emacs + Doom dependencies..."
yay -Sy --needed --noconfirm emacs git ripgrep fd

echo "Cloning Doom Emacs..."
if [ ! -d "$HOME/.config/emacs" ]; then
    git clone --depth 1 https://github.com/doomemacs/doomemacs "$HOME/.config/emacs"
else
    echo "Doom Emacs already exists, pulling latest..."
    git -C "$HOME/.config/emacs" pull
fi

echo "Running Doom install..."
"$HOME/.config/emacs/bin/doom" install

echo "Doom Emacs installation complete."