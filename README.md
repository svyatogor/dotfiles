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

The bootstrap requires mise `2026.8.3` or newer. It installs portable CLI tools through Mise, clones Zinit and TPM, initializes the Neovim config submodule, and deploys dotfiles. On macOS only, it also requires Homebrew, converges the selected laptop inventory, and removes undeclared packages.

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

## Terminal colours

The terminal (Ghostty, Rex) is the only place that defines colours. Tools refer to
palette indices, so switching the terminal between light and dark recolours them
live, including programs already running. Indices 16–255 must be generated from
the theme with the background→foreground ramp in both modes (Ghostty:
`palette-generate`, `palette-harmonious`; Rex: "Use extended theme palette").

| Role | Index | Catppuccin name |
| --- | --- | --- |
| Text, background | default (`-1`) | text, base |
| Surface: current line | `234` | surface0 |
| Surface: selection | `236` | surface1 |
| Borders, separators, line numbers | `241` | overlay0 |
| Muted text, comments | `246` | overlay2 |
| Secondary text | `249` | subtext0 |
| Error / ok / warning / primary / keyword / info | `1` / `2` / `3` / `4` / `5` / `6` | red / green / yellow / blue / mauve / teal |
| Numbers, constants | `208` | peach |
| Escapes, regex | `13` | pink |
| Diff removed / added background | `52` / `22` | — |
| Diff removed / added emphasis | `88` / `28` | — |

The full name → index map is `M.palette` in
`nvim/local/terminal-colors.nvim/lua/terminal-colors/catppuccin.lua`.

Avoid `0`, `7`, `15` (fixed black/white, invisible on one of the backgrounds) and
`16`/`231` (use default instead). The bright accents `9`–`14` are about a quarter
lower in contrast than `1`–`6`, close to Catppuccin Latte's own pastels: fine for
secondary accents, not for body text.
