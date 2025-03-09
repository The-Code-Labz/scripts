#!/bin/bash

# Function to check if htpasswd is installed
check_install_htpasswd() {
    if ! command -v htpasswd &>/dev/null; then
        echo "htpasswd not found! Installing apache2-utils..."
        sudo apt install -y apache2-utils
    else
        echo "htpasswd is already installed."
    fi
}

# Function to check if the system is up to date
check_system_update() {
    echo "Checking if the system is up to date..."
    # Check for available updates
    updates_available=$(apt list --upgradable 2>/dev/null | grep -c "upgradable")

    if [ "$updates_available" -eq 0 ]; then
        echo "System is up to date. Skipping update."
    else
        echo "Updates available. Running update and upgrade..."
        sudo apt update && sudo apt upgrade -y
    fi
}

# Prompt user for username and password
read -p "Enter username (avoid special characters like ':'): " username
echo "You entered username: $username"  # Debugging line to confirm input
read -s -p "Enter password: " password
echo ""  # Newline for output clarity
echo "You entered password: [hidden]"  # Password is not shown for security

# Check if htpasswd is installed, and install if necessary
check_install_htpasswd

# Check if system needs an update
check_system_update

# Generate htpasswd hash
hashed_password=$(htpasswd -nbB "$username" "$password" 2>/dev/null | sed -e 's/\$/\$\$/g')

# Debugging: Check if the hash generation succeeded
if [ $? -ne 0 ]; then
    echo "Error: Failed to generate htpasswd entry. Please check your input."
    exit 1
fi

# Display the result
echo "Generated htpasswd entry:"
echo "$hashed_password"