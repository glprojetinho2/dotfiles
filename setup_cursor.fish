#!/bin/fish
set non_default_cursors (find /usr/share/icons ~/.local/share/icons ~/.icons -type d -name "cursors" | grep -v default)
for cursor in $non_default_cursors
    rm -rf $cursor
end
