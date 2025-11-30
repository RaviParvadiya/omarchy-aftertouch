#!/usr/bin/env bash
set -e

# Auto install script for Brave browser on Arch Linux

echo "Installing Brave browser using yay..."

# Check if yay is installed
if ! command -v yay &> /dev/null; then
    echo "yay is not installed. Please install yay first."
    exit 1
fi

# Install Brave browser
yay -S --needed --noconfirm brave-bin

# Check if installation was successful
if ! command -v brave &> /dev/null; then
    echo "Brave installation failed."
    exit 1
fi

echo "Brave browser installed successfully!"

# Set Brave as default browser using xdg-settings
echo "Setting Brave as default browser..."
xdg-settings set default-web-browser brave-browser.desktop

echo "Done! Brave is now installed and set as your default browser."
