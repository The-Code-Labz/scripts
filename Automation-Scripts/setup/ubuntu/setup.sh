#!/bin/bash
set -e

echo "[+] Ubuntu Server Setup"

sudo apt update && sudo apt upgrade -y

CURRENT_USER=$(whoami)

if ! groups "${CURRENT_USER}" | grep -q "\bsudo\b"; then
    sudo usermod -aG sudo "${CURRENT_USER}"
    echo "[+] Added '${CURRENT_USER}' to sudo group."
fi

SUDO_FILE="/etc/sudoers.d/${CURRENT_USER}"
if [ ! -f "${SUDO_FILE}" ]; then
    echo "${CURRENT_USER} ALL=(ALL) NOPASSWD:ALL" | sudo tee "${SUDO_FILE}" > /dev/null
    sudo chmod 440 "${SUDO_FILE}"
    echo "[+] Configured NOPASSWD sudo for '${CURRENT_USER}'."
fi

if ! dpkg -l | grep -q openssh-server; then
    sudo apt install -y openssh-server
    echo "[+] OpenSSH server installed."
fi

SSHD_CONFIG="/etc/ssh/sshd_config"
sudo sed -i 's/^#*\s*PermitRootLogin.*/PermitRootLogin no/' "${SSHD_CONFIG}"
sudo sed -i 's/^#*\s*PasswordAuthentication.*/PasswordAuthentication no/' "${SSHD_CONFIG}"
sudo sed -i 's/^#*\s*AuthorizedKeysFile.*/AuthorizedKeysFile .ssh\/authorized_keys/' "${SSHD_CONFIG}"
sudo systemctl restart ssh

echo "[+] Setup complete!"
