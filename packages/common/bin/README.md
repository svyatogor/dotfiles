This package links repository-maintained scripts into `~/.local/bin`.

Usage:

- Put your executable scripts under `packages/common/bin/.local/bin/`.
- Make sure they have the executable bit set (`chmod +x`).
- Run `make stow` to link them into `~/.local/bin/`.

Notes:

- `~/.local/bin` is already on PATH in the provided shell configs.
- Files in this package are symlinked as-is; use subdirectories if you want to group scripts.
- To avoid accidentally linking non-scripts, keep docs out of `.local/bin/` or ensure they are ignored by stow.

