#!/bin/bash
set -e

echo "[+] SSH Setup and Hardening Script"

if [[ $EUID -ne 0 ]]; then
    echo "[-] This script must be run as root."
    exit 1
fi

SSH_DIR="${HOME}/.ssh"
AUTH_KEYS="${SSH_DIR}/authorized_keys"

mkdir -p "${SSH_DIR}"
chmod 700 "${SSH_DIR}"
touch "${AUTH_KEYS}"
chmod 600 "${AUTH_KEYS}"
echo "[+] Ensured ${AUTH_KEYS} exists with correct permissions."

if [[ -n "${1:-}" ]]; then
    echo "$1" >> "${AUTH_KEYS}"
    echo "[+] Public key added to ${AUTH_KEYS}"
fi

SSHD_CONFIG="/etc/ssh/sshd_config"
echo "[+] Hardening ${SSHD_CONFIG}..."

sed -i 's/^#*\s*PubkeyAuthentication.*/PubkeyAuthentication yes/' "${SSHD_CONFIG}"
sed -i 's/^#*\s*AuthorizedKeysFile.*/AuthorizedKeysFile .ssh\/authorized_keys/' "${SSHD_CONFIG}"
sed -i 's/^#*\s*PasswordAuthentication.*/PasswordAuthentication no/' "${SSHD_CONFIG}"
sed -i 's/^#*\s*PermitRootLogin.*/PermitRootLogin no/' "${SSHD_CONFIG}"
sed -i 's/^#*\s*ChallengeResponseAuthentication.*/ChallengeResponseAuthentication no/' "${SSHD_CONFIG}"

if command -v systemctl &>/dev/null; then
    systemctl restart sshd 2>/dev/null || systemctl restart ssh
    echo "[+] SSH service restarted."
fi

echo "[+] SSH setup and hardening complete."
