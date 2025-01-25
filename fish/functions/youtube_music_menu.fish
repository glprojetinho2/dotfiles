function youtube_music_menu -d "Search youtube using a floating menu. Audio version."
    pkill rofi

    # Default config directory
    set configdir "$HOME/.config/youtube_menu"
    not test -z $XDG_CONFIG_HOME; and set configdir "$XDG_CONFIG_HOME/.config/youtube_rofi"
    set histfile $configdir/history

    if not test -d "$configdir"
        echo "Directory $configdir does not exist, creating..."
        mkdir -p "$configdir"
    end

    tac $histfile
    set video_query (tac $histfile | sed '/^$/d' | rofi -dmenu -i -p "Search query")
    if test -z $video_query
        echo "no input."
        return 1
    end


    set raw_video_list ( pipe-viewer --no-interactive $video_query --custom-layout="[[video]]\ntitle = '''*TITLE*'''\nurl = '''*URL*'''" | sed -e "s/\"/'/g" -e "/^\$/d" -e 's/\x1b\[[0-9;]*m//g')
    set video_list (string join \n $raw_video_list | tomlq '.video')
    string join \n $video_list >/tmp/playlist.json

    set url_list (string join \n $video_list | jq -r '.[].url')

    if string match -r '^https?://' $video_query
        # a single link already spawns a video,
        # so we just exit.
        return 0
    end
    sed -i "/^$video_query\$/d" $histfile
    echo $video_query >>$histfile

    pkill -f mpvmusicsocket
    mpv --no-vid --input-ipc-server=/tmp/mpvmusicsocket $url_list
end
