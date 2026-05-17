# 📜 The-Code-Labz Scripts

> A collection of battle-tested shell scripts for Linux server setup, software installation, security hardening, and automation — targeting Ubuntu and Oracle Linux.

[![GitHub](https://img.shields.io/badge/GitHub-The--Code--Labz-181717?logo=github)](https://github.com/The-Code-Labz/scripts)
[![License](https://img.shields.io/badge/license-MIT-blue)](LICENSE)
[![Ansible](https://img.shields.io/badge/Ansible-Conversion%20In%20Progress-EE0000?logo=ansible)](https://gitlab.neurolearninglabs.com/code-labz/ansible)

---

## 📋 Table of Contents

- [Installation Scripts](#-installation-scripts)
- [Automation Scripts](#-automation-scripts)
- [Removal Scripts](#-removal-scripts)
- [Test Scripts](#-test-scripts)
- [Known Issues](#-known-issues)
- [Ansible Equivalents](#-ansible-equivalents)

---

## 📦 Installation Scripts

### 🐳 Docker

#### Ubuntu / Debian
Installs Docker CE from the official Docker APT repository.

```bash
curl -sSL https://raw.githubusercontent.com/The-Code-Labz/scripts/refs/heads/main/Installation-Scripts/Docker/ubuntu/install.sh | bash
```

> ✅ Installs: `docker-ce`, `docker-ce-cli`, `containerd.io`, `docker-buildx-plugin`, `docker-compose-plugin`
> Run as root or with sudo.

#### Oracle Linux / RHEL / CentOS
Installs Docker CE from the official Docker YUM repository.

```bash
curl -sSL https://raw.githubusercontent.com/The-Code-Labz/scripts/refs/heads/main/Installation-Scripts/Docker/oracle-linux/install.sh | bash
```

> ✅ Installs via `dnf`. Adds Docker CE stable repo. Run as root.

---

### 🦭 Podman

#### Ubuntu / Debian
```bash
curl -sSL https://raw.githubusercontent.com/The-Code-Labz/scripts/refs/heads/main/Installation-Scripts/Podman/ubuntu/install.sh | bash
```

#### Oracle Linux
```bash
curl -sSL https://raw.githubusercontent.com/The-Code-Labz/scripts/refs/heads/main/Installation-Scripts/Podman/oracle%20linux/install.sh | bash
```

> ⚠️ **Note:** These scripts install Podman for **server use**. `podman machine` commands are not included — those are desktop/macOS only.

---

### 🔒 fail2ban

#### Ubuntu / Debian
```bash
curl -sSL https://raw.githubusercontent.com/The-Code-Labz/scripts/refs/heads/main/Installation-Scripts/fail2ban/ubuntu/install.sh | bash
```

#### Oracle Linux
```bash
curl -sSL https://raw.githubusercontent.com/The-Code-Labz/scripts/refs/heads/main/Installation-Scripts/fail2ban/oracle-linux/install.sh | bash
```

> ✅ Oracle Linux script enables EPEL (`oracle-epel-release-el8`) before installing.

---

### 🔑 htpasswd (apache2-utils)

Installs `apache2-utils` to make the `htpasswd` utility available. No interactive prompts.

```bash
curl -sSL https://raw.githubusercontent.com/The-Code-Labz/scripts/refs/heads/main/Installation-Scripts/htpasswd/ubuntu/install.sh | bash
```

---

### 🏗️ Terraform

Installs Terraform via the official HashiCorp APT repository (Ubuntu only).

```bash
curl -sSL https://raw.githubusercontent.com/The-Code-Labz/scripts/refs/heads/main/Installation-Scripts/terraform/ubuntu/install.sh | bash
```

> ✅ Adds HashiCorp GPG key + APT repo. Installs latest stable Terraform.

---

### 🔥 UFW (Uncomplicated Firewall)

```bash
curl -sSL https://raw.githubusercontent.com/The-Code-Labz/scripts/refs/heads/main/Installation-Scripts/ufw/ubuntu/install.sh | bash
```

> ✅ Installs UFW, allows SSH (port 22), enables firewall. Ubuntu only.

---

### 💻 VSCode / code-server

Installs [code-server](https://github.com/coder/code-server) — run VS Code in the browser.

```bash
curl -fsSL https://code-server.dev/install.sh | sh
```

> ✅ Official installer. Enables `code-server@$USER` systemd service after install.

---

## ⚙️ Automation Scripts

### 👤 Add User (Ubuntu)

Creates a new user with optional sudo privileges.

```bash
curl -sL "https://raw.githubusercontent.com/The-Code-Labz/scripts/refs/heads/main/Automation-Scripts/Add%20User/Ubuntu/user.sh" | sudo bash -s <username> <password> yes
```

**Arguments:** `<username>` `<password>` `[yes|no]` (sudo)

> ⚠️ Must be run as root. Password is set via `chpasswd`.

---

### 🔐 SSH Setup & Hardening

Hardens `sshd_config` — enables pubkey auth, disables password auth, disables root login. Optionally adds a public key to `authorized_keys`.

```bash
curl -fsSL https://raw.githubusercontent.com/The-Code-Labz/scripts/refs/heads/main/Automation-Scripts/ssh_setup/ssh_setup.sh | bash -s -- "<your-public-key>"
```

> Accepts optional public key as first argument. Must run as root to modify `sshd_config`.

---

### 🗝️ Generate SSH Keypair

Generates an `ed25519` SSH keypair — useful for CI/CD deploy keys.

```bash
curl -s https://raw.githubusercontent.com/The-Code-Labz/scripts/refs/heads/main/Automation-Scripts/make-ssh-keys/keygen.sh | bash
```

> ✅ Generates `ed25519` keypair. Saves to current directory or `/home/ssh_keygen` when piped.

---

### 🛠️ Ubuntu Server Setup

Full Ubuntu server baseline: updates packages, configures sudo, installs OpenSSH, hardens SSH.

```bash
curl -sSL https://raw.githubusercontent.com/The-Code-Labz/scripts/refs/heads/main/Automation-Scripts/setup/ubuntu/setup.sh | bash
```

> ⚠️ Run as the user you want to configure. Requires sudo access.

---

## 🗑️ Removal Scripts

### 🚪 Teleport Removal

#### Ubuntu / Debian
```bash
curl -sSL https://raw.githubusercontent.com/The-Code-Labz/scripts/refs/heads/main/Removal-Scripts/Teleport/ubuntu/uninstall.sh | bash
```

#### Oracle Linux
```bash
curl -sSL https://raw.githubusercontent.com/The-Code-Labz/scripts/refs/heads/main/Removal-Scripts/Teleport/oracle-linux/uninstall.sh | bash
```

> ✅ Removes Teleport package, purges config files, removes `/etc/teleport`, `/var/lib/teleport`, `/var/log/teleport`. Run as root.

---

## 🧪 Test Scripts

### 🔗 Test Git SSH Connectivity

Verifies that your SSH key is correctly configured for Git.

```bash
curl -s -o /tmp/test.sh https://raw.githubusercontent.com/The-Code-Labz/scripts/refs/heads/main/Test-Scripts/git-ssh-key/test.sh && bash /tmp/test.sh && rm -f /tmp/test.sh
```

---

## 🐛 Known Issues

| # | File | Issue | Status |
|---|---|---|---|
| 1 | `Docker/ubuntu/install.sh` | Previously used `docker.io` (outdated). Now uses official `docker-ce` repo | ✅ Fixed |
| 2 | `Podman/ubuntu/install.sh` | Previously called `podman machine init/start` (desktop only, fails on servers) | ✅ Fixed |
| 3 | `Podman/oracle linux/install.sh` | Same `podman machine` issue + space in folder name causes URL encoding | ✅ Fixed |
| 4 | `htpasswd/ubuntu/install.sh` | Previously had interactive prompts — not curl-pipeable | ✅ Fixed |
| 5 | `ssh_setup/ssh_setup.sh` | Previously had interactive prompts — now accepts public key as argument | ✅ Fixed |
| 6 | `make-ssh-keys/keygen.sh` | Previously spun up Docker container to run ssh-keygen. Now uses ed25519 natively | ✅ Fixed |
| 7 | `setup/ubuntu/setup.sh` | `PermitRootLogin prohibit-password` → should be `no` | ✅ Fixed |
| 8 | `Podman/ubuntu/README.md` | curl URL had wrong path `/Podman/install.sh` | ✅ Fixed |
| 9 | `Add User/Ubuntu/README.md` | Referenced wrong GitLab path | ✅ Fixed |
| 10 | `Teleport/ubuntu/README.md` | Referenced wrong install path instead of removal path | ✅ Fixed |
| 11 | `Teleport/oracle-linux/README.md` | Same wrong path issue | ✅ Fixed |

---

## 🤖 Ansible Equivalents

All scripts in this repository are being converted into fully idempotent **Ansible roles** in the [ansible](https://gitlab.neurolearninglabs.com/code-labz/ansible) repository.

| Script | Ansible Role |
|---|---|
| Docker install | `roles/docker` |
| Podman install | `roles/podman` |
| fail2ban install | `roles/security` |
| UFW install | `roles/security` |
| htpasswd install | `roles/htpasswd` |
| Terraform install | `roles/terraform_install` |
| code-server install | `roles/vscode` |
| Add User | `roles/common` |
| SSH setup + hardening | `roles/security` |
| Ubuntu server setup | `roles/common` |
| Teleport removal | `roles/teleport` |

---

## 📋 Requirements

- Bash 4+
- Ubuntu 20.04+ or Oracle Linux 8+
- Root or sudo access

---

*Maintained by [The-Code-Labz](https://github.com/The-Code-Labz)*
