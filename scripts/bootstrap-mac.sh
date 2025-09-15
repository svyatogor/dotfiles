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

echo "[bootstrap-mac] Preparing Brew bundle set..."
CONTEXT=${CONTEXT:-}
repo_root="$(cd "$(dirname "$0")/.." && pwd)"
brew_dir="${repo_root}/brew"
root_brewfile="${repo_root}/Brewfile"

brewfiles=()
[[ -f "$root_brewfile" ]] && brewfiles+=("$root_brewfile")
[[ -f "$brew_dir/Brewfile.mac" ]] && brewfiles+=("$brew_dir/Brewfile.mac")
if [[ -n "$CONTEXT" && -f "$brew_dir/Brewfile.mac-$CONTEXT" ]]; then
  brewfiles+=("$brew_dir/Brewfile.mac-$CONTEXT")
fi

if [[ ${#brewfiles[@]} -gt 0 ]]; then
  tmp_brewfile="$(mktemp)"
  printf "# Auto-generated merged Brewfile (mac + context)\n" > "$tmp_brewfile"
  for f in "${brewfiles[@]}"; do
    printf "\n# === %s ===\n" "$f" >> "$tmp_brewfile"
    cat "$f" >> "$tmp_brewfile"
  done
  echo "[bootstrap-mac] Running brew bundle with merged file (${#brewfiles[@]} layers)..."
  brew bundle --file="$tmp_brewfile"
  echo "[bootstrap-mac] Cleaning up packages not in merged Brewfile..."
  brew bundle cleanup --force --file="$tmp_brewfile"
else
  echo "[bootstrap-mac] No Brewfiles found to process. Skipping brew bundle."
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
