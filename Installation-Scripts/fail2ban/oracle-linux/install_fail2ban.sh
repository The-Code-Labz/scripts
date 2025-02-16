#!/bin/bash

# Update package list
echo "Updating package list..."
sudo dnf check-update

# Install Fail2Ban
echo "Installing Fail2Ban..."
sudo dnf install -y epel-release  # Enable EPEL repository
sudo dnf install -y fail2ban

# Start and enable Fail2Ban service
echo "Starting and enabling Fail2Ban service..."
sudo systemctl start fail2ban
sudo systemctl enable fail2ban

# Check status of Fail2Ban service
echo "Checking Fail2Ban service status..."
sudo systemctl status fail2ban

echo "Fail2Ban installation complete!"