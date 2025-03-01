#!/bin/bash

set -e  # Exit on error

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Read username as input
echo -n "Enter the new username: "
read username

# Create the new user
echo "Creating user $username..."
sudo adduser "$username"

# Set password for the new user
echo "Setting password for $username..."
sudo passwd "$username"

# Add user to sudo group (optional)
echo -n "Should the user have sudo privileges? (y/n): "
read give_sudo
if [[ "$give_sudo" == "y" ]]; then
    sudo usermod -aG sudo "$username"
    echo "$username has been granted sudo privileges."
fi

echo "User $username created successfully."
