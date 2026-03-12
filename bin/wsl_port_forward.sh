#!/bin/bash

set -eu

PORT="${1:-2222}"

if ! grep -qiE 'microsoft|wsl' /proc/version 2>/dev/null; then
	echo "This script is only for WSL environments." >&2
	exit 1
fi

if ! command -v netsh.exe > /dev/null 2>&1; then
	echo "netsh.exe not found. Run this script in WSL with Windows PATH integration enabled." >&2
	exit 1
fi

IP=$(hostname -I | awk '{print $1}')
if [ -z "$IP" ]; then
	echo "Could not determine local WSL IP address." >&2
	exit 1
fi

netsh.exe interface portproxy delete v4tov4 "listenport=$PORT"
netsh.exe interface portproxy add v4tov4 "listenport=$PORT" "connectport=$PORT" "connectaddr=$IP"

echo "Port forwarding updated: Windows localhost:$PORT -> WSL $IP:$PORT"
