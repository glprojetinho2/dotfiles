#!/bin/zsh
parts=(${(@s: :)@})
mpv_args=()
for arg in $parts; do
    mpv_args+=($(echo $arg | awk '{ if ($0 == "true" || $0 == "false") print $0; else print "\"" $0 "\"" }'))
done
joined=${(j|, |)mpv_args}
echo "{\"command\": [$joined]}"| socat - $music_socket

