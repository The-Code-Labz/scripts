#!/bin/bash
set -e

echo "[+] Installing Podman on Oracle Linux..."
sudo dnf update -y
sudo dnf install -y podman
echo "[+] Podman installed successfully."
podman --version
