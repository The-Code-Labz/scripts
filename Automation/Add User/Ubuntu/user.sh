#!/bin/bash
set -e

USERNAME=$1
PASSWORD=$2
SUDO_PRIV=$3

if [[ -z "$USERNAME" || -z "$PASSWORD" ]]; then
    echo "Usage: $0 <username> <password> [sudo]"
    exit 1
fi

echo "Creating user $USERNAME..."
sudo adduser --gecos "" --disabled-password "$USERNAME"
echo "$USERNAME:$PASSWORD" | sudo chpasswd

if [[ "$SUDO_PRIV" == "yes" ]]; then
    sudo usermod -aG sudo "$USERNAME"
    echo "$USERNAME has been granted sudo privileges."
fi

echo "User $USERNAME created successfully."
