function yt_copy --description 'copies youtube link from youtube_menu.fish'
    cat /tmp/youtube_menu_link | wl-copy $argv
end
