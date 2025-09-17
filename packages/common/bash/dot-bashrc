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

export LANG=C.UTF-8
export LC_ALL=C.UTF-8
export BAT_THEME=base16-256
export LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml,$HOME/.config/lazygit/colors.yml"

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

# Tinty isn't able to apply environment variables to your shell due to
# the way shell sub-processes work. This is a work around by running
# Tinty through a function and then executing the shell scripts.
tinty_source_shell_theme() {
  newer_file=$(mktemp)
  tinty $@
  subcommand="$1"

  if [ "$subcommand" = "apply" ] || [ "$subcommand" = "init" ]; then
    tinty_data_dir="${XDG_DATA_HOME:-$HOME/.local/share}/tinted-theming/tinty"

    while read -r script; do
      # shellcheck disable=SC1090
      . "$script"
    done < <(find "$tinty_data_dir" -maxdepth 1 -type f -o -type l -name "*.sh" -newer "$newer_file")

    unset tinty_data_dir
  fi

  unset subcommand
}

if [ -n "$(command -v 'tinty')" ]; then
  eval "$(tinty generate-completion bash)"
  tinty_source_shell_theme "init" >/dev/null
  alias tinty=tinty_source_shell_theme
fi

command -v fzf >/dev/null 2>&1 && eval "$(fzf --bash)"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init bash)"

function assume() {
  export GRANTED_ALIAS_CONFIGURED="true"
  source /nix/store/hcz8ndam06rs0ynzz7390kjf6iws3xsr-granted-0.38.0/bin/assume "$@"
  unset GRANTED_ALIAS_CONFIGURED
}

if [[ -s $HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh ]]; then
  . "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
fi
