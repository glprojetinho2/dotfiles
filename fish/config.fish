if status is-interactive
    # Commands to run in interactive sessions can go here
end
fish_add_path -p $HOME/.local/share/nvim/mason/bin/ $HOME/.local/share/lvim/mason/bin/
set -U EDITOR "vim"
set -U VISUAL "lvim"
set fish_greeting
set -x MANPAGER "nvim +Man!"
set -g fish_key_bindings fish_vi_key_bindings
alias chromium="chromium --enable-features=UseOzonePlatform --ozone-platform=wayland"
starship init fish | source
zoxide init fish | source
