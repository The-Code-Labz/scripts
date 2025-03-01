#!/bin/bash

# Update the package list
echo "Updating package list..."
sudo apt update

# Upgrade the existing packages
echo "Upgrading packages..."
sudo apt upgrade -y

# Install Docker and Docker Compose
echo "Installing Docker..."
sudo apt install -y docker.io

echo "Installing Docker Compose..."
sudo apt install -y docker-compose

# Start and enable Docker service
echo "Starting Docker service..."
sudo systemctl start docker
sudo systemctl enable docker
sudo docker info

echo "Installation complete!"