#!/bin/bash
set -e

# Check if the script is being executed as root
if [[ $EUID -ne 0 ]]; then
    echo "Error: This script must be run as root."
    exit 1
fi

USERNAME=$1
PASSWORD=$2
SUDO_PRIV=$3

if [[ -z "$USERNAME" || -z "$PASSWORD" ]]; then
    echo "Usage: $0 <username> <password> [sudo]"
    exit 1
fi

echo "Creating user $USERNAME..."
adduser --gecos "" --disabled-password "$USERNAME"
echo "$USERNAME:$PASSWORD" | chpasswd

if [[ "$SUDO_PRIV" == "yes" ]]; then
    usermod -aG sudo "$USERNAME"
    echo "$USERNAME has been granted sudo privileges."

    # Allow the user to use sudo without a password
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" | tee -a /etc/sudoers > /dev/null
    echo "$USERNAME can now use sudo without a password."
fi

echo "User $USERNAME created successfully."