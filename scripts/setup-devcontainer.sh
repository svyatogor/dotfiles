#!/usr/bin/env bash
set -euo pipefail

echo "[devcontainer-setup] Installing base tooling + stowing configs..."

OS="$(uname -s)"

install_with_apt() {
  # Declarative install from apt lists
  PROFILE=devcontainer bash "$(dirname "$0")/apt-install.sh"
  # fd-find installs as fdfind on Debian/Ubuntu; symlink to fd if missing
  if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
    sudo ln -sf "$(command -v fdfind)" /usr/local/bin/fd
  fi
}

install_mise() {
  if command -v mise >/dev/null 2>&1; then
    return
  fi
  echo "[devcontainer-setup] Installing mise..."
  curl -fsSL https://mise.jdx.dev/install.sh | bash
  # ensure common install path is in PATH for this session
  export PATH="$HOME/.local/bin:$PATH"
}

case "$OS" in
  Linux)
    if command -v apt-get >/dev/null 2>&1; then
      install_with_apt
    fi
    ;;
  Darwin)
    echo "[devcontainer-setup] On macOS? Consider running: make mac"
    ;;
  *) ;;
esac

# Stow dotfiles
repo_root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$repo_root"
if ! command -v stow >/dev/null 2>&1; then
  echo "GNU stow not installed; skipping stow step." >&2
else
  # Override conflicts across packages; avoid --adopt to keep repo clean
  rm ~/.zsh* || true
  rm ~/.zprofile* || true
  rm ~/.bash* || true
  PROFILE=devcontainer STOW_OVERRIDE='.*' make stow
fi

# Install mise tools if present
install_mise || true
if command -v mise >/dev/null 2>&1; then
  mise install || true
fi

echo "[devcontainer-setup] Complete."
