#!/bin/sh
read pipe_info
echo $pipe_info > /tmp/aas
alacritty -e echo "$pipe_info" | pinentry-curses "$@"
