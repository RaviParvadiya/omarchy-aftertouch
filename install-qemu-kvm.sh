#!/usr/bin/env bash
set -e

echo "Installing QEMU + KVM..."

sudo pacman -S --needed --noconfirm \
    qemu-full \
    qemu-img \
    libvirt \
    virt-install \
    virt-manager \
    virt-viewer \
    edk2-ovmf \
    dnsmasq \
    swtpm \
    guestfs-tools \
    libosinfo \
    tuned


# --- Check if virtualization is supported ---
echo "Checking CPU virtualization support..."
if grep -E '(vmx|svm)' /proc/cpuinfo > /dev/null; then
    echo "CPU supports virtualization"
else
    echo "⚠ Warning: CPU virtualization not detected. Check BIOS settings."
fi

# --- Check KVM kernel modules ---
echo "Checking KVM kernel modules..."
if lsmod | grep -q kvm; then
    echo "KVM modules are loaded"
else
    echo "KVM modules are NOT loaded. A reboot may be required."
fi

echo "Enabling libvirtd service..."
sudo systemctl enable --now libvirtd

echo "Adding $USER to libvirt group..."
sudo usermod -aG libvirt "$USER"

# --- Enable default network ---
if ! sudo virsh net-info default &>/dev/null; then
    echo "Enabling default network..."
    sudo virsh net-autostart default
    sudo virsh net-start default
else
    echo "Default network already active."
fi
