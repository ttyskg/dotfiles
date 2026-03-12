#!/bin/sh

set -eu

if [ $# -ne 1 ]; then
	echo "Usage: $0 <file>" >&2
	exit 1
fi

if [ ! -f "$1" ]; then
	echo "File not found: $1" >&2
	exit 1
fi

if ! command -v xclip > /dev/null 2>&1; then
	echo "xclip not found." >&2
	exit 1
fi

cat "$1" | xclip -selection clipboard
