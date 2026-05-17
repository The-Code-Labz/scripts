#!/bin/bash
set -e

echo "[+] Installing Podman on Ubuntu..."
sudo apt-get update
sudo apt-get install -y podman
echo "[+] Podman installed successfully."
podman --version
