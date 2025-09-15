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
- `packages/` – stow packages (each subfolder is one package):
  - `bash/` → `~/.bashrc`, `~/.bash_profile`
  - `zsh/` → `~/.zsh*`
  - `git/` → `~/.git*`
  - `starship/` → `~/.config/starship.toml`
  - `direnv/` → `~/.config/direnv/direnvrc`
  - `mise/` → `~/.config/mise/config.toml`
  - `tmux/` → `~/.tmux.conf`
  - `nvim/` → `~/.config/nvim/init.lua` (lightweight starter)

You can freely add/remove stow packages. Each top‑level directory is a unit you can `stow` independently.

## Common commands

- `make mac` – Bootstrap a mac (Homebrew + Brewfile + stow)
- `make devcontainer` – Setup in a Dev Container / Linux image
- `make stow` – Stow all packages in this repo
- `make unstow` – Unstow all packages
- `make brew-dump` – Refresh `Brewfile` from current mac
- `make mise-install` – Install tools defined in mise config

## Notes

- Platform-specific tweaks are kept minimal and done via small conditionals in shell configs.
- `~/.gitconfig.local` is intentionally ignored – keep personal identity/tokens there.
- `mise` integrates with `direnv` automatically via `direnvrc`.
- Stow reads `packages/.stow-global-ignore` so meta files aren’t linked.
- Prefer Bash across environments. On macOS, you can switch to Homebrew Bash:
  - `brew install bash` (already in Brewfile)
  - `sudo bash -c 'echo /opt/homebrew/bin/bash >> /etc/shells'` (Apple Silicon)
  - `chsh -s /opt/homebrew/bin/bash`
