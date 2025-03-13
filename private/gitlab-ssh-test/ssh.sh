#!/bin/bash

# Exit if any command fails
set -e

# Temporary file to store the private key
TEMP_PRIVATE_KEY_FILE="/tmp/temp_ssh_key"

# Function to check if SSH agent is running
check_ssh_agent() {
  if [ -z "$SSH_AUTH_SOCK" ]; then
    echo "Starting ssh-agent..."
    eval "$(ssh-agent -s)"
  fi
}

# Prompt the user to paste the private key
echo "Paste your private key below (end with Ctrl+D):"
PRIVATE_KEY=$(cat)  # Capture multiline input

# Validate that a private key was entered
if [[ -z "$PRIVATE_KEY" || ! "$PRIVATE_KEY" =~ "PRIVATE KEY" ]]; then
  echo "Error: Invalid or empty private key."
  exit 1
fi

# Save the private key to a temporary file
echo "Saving private key to a temporary file..."
echo "$PRIVATE_KEY" > "$TEMP_PRIVATE_KEY_FILE"
chmod 600 "$TEMP_PRIVATE_KEY_FILE"

# Add the private key to the SSH agent
echo "Adding the private key to the SSH agent..."
check_ssh_agent
ssh-add "$TEMP_PRIVATE_KEY_FILE"

# Prompt the user for the GitLab repository domain
echo "Enter the GitLab repository domain (e.g., gitlab.neurolearninglabs.com):"
read -r GITLAB_DOMAIN

# Test the SSH connection to the repository
echo "Testing SSH connection to GitLab..."
ssh -T "git@$GITLAB_DOMAIN"

# Check the result of the SSH test
if [ $? -eq 0 ]; then
  echo "SSH connection successful! Your SSH key is working."
else
  echo "SSH connection failed. Please check your private key and GitLab settings."
fi

# Clean up: remove the private key from the SSH agent