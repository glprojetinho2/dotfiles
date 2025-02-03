#!/bin/sh
resultado="$(rg --color=always -C1 "$1")"
echo "$resultado" | aha | wl-copy -t text/html
echo "$resultado"
