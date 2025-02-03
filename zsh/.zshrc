function _bindings() {
  bindkey '^L' clear-screen-and-scrollback
  bindkey "^[e" edit-command-line
}
zvm_after_init_commands+=(_bindings)

source /usr/share/zsh/share/antigen.zsh
antigen bundle jeffreytse/zsh-vi-mode
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=(history completion match_prev_cmd)
antigen apply

alias chm='chmod +100'
alias hx=helix
alias fzfc='fzf | wl-copy'
alias lt='ls -ltr'
alias gitc='git clone $(wl-paste)'
alias ..='cd ..'
alias yt_copy='cat /tmp/youtube_menu_link | wl-copy'

export EDITOR=helix
export VISUAL=helix
export MANPAGER='less -R'
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history
setopt appendhistory

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

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
