alias chm='chmod +100'
alias hx=helix
alias fzfc='fzf | wl-copy'
alias ls='ls --color=always'
alias lt='ls -ltr'
alias gitc='git clone $(wl-paste)'
alias ..='cd ..'
alias yt_copy='cat /tmp/youtube_menu_link | wl-copy'
alias cdfzf='cd $(dirname (find . | fzf | xargs realpath || pwd))'

function lofzf() {
  locate $1 | fzf | wl-copy
}
