bindkey -e

bindkey '^p' history-beginning-search-backward
bindkey '^n' history-beginning-search-forward
bindkey '^[w' kill-region

# Arrow keys: prefix history search (fish-like `cd D` + Up/Down)
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward

# Option+Arrow: word navigation (macOS terminals)
bindkey '\e[1;3D' backward-word
bindkey '\e[1;3C' forward-word
bindkey '\e[1;9D' backward-word
bindkey '\e[1;9C' forward-word

# Ctrl+Arrow: word navigation
bindkey '\e[1;5D' backward-word
bindkey '\e[1;5C' forward-word
bindkey '\e[5D' backward-word
bindkey '\e[5C' forward-word
