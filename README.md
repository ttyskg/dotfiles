# dotfiles

This is my backup of my dotfiles.

## Bash startup files

- `.bashrc` is tracked here and is split into two parts:
  - settings for **every** shell (PATH, exported variables, `umask`), and
  - settings for **interactive** shells only (history, prompt, aliases,
    completion, `set -o vi`, `CDPATH`, keychain).
- `.bash_profile` stays minimal and only loads `.bashrc` for login shells.
- `.bashrc.local` is optional for machine-specific settings and is not tracked
  by Git.

Load order on login shells:

1. `.bash_profile`
2. `.bashrc`
3. `.bashrc.local` (if present)

## Local secrets

- `.msmtprc` is copied to `~/` by `setup.sh` (not symlinked), so each device can keep its own password config.
- Add a password command in local `~/.msmtprc` (example: `passwordeval "pass show mail/gmail_app_password"`).
- Set `NOTIFY_EMAIL` in `~/.bashrc.local` for `bin/notify_me.sh`.
- Start from `.bashrc.local.example` in this repository for first-time setup.

First-time setup (from the repository root):

```bash
cp .bashrc.local.example ~/.bashrc.local
```

Then edit `~/.bashrc.local` as needed.

Example:

```bash
export NOTIFY_EMAIL="your_email@example.com"
```

## Utilities

- `bin/wsl_port_forward.sh [port]` now validates WSL usage and defaults to port `2222`.
- `bin/clipboard.sh <file>` validates file and `clip.exe` before copying.
- `bin/clipboard_xclip.sh <file>` validates file and `xclip` before copying.

## Runtime notes

- `.bashrc` sets `DISPLAY` only when running in WSL.
- SSH agent: login shells start it (`keychain`, or a plain `ssh-agent` fallback).
  *Every* shell, non-interactive ones included, then adopts an agent that is
  already running, so `git push` works from scripts and CLI agents without
  sourcing anything by hand. `~/.keychain/<host>-sh` takes precedence over the
  older `~/.ssh/ssh-agent`, and a socket that no longer exists is discarded.
- PATH entries for optional tools are added only when directories exist.

## Setup script

- Run `./setup.sh` for normal setup.
- Run `./setup.sh --dry-run` to preview changes without writing files.
- Run `./setup.sh --force` to overwrite copied local files such as `~/.msmtprc`.
