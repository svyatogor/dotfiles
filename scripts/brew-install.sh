#!/usr/bin/env bash
set -euo pipefail

echo "[brew] Starting Homebrew setup..."

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "[brew] This script is intended for macOS only." >&2
  exit 1
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "[brew] Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [[ -d "/opt/homebrew" ]]; then
  eval "$('/opt/homebrew/bin/brew' shellenv)"
elif [[ -d "/usr/local/Homebrew" ]]; then
  eval "$('/usr/local/bin/brew' shellenv)"
fi

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
brew_dir="${repo_root}/brew"
root_brewfile="${repo_root}/Brewfile"
context="${CONTEXT:-}"

echo "[brew] Preparing Brew bundle set..."
brewfiles=()
[[ -f "$root_brewfile" ]] && brewfiles+=("$root_brewfile")
[[ -f "$brew_dir/Brewfile.mac" ]] && brewfiles+=("$brew_dir/Brewfile.mac")
if [[ -n "$context" && -f "$brew_dir/Brewfile.mac-$context" ]]; then
  brewfiles+=("$brew_dir/Brewfile.mac-$context")
fi

if [[ ${#brewfiles[@]} -gt 0 ]]; then
  tmp_brewfile="$(mktemp)"
  trap 'rm -f "'"$tmp_brewfile"'"' EXIT
  printf "# Auto-generated merged Brewfile (mac + context)\n" > "$tmp_brewfile"
  for f in "${brewfiles[@]}"; do
    printf "\n# === %s ===\n" "$f" >> "$tmp_brewfile"
    cat "$f" >> "$tmp_brewfile"
  done
  echo "[brew] Running brew bundle with merged file (${#brewfiles[@]} layers)..."
  brew bundle --file="$tmp_brewfile"
  echo "[brew] Cleaning up packages not in merged Brewfile..."
  brew bundle cleanup --force --file="$tmp_brewfile"
  rm -f "$tmp_brewfile"
  trap - EXIT
else
  echo "[brew] No Brewfiles found to process. Skipping brew bundle."
fi

echo "[brew] Ensuring stow + mise present..."
brew list stow >/dev/null 2>&1 || brew install stow
brew list mise >/dev/null 2>&1 || brew install mise

echo "[brew] Homebrew setup complete."
