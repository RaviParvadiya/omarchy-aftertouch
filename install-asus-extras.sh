#!/usr/bin/env bash
set -e

# --- Detect ASUS Laptop ---
if ! cat /sys/devices/virtual/dmi/id/sys_vendor 2>/dev/null | grep -qi "asus"; then
    exit 0
fi

# --- Add ASUS Linux repository ---
if ! grep -q "\[g14\]" /etc/pacman.conf; then
    echo "Adding ASUS Linux g14 repository..."
    echo -e "\n[g14]\nServer = https://arch.asus-linux.org" | sudo tee -a /etc/pacman.conf

    # --- Import GPG key ---
    echo "Importing ASUS Linux GPG key..."
    sudo pacman-key --recv-keys 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
    sudo pacman-key --finger 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
    sudo pacman-key --lsign-key 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
fi


# --- Update package database ---
sudo pacman -Sy

# --- Install ASUS tools ---
echo "Installing asusctl..."
if ! pacman -Q asusctl &>/dev/null; then
    sudo pacman -S --noconfirm asusctl
fi

# --- Install firmware daemon ---
echo "Installing fwupd for firmware updates..."
sudo pacman -S --needed --noconfirm fwupd
sudo systemctl enable --now fwupd.service

# --- Remove open-source NVIDIA driver if installed ---
if pacman -Q nvidia-open-dkms &>/dev/null; then
    echo "Removing nvidia-open-dkms..."
    sudo pacman -Rns --noconfirm nvidia-open-dkms
fi

# --- Install proprietary NVIDIA drivers ---
echo "Installing NVIDIA proprietary drivers and utilities..."
sudo pacman -S --needed --noconfirm \
    nvidia-dkms \
    nvidia-utils \
    nvidia-prime \
    lib32-nvidia-utils \
    libva-nvidia-driver \
    vulkan-icd-loader \
    egl-wayland \
    qt5-wayland \
    qt6-wayland

# --- Configure NVIDIA modprobe for early KMS ---
# echo "options nvidia_drm modeset=1" | sudo tee /etc/modprobe.d/nvidia.conf >/dev/null

# --- Configure mkinitcpio for early loading ---
# MKINITCPIO_CONF="/etc/mkinitcpio.conf"
# NVIDIA_MODULES="nvidia nvidia_modeset nvidia_uvm nvidia_drm"

# sudo cp "$MKINITCPIO_CONF" "${MKINITCPIO_CONF}.backup"
# sudo sed -i -E 's/ nvidia_drm//g; s/ nvidia_uvm//g; s/ nvidia_modeset//g; s/ nvidia//g;' "$MKINITCPIO_CONF"
# sudo sed -i -E "s/^(MODULES=\\()/\\1${NVIDIA_MODULES} /" "$MKINITCPIO_CONF"
# sudo sed -i -E 's/  +/ /g' "$MKINITCPIO_CONF"

# sudo mkinitcpio -P

# --- Install NVIDIA laptop power management for hybrid graphics ---
# if ! command -v nvidia-powerd &>/dev/null; then
#     echo "Installing NVIDIA laptop power management..."
#     TMP_DIR="/tmp/nvidia-laptop-power-cfg"

#     if [ -d "$TMP_DIR" ]; then
#         rm -rf "$TMP_DIR"
#     fi

#     git clone https://gitlab.com/asus-linux/nvidia-laptop-power-cfg.git "$TMP_DIR"
    
#     pushd /tmp/nvidia-laptop-power-cfg >/dev/null
   
#     if ! makepkg -sfi --noconfirm; then
#         echo "Error: Failed to install nvidia-laptop-power-cfg"
#         popd >/dev/null
#         exit 1
#     fi

#     popd >/dev/null
# fi

# --- Enable NVIDIA power management services ---
# echo "Enabling NVIDIA power management services..."
# sudo systemctl enable nvidia-powerd
# sudo systemctl enable nvidia-suspend.service nvidia-hibernate.service nvidia-resume.service
# sudo systemctl enable --now nvidia-powerd

echo "ASUS setup complete."
