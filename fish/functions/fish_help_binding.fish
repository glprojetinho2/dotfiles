function fish_help_binding
    # Get all commandline tokens not starting with "-", up to and including the cursor's
    set -l args (string match -rv '^-|^$' -- (commandline -cpo && commandline -t))

    # If commandline is empty, exit.
    if not set -q args[1]
        printf \a
        return
    end

    # Skip leading commands and display the manpage of following command
    while set -q args[2]
        and string match -qr -- '^(and|begin|builtin|caffeinate|command|doas|entr|env|exec|if|mosh|nice|not|or|pipenv|prime-run|setsid|sudo|systemd-nspawn|time|watch|while|xargs|.*=.*)$' $args[1]
        echo $args[1]
        set -e args[1]
    end

    # If there are at least two tokens not starting with "-", the second one might be a subcommand.
    # Try "man first-second" and fall back to "man first" if that doesn't work out.
    set -l maincmd (basename $args[1])
    # HACK: If stderr is not attached to a terminal `less` (the default pager)
    # wouldn't use the alternate screen.
    # But since we don't know what pager it is, and because `man` is totally underspecified,
    # the best we can do is to *try* the man page, and assume that `man` will return false if it fails.
    # See #7863.
    set cmds
    if set -q args[2]
        set -a cmds "$maincmd $args[2] -help" "$maincmd $args[2] -h" "$maincmd $args[2] --help" "$maincmd $args[2] help"
    end
    set -a cmds "$maincmd -help" "$maincmd -h" "$maincmd --help" "$maincmd help"
    for help_command in $cmds
        if eval $help_command | cat &>/dev/null
            eval $help_command | bat
            break
        else
            printf \a
        end
    end
    commandline -f repaint
end
