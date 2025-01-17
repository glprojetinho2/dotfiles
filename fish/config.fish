if status is-interactive
    # Commands to run in interactive sessions can go here
end
set -gx EDITOR helix
set -gx VISUAL helix
set -gx MANPAGER bat
set -gx BAT_THEME gruvbox-light
set fish_greeting
set -g fish_key_bindings fish_vi_key_bindings
bind -M insert \cf accept-autosuggestion
bind -M insert \cn history-search-forward
bind -M insert \cp history-search-backward
bind -M insert \ct fish_tldr_binding
bind -- !! 'commandline -i "( $history[1] )"'

starship init fish | source
zoxide init fish | source

if test -z $WAYLAND_DISPLAY; and test -n $XDG_VTNR; and test $XDG_VTNR -eq 1
    exec sway
end
