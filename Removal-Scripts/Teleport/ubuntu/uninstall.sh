#!/bin/bash

# Stop Teleport service if running
if systemctl is-active --quiet teleport; then
    echo "Stopping Teleport service..."
    systemctl stop teleport
else
    echo "Teleport service is not running."
fi

# Kill any running Teleport processes
if pgrep -f teleport > /dev/null; then
    echo "Killing Teleport processes..."
    pkill -f teleport
else
    echo "No running Teleport processes found."
fi

# Remove Teleport data directory
if [ -d /var/lib/teleport ]; then
    echo "Removing /var/lib/teleport..."
    rm -rf /var/lib/teleport
else
    echo "No data directory found at /var/lib/teleport."
fi

# Remove Teleport configuration file
if [ -f /etc/teleport.yaml ]; then
    echo "Removing /etc/teleport.yaml..."
    rm -f /etc/teleport.yaml
else
    echo "No configuration file found at /etc/teleport.yaml."
fi

# Uninstall Teleport package
if apt list installed teleport &>/dev/null; then
    echo "Uninstalling Teleport package..."
    apt remove -y teleport
else
    echo "Teleport package is not installed."
fi

echo "Teleport has been completely removed."
