#!/bin/bash

# Update package list
echo "Updating package list..."
sudo apt update

# Install ufw
echo "Installing UFW..."
sudo apt install -y ufw

# Allow SSH on port 22
echo "Allowing SSH on port 22..."
sudo ufw allow 22

# Enable UFW
echo "Enabling UFW..."
sudo ufw enable

# Status of UFW
echo "UFW status:"
sudo ufw status