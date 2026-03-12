complete -c gwd -f -a '(
    set -l wt_root (path dirname (git rev-parse --absolute-git-dir) 2>/dev/null)
    git worktree list --porcelain 2>/dev/null | string replace -rf "^worktree (.+)" "\$1" | while read -l wt
        test "$wt" = "$wt_root"; and continue
        path basename $wt
    end
)'
