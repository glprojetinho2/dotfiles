alias chm='chmod +100'
alias hx=helix
alias fzfc='fzf | wl-copy'
alias ls='ls --color=always'
alias lt='ls -ltr'
alias gitc='git clone $(wl-paste)'
alias ..='cd ..'
alias yt_copy='cat /tmp/youtube_menu_link | wl-copy'
alias cdfzf='cd $(dirname (find . | fzf | xargs realpath || pwd))'
alias last_video='find ~/Vídeos -type f -name "*.mp4" -printf "%T@ %p\n" | sort -n | tail -n1 | cut -d" " -f2'
alias play_last_video='mpv $(last_video)'
alias speedup_last_video='ffmpeg -i $(last_video) -filter:v "setpts=0.5*PTS" -an $(echo "$(last_video)" | sed "s/\.[^.]*$//")_2x.mp4'
alias compress_last_video='ffmpeg -i $(last_video) -vf "scale=1280:720" -vcodec libx264 -crf 23 -acodec aac -b:a 128k $(echo "$(last_video)" | sed "s/\.[^.]*$//")_compressed.mp4'


function lofzf() {
  locate $1 | fzf | wl-copy
}
