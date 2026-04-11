# Theme-adaptive wrappers for tools that need explicit theme colors.
# ANSI-based configs (zsh-syntax-highlighting, tmux, lazydocker) adapt
# automatically via terminal palette. These wrappers handle tools that
# need hex colors or theme names (fzf, bat, eza, lazygit).

_THEME_DIR="${DOTFILES:-$HOME/dotfiles}/themes"
_THEME_DARK="catppuccin-frappe"
_THEME_LIGHT="catppuccin-latte"

# --- zsh-syntax-highlighting (ANSI, theme-agnostic) -------------------------
source "$_THEME_DIR/zsh-syntax-highlighting.zsh"

# --- OSC 11 detection (for fzf/bat/eza on-demand) ---------------------------
_THEME_VARIANT="$_THEME_DARK"

# Detect terminal background via OSC 11. Sets _THEME_VARIANT.
_detect_theme() {
  _THEME_VARIANT="$_THEME_DARK"
  [[ -r /dev/tty ]] || return

  local oldstty char buf=""
  oldstty=$(stty -g </dev/tty 2>/dev/null) || return
  stty raw -echo min 0 time 5 </dev/tty 2>/dev/null
  while read -rs -t 0 -k 1 char </dev/tty 2>/dev/null; do :; done
  printf '\e]11;?\a' >/dev/tty
  while IFS= read -rs -t 1 -k 1 char </dev/tty 2>/dev/null; do
    buf+="$char"
    [[ "$char" == $'\a' ]] && break
    [[ "$buf" == *$'\e\\' ]] && break
  done
  stty "$oldstty" </dev/tty 2>/dev/null

  if [[ "$buf" =~ 'rgb:([0-9a-fA-F]+)/([0-9a-fA-F]+)/([0-9a-fA-F]+)' ]]; then
    local r=$((16#${match[1]:0:2}))
    local g=$((16#${match[2]:0:2}))
    local b=$((16#${match[3]:0:2}))
    local luminance=$(( (r * 2126 + g * 7152 + b * 722) / 10000 ))
    (( luminance > 128 )) && _THEME_VARIANT="$_THEME_LIGHT"
  fi
}

# --- fzf wrapper ------------------------------------------------------------
fzf() {
  _detect_theme
  local FZF_THEME
  source "$_THEME_DIR/$_THEME_VARIANT/fzf.env"
  command fzf ${=FZF_THEME} "$@"
}

# --- bat wrapper ------------------------------------------------------------
bat() {
  _detect_theme
  local BAT_THEME
  source "$_THEME_DIR/$_THEME_VARIANT/bat.env"
  command bat --theme="$BAT_THEME" "$@"
}

# --- eza wrapper ------------------------------------------------------------
eza() {
  _detect_theme
  local eza_dir="$_THEME_DIR/$_THEME_VARIANT/eza"
  [[ -d "$eza_dir" ]] || eza_dir="${HOME}/.local/share/theme/eza"
  EZA_CONFIG_DIR="$eza_dir" command eza --icons auto --git --group-directories-first "$@"
}

# --- lazygit wrapper ---------------------------------------------------------
lazygit() {
  _detect_theme
  LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml,$_THEME_DIR/$_THEME_VARIANT/lazygit.yml" command lazygit "$@"
}
