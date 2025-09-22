#!/usr/bin/env bash
set -euo pipefail

echo "[bootstrap-mac] Starting macOS bootstrap..."

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This script is for macOS only." >&2
  exit 1
fi

CONTEXT=${CONTEXT:-}
repo_root="$(cd "$(dirname "$0")/.." && pwd)"

echo "[bootstrap-mac] Running make brew..."
CONTEXT="$CONTEXT" make -C "$repo_root" brew
eval "$(/opt/homebrew/bin/brew shellenv)"

echo "[bootstrap-mac] Stowing dotfiles..."
cd "$repo_root"
make stow

echo "[bootstrap-mac] Installing mise tools..."
if command -v mise >/dev/null 2>&1; then
  mise self-update -y || true
  mise install || true
fi

echo /opt/homebrew/bin/bash | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/bash

echo "[bootstrap-mac] Done. Consider restarting your terminal."
