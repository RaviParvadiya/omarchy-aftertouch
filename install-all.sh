#!/usr/bin/env bash
set -e

# --- Update package database on fresh Arch install ---
sudo pacman -Syy

# Cache sudo password for the entire script
sudo -v

# Keep sudo alive while script runs
( 
  while true; do
    sudo -v
    sleep 60
  done
) &
SUDO_KEEPALIVE_PID=$!

# Stop sudo keep-alive on exit (success or failure)
trap 'kill "$SUDO_KEEPALIVE_PID" 2>/dev/null || true' EXIT

# Install all packages in order
./install-terminals.sh
./install-zsh.sh
./install-mise.sh
./install-go.sh
# ./install-postgresql.sh
./install-tmux.sh
./install-stow.sh
./install-dotfiles.sh
./install-asus-extras.sh
./install-hyprland-overrides.sh
./install-grub-theme.sh
./install-doom-emacs.sh
# ./install-qemu-kvm.sh
./install-brave.sh

./set-shell.sh

# Print instructions LAST
./install-notes.sh
