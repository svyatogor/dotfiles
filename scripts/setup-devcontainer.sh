#!/usr/bin/env bash
set -euo pipefail

echo "[devcontainer-setup] Installing base tooling + stowing configs..."

OS="$(uname -s)"

# install_with_apt() {
#   # Declarative install from apt lists
#   PROFILE=devcontainer bash "$(dirname "$0")/apt-install.sh"
#   # fd-find installs as fdfind on Debian/Ubuntu; symlink to fd if missing
#   if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
#     sudo ln -sf "$(command -v fdfind)" /usr/local/bin/fd
#   fi
# }

install_mise() {
  if command -v mise >/dev/null 2>&1; then
    return
  fi
  echo "[devcontainer-setup] Installing mise..."
  curl -fsSL https://mise.jdx.dev/install.sh | bash
  # ensure common install path is in PATH for this session
  export PATH="$HOME/.local/bin:$PATH"
}

install_stow_from_source() {
  local version="${1:-2.4.1}"
  if ! command -v wget >/dev/null 2>&1; then
    echo "[devcontainer-setup] wget is required to install GNU stow from source." >&2
    return 1
  fi

  local tmp_dir
  tmp_dir="$(mktemp -d)"
  (
    set -euo pipefail
    trap 'rm -rf "$tmp_dir"' EXIT
    cd "$tmp_dir"
    local archive="stow-${version}.tar.gz"
    local url="https://ftp.gnu.org/gnu/stow/${archive}"
    echo "[devcontainer-setup] Downloading GNU stow ${version}..."
    wget "$url"
    tar xvf "$archive"
    cd "stow-${version}"
    ./configure
    make
    sudo make install
  )
}

ensure_stow() {
  local required_version="2.4"
  local desired_version="2.4.1"
  local installed_version=""

  if command -v stow >/dev/null 2>&1; then
    installed_version="$(stow --version 2>/dev/null | head -n1 | awk '{print $NF}')"
    if [[ -n "$installed_version" ]] && [[ "$(printf '%s\n' "$required_version" "$installed_version" | sort -V | head -n1)" == "$required_version" ]]; then
      return 0
    fi
    echo "[devcontainer-setup] Found GNU stow ${installed_version:-unknown}; upgrading to ${desired_version}."
  else
    echo "[devcontainer-setup] GNU stow not found; installing ${desired_version}."
  fi

  if install_stow_from_source "$desired_version"; then
    hash -r
    return 0
  fi

  echo "[devcontainer-setup] Failed to install GNU stow ${desired_version}." >&2
  return 1
}

# case "$OS" in
#   Linux)
#     if command -v apt-get >/dev/null 2>&1; then
#       install_with_apt
#     fi
#     ;;
#   Darwin)
#     echo "[devcontainer-setup] On macOS? Consider running: make mac"
#     ;;
#   *) ;;
# esac

# Stow dotfiles
if ! ensure_stow; then
  echo "[devcontainer-setup] Continuing without stowing configs." >&2
fi
repo_root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$repo_root"
if ! command -v stow >/dev/null 2>&1; then
  echo "GNU stow not installed; skipping stow step." >&2
else
  # Override conflicts across packages; avoid --adopt to keep repo clean
  rm ~/.zsh* || true
  rm ~/.zprofile* || true
  rm ~/.bash* || true
  make stow
fi

# Install mise tools if present
install_mise || true
if command -v mise >/dev/null 2>&1; then
  mise self-update -y || true
  mise install || true
fi

if command -v tinty >/dev/null 2>&1; then
  tinty sync || true
  tinty init || true
fi

echo "[devcontainer-setup] Complete."
