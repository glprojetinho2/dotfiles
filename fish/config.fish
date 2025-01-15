if status is-interactive
    # Commands to run in interactive sessions can go here
end
fish_add_path $HOME/.local/bin
set -gx EDITOR helix
set -gx VISUAL helix
set fish_greeting
set -gx fish_key_bindings fish_vi_key_bindings
bind -M insert \cf accept-autosuggestion

starship init fish | source
zoxide init fish | source

if test -z $WAYLAND_DISPLAY && test -n $XDG_VTNR && test $XDG_VTNR -eq 1
    exec sway
end
