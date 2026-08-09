# --- Plugin manager: Zinit -------------------------------------------------
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ -f "$ZINIT_HOME/zinit.zsh" ]]; then
  source "$ZINIT_HOME/zinit.zsh"
fi

# --- Environment bootstrap --------------------------------------------------
if command -v brew >/dev/null 2>&1; then
  eval "$(brew shellenv)"
fi

export MISE_LOG_LEVEL=error
eval "$(~/.local/bin/mise activate zsh)"

eval "$(starship init zsh)"

export FZF_CTRL_R_OPTS="--tmux center,80%,80% --reverse --preview 'echo {}' --preview-window down:3:wrap --bind '?:toggle-preview'"
eval "$(fzf --zsh)"

if [[ -z "$CLAUDECODE" ]]; then
  command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init --cmd cd zsh)"
fi

# --- Custom functions & completions (autoload) ------------------------------
ZSHCONF="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
fpath=("$ZSHCONF/functions" "$ZSHCONF/completions" $fpath)
autoload -Uz gwt gwd gws

# --- Plugins ----------------------------------------------------------------
if (( $+functions[zinit] )); then
  zinit light zsh-users/zsh-completions
  zinit light Aloxaf/fzf-tab
  zinit light hlissner/zsh-autopair
  zinit light urbainvaes/fzf-marks

autoload -U compinit && compinit
zinit cdreplay -q

  zinit ice wait lucid
  zinit light zsh-users/zsh-autosuggestions

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
ZSH_HIGHLIGHT_MAXLENGTH=512
  zinit ice wait lucid
  zinit light zsh-users/zsh-syntax-highlighting
fi

# --- Modular config ---------------------------------------------------------
for f in "$ZSHCONF"/conf.d/*.zsh(N); do
  source "$f"
done

autoload -U select-word-style
select-word-style bash

[[ -f ~/.local/share/secrets.sh ]] && source ~/.local/share/secrets.sh
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

if [ -z "$SSH_AUTH_SOCK" ]; then
  eval $(ssh-agent -s)
fi

if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi
