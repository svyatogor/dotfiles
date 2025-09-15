# Prefer user-local bins
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

[[ $- == *i* ]] || return

HISTCONTROL=ignoreboth
HISTFILESIZE=32768
HISTSIZE=32768

shopt -s histappend
shopt -s checkwinsize
shopt -s extglob
shopt -s globstar
shopt -s checkjobs

# Homebrew shellenv (macOS Intel/Apple Silicon)
if [ -d /opt/homebrew ]; then
  eval "$('/opt/homebrew/bin/brew' shellenv)"
elif [ -d /usr/local/Homebrew ]; then
  eval "$('/usr/local/bin/brew' shellenv)"
fi

# mise
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate bash)"
fi

# direnv
if command -v direnv >/dev/null 2>&1; then
  export DIRENV_LOG_FORMAT=""
  eval "$(direnv hook bash)"
fi

# Starship prompt
if command -v starship >/dev/null 2>&1; then
  export STARSHIP_CONFIG="$HOME/.config/starship.toml"
  eval "$(starship init bash)"
fi

# macOS: prefer GNU coreutils if installed
command -v gsed >/dev/null 2>&1 && alias sed=gsed
command -v ggrep >/dev/null 2>&1 && alias grep=ggrep
command -v gls >/dev/null 2>&1 && alias ls=gls

alias cat=bat
alias eza='eza --icons auto --git'
alias g=lazygit
alias gp='git push'
alias gss='git status -s'
alias la='eza -a'
alias less=bat
alias ll='eza -l'
alias lla='eza -la'
alias ls=eza
alias lt='eza --tree'
alias n=nvim
alias vim=nvim

# if [[ ! -v BASH_COMPLETION_VERSINFO ]]; then
#   . "/nix/store/ny5hpgdkfvm89kzg9nq7v3fzjklx3166-bash-completion-2.16.0/etc/profile.d/bash_completion.sh"
# fi

# if [[ :$SHELLOPTS: =~ :(vi|emacs): ]]; then
#   eval "$(/nix/store/xs72wvbjhyghfnzdyb384s6d9b09c0jj-fzf-0.62.0/bin/fzf --bash)"
# fi

# function assume() {
#   export GRANTED_ALIAS_CONFIGURED="true"
#   source /nix/store/hcz8ndam06rs0ynzz7390kjf6iws3xsr-granted-0.38.0/bin/assume "$@"
#   unset GRANTED_ALIAS_CONFIGURED
# }

# source "/nix/store/ajdz9pyc1pafi6ip5f05r6v8yax225da-wezterm-0-unstable-2025-05-18/etc/profile.d/wezterm.sh"


# # Initialize fzf key bindings (no prompts)
# if [[ -x "$(brew --prefix)/opt/fzf/install" ]]; then
#   yes | "$(brew --prefix)"/opt/fzf/install --key-bindings --completion --no-bash --no-fish || true
# fi