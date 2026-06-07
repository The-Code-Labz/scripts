# setup-sudo-user

Grants an existing Linux user full passwordless sudo access.

## What it does

1. Adds the user to the `sudo` group via `usermod -aG sudo`
2. Writes a sudoers drop-in file to `/etc/sudoers.d/<username>`
3. Sets correct permissions (`440`) on the drop-in file
4. Validates the sudoers syntax with `visudo` before finalizing

If validation fails, the script removes the invalid file and exits with an error — it will not leave a broken sudoers state behind.

## Usage

```bash
sudo ./grant-sudo.sh <username>
```

**Example:**

```bash
sudo ./grant-sudo.sh dlynton
```

## Requirements

- Must be run as root or with `sudo`
- The target user must already exist on the system
- `visudo` must be available (`sudo` package)

## Security Notes

- The drop-in file uses `NOPASSWD:ALL` — grant this only to trusted users
- File permissions are set to `440` (read-only, owner/group root) as required by sudoers
- Syntax is validated before the file is left in place
