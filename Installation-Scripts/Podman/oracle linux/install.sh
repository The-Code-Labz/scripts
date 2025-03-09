#!/bin/bash

set -e  # Exit on error

# Update package list
echo "Updating package list..."
sudo dnf update -y

# Install Podman
echo "Installing Podman..."
sudo dnf install -y podman

# Initialize Podman machine
echo "Initializing Podman machine..."
podman machine init

# Start Podman machine
echo "Starting Podman machine..."
podman machine start

# Display Podman info
echo "Podman installation complete. Displaying Podman info:"
podman info
