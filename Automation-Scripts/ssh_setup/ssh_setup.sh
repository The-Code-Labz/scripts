#!/bin/bash

set -e

echo "[+] SSH Key Setup Script"

# Step 1: Generate SSH key if not exists
read -p "Do you want to generate a new SSH key? (y/n): " gen_key
if [[ "$gen_key" == "y" ]]; then
    read -p "Enter email/label for SSH key: " email
    ssh-keygen -t ed25519 -C "$email"
fi

# Step 2: Ensure .ssh folder and authorized_keys exist
SSH_DIR="$HOME/.ssh"
AUTH_KEYS="$SSH_DIR/authorized_keys"

mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

touch "$AUTH_KEYS"
chmod 600 "$AUTH_KEYS"

echo "[+] Ensured $AUTH_KEYS exists"

# Step 3: Edit sshd_config
SSHD_CONFIG="/etc/ssh/sshd_config"

if [[ $EUID -ne 0 ]]; then
    echo "[-] This part requires sudo/root access to modify sshd_config."
    exit 1
fi

echo "[+] Updating sshd_config..."
sed -i 's/^#\?\s*PubkeyAuthentication.*/PubkeyAuthentication yes/' "$SSHD_CONFIG"
sed -i 's/^#\?\s*AuthorizedKeysFile.*/AuthorizedKeysFile .ssh\/authorized_keys/' "$SSHD_CONFIG"

# Step 4: Ask to add a public key
read -p "Do you want to add a public key to authorized_keys? (y/n): " add_key
if [[ "$add_key" == "y" ]]; then
    read -p "Paste the public key: " pubkey
    echo "$pubkey" >> "$AUTH_KEYS"
    echo "[+] Key added to $AUTH_KEYS"
fi

# Step 5: Restart SSH service
if command -v systemctl >/dev/null; then
    echo "[+] Restarting SSH service..."
    systemctl restart sshd
else
    echo "[!] Warning: systemctl not found. Restart sshd manually if needed."
fi

echo "[✓] SSH setup completed successfully."
