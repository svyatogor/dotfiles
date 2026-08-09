# Repository Guidelines

## Structure

- `mise.toml` is the shared macOS Bootstrap declaration; `mise.home.toml` and `mise.work.toml` hold profile additions.
- `dotfiles/` mirrors `$HOME`. Keep linkable files here and use an explicit copy-mode entry for apps that rewrite their configuration.
- `profiles/` holds copied home/work-only configuration and the persisted Mise environment selector.
- `.config/mise/` defines portable CLI versions. `Brewfile` is the complete native macOS package inventory.
- `scripts/` contains small idempotent bootstrap helpers only.

## Commands

- `mise -E home bootstrap --dry-run` / `mise -E work bootstrap --dry-run` previews a profile without changing the machine.
- `mise -E home bootstrap` / `mise -E work bootstrap` applies a reviewed profile.
- `mise tasks validate` validates task declarations; do not use it as a substitute for a Bootstrap dry-run.

## Conventions

- Scope is macOS home and work only. Do not add Linux or devcontainer provisioning without explicit direction.
- Prefer native Mise capabilities for tools and dotfiles. Keep every macOS formula and cask in the single Brewfile so cleanup remains correct.
- Preserve `git-crypt` attributes when moving secret-backed files.
- Shell scripts use Bash with `set -euo pipefail`, two-space indentation, and quoted expansions.

## Validation

- Run the matching read-only Bootstrap dry-run before a PR.
- Never use `--force-dotfiles` without checking its target conflicts first.
- Follow Conventional Commit syntax when creating a commit.
