# Dotfiles

macOS workstation setup for `home` and `work`, orchestrated by [Mise Bootstrap](https://mise.jdx.dev/bootstrap.html). Mise owns portable tools and dotfiles; one Brewfile owns all native macOS packages.

## Profiles

From this checkout, preview the selected profile:

```sh
mise -E home bootstrap --dry-run
mise -E work bootstrap --dry-run
```

After reviewing the preview, apply it on the target Mac:

```sh
mise -E home bootstrap
mise -E work bootstrap
```

The bootstrap requires mise `2026.8.3` or newer and Homebrew. It installs portable CLI tools through Mise, clones Zinit and TPM, deploys dotfiles, converges the selected Brewfile inventory, removes undeclared Homebrew packages, and refreshes 1Password secrets when signed in.

The Brewfile refuses to run without exactly one selected profile, preventing an incomplete inventory from being used for cleanup.

`mise.home.toml` owns personal AWS/SSH config and the home toolchain. `mise.work.toml` owns the work toolchain. The Brewfile reads the same environment to select profile-specific apps. Shared tools are deployed to `~/.config/mise/config.toml`; the selected toolchain is copied to `~/.config/mise/config.local.toml`.

## Layout

- `mise.toml` — shared macOS bootstrap declaration.
- `mise.home.toml`, `mise.work.toml` — profile additions.
- `Brewfile` — complete native macOS package inventory with home/work conditions.
- `dotfiles/` — direct home-directory layout; `symlink-each` links most files.
- `profiles/` — profile-only copied AWS and SSH configuration.
- `.config/mise/` — shared and profile-specific tool versions, loaded during bootstrap and deployed globally.
- `scripts/extract-secrets.sh` — optional 1Password refresh task.

Editor-owned configuration that rewrites files (`git`, `btop`, Zed, and Lazydocker) uses copy mode. Other dotfiles are individual symlinks, so an unmanaged file beside them is left alone.

## Migration notes

Do not run with `--force-dotfiles` on an existing Mac until the dry-run output has been reviewed. Bootstrap replaces `~/.config/mise/config.local.toml` with the selected home or work toolchain.

Linux VMs use only the `.config/mise/` tool declarations; do not run the macOS Bootstrap task there. Devcontainers remain out of scope.
