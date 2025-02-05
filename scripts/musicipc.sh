#!/bin/zsh

command=$1
export music_socket=/tmp/mpvmusicsocket

# Converts `watch?v=???` (or the whole url) to the video's title (based on /tmp/playlist.json)
function url_to_title() {
    if ! echo "$@" | grep -Eq 'watch.+'
    then
        echo "$@"
        return 1
    fi
    cat /tmp/playlist.json | jq -r ".[] | select(.url | contains(\"$@\")) | .title"
}

case "$command" in
    toggleplay)
        paused="$(mpv_command get_property pause | jq '.data')"
        if [[ $paused = false ]]; then
            mpv_command set_property pause true
        else
            mpv_command set_property pause false
        fi
        ;;
    plusminute)
        echo 'seek 60' | socat - $music_socket
        ;;
    minusminute)
        echo 'seek -60' | socat - $music_socket
        ;;
    next)
        mpv_command playlist-next
        ;;
    prev)
        mpv_command playlist-prev
        ;;
    status)
        function format_time() {
            if [[ ${#1} -eq 1 ]]; then
                echo "0$1"
            else
                echo $1
            fi
        }
        timestamp="$(mpv_command get_property time-pos | jq '.data')"
        minutes="$(echo $(($timestamp / 60)) | cut -d '.' -f1 )"
        minutes="$(format_time $minutes)"
        seconds="$(echo $(($timestamp % 60)) | cut -d '.' -f1 )"
        seconds="$(format_time $seconds)"
        # `relative_song \$playlist +1` fetches the next song
        function relative_song() {
            if [[ "${#@[@]}" -ne "3" ]]; then
                return 1
            fi
            playlist=$1
            song_url=$2
            offset=$3
            current_id="$(echo $playlist | jq -r ".data.[] | select(.filename | contains(\"$song_url\")) | .id")"
            
            searched_song_url="$(echo $playlist | jq -r ".data.[] | select(.id==$(($current_id$offset))) | .filename")"
            url_to_title "$searched_song_url"
        }

        # this is actually `watch?v=???`
        song_url="$(mpv_command get_property filename | jq -r '.data')"
        playlist="$(mpv_command get_property playlist )"
        song_title="$(relative_song $playlist $song_url '+0')"
        if [[ $? -ne 0 ]]; then
            echo -e "$song_url\n$song_title"
            echo "coudn't figure out the songs title"
            exit 1
        fi
        next="$(relative_song $playlist $song_url '+1')"
        if [[ ! -z $next ]]; then
            next="$next <span foreground='yellow'>(next)</span>\n"
        fi

        previous="$(relative_song $playlist $song_url '-1')"
        if [[ ! -z $previous ]]; then
            previous="\n$previous <span foreground='yellow'>(previous)</span>"
        fi

        nextnext="$(relative_song $playlist $song_url '+2')\n"
        previousprevious="\n$(relative_song $playlist $song_url '-2')"

        title_stop_at=40
        trimmed_song_title="$song_title"
        if [[ ${#song_title} -gt $title_stop_at ]]; then
            trimmed_song_title="$(echo $song_title | cut -c1-40)..."
        fi
        cat << EOF | paste -sd' ' - 
        {
            "text": "[$trimmed_song_title] $minutes:$seconds",
            "tooltip": "<tt>$nextnext$next<b>$song_title [<span foreground='yellow'><i>$minutes:$seconds</i></span>]</b>$previous$previousprevious</tt>"
        }
EOF
        ;;

    *)
        echo bruh
        ;;
esac
