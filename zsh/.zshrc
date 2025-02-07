source "$ZDOTDIR/aliases.zsh"
source "$ZDOTDIR/prompt.zsh"
source "$ZDOTDIR/functions.zsh"
source "$ZDOTDIR/bindings.zsh"
source "$ZDOTDIR/less.zsh"

autoload -U compinit 
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

export EDITOR=helix
export VISUAL=helix
export MANPAGER=less
HISTSIZE=10000
SAVEHIST=10000
[ -d ~/.cache/zsh ] || mkdir ~/.cache/zsh
HISTFILE=~/.cache/zsh/history
setopt append_history

source /usr/share/zsh/share/antigen.zsh
antigen bundle jeffreytse/zsh-vi-mode
antigen bundle zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=(history completion match_prev_cmd)
antigen apply

eval "$(zoxide init zsh)"
