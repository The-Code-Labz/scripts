#!/bin/bash

# Check if the script is run as root, if not use sudo
if [ "$EUID" -ne 0 ]; then
    SUDO="sudo"
else
    SUDO=""
fi

# Stop Teleport service if running
if systemctl is-active --quiet teleport; then
    echo "Stopping Teleport service..."
    $SUDO systemctl stop teleport
else
    echo "Teleport service is not running."
fi

# Kill any running Teleport processes
if pgrep -f teleport > /dev/null; then
    echo "Killing Teleport processes..."
    $SUDO pkill -f teleport
else
    echo "No running Teleport processes found."
fi

# Remove Teleport data directory
if [ -d /var/lib/teleport ]; then
    echo "Removing /var/lib/teleport..."
    $SUDO rm -rf /var/lib/teleport
else
    echo "No data directory found at /var/lib/teleport."
fi

# Remove Teleport configuration file
if [ -f /etc/teleport.yaml ]; then
    echo "Removing /etc/teleport.yaml..."
    $SUDO rm -f /etc/teleport.yaml
else
    echo "No configuration file found at /etc/teleport.yaml."
fi

# Uninstall Teleport package
if yum list installed teleport &>/dev/null; then
    echo "Uninstalling Teleport package..."
    $SUDO yum remove -y teleport
else
    echo "Teleport package is not installed."
fi

echo "Teleport has been completely removed."
