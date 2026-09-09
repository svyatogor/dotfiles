export EDITOR=nvim
export GIT_EDITOR=nvim

export LANG=C.UTF-8
export LC_ALL=C.UTF-8

export PATH="$PATH:$HOME/.local/bin"
if command -v brew >/dev/null 2>&1; then
  export PATH="$(brew --prefix libpq)/bin:$PATH"
fi


export HOMEBREW_NO_ENV_HINTS=1

export SSH_ASKPASS_REQUIRE=never

_theme_dir="${XDG_CONFIG_HOME:-$HOME/.config}/themes/current"

[[ -r "$_theme_dir/bat.env" ]] && source "$_theme_dir/bat.env"
[[ -r "$_theme_dir/fzf.env" ]] && source "$_theme_dir/fzf.env"

export EZA_CONFIG_DIR="$_theme_dir/eza"
export LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml,$_theme_dir/lazygit.yml"

export GLOW_STYLE="$_theme_dir/glow.json"
export GLOW_WIDTH=120
export GLOW_PAGER=true

unset _theme_dir
