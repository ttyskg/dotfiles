#!/bin/bash

set -eu

DRY_RUN=false
FORCE=false

show_help() {
  echo "Usage: $0 [--dry-run] [--force]"
  echo
  echo "  --dry-run   Print actions without changing files"
  echo "  --force     Overwrite local copied files (.msmtprc)"
}

run_cmd() {
  if [ "$DRY_RUN" = true ]; then
    echo "[dry-run] $*"
  else
    "$@"
  fi
}

while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run)
      DRY_RUN=true
      ;;
    --force)
      FORCE=true
      ;;
    -h|--help)
      show_help
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      show_help
      exit 1
      ;;
  esac
  shift
done

THIS_DIR="$(cd "$(dirname "$0")" && pwd)"

cd "$THIS_DIR"

echo "start setup..."

for f in .??*; do
  # Ignore files
  [[ "$f" == .git ]] && continue
  [[ "$f" == .gitignore ]] && continue
  [[ "$f" == .gitmodules ]] && continue
  [[ "$f" == *.example ]] && continue
  # .vscode here is the workspace setting for THIS repository.
  # $HOME/.vscode is a real directory owned by VS Code itself, so never link it.
  [[ "$f" == .vscode ]] && continue

  # Copy file instead of symlink. They could contain sensitive information.
  # Therefore, they will be modified after copying to HOME.
  if [[ "$f" == .msmtprc ]]; then
    if [ "$FORCE" = true ]; then
      run_cmd cp -vf "$THIS_DIR/$f" "$HOME/$f"
    else
      run_cmd cp -vn "$THIS_DIR/$f" "$HOME/$f"
    fi
    run_cmd chmod 600 "$HOME/$f"
    continue
  fi

  # Make symbolic links of dotfile to HOME
  run_cmd ln -snfv "$THIS_DIR/$f" "$HOME/$f"
done

# Make symbolic links of bin/* to $HOME/.local/bin
run_cmd mkdir -p "$HOME/.local/bin"

for f in bin/*; do
  [[ "$f" == *.example ]] && continue
  bin_name="$(basename "$f")"
  bin_name="${bin_name%.sh}"
  bin_name="${bin_name%.py}"
  run_cmd ln -snfv "$THIS_DIR/$f" "$HOME/.local/bin/$bin_name"
done

# Make symbolic links of config/* to $XDG_CONFIG_HOME, mirroring the tree
# below config/. These are linked file by file rather than directory by
# directory: ~/.config/herdr, for one, also holds logs, sockets and
# session.json, which are runtime state and must stay out of this repository.
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

find config -type f ! -name '*.example' | while IFS= read -r f; do
  rel="${f#config/}"
  run_cmd mkdir -p "$XDG_CONFIG_HOME/$(dirname "$rel")"
  run_cmd ln -snfv "$THIS_DIR/$f" "$XDG_CONFIG_HOME/$rel"
done

echo "finished!"
