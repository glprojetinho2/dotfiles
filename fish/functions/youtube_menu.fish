function youtube_menu -d "Search youtube using a floating menu."
    pkill rofi

    # Default config directory
    set configdir "$HOME/.config/youtube_menu"
    not test -z $XDG_CONFIG_HOME; and set configdir "$XDG_CONFIG_HOME/.config/youtube_menu"
    set histfile $configdir/history

    if not test -d "$configdir"
        echo "Directory $configdir does not exist, creating..."
        mkdir -p "$configdir"
    end

    set video_query (tac $histfile | sed '/^$/d' | rofi -dmenu -i -p "Search query: ")
    if test -z $video_query
        echo "no input."
        return 1
    end
    set video_list (pipe-viewer --no-interactive --custom-layout="*NO*. *TITLE* *AUTHOR* *AGE_SHORT* *VIEWS_SHORT* *TIME* *ID*" $video_query | sed -e 's/\x1b\[[0-9;]*m//g' -e 's/^ \+//g' -e '/^$/d')
    if string match -r '^https?://' $video_query
        # a single link already spawns a video,
        # so we just exit.
        return 0
    end

    set video_id ( string join \n $video_list | rofi -dmenu -i -l 20 -p "Choose an youtube video: " | tr ' ' '\n')[-1]
    if test -z $video_id
        echo "no video selected."
        return 1
    end
    sed -i "/^$video_query\$/d" $histfile
    echo $video_query >>$histfile

    echo "video id: $video_id"
    mpv --cache=no --input-ipc-server=/tmp/mpvvideosocket "https://www.youtube.com/watch/?v=$video_id" $argv
end
