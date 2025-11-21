#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMPLATE_FILE="$SCRIPT_DIR/secrets-template.sh"
SECRETS_FILE="$HOME/.local/share/secrets.sh"

echo "Extracting secrets from 1Password..."

# Check if op CLI is available
if ! command -v op &>/dev/null; then
  echo "Warning: 1Password CLI not found; skipping secret extraction" >&2
  exit 0
fi

# Check if authenticated
if ! op account get &>/dev/null; then
  echo "Warning: Not authenticated with 1Password CLI; skipping secret extraction" >&2
  echo "To extract secrets, run: eval \$(op signin)" >&2
  exit 0
fi

# Check if template file exists
if [[ ! -f "$TEMPLATE_FILE" ]]; then
  echo "Error: Template file not found: $TEMPLATE_FILE" >&2
  exit 1
fi

# Ensure the directory exists
mkdir -p "$(dirname "$SECRETS_FILE")"

# Use op inject to resolve all secrets and write directly to file
if op inject -i "$TEMPLATE_FILE" -o "$SECRETS_FILE"; then
  echo "Secrets extracted to $SECRETS_FILE"
else
  echo "Error: Failed to inject secrets from 1Password" >&2
  exit 1
fi
