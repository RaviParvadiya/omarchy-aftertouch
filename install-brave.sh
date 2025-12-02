#!/usr/bin/env bash
set -e

echo "Installing Brave browser using yay..."
yay -S --needed --noconfirm brave-bin

# --- Verify Installation ---
if ! command -v brave &> /dev/null; then
    echo "Brave installation failed."
    exit 1
fi

# --- Set Default Browser ---
echo "Setting Brave as default browser..."
xdg-settings set default-web-browser brave-browser.desktop

echo "Done! Brave is now installed and set as your default browser."
