mkdir -p ~/.local/state/zsh/
HISTDUP=erase
HISTFILE=~/.local/state/zsh/history
HISTSIZE=32768
SAVEHIST=$HISTSIZE

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
