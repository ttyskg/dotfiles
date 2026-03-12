#!/bin/bash

set -eu

# Default recipient
TO="${NOTIFY_EMAIL:-}"

# Default values
SUBJECT="Notification from $(hostname)"
BODY="This is an automated message from $(hostname)."

# Help message
show_help() {
  echo "Usage: $0 [OPTIONS]"
  echo
  echo "Send an email using msmtp with specified subject and body."
  echo "Set recipient with NOTIFY_EMAIL environment variable."
  echo
  echo "Options:"
  echo "  -s, --subject  SUBJECT   Email subject line"
  echo "  -b, --body     BODY      Email body text"
  echo "  -h, --help                Show this help message"
  exit 0
}

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    -s|--subject)
      if [[ $# -lt 2 ]]; then
        echo "Missing value for $1" >&2
        exit 1
      fi
      SUBJECT="$2"
      shift 2
      ;;
    -b|--body)
      if [[ $# -lt 2 ]]; then
        echo "Missing value for $1" >&2
        exit 1
      fi
      BODY="$2"
      shift 2
      ;;
    -h|--help)
      show_help
      ;;
    *)
      echo "Unknown option: $1" >&2
      show_help
      ;;
  esac
done

if ! command -v msmtp >/dev/null 2>&1; then
  echo "msmtp not found. Please install msmtp first." >&2
  exit 1
fi

if [[ -z "$TO" ]]; then
  echo "NOTIFY_EMAIL is not set. Configure it in ~/.bash_local." >&2
  exit 1
fi

# Send email
echo -e "To: $TO\nSubject: $SUBJECT\n\n$BODY" | msmtp "$TO"
