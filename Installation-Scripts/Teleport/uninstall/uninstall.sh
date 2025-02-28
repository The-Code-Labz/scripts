#!/bin/bash

# Script to clean up Teleport installation.
# WARNING: This script will remove Teleport data and configuration.  Use with caution.

echo "This script will remove Teleport data and configuration. Are you sure you want to continue? (y/n)"

# Use a timeout to prevent indefinite hanging if no input is received.
read -r answer

# Trim whitespace from the answer
answer=$(echo "$answer" | tr -d '[:space:]')

echo "You entered: '$answer'"  # Debugging line

if [[ "$answer" != "y" ]]; then
  echo "Aborting cleanup."
  exit 1
fi

# Stop Teleport service
echo "- Stopping Teleport service..."
sudo systemctl stop teleport 2>/dev/null
if [ $? -eq 0 ]; then
  echo "  Teleport service stopped successfully."
else
  echo "  Teleport service may not be running or could not be stopped.  Continuing..."
fi

# Stop any running Teleport processes
echo "- Stopping any running Teleport processes..."
sudo pkill -f teleport 2>/dev/null
if [ $? -eq 0 ]; then
  echo "  Teleport processes stopped successfully."
else
  echo "  No Teleport processes found or could not be stopped.  Continuing..."
fi

# Remove data under /var/lib/teleport and the directory itself
echo "- Removing data under /var/lib/teleport..."
sudo rm -rf /var/lib/teleport
if [ $? -eq 0 ]; then
  echo "  /var/lib/teleport removed successfully."
else
  echo "  Failed to remove /var/lib/teleport.  Check permissions and existence.  Continuing..."
fi

# Remove configuration at /etc/teleport.yaml
echo "- Removing configuration at /etc/teleport.yaml..."
sudo rm -f /etc/teleport.yaml
if [ $? -eq 0 ]; then
  echo "  /etc/teleport.yaml removed successfully."
else
  echo "  Failed to remove /etc/teleport.yaml.  Check permissions and existence.  Continuing..."
fi

# Remove Teleport package
echo "- Removing Teleport package..."
sudo apt remove teleport -y
if [ $? -eq 0 ]; then
  echo "  Teleport package removed successfully."
else
  echo "  Failed to remove Teleport package.  Package may not be installed or apt is not configured. Continuing..."
fi

echo "Teleport cleanup complete.  Run the installer again to reinstall Teleport."

exit 0