function gwt -d "Create or switch to a git worktree"
    set -l branch $argv[1]

    if test -z "$branch"
        echo "Usage: gwt <branch-name>"
        return 1
    end

    set -l folder_name (string replace -a '/' '-' $branch)
    set -l wt_root (path dirname (git rev-parse --absolute-git-dir))
    set -l target_path "$wt_root/$folder_name"

    if test -d "$target_path"
        cd "$target_path"
        if set -q TMUX
            tmux rename-window "$folder_name"
        end
        return
    end

    if git show-ref --quiet refs/heads/"$branch"; or git show-ref --quiet refs/remotes/origin/"$branch"
        git worktree add "$target_path" "$branch"
    else
        set -l base_branch (git remote show origin | awk '/HEAD branch/ {print $NF}')
        test -z "$base_branch"; and set base_branch main
        git worktree add -b "$branch" "$target_path" origin/"$base_branch"
        git -C "$target_path" config branch."$branch".remote origin
        git -C "$target_path" config branch."$branch".merge "refs/heads/$branch"
    end

    cd "$target_path"
    if set -q TMUX
        tmux rename-window "$folder_name"
    end
end
