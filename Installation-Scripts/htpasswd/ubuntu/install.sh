#!/bin/bash
set -e

echo "[+] Installing apache2-utils (htpasswd)..."
sudo apt-get update
sudo apt-get install -y apache2-utils
echo "[+] htpasswd installed successfully."
echo ""
echo "Usage examples:"
echo "  htpasswd -nbB <username> <password>           # Generate hash"
echo "  htpasswd -c /etc/nginx/.htpasswd <username>   # Create new file"
