function youtube_dmenu -d "Search youtube using dmenu"
    # you need to add this to ~/.config/pipe-viewer/pipe-viewer.conf 
    # ( append it to `custom_layout_format` ).
    # { align => "right", color => "bold", text => "*ID*", width => 11 },
    pkill dmenu

    # Default config directory
    set configdir "$HOME/.config/youtube_dmenu"
    not test -z $XDG_CONFIG_HOME; and set configdir "$XDG_CONFIG_HOME/.config/youtube_dmenu"
    set histfile $configdir/history

    if not test -d "$configdir"
        echo "Directory $configdir does not exist, creating..."
        mkdir -p "$configdir"
    end

    set video_query (cat $histfile | dmenu -p "Search query: ")
    if test -z $video_query
        echo "no input."
        return 1
    end
    set video_id (pyt --results=50 --no-interactive $video_query | sed -e 's/\x1b\[[0-9;]*m//g' -e 's/^ \+//g' | dmenu -l 20 -p "Choose an youtube video: " | tr -s ' ' | cut -d ':' -f2- | cut -d ' ' -f2)
    if test -z $video_id
        echo "no video selected."
        return 1
    end
    grep "^$video_query\$" $histfile; or echo $video_query >>$histfile

    pyt --no-interactive "https://www.youtube.com/watch/?v=$video_id"
end
