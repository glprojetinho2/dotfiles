#!/bin/fish
function screen_recorder
    pkill -f wf-recorder
    and notify-send "Finishing recording"
    and return 1
    set -l RECORD (swaymsg -t get_outputs | yq '(.[] | select(.focused==true)) | .name' | yq -r)
    if test -z "$RECORD"
        return 1
    end

    set -l filename "recording_$(date +%c | tr ' ' '_').mp4"

    set video_path "$HOME/Vídeos/$filename"
    set audio_output (pactl list sources | grep Name | cut -d ':' -f2 | cut -d ' ' -f2 | grep output)[1]
    wf-recorder -f $video_path --output $RECORD --audio=$audio_output $argv
    echo "file://$video_path" | wl-copy -t text/uri-list
end
