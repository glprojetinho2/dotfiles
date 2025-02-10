#!/bin/sh
[ -d cursor ] || exit 1
non_default_cursors=($(find /usr/share/icons ~/.local/share/icons ~/.icons -type d -name "cursors" | grep -vE '^/usr/share/icons/default/$'))

for cursor in $non_default_cursors; do
    sudo rm -rf $cursor
done
sudo rm -rf /usr/share/icons/default
sudo cp -rTf cursor /usr/share/icons/default
