#!/bin/sh
#
# Copy a file, or standard input, to the system clipboard.
#
#   clipboard FILE
#   command | clipboard
#   clipboard -x FILE     skip clip.exe and use the X11/Wayland clipboard
#
# Backends are tried in order: clip.exe (WSL), wl-copy (Wayland), xclip,
# xsel. On WSL clip.exe wins, because that is the clipboard Windows
# applications actually read; -x is there for the X11 side.

set -eu

usage() {
	echo "Usage: clipboard [-x] [FILE]" >&2
	echo "       command | clipboard [-x]" >&2
}

use_x11=false

while [ $# -gt 0 ]; do
	case "$1" in
		-x|--x11)
			use_x11=true
			shift
			;;
		-h|--help)
			usage
			exit 0
			;;
		--)
			shift
			break
			;;
		-*)
			echo "Unknown option: $1" >&2
			usage
			exit 1
			;;
		*)
			break
			;;
	esac
done

if [ $# -gt 1 ]; then
	usage
	exit 1
fi

if [ $# -eq 1 ]; then
	if [ ! -f "$1" ]; then
		echo "File not found: $1" >&2
		exit 1
	fi
	exec < "$1"
elif [ -t 0 ]; then
	echo "Nothing to copy: pass a file or pipe something in." >&2
	usage
	exit 1
fi

if [ "$use_x11" = false ] && command -v clip.exe > /dev/null 2>&1; then
	exec clip.exe
elif command -v wl-copy > /dev/null 2>&1; then
	exec wl-copy
elif command -v xclip > /dev/null 2>&1; then
	exec xclip -selection clipboard
elif command -v xsel > /dev/null 2>&1; then
	exec xsel --clipboard --input
fi

echo "No clipboard command found (tried clip.exe, wl-copy, xclip, xsel)." >&2
exit 1
