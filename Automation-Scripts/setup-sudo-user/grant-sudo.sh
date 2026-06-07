#!/usr/bin/env bash
# =============================================================================
# grant-sudo.sh
# Grants a user full passwordless sudo access.
# Usage: sudo ./grant-sudo.sh <username>
# =============================================================================

set -euo pipefail

# --------------------------------------------------------------------------- #
# Validation
# --------------------------------------------------------------------------- #
if [[ $EUID -ne 0 ]]; then
  echo "[ERROR] This script must be run as root (or with sudo)." >&2
  exit 1
fi

if [[ $# -lt 1 ]]; then
  echo "[ERROR] Usage: $0 <username>" >&2
  exit 1
fi

USERNAME="$1"

# Verify the user actually exists
if ! id "$USERNAME" &>/dev/null; then
  echo "[ERROR] User '$USERNAME' does not exist on this system." >&2
  exit 1
fi

# --------------------------------------------------------------------------- #
# Add user to sudo group
# --------------------------------------------------------------------------- #
echo "[INFO] Adding '$USERNAME' to the sudo group..."
usermod -aG sudo "$USERNAME"

# --------------------------------------------------------------------------- #
# Write sudoers drop-in (safe, with visudo validation)
# --------------------------------------------------------------------------- #
SUDOERS_FILE="/etc/sudoers.d/${USERNAME}"
SUDOERS_LINE="${USERNAME} ALL=(ALL) NOPASSWD:ALL"

echo "[INFO] Writing sudoers drop-in: $SUDOERS_FILE"
echo "$SUDOERS_LINE" | tee "$SUDOERS_FILE" > /dev/null
chmod 440 "$SUDOERS_FILE"

# Validate the sudoers file before leaving it in place
if ! visudo -cf "$SUDOERS_FILE"; then
  echo "[ERROR] Sudoers validation failed. Removing invalid file." >&2
  rm -f "$SUDOERS_FILE"
  exit 1
fi

# --------------------------------------------------------------------------- #
# Done
# --------------------------------------------------------------------------- #
echo "[SUCCESS] '$USERNAME' now has full passwordless sudo access."
echo "          Sudoers file: $SUDOERS_FILE"
