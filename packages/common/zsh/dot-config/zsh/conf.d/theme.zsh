# Theme-adaptive wrappers for tools that need explicit theme colors.
# ANSI-based configs (zsh-syntax-highlighting, tmux, lazydocker) adapt
# automatically via terminal palette. These wrappers handle tools that
# need hex colors or theme names (fzf, bat, eza, lazygit).

_THEME_DIR="${0:A:h:h}/themes"
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

# --- eza (ANSI, theme-agnostic) ---------------------------------------------
# EZA_COLORS uses ANSI codes (30-37, 90-97) so the terminal palette drives the
# actual colors -- no hex, no theme detection needed.
export EZA_COLORS="\
di=34:ln=1;36:pi=2:bd=31:cd=31:so=2:sp=35:ex=32:mp=36:\
ur=31;1:uw=33;1:ux=32;1:ue=32;1:\
gr=31:gw=33:gx=32:tr=31:tw=33:tx=32:\
su=35:sf=2:xa=2:oc=36:\
nb=2:nk=2:nm=34:ng=35:nt=35:\
ub=2:uk=36:um=35:ug=35:ut=36:\
df=2:ds=2:\
uu=2:uR=31:un=31:gu=2:gR=31:gn=2:\
lc=2:lm=2:\
ga=32:gm=33:gd=31:gv=36:gt=35:gi=2:gc=91:\
Gm=2:Go=35:Gc=32:Gd=31:\
xx=2:da=33:in=2:bl=2:hd=1:\
lp=36:cc=36:bO=2:\
im=33:vi=31:mu=32:lo=36:cr=2:do=2;3:co=35:tm=31:cm=36:bu=33;1"

eza() {
  command eza --icons auto --git --group-directories-first "$@"
}

# --- lazygit wrapper ---------------------------------------------------------
lazygit() {
  _detect_theme
  LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml,$_THEME_DIR/$_THEME_VARIANT/lazygit.yml" command lazygit "$@"
}
