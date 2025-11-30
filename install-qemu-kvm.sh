#!/usr/bin/env bash
set -e

echo "Installing QEMU + KVM..."

# Install QEMU, KVM, and related packages
sudo pacman -S qemu-full qemu-img libvirt virt-install virt-manager virt-viewer edk2-ovmf dnsmasq swtpm guestfs-tools libosinfo tuned


# Check if virtualization is supported
echo "Checking CPU virtualization support..."
if grep -E '(vmx|svm)' /proc/cpuinfo > /dev/null; then
    echo "✓ CPU supports virtualization"
else
    echo "⚠ Warning: CPU virtualization not detected. Check BIOS settings."
fi

echo "Checking KVM kernel modules..."
if lsmod | grep -q kvm; then
    echo "✓ KVM modules are loaded"
else
    echo "⚠ KVM modules are NOT loaded. A reboot may be required."
fi

# Enable libvirtd service
echo "Enabling libvirtd service..."
sudo systemctl enable --now libvirtd

# Add current user to libvirt group
echo "Adding $USER to libvirt group..."
sudo usermod -aG libvirt "$USER"

# Enable default network
echo "Setting up default network..."
sudo virsh net-autostart default 2>/dev/null || true
sudo virsh net-start default 2>/dev/null || true

# Generate notes file
NOTES_FILE="./qemu-kvm-notes.sh"

cat <<EOF > "$NOTES_FILE"
#!/usr/bin/env bash

echo ""
echo "-------------------------------------------"
echo "         QEMU + KVM NOTE"
echo "-------------------------------------------"
echo ""
echo "⚠ IMPORTANT: Log out and log back in for group changes to take effect!"
echo ""
echo "Useful commands:"
echo "  virt-manager                # Launch GUI"
echo "  systemctl status libvirtd   # Check service"
echo "  virsh list --all            # List VMs"
echo ""
echo "-------------------------------------------"
EOF

chmod +x "$NOTES_FILE"

echo "Notes saved to $NOTES_FILE"
