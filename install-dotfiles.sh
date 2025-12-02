#!/usr/bin/env bash
set -e

ORIGINAL_DIR=$(pwd)
REPO_URL="https://github.com/raviparvadiya/dotfiles.git"
REPO_NAME="dotfiles"

# --- Check if stow is installed ---
if ! pacman -Qi "stow" &>/dev/null; then
  echo "Install stow first"
  exit 1
fi

cd ~

# --- Clone repository if it doesn't exist ---
if [ -d "$REPO_NAME" ]; then
  echo "Repository '$REPO_NAME' already exists. Skipping clone"
else
    if ! git clone "$REPO_URL"; then
        echo "Failed to clone the repository."
        exit 1
    fi
fi

# --- Remove old configs ---
echo "Removing old configs"
rm -rf ~/.config/nvim ~/.local/share/nvim/ ~/.local/state/nvim ~/.cache/nvim/ ~/.config/hypr/hyprlock.conf

# --- Stow dotfiles ---
cd "$REPO_NAME"

for dir in zshrc tmux nvim hyprlock hyprmocha; do
  echo "Stowing $dir..."
  stow "$dir"
done

cd "$ORIGINAL_DIR"
