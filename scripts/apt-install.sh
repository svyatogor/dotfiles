#!/usr/bin/env bash
set -euo pipefail

# Declarative apt installer.
# Reads package lists from profile-aware locations and installs them via apt.
# - PROFILE: selects additional root under packages/<PROFILE> (default: linux on non-mac, mac otherwise)
# - FILES: optional explicit files to read (space-separated). If set, PROFILE roots are ignored.
#
# Each file format:
# - One package name per line
# - Comments start with '#'
# - Blank lines are ignored

PROFILE=${PROFILE:-}
CONTEXT=${CONTEXT:-}
UNAME_S="$(uname -s)"
if [[ -z "${PROFILE}" ]]; then
  if [[ "${UNAME_S}" == "Darwin" ]]; then
    PROFILE="mac"
  else
    PROFILE="linux"
  fi
fi

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PACKAGES_DIR="${REPO_ROOT}/packages"

declare -a FILES_ARR=()
if [[ "${FILES:-}" != "" ]]; then
  # Use explicit files if provided
  # shellcheck disable=SC2206
  FILES_ARR=(${FILES})
else
  # Discover default apt lists for common, profile, context, and profile-context roots
  [[ -f "${PACKAGES_DIR}/common/apt.txt" ]] && FILES_ARR+=("${PACKAGES_DIR}/common/apt.txt")
  [[ -f "${PACKAGES_DIR}/${PROFILE}/apt.txt" ]] && FILES_ARR+=("${PACKAGES_DIR}/${PROFILE}/apt.txt")
  if [[ -n "${CONTEXT}" ]]; then
    [[ -f "${PACKAGES_DIR}/${CONTEXT}/apt.txt" ]] && FILES_ARR+=("${PACKAGES_DIR}/${CONTEXT}/apt.txt")
    [[ -f "${PACKAGES_DIR}/${PROFILE}-${CONTEXT}/apt.txt" ]] && FILES_ARR+=("${PACKAGES_DIR}/${PROFILE}-${CONTEXT}/apt.txt")
  fi
fi

if [[ ${#FILES_ARR[@]} -eq 0 ]]; then
  echo "[apt-install] No apt package files found. Skipping." >&2
  exit 0
fi

if ! command -v apt-get >/dev/null 2>&1; then
  echo "[apt-install] apt-get not found. This script targets Debian/Ubuntu." >&2
  exit 0
fi

echo "[apt-install] Using files:"
for f in "${FILES_ARR[@]}"; do echo "  - ${f}"; done

# Merge, normalize, and dedupe package names
mapfile -t PACKAGES < <(cat "${FILES_ARR[@]}" \
  | sed -E 's/#.*$//' \
  | tr -d '\r' \
  | awk 'NF' \
  | sort -u)

if [[ ${#PACKAGES[@]} -eq 0 ]]; then
  echo "[apt-install] No packages to install after filtering." >&2
  exit 0
fi

echo "[apt-install] Will install: ${PACKAGES[*]}"

sudo apt-get update -y
sudo apt-get install -y "${PACKAGES[@]}"

echo "[apt-install] Done."
