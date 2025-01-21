function mpv_command --description 'sends command to the mpv socket'
    argparse s/socket= -- $argv
    set soc /tmp/mpvmusicsocket
    set -q _flag_socket; and set soc $_flag_socket
    set mpv_args (string join \n $argv | awk '{ if ($0 == "true" || $0 == "false") print $0; else print "\"" $0 "\"" }' | string join ', ')
    echo "{ \"command\": [$mpv_args] }" | socat - $soc
end
