#/bin/sh
pkill rofi


# Default config directory
configdir="$HOME/.config/youtube_menu"
if [[ ! -z $XDG_CONFIG_HOME ]]
    then
    configdir="$XDG_CONFIG_HOME/.config/youtube_menu"
fi
histfile="$configdir/history"

if [[ ! -d "$configdir" ]]
    then
    echo "Directory $configdir does not exist, creating..."
    mkdir -p "$configdir"
fi

clipb="$(wl-paste)"
if [[ ! -z $(echo "$clipb" | grep 'youtube\.com|youtu\.be') ]]; then
    copied_youtube_link="$clipb"
fi
suggestions="$copied_youtube_link\n$(tac $histfile)"
video_query="$(echo -e "$suggestions" | sed '/^$/d' | rofi -dmenu -i -p "Search query")"
if [[ -z $video_query ]]; then
    echo "no input."
    exit 1
fi
video_list_with_id="$(pipe-viewer  --append-args="--input-ipc-server=/tmp/mpvvideosocket" --no-interactive --custom-layout="*NO*. *TITLE* [[*AUTHOR*]] *AGE_SHORT* *VIEWS_SHORT* *TIME* ||| *ID*" $video_query | sed -e 's/\x1b\[[0-9;]*m//g' -e 's/^ \+//g' -e '/^$/d')"
video_list="$(echo "$video_list_with_id" | sed 's/ ||| .*//g')"
echo "$video_list" >/tmp/vdlist
if grep '^https?://' "$video_query"; then
    # a single link already spawns a video,
    # so we just exit.
    exit 0
fi

video_number="$(echo "$video_list" | rofi -dmenu -i -l 20 -p "Choose an youtube video" | cut -d . -f1 )"
if [[ -z $video_number ]]; then
    exit 0
fi
video_id="$(echo "$video_list_with_id" | grep "^$video_number." | sed 's/.\+ ||| //g')"
if [[ -z $video_id ]]; then
    echo "no video selected."
    exit 1
fi
sed -i "/^$video_query\$/d" $histfile
echo "$video_query" >>$histfile

echo "video id: $video_id"
yt_link="https://www.youtube.com/watch?v="$video_id""
echo "$yt_link" >/tmp/youtube_menu_link
mpv --input-ipc-server=/tmp/mpvvideosocket $yt_link $argv
