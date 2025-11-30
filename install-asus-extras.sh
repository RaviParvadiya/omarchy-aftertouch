#!/usr/bin/env bash
set -e

# Check if this is an ASUS laptop
if ! cat /sys/devices/virtual/dmi/id/sys_vendor 2>/dev/null | grep -qi "asus"; then
    exit 0
fi

# Install tools
yay -Sy --needed --noconfirm asusctl supergfxctl

# Check if MUX switch is supported
if ! supergfxctl -g >/dev/null 2>&1; then
    exit 0
fi

# Enable services (only if supported)
echo "Enabling ASUS services..."
sudo systemctl enable --now supergfxd.service
sudo systemctl enable --now asusd.service

# echo "Optional: setting default GPU mode to hybrid..."
# sudo mkdir -p /etc/supergfxctl
# echo "mode=hybrid" | sudo tee /etc/supergfxctl/graphics.conf >/dev/null

echo "Reboot for GPU mode switching to fully work."
