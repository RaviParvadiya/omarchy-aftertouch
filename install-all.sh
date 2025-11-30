#!/usr/bin/env bash
set -e

# Cache sudo password for the entire script
sudo -v

# Keep sudo alive while script runs
while true; do sudo -v; sleep 60; done 2>/dev/null &
SUDO_KEEPALIVE_PID=$!

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
./install-qemu-kvm.sh
./install-brave.sh

./set-shell.sh

# Print instructions LAST
if [ -f "./grub-theme-notes.sh" ]; then
  ./grub-theme-notes.sh
fi

if [ -f "./qemu-kvm-notes.sh" ]; then
  ./qemu-kvm-notes.sh
fi

# Stop sudo keep-alive
trap 'kill "$SUDO_KEEPALIVE_PID"' EXIT