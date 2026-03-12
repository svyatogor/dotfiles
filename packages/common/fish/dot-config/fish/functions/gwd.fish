function gwd -d "Remove a git worktree"
    set -l branch $argv[1]

    if test -z "$branch"
        echo "Usage: gwd <branch-name>"
        return 1
    end

    set -l folder_name (string replace -a '/' '-' $branch)
    set -l wt_root (path dirname (git rev-parse --absolute-git-dir))
    set -l target_path "$wt_root/$folder_name"

    if not test -d "$target_path"
        echo "Worktree not found: $target_path"
        return 1
    end

    git worktree remove "$target_path"; and echo "Removed worktree: $target_path"
end
