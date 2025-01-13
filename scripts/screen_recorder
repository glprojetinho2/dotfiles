#!/bin/bash
pgrep wf-recorder && notify-send "Finishing recording" && pkill wf-recorder && exit 1
RECORD=$(zenity --list --title "Choose display to record" --column "Display" $(wlr-randr | awk '!/^ / {print $1}'))
if [ -z "$RECORD" ]; then
  exit 1
fi

filename=recording_$(date +%c | tr ' ' '_').mp4
wf-recorder -f ~/Vídeos/$filename --output $RECORD &
notify-send "Recording $filename"
