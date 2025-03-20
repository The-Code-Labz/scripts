#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Update and upgrade packages
echo "Updating and upgrading packages..."
sudo apt update && sudo apt upgrade -y

# Get the current user
CURRENT_USER=$(whoami)

# Add the current user to the sudo group if not already a member
if ! groups "$CURRENT_USER" | grep -q "\bsudo\b"; then
  echo "Adding '$CURRENT_USER' to the sudo group..."
  sudo usermod -aG sudo "$CURRENT_USER"
else
  echo "'$CURRENT_USER' is already in the sudo group."
fi

# Configure sudo to allow the current user to execute commands without a password
SUDO_FILE="/etc/sudoers.d/$CURRENT_USER"
if [ ! -f "$SUDO_FILE" ]; then
  echo "Configuring sudo for '$CURRENT_USER' to not require a password..."
  echo "$CURRENT_USER ALL=(ALL) NOPASSWD:ALL" | sudo tee "$SUDO_FILE" > /dev/null
  sudo chmod 440 "$SUDO_FILE"
else
  echo "Sudo configuration for '$CURRENT_USER' already exists."
fi

# Install SSH server if not already installed
if ! dpkg -l | grep -q openssh-server; then
  echo "Installing OpenSSH server..."
  sudo apt install -y openssh-server
else
  echo "OpenSSH server is already installed."
fi

# Enable root SSH access with authentication key only
SSHD_CONFIG="/etc/ssh/sshd_config"

echo "Configuring SSH for root access with key authentication only..."
sudo sed -i 's/^PermitRootLogin .*/PermitRootLogin prohibit-password/' "$SSHD_CONFIG"
sudo sed -i 's/^#AuthorizedKeysFile .*/AuthorizedKeysFile .ssh\/authorized_keys/' "$SSHD_CONFIG"

echo "Restarting SSH service..."
sudo systemctl restart ssh

echo "Setup complete!"