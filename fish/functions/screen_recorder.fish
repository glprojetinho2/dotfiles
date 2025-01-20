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
    notify-send "Recording $filename"

    set video_path "$HOME/Vídeos/$filename"
    wf-recorder -f $video_path --output $RECORD $argv
    echo "file://$video_path" | wl-copy -t text/uri-list
end
