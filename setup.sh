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

run_cmd mkdir -p "$HOME/bin"

for f in bin/*; do
  [[ "$f" == *.example ]] && continue
  run_cmd ln -snfv "$THIS_DIR/$f" "$HOME/bin/$(basename "$f")"
done

echo "finished!"
