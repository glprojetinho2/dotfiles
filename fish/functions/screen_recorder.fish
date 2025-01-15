#!/bin/fish
function screen_recorder
    pgrep wf-recorder
    and notify-send "Finishing recording"
    and pkill wf-recorder
    and return 1
    set -l RECORD (swaymsg -t get_outputs | yq '(.[] | select(.focused==true)) | .name' | yq -r)
    if test -z "$RECORD"
        return 1
    end

    set -l filename "recording_$(date +%c | tr ' ' '_').mp4"
    notify-send "Recording $filename"
    wf-recorder -f "$HOME/Vídeos/$filename" --output $RECORD $argv &
end
