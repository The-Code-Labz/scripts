#!/bin/bash

# Update package list
echo "Updating package list..."
sudo dnf update -y

# Install EPEL repository (required for UFW)
echo "Installing EPEL repository..."
sudo dnf install -y epel-release

# Install ufw
echo "Installing UFW..."
sudo dnf install -y ufw

# Allow SSH on port 22
echo "Allowing SSH on port 22..."
sudo ufw allow 22

# Enable UFW
echo "Enabling UFW..."
sudo ufw enable

# Status of UFW
echo "UFW status:"
sudo ufw status