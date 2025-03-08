#!/bin/sh
pkill rofi

# Default config directory
configdir="$HOME/.config/youtube_music_menu"
if [[ ! -z $XDG_CONFIG_HOME ]]; then
	configdir="$XDG_CONFIG_HOME/.config/youtube_music_menu"
fi
histfile=$configdir/history

if [[ ! -d "$configdir" ]]; then
	echo "Directory $configdir does not exist, creating..."
	mkdir -p "$configdir"
fi

video_query="$(tac $histfile | sed '/^$/d' | rofi -dmenu -i -p "Search query")"
if [[ -z $video_query ]]; then
	echo "no input."
	exit 1
fi

raw_video_list="$(pipe-viewer --no-interactive $video_query --custom-layout="[[video]]\ntitle = '''*TITLE*'''\nurl = '''*URL*'''" | sed -e "s/\"/'/g" -e "/^\$/d" -e 's/\x1b\[[0-9;]*m//g')"
video_list="$(echo "$raw_video_list" | tomlq '.video')"
echo "$video_list" >/tmp/playlist.json

url_list="$(echo "$video_list" | jq -r '.[].url')"

if echo $video_query | grep '^https?://'; then
	# a single link already spawns a video,
	# so we just exit.
	exit 0
fi

sed -i "/^$video_query\$/d" $histfile
echo $video_query >>$histfile

pkill -f mpvmusicsocket
mpv --no-vid --input-ipc-server=/tmp/mpvmusicsocket $url_list
