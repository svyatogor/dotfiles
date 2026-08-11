# Dotfiles

Laptop and Linux VM setup orchestrated by [Mise Bootstrap](https://mise.jdx.dev/bootstrap.html). Mise owns portable tools and dotfiles; one Brewfile owns all native macOS packages.

## Profiles

From this checkout, preview the selected profile:

```sh
mise -E earth bootstrap --dry-run
mise -E mars bootstrap --dry-run
mise -E mercury bootstrap --dry-run
mise -E neptune bootstrap --dry-run
```

After reviewing the preview, apply it on the target machine:

```sh
mise -E earth bootstrap
mise -E mars bootstrap
mise -E mercury bootstrap
mise -E neptune bootstrap
```

The bootstrap requires mise `2026.8.3` or newer. It installs portable CLI tools through Mise, clones Zinit and TPM, and deploys dotfiles. On macOS only, it also requires Homebrew, converges the selected laptop inventory, and removes undeclared packages.

The Brewfile refuses to run without exactly one laptop profile, preventing an incomplete inventory from being used for cleanup.

`mise.earth.toml` owns personal AWS/SSH config. `mars` and `neptune` use the same employer toolchain. `mercury` needs no additions to the shared VM setup. Bootstrap records the selected planet in `~/.config/mise/miserc.toml`, so later Mise commands load its profile automatically. The Brewfile reads the same environment to select profile-specific apps. Shared and profile-specific tools are deployed under `~/.config/mise/`.

## Layout

- `.miserc.toml` — enables Mise's native platform environments.
- `mise.toml` — shared laptop and Linux VM bootstrap declaration.
- `mise.macos.toml` — automatically loaded macOS-only dotfile and Brew task.
- `mise.linux.toml` — installs Zsh and Ghostty terminfo, then selects Zsh as the Linux login shell.
- `mise.<planet>.toml` — profile additions where needed.
- `Brewfile` — complete native macOS package inventory with laptop-profile conditions.
- `dotfiles/` — direct home-directory layout; `symlink-each` links most files.
- `profiles/` — profile-only copied AWS and SSH configuration.
- `dotfiles/.config/mise/` — shared and profile-specific tool versions, deployed globally.
- `scripts/extract-secrets.sh` — optional 1Password refresh task.

Editor-owned configuration that rewrites files (`git`, `btop`, Zed, and Lazydocker) uses copy mode. Other dotfiles are individual symlinks, so an unmanaged file beside them is left alone.

## Migration notes

Do not run with `--force-dotfiles` on an existing machine until the dry-run output has been reviewed.

Linux VMs run the same Bootstrap command; Mise does not load `mise.macos.toml` there, so Homebrew and macOS-only dotfiles are skipped. Devcontainers remain out of scope.
