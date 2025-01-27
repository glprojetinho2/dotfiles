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

    set clipb (wl-paste)
    if string match -r 'youtube\.com|youtu\.be' $clipb
        set copied_youtube_link $clipb
    end
    set suggestions (echo -e "$copied_youtube_link\n$(tac $histfile)")
    set video_query ( string join \n $suggestions | sed '/^$/d' | rofi -dmenu -i -p "Search query")
    if test -z $video_query
        echo "no input."
        return 1
    end
    set video_list_with_id (pipe-viewer  --append-args="--input-ipc-server=/tmp/mpvvideosocket" --no-interactive --custom-layout="*NO*. *TITLE* [[*AUTHOR*]] *AGE_SHORT* *VIEWS_SHORT* *TIME* ||| *ID*" $video_query | sed -e 's/\x1b\[[0-9;]*m//g' -e 's/^ \+//g' -e '/^$/d')
    set video_list (string join \n $video_list_with_id | sed 's/ ||| .*//g')
    string join \n $video_list >/tmp/vdlist
    if string match -r '^https?://' $video_query
        # a single link already spawns a video,
        # so we just exit.
        return 0
    end

    set video_number ( string join \n $video_list | rofi -dmenu -i -l 20 -p "Choose an youtube video" | cut -d . -f1 )
    set video_id (string join \n $video_list_with_id | grep "^$video_number." | sed 's/.\+ ||| //g')
    if test -z $video_id
        echo "no video selected."
        return 1
    end
    sed -i "/^$video_query\$/d" $histfile
    echo $video_query >>$histfile

    echo "video id: $video_id"
    set yt_link "https://www.youtube.com/watch?v=$video_id"
    echo $yt_link >/tmp/youtube_menu_link
    mpv --input-ipc-server=/tmp/mpvvideosocket $yt_link $argv
end
