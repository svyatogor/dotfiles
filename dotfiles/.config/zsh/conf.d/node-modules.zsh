autoload -Uz add-zsh-hook

if (( ! ${+NODE_MODULES_ROOTS} )); then
  typeset -ga NODE_MODULES_ROOTS=(
    "$HOME/Projects"
    "$HOME/src"
  )
fi

typeset -g _node_modules_bin=

_update_node_modules_path() {
  local root directory candidate

  if [[ -n "$_node_modules_bin" ]]; then
    path=("${(@)path:#$_node_modules_bin}")
    _node_modules_bin=
  fi

  for root in "$NODE_MODULES_ROOTS[@]"; do
    root="${root:A}"
    directory="${PWD:A}"

    if [[ "$directory" == "$root" || "$directory" == "$root"/* ]]; then
      while true; do
        candidate="${directory%/}/node_modules/.bin"
        if [[ -d "$candidate" ]]; then
          _node_modules_bin="$candidate"
          path=("$candidate" $path)
          return
        fi

        [[ "$directory" == "$root" ]] && return
        directory="${directory:h}"
      done
    fi
  done
}

add-zsh-hook chpwd _update_node_modules_path
add-zsh-hook precmd _update_node_modules_path
_update_node_modules_path
