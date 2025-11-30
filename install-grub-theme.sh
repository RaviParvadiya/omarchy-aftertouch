#!/usr/bin/env bash
set -e

THEME_NAME="catppuccin-mocha-grub-theme"
THEME_DIR="/boot/grub/themes/$THEME_NAME"
REPO_DIR="$HOME/catppuccin-grub"

echo "Installing Catppuccin GRUB theme..."

# Clone only if not present
if [ ! -d "$REPO_DIR" ]; then
  git clone https://github.com/catppuccin/grub.git "$REPO_DIR"
else
  echo "Repo already exists, pulling latest..."
  git -C "$REPO_DIR" pull
fi

# Create themes directory if missing
sudo mkdir -p /boot/grub/themes

# Copy theme
echo "Copying theme to $THEME_DIR..."
sudo rm -rf "$THEME_DIR"
sudo cp -r "$REPO_DIR/src/catppuccin-mocha-grub-theme" "$THEME_DIR"

echo "Catppuccin GRUB theme installed successfully!"

# Generate notes file instead of printing now
NOTES_FILE="./grub-theme-notes.sh"

cat <<EOF > "$NOTES_FILE"
#!/usr/bin/env bash

echo ""
echo "-------------------------------------------"
echo "           GRUB THEME MANUAL SETUP"
echo "-------------------------------------------"
echo ""
echo "Edit this file: /etc/default/grub"
echo ""
echo "Add or update:"
echo "   GRUB_THEME=\\"$THEME_DIR/theme.txt\\""
echo ""
echo "Comment:"
echo "   # GRUB_TERMINAL_OUTPUT=console"
echo ""
echo "Then apply changes:"
echo "   sudo grub-mkconfig -o /boot/grub/grub.cfg"
echo ""
echo "-------------------------------------------"
EOF

chmod +x "$NOTES_FILE"

echo "Theme installed. Notes saved to $NOTES_FILE"