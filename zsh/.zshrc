function help_binding() {
    echo -e '\n'
    function command_filter() {
        echo "LBUFFER: $LBUFFER"
        args_raw="$(echo $LBUFFER | sed -e 's/"[^"]*"//g' -e "s/'[^']*'//g")"
        echo "args_raw: $args_raw"
        args=${(s/ /)args_raw}
        # Get all commandline tokens not starting with "-", up to and including the cursor's
        args=${args:#-*}
    }
    args=command_filter

    # If commandline is empty, exit.
    if [[ -z args ]]; then
        printf \a
        exit 0
    fi

    # Skip leading commands and display the manpage of following command
    while [ ! -z $args[2] ] && [ ! -z $(echo $args[1] | grep -E '^(and|begin|builtin|caffeinate|command|doas|entr|env|exec|if|mosh|nice|not|or|pipenv|prime-run|setsid|sudo|systemd-nspawn|time|watch|while|xargs|.*=.*)$') ]; do
        echo $args[1]
        args[1]=()
    done

    # If there are at least two tokens not starting with "-", the second one might be a subcommand.
    # Try "man first-second" and fall back to "man first" if that doesn't work out.
    maincmd="$(basename $args[1])"
    # HACK: If stderr is not attached to a terminal `less` (the default pager)
    # wouldn't use the alternate screen.
    # But since we don't know what pager it is, and because `man` is totally underspecified,
    # the best we can do is to *try* the man page, and assume that `man` will return false if it fails.
    # See #7863.
    cmds=()
    if [[ ! -z args[2] ]]; then
        cmds+=("$maincmd $args[2] -help" "$maincmd $args[2] -h" "$maincmd $args[2] --help" "$maincmd $args[2] help")
    fi
    cmds+=("$maincmd -help" "$maincmd -h" "$maincmd --help" "$maincmd help")
    for help_command in $cmds; do
        if eval "$help_command &>/dev/null"; then
            echo "help_command: $help_command"
            echo "args: $args"
            echo "maincmd: $maincmd"
            eval "$help_command | $MANPAGER"
            break
        else
            printf \a
        fi
    done
    zle reset-prompt
}

autoload -U help_binding
zle -N help_binding

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

function _bindings() {
  bindkey '^L' clear-screen-and-scrollback
  bindkey "^[e" edit-command-line
  bindkey "^[E" edit_command
  # F1 = manpage
  bindkey "^[OP" help_binding
  bindkey "^[R" reload_config
  bindkey "^z" _foreground
}
zvm_after_init_commands+=(_bindings)

source /usr/share/zsh/share/antigen.zsh
antigen bundle jeffreytse/zsh-vi-mode
antigen bundle zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=(history completion match_prev_cmd)

alias chm='chmod +100'
alias hx=helix
alias fzfc='fzf | wl-copy'
alias ls='ls --color=always'
alias lt='ls -ltr'
alias gitc='git clone $(wl-paste)'
alias ..='cd ..'
alias yt_copy='cat /tmp/youtube_menu_link | wl-copy'
alias cdfzf='cd $(dirname (find . | fzf | xargs realpath || pwd))'

export EDITOR=helix
export VISUAL=helix
export MANPAGER='less -R'
HISTSIZE=10000
SAVEHIST=10000
[ -d ~/.cache/zsh ] || mkdir ~/.cache/zsh
HISTFILE=~/.cache/zsh/history
setopt append_history

autoload -U compinit edit-command-line
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

function clear-screen-and-scrollback() {
  builtin echoti civis >"$TTY"
  builtin print -rn -- $'\e[H\e[2J' >"$TTY"
  builtin zle .reset-prompt
  builtin zle -R
  builtin print -rn -- $'\e[3J' >"$TTY"
  builtin echoti cnorm >"$TTY"
}
zle -N clear-screen-and-scrollback
zle -N edit-command-line

function lofzf() {
  locate $1 | fzf | wl-copy
}


function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

antigen bundle zsh-users/zsh-syntax-highlighting
antigen apply
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
