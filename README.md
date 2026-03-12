# dotfiles

This is my backup of my dotfiles.

## Bash startup files

- `.bashrc` contains shared interactive shell settings and is tracked in this repository.
- `.bash_profile` stays minimal and only loads `.bashrc` for login shells.
- `.bash_local` is optional for machine-specific settings and is not tracked by Git.

Load order on login shells:

1. `.bash_profile`
2. `.bashrc`
3. `.bash_local` (if present)

## Local secrets

- `.msmtprc` is copied to `~/` by `setup.sh` (not symlinked), so each device can keep its own password config.
- Add a password command in local `~/.msmtprc` (example: `passwordeval "pass show mail/gmail_app_password"`).
- Set `NOTIFY_EMAIL` in `~/.bash_local` for `bin/notify_me.sh`.
- Start from `.bash_local.example` in this repository for first-time setup.

First-time setup:

```bash
cp ~/.bash_local.example ~/.bash_local
```

Then edit `~/.bash_local` as needed.

Example:

```bash
export NOTIFY_EMAIL="your_email@example.com"
```

## Utilities

- `bin/wsl_port_forward.sh [port]` now validates WSL usage and defaults to port `2222`.
- `bin/clipboard.sh <file>` validates file and `clip.exe` before copying.
- `bin/clipboard_xclip.sh <file>` validates file and `xclip` before copying.

## Runtime notes

- `.bashrc` now sets `DISPLAY` only when running in WSL.
- SSH agent fallback restores from `~/.ssh/ssh-agent` and re-creates it only when needed.
- PATH entries for optional tools are added only when directories exist.

## Setup script

- Run `./setup.sh` for normal setup.
- Run `./setup.sh --dry-run` to preview changes without writing files.
- Run `./setup.sh --force` to overwrite copied local files such as `~/.msmtprc`.
