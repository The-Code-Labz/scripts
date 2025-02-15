#!/bin/bash

# Update the system
echo "Updating package list..."
sudo dnf update -y

# Install required packages for Docker installation
echo "Installing required packages..."
sudo dnf install -y yum-utils device-mapper-persistent-data lvm2

# Set up the Docker repository
echo "Setting up Docker repository..."
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# Install Docker
echo "Installing Docker..."
sudo dnf install -y docker-ce docker-ce-cli containerd.io

# Start and enable Docker service
echo "Starting Docker service..."
sudo systemctl start docker
sudo systemctl enable docker

# Install Docker Compose
echo "Installing Docker Compose..."
sudo dnf install -y python3-pip
sudo pip3 install docker-compose

echo "Installation complete!"