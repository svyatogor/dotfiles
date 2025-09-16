# Dotfiles (stow + Homebrew + mise)

This repo manages my cross-platform dotfiles with GNU Stow, Homebrew (on macOS), and mise for toolchains. It targets macOS (home/work contexts), Linux, devcontainers, and WSL-style setups.

## Quick start

- Clone the repo to `~/dotfiles` (or any path) and `cd` into it.
- Run `make` to bootstrap the current platform. The default goal detects the profile:
  - macOS runs Homebrew bundle + cleanup, then stows dotfiles and installs mise tools.
  - Linux or WSL stows dotfiles and runs `mise install`.
  - In devcontainers set `PROFILE=devcontainer` (or run `make devcontainer`) for container-appropriate setup.
- Re-run `make` whenever you add packages or update mise tool definitions.

You can override `PROFILE` (`mac`, `linux`, `devcontainer`) and `CONTEXT` (`home`, `work`, …) per invocation, e.g. `make CONTEXT=work`.

## Repository layout

- `Makefile` – orchestration for bootstrap, stow, tooling installs, and context helpers.
- `scripts/` – helper scripts used by the make targets (see below for details).
- `packages/` – GNU Stow packages arranged by scope:
  - `packages/common/` – shared across every machine.
  - `packages/<profile>/` – profile-specific (e.g. `mac/`, `devcontainer/`).
  - `packages/<context>/` – optional persona overrides (e.g. `home/`, `work/`).
  - `packages/<profile>-<context>/` – combined overrides when both apply.
  - Example packages under `common/`: `bash/`, `git/`, `direnv/`, `mise/`, `starship/`, `tmux/`, `nvim/`.
- `Brewfile` – base Homebrew bundle for all macOS installs.
- `brew/` – layered Brewfiles (`Brewfile.mac`, `Brewfile.mac-work`, …) merged on demand.
- `assets/` – supporting files such as fonts synced by stow.

Each directory inside a stow root is an independent package; add or remove directories to control what gets linked.

## Scripts

- `scripts/bootstrap-mac.sh` – end-to-end macOS bootstrap (brew, stow, mise) used by `make mac`.
- `scripts/brew-install.sh` – ensures Homebrew is installed, merges layered Brewfiles, runs `brew bundle`, and cleans unused packages.
- `scripts/setup-devcontainer.sh` – convenience bootstrap for devcontainers/WSL; stows dotfiles and installs mise when available.
- `scripts/apt-install.sh` – declarative APT installer that merges profile/context package lists and installs them via `apt-get`.

These helpers respect the same `PROFILE`/`CONTEXT` environment variables as the Makefile.

## Make targets

- `make` / `make bootstrap` – default goal; runs brew+stow+mise on macOS, stow+mise on Linux/WSL, or `devcontainer` + stow + mise when `PROFILE=devcontainer`.
- `make mac` – macOS bootstrap wrapper using `scripts/bootstrap-mac.sh`.
- `make devcontainer` – devcontainer bootstrap wrapper.
- `make brew` – install Homebrew if needed and run the layered bundle.
- `make stow` / `make unstow` – link or unlink every discovered package for the active profile/context.
- `make mise-install` – install toolchains defined in `mise/config.toml`.
- `make apt-install` – apply the declarative apt package lists.
- `make brew-dump` – refresh the root `Brewfile` from the current mac.
- `make list` – show the active profile, context, and packages that will be stowed.
- `make check` – lightweight diagnostic (profile+context info plus tool versions).
- `make set-context`, `make show-context`, `make clear-context` – manage the persisted context file under `~/.config/dotfiles-v2/`.

You can pass `STOW_OVERRIDE` (regex) to resolve conflicts or `STOW_ADOPT=1` to pull existing files into the repo when stowing.

## Notes

- Platform-specific tweaks are intentionally small and handled inside the stowed shell configs.
- `~/.gitconfig.local` stays untracked for personal identity/tokens.
- `mise` integrates with `direnv` via the provided `direnvrc`.
- Each stow root ships its own `.stow-global-ignore` so helper files aren’t linked.
- Prefer Bash across environments. On macOS you can switch to Homebrew Bash:
  - `brew install bash`
  - `sudo bash -c 'echo /opt/homebrew/bin/bash >> /etc/shells'` (Apple Silicon)
  - `chsh -s /opt/homebrew/bin/bash`

### Declarative apt (Linux/devcontainers)

- Define baseline packages in `packages/common/apt.txt`.
- Add profile/context packages in `packages/<profile>/apt.txt`, `packages/<context>/apt.txt`, or `packages/<profile>-<context>/apt.txt`.
- Install with `make apt-install` or directly via `scripts/apt-install.sh`.
- Lines are package names; `#` comments and blank lines are ignored before deduping.

### Custom scripts in PATH

- Place executable scripts under `packages/common/bin/.local/bin/` (or another stow package).
- Run `make stow` to link them into `~/.local/bin/`.
- `~/.local/bin` is already included in the shell PATH that ships with these dotfiles.
