complete -c gwt -f -a '(git branch -a --format="%(refname:short)" 2>/dev/null | string replace -r "^origin/" "" | sort -u)'
