function mercuric -d "Mercuric project utilities"
    set -l subcommand $argv[1]

    if test -z "$subcommand"
        echo "Usage: mercuric <command> [options]"
        echo ""
        echo "Commands:"
        echo "  commit -m <message>        Commit and push changes in backend and frontend"
        echo "  checkout [-b] <branch>    Checkout a branch in backend and frontend"
        echo "  pull                      Pull latest changes in backend and frontend"
        echo "  status                    Show git status in backend and frontend"
        return 1
    end

    switch $subcommand
        case commit
            __mercuric_commit $argv[2..]
        case checkout
            __mercuric_checkout $argv[2..]
        case pull
            __mercuric_pull $argv[2..]
        case status
            __mercuric_status $argv[2..]
        case '*'
            echo "mercuric: unknown command '$subcommand'"
            return 1
    end
end

function __mercuric_checkout -d "Checkout a branch in backend and frontend"
    set -l project_root /Users/hardik/Projects/Mercuric
    set -l create_branch false
    set -l branch ""

    # Parse args
    if test (count $argv) -eq 0
        echo "mercuric checkout: missing branch name"
        return 1
    end

    if test "$argv[1]" = "-b"
        set create_branch true
        if test (count $argv) -lt 2
            echo "mercuric checkout: missing branch name after -b"
            return 1
        end
        set branch "$argv[2]"
    else
        set branch "$argv[1]"
    end

    set -l failed 0

    for dir in backend frontend
        set -l repo $project_root/$dir
        echo "── $dir ──"

        if not test -d $repo/.git
            echo "  ⚠ Not a git repo, skipping"
            set failed 1
            continue
        end

        if test "$create_branch" = true
            git -C $repo checkout -b "$branch"
        else
            git -C $repo checkout "$branch"
        end
        or begin
            echo "  ✗ Failed in $dir"
            set failed 1
        end
    end

    if test $failed -eq 1
        return 1
    end

    echo ""
    echo "Done!"
end

function __mercuric_pull -d "Pull latest changes in backend and frontend"
    set -l project_root /Users/hardik/Projects/Mercuric
    set -l failed 0

    for dir in backend frontend
        set -l repo $project_root/$dir
        echo "── $dir ──"

        if not test -d $repo/.git
            echo "  ⚠ Not a git repo, skipping"
            set failed 1
            continue
        end

        git -C $repo pull $argv
        or begin
            echo "  ✗ Failed in $dir"
            set failed 1
        end
    end

    if test $failed -eq 1
        return 1
    end

    echo ""
    echo "Done!"
end

function __mercuric_status -d "Show git status in backend and frontend"
    set -l project_root /Users/hardik/Projects/Mercuric

    for dir in backend frontend
        set -l repo $project_root/$dir
        echo "── $dir ──"

        if not test -d $repo/.git
            echo "  ⚠ Not a git repo, skipping"
            continue
        end

        git -C $repo status $argv
    end
end

function __mercuric_commit -d "Commit and push backend and frontend"
    set -l project_root /Users/hardik/Projects/Mercuric
    set -l message ""

    # Parse -m flag
    set -l i 1
    while test $i -le (count $argv)
        if test "$argv[$i]" = "-m"
            set -l next (math $i + 1)
            if test $next -le (count $argv)
                set message "$argv[$next]"
            end
        end
        set i (math $i + 1)
    end

    if test -z "$message"
        echo "mercuric commit: missing commit message (-m)"
        return 1
    end

    set -l failed 0

    for dir in backend frontend
        set -l repo $project_root/$dir
        echo "── $dir ──"

        if not test -d $repo/.git
            echo "  ⚠ Not a git repo, skipping"
            set failed 1
            continue
        end

        # Check for changes
        set -l status_output (git -C $repo status --porcelain)
        if test -z "$status_output"
            echo "  No changes to commit"
            continue
        end

        git -C $repo add -A
        and git -C $repo commit -m "$message"
        and git -C $repo push
        or begin
            echo "  ✗ Failed in $dir"
            set failed 1
        end
    end

    if test $failed -eq 1
        return 1
    end

    echo ""
    echo "Done!"
end
