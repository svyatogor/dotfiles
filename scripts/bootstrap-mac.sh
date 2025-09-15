#!/usr/bin/env bash
set -euo pipefail

echo "[bootstrap-mac] Starting macOS bootstrap..."

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This script is for macOS only." >&2
  exit 1
fi

# Install Homebrew if missing
if ! command -v brew >/dev/null 2>&1; then
  echo "[bootstrap-mac] Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Ensure brew in PATH for current shell
if [[ -d "/opt/homebrew" ]]; then
  eval "$('/opt/homebrew/bin/brew' shellenv)"
elif [[ -d "/usr/local/Homebrew" ]]; then
  eval "$('/usr/local/bin/brew' shellenv)"
fi

echo "[bootstrap-mac] Running Brew Bundle..."
brew bundle --file="$(dirname "$0")/../Brewfile"

# Initialize fzf key bindings (no prompts)
if [[ -x "$(brew --prefix)/opt/fzf/install" ]]; then
  yes | "$(brew --prefix)"/opt/fzf/install --key-bindings --completion --no-bash --no-fish || true
fi

echo "[bootstrap-mac] Ensuring stow + mise present..."
brew list stow >/dev/null 2>&1 || brew install stow
brew list mise >/dev/null 2>&1 || brew install mise

echo "[bootstrap-mac] Stowing dotfiles..."
repo_root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$repo_root"
make stow

echo "[bootstrap-mac] Installing mise tools..."
if command -v mise >/dev/null 2>&1; then
  mise install || true
fi

echo "[bootstrap-mac] Done. Consider restarting your terminal."

