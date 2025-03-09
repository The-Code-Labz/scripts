#!/bin/bash

# Function to check if htpasswd is installed
check_install_htpasswd() {
    if ! command -v htpasswd &>/dev/null; then
        echo "htpasswd not found! Installing apache2-utils..."
        sudo apt update && sudo apt install -y apache2-utils
    else
        echo "htpasswd is already installed."
    fi
}

# Prompt user for username and password
read -p "Enter username: " username
read -s -p "Enter password: " password
echo ""

# Install htpasswd if not installed
check_install_htpasswd

# Generate htpasswd hash
hashed_password=$(htpasswd -nbB "$username" "$password" | sed -e 's/\$/\$\$/g')

# Display the result
echo "Generated htpasswd entry:"
echo "$hashed_password"
