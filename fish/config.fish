if status is-interactive
    # Commands to run in interactive sessions can go here
end
set -U EDITOR helix
set -U VISUAL helix
set fish_greeting
set -g fish_key_bindings fish_vi_key_bindings
bind -M insert \cf accept-autosuggestion

starship init fish | source
zoxide init fish | source

if test -z $WAYLAND_DISPLAY && test -n $XDG_VTNR && test $XDG_VTNR -eq 1
    exec sway
end
