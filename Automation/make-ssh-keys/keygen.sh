#!/bin/bash

# Exit immediately if a command fails
set -e

# Define variables
CONTAINER_NAME="ssh-keygen-container"
SSH_KEY_NAME="ci-cd-deploy-key"
SSH_KEY_DIR="/root/.ssh"
TEMP_DIR="/tmp"
PRIVATE_KEY_OUTPUT="${TEMP_DIR}/${SSH_KEY_NAME}"
PUBLIC_KEY_OUTPUT="${TEMP_DIR}/${SSH_KEY_NAME}.pub"

# Pull the Alpine Linux image
echo "Pulling Alpine Linux image..."
docker pull alpine:latest

# Run a temporary Alpine container
echo "Starting Alpine Linux container..."
docker run -d --name $CONTAINER_NAME alpine:latest tail -f /dev/null

# Install OpenSSH inside the container
echo "Installing OpenSSH in the container..."
docker exec $CONTAINER_NAME apk add --no-cache openssh

# Create the SSH key folder inside the container
docker exec $CONTAINER_NAME mkdir -p $SSH_KEY_DIR

# Generate the SSH key pair
echo "Generating SSH key pair..."
docker exec $CONTAINER_NAME ssh-keygen -t rsa -b 4096 -C "ci-cd-deploy-key" -f "${SSH_KEY_DIR}/${SSH_KEY_NAME}" -N ""

# Copy the private key from the container to the host
echo "Copying private key to host..."
docker cp $CONTAINER_NAME:"${SSH_KEY_DIR}/${SSH_KEY_NAME}" "$PRIVATE_KEY_OUTPUT"

# Copy the public key from the container to the host
echo "Copying public key to host..."
docker cp $CONTAINER_NAME:"${SSH_KEY_DIR}/${SSH_KEY_NAME}.pub" "$PUBLIC_KEY_OUTPUT"

# Display the private key
echo "Private key generated:"
cat "$PRIVATE_KEY_OUTPUT"

# Display the public key
echo "Public key generated:"
cat "$PUBLIC_KEY_OUTPUT"

# Clean up: stop and remove the container
echo "Cleaning up: removing container..."
docker stop $CONTAINER_NAME
docker rm $CONTAINER_NAME

# Optional: Set permissions on the keys (private key should be read-only for the owner)
chmod 600 "$PRIVATE_KEY_OUTPUT"

echo "Script completed successfully!"