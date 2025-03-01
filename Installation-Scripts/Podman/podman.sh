#!/bin/bash

set -e  # Exit on error

# Update package list
echo "Updating package list..."
sudo apt update

# Install Podman
echo "Installing Podman..."
sudo apt-get -y install podman

# Initialize Podman machine
echo "Initializing Podman machine..."
podman machine init

# Start Podman machine
echo "Starting Podman machine..."
podman machine start

# Display Podman info
echo "Podman installation complete. Displaying Podman info:"
podman info
