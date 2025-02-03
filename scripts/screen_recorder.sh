#!/bin/sh
pkill -f wf-recorder && notify-send "Finishing recording" && exit 1
RECORD=$(wlr-randr | yq '(.[] | select(.focused==true)) | .name' | yq -r)
if [[ -z "$RECORD" ]]; then
    exit 1
fi
filename="recording_$(date +%c | tr ' ' '_').mp4"

video_path="$HOME/Vídeos/$filename"
audio_output=$(pactl list sources | grep Name | cut -d ':' -f2 | cut -d ' ' -f2 | grep output | head -n1)
wf-recorder -f $video_path --output $RECORD --audio=$audio_output $@
echo "file://$video_path" | wl-copy -t text/uri-list
