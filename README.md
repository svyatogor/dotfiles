# Dotfiles (stow + Homebrew + mise)

This repo manages my cross‑platform dotfiles with GNU Stow, Homebrew (on macOS), and mise for dev toolchains. It targets macOS (personal and home), Linux, and Dev Containers.

## Quick start

- Clone the repo to `~/dotfiles` (or any path).
- On macOS: `make mac` to bootstrap brew, install packages, and stow configs.
- In a Dev Container or Linux: `make devcontainer` to install basics and stow configs.
- To (un)link configs: `make stow` / `make unstow`.

## Structure

- `scripts/` – bootstrap and setup scripts
- `Brewfile` – Homebrew formulas/casks for macOS
- `Makefile` – orchestration for common tasks
- `packages/` – stow packages grouped by profile:
  - `packages/common/` – cross‑platform packages (stowed everywhere)
  - `packages/mac/` – macOS‑only packages
  - `packages/devcontainer/` – devcontainer‑only packages
  - Example packages under `common/`:
    - `bash/` → `~/.bashrc`, `~/.bash_profile`
    - `git/` → `~/.config/git/*` or `~/.git*`
    - `starship/` → `~/.config/starship.toml`
    - `direnv/` → `~/.config/direnv/direnvrc`
    - `mise/` → `~/.config/mise/config.toml`
    - `tmux/` → `~/.tmux.conf`
    - `nvim/` → `~/.config/nvim/**`

You can freely add/remove stow packages. Each top‑level directory is a unit you can `stow` independently.

## Common commands

- `make mac` – Bootstrap a mac (Homebrew + Brewfile + stow)
- `make devcontainer` – Setup in a Dev Container / Linux image
- `make stow` – Stow all packages in this repo
- `make unstow` – Unstow all packages
- `make brew-dump` – Refresh `Brewfile` from current mac
- `make mise-install` – Install tools defined in mise config
- `make apt-install` – Install apt packages from profile lists

## Notes

- Platform-specific tweaks are kept minimal and done via small conditionals in shell configs.
- `~/.gitconfig.local` is intentionally ignored – keep personal identity/tokens there.
- `mise` integrates with `direnv` automatically via `direnvrc`.
- Each profile root has its own `.stow-global-ignore` so meta files aren’t linked.
- Prefer Bash across environments. On macOS, you can switch to Homebrew Bash:
  - `brew install bash` (already in Brewfile)
  - `sudo bash -c 'echo /opt/homebrew/bin/bash >> /etc/shells'` (Apple Silicon)
  - `chsh -s /opt/homebrew/bin/bash`

### Declarative apt (Linux/devcontainers)

- Define baseline packages in `packages/common/apt.txt`.
- Add environment-specific packages in `packages/devcontainer/apt.txt` or create `packages/linux/apt.txt`.
- Install with `make apt-install` or directly `scripts/apt-install.sh`.
- Lines are packages, `#` are comments; duplicates are deduped.

### Custom Scripts in PATH

- Place your scripts under `packages/common/bin/.local/bin/` and make them executable.
- Run `make stow` to link them into `~/.local/bin/`.
- `~/.local/bin` is already included in the provided shell PATH.
