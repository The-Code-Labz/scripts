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
CUSTOM_KEY_FILE="${TEMP_DIR}/id_rsa"
DEFAULT_DNS="1.1.1.1"
DEFAULT_PORT=2424

# Step 1: Prompt User to Input Private Key Using Nano
echo "Opening nano editor for private key input..."
echo "Paste your private key into the nano editor. Save and exit when done."
nano "$CUSTOM_KEY_FILE"

# Step 2: Validate Private Key Format
echo "Inspecting the private key file..."
if ! grep -q "^-----BEGIN OPENSSH PRIVATE KEY-----$" "$CUSTOM_KEY_FILE" || ! grep -q "^-----END OPENSSH PRIVATE KEY-----$" "$CUSTOM_KEY_FILE"; then
  echo "Error: Invalid private key format. Ensure it starts with '-----BEGIN OPENSSH PRIVATE KEY-----' and ends with '-----END OPENSSH PRIVATE KEY-----'."
  rm -f "$CUSTOM_KEY_FILE"
  exit 1
fi

# Step 3: Fix Line Endings
echo "Fixing line endings..."
dos2unix "$CUSTOM_KEY_FILE" > /dev/null 2>&1 || echo "dos2unix not found, skipping line ending fix..."

# Step 4: Set Secure Permissions for the Private Key
echo "Setting secure file permissions..."
chmod 600 "$CUSTOM_KEY_FILE"

# Step 5: Pull the Alpine Linux Image
echo "Pulling Alpine Linux image..."
docker pull alpine:latest

# Step 6: Start a Temporary Alpine Linux Container with Custom DNS
read -p "Enter a custom DNS resolver (default: $DEFAULT_DNS): " CUSTOM_DNS
CUSTOM_DNS=${CUSTOM_DNS:-$DEFAULT_DNS}  # Use default if no input is provided

echo "Starting Alpine Linux container with DNS: $CUSTOM_DNS..."
docker run -d --name $CONTAINER_NAME --dns="$CUSTOM_DNS" alpine:latest tail -f /dev/null

# Ensure the container is cleaned up after the script finishes
function cleanup {
  echo "Cleaning up temporary files and container..."
  rm -f "$CUSTOM_KEY_FILE"
  docker stop "$CONTAINER_NAME" > /dev/null 2>&1 || true
  docker rm "$CONTAINER_NAME" > /dev/null 2>&1 || true
}
trap cleanup EXIT

# Step 7: Install OpenSSH Inside the Container
echo "Installing OpenSSH in the container..."
docker exec $CONTAINER_NAME apk add --no-cache openssh

# Step 8: Create the SSH Key Directory in the Container
echo "Creating the /root/.ssh directory in the container..."
docker exec $CONTAINER_NAME mkdir -p $SSH_KEY_DIR
docker exec $CONTAINER_NAME chmod 700 $SSH_KEY_DIR

# Step 9: Copy the User-Provided Private Key to the Container
echo "Copying the private key to the container..."
docker cp "$CUSTOM_KEY_FILE" $CONTAINER_NAME:"${SSH_KEY_DIR}/id_rsa"
docker exec $CONTAINER_NAME chmod 600 "${SSH_KEY_DIR}/id_rsa"

# Step 10: Generate a New Public Key from the Private Key
echo "Generating public key from private key in the container..."
docker exec $CONTAINER_NAME ssh-keygen -y -f "${SSH_KEY_DIR}/id_rsa" > "$PUBLIC_KEY_OUTPUT"

# Step 11: Parse and Test SSH Connection
echo "Testing SSH connection using the provided private key..."
read -p "Enter the GitLab SSH URL (e.g., ssh://git@gitlab.com:2424/user/project.git): " GITLAB_SSH_URL

# Remove 'ssh://' if present in the URL
GITLAB_SSH_URL=$(echo "$GITLAB_SSH_URL" | sed 's|ssh://||')

# Extract hostname and repository path from the SSH URL
HOSTNAME=$(echo "$GITLAB_SSH_URL" | cut -d'@' -f2 | cut -d':' -f1)
REPO_PATH=$(echo "$GITLAB_SSH_URL" | cut -d':' -f2)

# Default port
PORT=$DEFAULT_PORT

# Check for a custom port (e.g., gitlab.com:2424)
if [[ "$HOSTNAME" =~ :([0-9]+)$ ]]; then
  PORT="${BASH_REMATCH[1]}"
  HOSTNAME=$(echo "$HOSTNAME" | cut -d':' -f1)  # Remove the port from the hostname
fi

echo "Parsed Hostname: $HOSTNAME"
echo "Parsed Repository Path: $REPO_PATH"
echo "Using Port: $PORT"

# Test SSH connection
echo "Testing SSH connection to GitLab ($HOSTNAME) on port $PORT..."
docker exec $CONTAINER_NAME ssh -i "${SSH_KEY_DIR}/id_rsa" -p "$PORT" -o StrictHostKeyChecking=no -T "git@$HOSTNAME"

# Step 12: Copy the Private Key Back to the Host
echo "Copying private key back to host..."
docker cp $CONTAINER_NAME:"${SSH_KEY_DIR}/id_rsa" "$PRIVATE_KEY_OUTPUT"

# Step 13: Display the Generated Keys
echo "Private key saved to: $PRIVATE_KEY_OUTPUT"
echo "Public key saved to: $PUBLIC_KEY_OUTPUT"

echo "Script completed successfully!"