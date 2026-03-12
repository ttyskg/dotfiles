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
