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

## Vim

Plugin-free on purpose: VS Code does the multi-file editing, Vim only has to
handle quick viewing and small edits in a terminal. `.vimrc` sources Vim's own
`defaults.vim` and adds, in place of the plugins that used to live here:

| was | now |
| --- | --- |
| NERDTree | netrw in tree mode, still toggled with `Ctrl-N` |
| indentLine | indent guides via `listchars` `leadmultispace` |
| lightline.vim | a hand-written `statusline` |
| vim-colors-solarized | `habamax`, bundled with Vim 9 |
| UltiSnips | nothing |

Also worth knowing:

- Persistent undo lives in `~/.cache/vim/undo`, deliberately outside this
  repository (`~/.vim` is a symlink into it).
- `\y` copies the visual selection, or in normal mode the whole buffer,
  through `clip.exe` or `xclip`. The Debian `vim` package is built without
  `+clipboard`, so yanks cannot reach the system clipboard on their own.
- The mouse is off, so dragging still selects text at the terminal level.
- `.vim/UltiSnips/python.snippets` is a leftover from UltiSnips and is unused.

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
