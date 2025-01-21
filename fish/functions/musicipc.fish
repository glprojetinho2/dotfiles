function musicipc -d "Control music playback externally"
    set command $argv[1]
    set soc /tmp/mpvmusicsocket

    function url_to_title -d "Converts `watch?v=???` (or the whole url) to the video's title (based on /tmp/playlist.json)"
        string match -r 'watch.+' $argv >/dev/null 2>&1; or return 0
        cat /tmp/playlist.json | jq -r ".[] | select(.url | contains(\"$argv\")) | .title"
    end

    function mpv_command -d "sends command to the mpv socket"
        set soc /tmp/mpvmusicsocket
        set mpv_args (string join \n $argv | awk '{ if ($0 == "true" || $0 == "false") print $0; else print "\"" $0 "\"" }' | string join ', ')
        echo "{ \"command\": [$mpv_args] }" | socat - $soc
    end

    switch $command
        case toggleplay
            set paused (mpv_command get_property pause | jq '.data')
            if test $paused = false
                mpv_command set_property pause true
            else
                mpv_command set_property pause false
            end
        case plusminute
            echo 'seek 60' | socat - $soc

        case minusminute
            echo 'seek -60' | socat - $soc
        case next
            mpv_command playlist-next
        case prev
            mpv_command playlist-prev
        case status
            function format_time
                if test (string length $argv[1]; or return 0) -eq 1
                    echo "0$argv[1]"
                else
                    echo $argv[1]
                end
            end
            set timestamp (mpv_command get_property time-pos | jq '.data')
            set minutes (builtin math "$timestamp / 60" | cut -d '.' -f1 )
            set minutes (format_time $minutes)
            set seconds (builtin math "$timestamp % 60" | cut -d '.' -f1 )
            set seconds (format_time $seconds)

            function relative_song -d "`relative_song \$playlist +1` fetches the next song"
                if test (count $argv) -ne 3
                    return 1
                end
                set playlist $argv[1]
                set song_url $argv[2]
                set offset $argv[3]
                set current_id (echo $playlist | jq -r ".data.[] | select(.filename | contains(\"$song_url\")) | .id")
                set searched_song_url (echo $playlist | jq -r ".data.[] | select(.id==$(math "$current_id$offset")) | .filename")
                url_to_title $searched_song_url
            end

            set song_url (mpv_command get_property filename | jq -r '.data') # this is actually `watch?v=???`
            set playlist (mpv_command get_property playlist )
            set song_title (relative_song $playlist $song_url '+0'); or return 1

            set next (relative_song $playlist $song_url '+1')
            if not test -z $next
                set next (echo "$next <span foreground='yellow'>(next)</span>\n")
            end

            set previous (relative_song $playlist $song_url '-1')
            if not test -z $previous
                set previous (echo "\n$previous <span foreground='yellow'>(previous)</span>")
            end

            set nextnext (echo "$(relative_song $playlist $song_url '+2')\n")
            set previousprevious (echo "\n$(relative_song $playlist $song_url '-2')")

            set title_stop_at 40
            set trimmed_song_title $song_title
            if test (string length $song_title) -gt $title_stop_at
                set trimmed_song_title "$(string sub -l 40 $song_title)..."
            end
            echo "{\"text\": \"[$trimmed_song_title] $minutes:$seconds\", \
            \"tooltip\": \"<tt>$nextnext$next<b>$song_title</b>$previous$previousprevious</tt>\"}"
    end
end
