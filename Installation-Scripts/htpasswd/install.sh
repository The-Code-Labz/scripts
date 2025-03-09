#!/bin/bash

# Update and upgrade the system first
echo "Running system update and upgrade..."
sudo apt update && sudo apt upgrade -y

# Function to check if htpasswd is installed
check_install_htpasswd() {
    if ! command -v htpasswd &>/dev/null; then
        echo "htpasswd not found! Installing apache2-utils..."
        sudo apt install -y apache2-utils
    else
        echo "htpasswd is already installed."
    fi
}

# Prompt user for username and password
read -p "Enter username (avoid special characters like ':'): " username
read -s -p "Enter password: " password
echo ""

# Check if htpasswd is installed, and install if necessary
check_install_htpasswd

# Generate htpasswd hash
hashed_password=$(htpasswd -nbB "$username" "$password" 2>/dev/null | sed -e 's/\$/\$\$/g')

# Check if the username contains an illegal character
if [[ $? -ne 0 ]]; then
    echo "Error: username contains illegal characters (e.g., ':'). Please try again."
    exit 1
fi

# Display the result
echo "Generated htpasswd entry:"
echo "$hashed_password"
