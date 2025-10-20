# Repository Guidelines

## Project Structure & Module Organization
- `Makefile` orchestrates bootstrap tasks and profile/context detection.
- `packages/common`, `packages/<profile>`, `packages/<context>`, and `packages/<profile>-<context>` hold GNU Stow packages; Git, shell, and mise config live in tool-named subdirectories.
- `scripts/` contains Bash helpers such as `bootstrap-mac.sh`, `brew-install.sh`, `setup-devcontainer.sh`, and `apt-install.sh`.
- `brew/` stores layered Brewfiles; the root `Brewfile` is the shared baseline; `assets/` carries fonts and other stowable artifacts.

## Build, Test & Development Commands
- `make` auto-selects mac/linux/devcontainer bootstrap and runs Homebrew, Stow, and mise steps.
- `make list` prints the active profile/context along with discovered packages; override with `PROFILE=mac CONTEXT=work make list`.
- `make stow` / `make unstow` link or unlink every package for the current profile; use `STOW_OVERRIDE` or `STOW_ADOPT=1` as needed.
- `make brew`, `make devcontainer`, and `make apt-install` execute platform-specific installers.
- `make check` runs the `list` target and surfaces tool versions for quick validation.

## Coding Style & Naming Conventions
- Shell scripts target modern Bash with `set -euo pipefail`, two-space indentation, `[[ ... ]]` conditionals, and double-quoted expansions.
- Script names describe the task (`bootstrap-mac`, `apt-install`); keep new helpers under `scripts/` and mark executables with the `.sh` suffix when they rely on Bash.
- Stow package folders mirror the destination tool name (`packages/common/nvim`, `packages/mac/homebrew`); dotfiles or templates go inside the package root with their final names.

## Testing Guidelines
- Run `make check` before opening a PR; for targeted stacks, rerun `make stow` in a clean shell and inspect the resulting symlinks.
- On macOS, execute `make brew` after updating any Brewfile to ensure bundle resolution; on Debian-based systems, exercise `scripts/apt-install.sh FILES=...` with the intended lists.

## Commit & Pull Request Guidelines
- Follow the prevailing Conventional Commit syntax (`feat(mise): ...`, `chore(config): ...`); include a focused verb phrase and scope when applicable.
- Summaries should describe the infrastructure change and affected profile/context; avoid generic bodies like "update".
- PRs should mention which make targets were run, highlight new packages introduced, and call out any manual post-install steps. Attach command logs or screenshots when tweaking UI-facing assets.
