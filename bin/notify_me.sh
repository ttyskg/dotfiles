#!/bin/bash

# Default recipient
TO="tatsu100311@gmail.com"

# Default values
SUBJECT="Notification from $HOSTNAME"
BODY="This is an automated message from $HOSTNAME."

# Help message
show_help() {
  echo "Usage: $0 [OPTIONS]"
  echo
  echo "Send an email using msmtp with specified subject and body."
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
      SUBJECT="$2"
      shift 2
      ;;
    -b|--body)
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

# Send email
echo -e "To: $TO\nSubject: $SUBJECT\n\n$BODY" | msmtp "$TO"
