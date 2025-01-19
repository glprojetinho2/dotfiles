function musicipc -d "Control music playback externally"
    set command $argv[1]
    set socket /tmp/mpvmusicsocket
    switch $command
        case toggleplay
            set paused (echo '{ "command": ["get_property", "pause"] }' | socat - $socket | jq '.data')
            if test $paused = false
                echo '{ "command": ["set_property", "pause", true] }' | socat - $socket
            else
                echo '{ "command": ["set_property", "pause", false] }' | socat - $socket
            end
        case plusminute
            echo 'seek 60' | socat - $socket
        case minusminute
            echo 'seek -60' | socat - $socket
        case status
            function format_time
                if test (string length $argv[1]) -eq 1
                    echo "0$argv[1]"
                else
                    echo $argv[1]
                end
            end
            set timestamp (echo '{ "command": ["get_property", "time-pos"] }' | socat - /tmp/mpvmusicsocket | jq '.data')
            set minutes (math "$timestamp / 60" | cut -d '.' -f1 )
            set minutes (format_time $minutes)
            set seconds (math "$timestamp % 60" | cut -d '.' -f1 )
            set seconds (format_time $seconds)

            set music_title (echo '{ "command": ["get_property", "media-title"] }' | socat - $socket | jq -r '.data' | string sub -l 7)

            echo "[$music_title] $minutes:$seconds"
    end
end
