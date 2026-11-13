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

# Colours reference terminal palette indices so they follow its light/dark theme.
# Roles: see "Terminal colours" in the repository README.
export BAT_THEME=terminal
export FZF_DEFAULT_OPTS="--color=base16,fg:-1,bg:-1,fg+:-1,bg+:234,selected-bg:236,gutter:-1,hl:4,hl+:4:bold,border:240,separator:240,scrollbar:240,preview-border:240,info:246,label:246,disabled:246,prompt:5,pointer:4,marker:2,spinner:6,header:5,query:-1"

export GLOW_WIDTH=120
export GLOW_PAGER=true
