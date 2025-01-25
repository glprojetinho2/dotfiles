#!/bin/fish
test -d cursor; or return 1
set non_default_cursors ( find /usr/share/icons ~/.local/share/icons ~/.icons -type d -name "cursors" | grep -vE '^/usr/share/icons/default/$')

for cursor in $non_default_cursors
    sudo rm -rf $cursor
end
sudo rm -rf /usr/share/icons/default
sudo cp -rTf cursor /usr/share/icons/default
