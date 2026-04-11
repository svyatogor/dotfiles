# zsh-syntax-highlighting theme using ANSI palette (0-15).
# Terminal swaps the palette on light/dark switch, so colors adapt instantly.

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main cursor)
typeset -gA ZSH_HIGHLIGHT_STYLES

# green (2) — commands
ZSH_HIGHLIGHT_STYLES[alias]='fg=2'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=2'
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=2'
ZSH_HIGHLIGHT_STYLES[function]='fg=2'
ZSH_HIGHLIGHT_STYLES[command]='fg=2'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=2,italic'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=2'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=2'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=2'

# bright yellow (11) — options, autodirectory (≈ peach)
ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=11,italic'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=11'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=11'

# yellow (3) — strings
ZSH_HIGHLIGHT_STYLES[command-substitution-quoted]='fg=3'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-quoted]='fg=3'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=3'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=3'
ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=3'

# red (1) — separators, escapes
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=1'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]='fg=1'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=1'
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=1'

# pink (5) — back-quoted, history (≈ mauve)
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=5'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=5'

# bright red (9) — errors, unclosed
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=9'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]='fg=9'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]='fg=9'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument-unclosed]='fg=9'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-unclosed]='fg=9'

# bright black (8) — comments
ZSH_HIGHLIGHT_STYLES[comment]='fg=8'

# default fg — paths, variables, delimiters
ZSH_HIGHLIGHT_STYLES[path]='fg=default,underline'
ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=1,underline'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=default,underline'
ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg=1,underline'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=default'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-unquoted]='fg=default'
ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=default'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=default'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=default'
ZSH_HIGHLIGHT_STYLES[assign]='fg=default'
ZSH_HIGHLIGHT_STYLES[named-fd]='fg=default'
ZSH_HIGHLIGHT_STYLES[numeric-fd]='fg=default'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=default'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=default'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=default'
ZSH_HIGHLIGHT_STYLES[default]='fg=default'
ZSH_HIGHLIGHT_STYLES[cursor]='fg=default'
