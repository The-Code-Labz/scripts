#!/bin/bash
set -e

SSH_KEY_NAME="ci-cd-deploy-key"

if [ -t 0 ]; then
    OUTPUT_DIR="$(pwd)"
else
    OUTPUT_DIR="/home/ssh_keygen"
    mkdir -p "${OUTPUT_DIR}"
fi

PRIVATE_KEY="${OUTPUT_DIR}/${SSH_KEY_NAME}"
PUBLIC_KEY="${OUTPUT_DIR}/${SSH_KEY_NAME}.pub"

echo "[+] Generating ed25519 SSH keypair..."
ssh-keygen -t ed25519 -C "${SSH_KEY_NAME}" -f "${PRIVATE_KEY}" -N ""
chmod 600 "${PRIVATE_KEY}"

echo ""
echo "[+] SSH keypair generated."
echo "    Private key : ${PRIVATE_KEY}"
echo "    Public key  : ${PUBLIC_KEY}"
echo ""
echo "Public key:"
cat "${PUBLIC_KEY}"
