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

- Persistent undo lives in `~/.cache/vim/undo`.
- `\y` copies the visual selection, or in normal mode the whole buffer,
  through `clip.exe` or `xclip`. The Debian `vim` package is built without
  `+clipboard`, so yanks cannot reach the system clipboard on their own.
- The mouse is off, so dragging still selects text at the terminal level.
- `.vimrc` is the only Vim file here. `~/.vim` belongs to Vim itself and is no
  longer symlinked into this repository.

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

## tmux

- The prefix is `C-a`; `|` and `-` split, `h`/`j`/`k`/`l` move between panes and
  `H`/`J`/`K`/`L` resize them, `r` reloads the config.
- Copy mode uses vi keys: `v` selects, `C-v` toggles a rectangle, `y` copies.
  On WSL `y` and mouse-drag also put the text on the Windows clipboard.
- `default-terminal` is `tmux-256color` and `terminal-overrides` carries `Tc`,
  so 24-bit colour reaches programs inside panes. `COLORTERM` is forwarded from
  the attaching client, which is how Vim decides to switch `termguicolors` on.

## herdr

`config/herdr/config.toml` is symlinked to `~/.config/herdr/config.toml`. The
rest of `~/.config/herdr` — logs, sockets, `session.json` — is runtime state and
is deliberately not tracked, which is why `setup.sh` links the file rather than
the directory.

The bindings follow `.tmux.conf` where the two disagree, and stay at herdr's
defaults where they already agree:

| | tmux | herdr |
| --- | --- | --- |
| prefix | `C-a` | `C-a` (herdr's own default is `C-b`) |
| split | `\|` and `-` | `\|` and `-` |
| pane focus / resize | `h`/`j`/`k`/`l`, `H`/`J`/`K`/`L` | the same, but resizing does not repeat; `prefix r` opens resize mode |
| detach | `prefix d` | `prefix q` |
| reload | `prefix r` | `prefix shift+R`, or `herdr server reload-config` |

`herdr config check` validates the file before a reload.

What did not carry over from tmux: there is no `synchronize-panes`, no paste
binding to match `prefix ]`, and no `escape-time` equivalent — herdr holds a
lone `Esc` for one flush and the delay is not configurable. Copy mode has vi
motions built in but its keys cannot be rebound, and copying leaves through
OSC 52 to the outer terminal instead of a pipe to `clip.exe`.

## Utilities

Installed by `setup.sh` into `~/.local/bin`, with any `.sh`/`.py` suffix
stripped:

| command | what it does |
| --- | --- |
| `clipboard [-x] [FILE]` | Copy a file or stdin to the clipboard: `clip.exe`, `wl-copy`, `xclip` or `xsel`, first one found. `-x` skips `clip.exe`. Aliased to `cb` / `cbx`. |
| `wsl_port_forward [PORT]` | Forward `localhost:PORT` on Windows to this WSL instance. Defaults to `2222`. |
| `notify_me [-s SUBJECT] [-b BODY]` | Send mail through `msmtp` to `$NOTIFY_EMAIL`. |
| `fix-jis-names [-r] [--apply] [PATH...]` | Restore Japanese filenames mangled by a CP437 misread. Dry run unless `--apply`. |
| `make_vs_devcontainer [--force]` | Write a `.devcontainer/` (Python image, Compose, ruff/mypy/pytest) into the current directory. |

## Runtime notes

- `.bashrc` sets `DISPLAY` only when running in WSL.
- SSH agent: login shells start it (`keychain`, or a plain `ssh-agent` fallback).
  *Every* shell, non-interactive ones included, then adopts an agent that is
  already running, so `git push` works from scripts and CLI agents without
  sourcing anything by hand. `~/.keychain/<host>-sh` takes precedence over the
  older `~/.ssh/ssh-agent`, and a socket that no longer exists is discarded.
- PATH entries for optional tools are added only when directories exist.
- `.dircolors` is the `dircolors.ansi-dark` theme vendored from
  seebi/dircolors-solarized.
- `.gitconfig` sets `pull.ff = only`, so a diverged `git pull` stops rather
  than creating a merge commit; reconcile with `git pull --rebase` or
  `git merge`. New repositories get `main` as the default branch.

## Setup script

- Run `./setup.sh` for normal setup.
- Run `./setup.sh --dry-run` to preview changes without writing files.
- Run `./setup.sh --force` to overwrite copied local files such as `~/.msmtprc`.

It links from three places: dotfiles at the repository root go to `~/`, `bin/*`
goes to `~/.local/bin` with any `.sh`/`.py` suffix stripped, and the tree under
`config/` is mirrored file by file into `$XDG_CONFIG_HOME` (`~/.config`).
