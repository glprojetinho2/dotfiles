# Used to extract the command used before the cursor.
# Let's consider the cursor to be [CURSOR] and the
# returned value will be enclosed in braces ({}):
# echo -e 'example\nnotexample' | {grep} '^e'[CURSOR]
# {echo} -e 'example\nnotexam[CURSOR]ple' | grep '^e'
# {cargo install} --path .[CURSOR]
# sudo {touch} /etc/file [CURSOR]
# This is a hack, so its behavior might be odd at times.
function command_before_cursor() {
    echo
    # Get all commandline tokens not starting with "-", up to and including the cursor's
    args="$(echo $LBUFFER | paste -sd ' ' | sed -E -e 's/"[^"]*"//g' -e "s/'[^']*'//g" -e 's/"[^"]*$//g' -e "s/'[^']*$//g" -e 's/\s+/ /g' -e 's/.*\|//g')"
    args=(${(s/ /)args})
    args=(${args:#-*})
    args=(${args:#caffeinate})
    args=(${args:#env})
    args=(${args:#entr})
    args=(${args:#exec})
    args=(${args:#if})
    args=(${args:#mosh})
    args=(${args:#doas})
    args=(${args:#nice})
    args=(${args:#pipenv})
    args=(${args:#prime-run})
    args=(${args:#setsid})
    args=(${args:#sudo})
    args=(${args:#systemd-nspawn})
    args=(${args:#time})
    args=(${args:#watch})
    args=(${args:#while})
    args=(${args:#xargs})
    args=(${args:#.*=.*})
    echo $args

    # If commandline is empty, exit.
    if [[ -z $args ]]; then
        printf \a
        exit 0
    fi

    # If there are at least two tokens not starting with "-", the second one might be a subcommand.
    # Try "man first-second" and fall back to "man first" if that doesn't work out.
    maincmd="$(basename $args[1])"
    echo "$maincmd $args[2]"
}

function help_binding() {
    command=(${(s/ /)$(command_before_cursor)})
    cmds=()
    if [[ ! -z args[2] ]]; then
        both="$command[1] $command[2]"
        cmds+=("$both -help" "$both -h" "$both --help" "$both help")
    fi
    cmds+=("$command[1] -help" "$command[1] -h" "$command[1] --help" "$command[1] help")
    for help_command in $cmds; do
        if eval "$help_command &>/dev/null"; then
            eval "$help_command | $MANPAGER"
            break
        fi
    done
    zle reset-prompt
}

autoload -U help_binding
zle -N help_binding

function tldr_binding() {
    command=(${(s/ /)$(command_before_cursor)})
    cmds=()
    if [[ ! -z args[2] ]]; then
        both="$command[1] $command[2]"
        cmds+=($both)
    fi
    cmds+=($command[1])
    for args in $cmds; do
        if eval "tldr $args &>/dev/null"; then
            eval "tldr --color=always $args | $MANPAGER"
            break
        fi
    done
    zle reset-prompt
  
}

autoload -U tldr_binding
zle -N tldr_binding

function man_binding() {
    command=(${(s/ /)$(command_before_cursor)})
    cmds=()
    if [[ ! -z args[2] ]]; then
        both="$command[1]-$command[2]"
        cmds+=($both)
    fi
    cmds+=($command[1])
    for args in $cmds; do
        if eval "MANPAGER=cat man $args &>/dev/null"; then
            eval "man $args"
            break
        fi
    done
    zle reset-prompt
  
}

autoload -U man_binding
zle -N man_binding

function reload_config() {
    echo -e "\n"
    source ~/.config/zsh/.zshrc
    echo -e "\n"
    clear
    zle reset-prompt
}

autoload -U reload_config
zle -N reload_config

function edit_command() {
  file="$(which $BUFFER)"
  file_owner_id="$(stat -c %u $file)"
  current_user_id="$(id -u)"
  if [[ "$file_owner_id" == "$current_user_id" ]]; then
    $EDITOR $file
  else
    sudo $EDITOR $file
  fi
}

autoload -U edit_command
zle -N edit_command

function _foreground() {
  fg
}

autoload -U _foreground
zle -N _foreground

autoload -U edit-command-line
zle -N edit-command-line

function __pwd() {
    echo
    pwd
    zle reset-prompt
}

autoload -U __pwd
zle -N __pwd

autoload -U command_before_cursor
zle -N command_before_cursor

function clear-screen-and-scrollback() {
  builtin echoti civis >"$TTY"
  builtin print -rn -- $'\e[H\e[2J' >"$TTY"
  builtin zle .reset-prompt
  builtin zle -R
  builtin print -rn -- $'\e[3J' >"$TTY"
  builtin echoti cnorm >"$TTY"
}
zle -N clear-screen-and-scrollback

function _bindings() {
  bindkey '^L' clear-screen-and-scrollback
  bindkey "^[e" edit-command-line
  bindkey "^[E" edit_command
  # F1 = manpage
  bindkey "^[OP" man_binding
  bindkey "^t" tldr_binding
  bindkey "^h" command_before_cursor
  bindkey "^[R" reload_config
  bindkey "^z" _foreground
  bindkey "^[d" __pwd
}

_bindings
zvm_after_init_commands+=(_bindings)
