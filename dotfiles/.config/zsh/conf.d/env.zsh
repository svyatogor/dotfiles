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
