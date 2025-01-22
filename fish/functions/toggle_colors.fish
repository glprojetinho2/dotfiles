function toggle_colors -d "Changes alacritty's theme"
    set light_theme '~/.config/alacritty/light-theme.toml'
    set dark_theme '~/.config/alacritty/dark-theme.toml'
    set config ~/.config/alacritty/alacritty.toml
    if cat $config | grep $light_theme
        sed -i "s:$light_theme:$dark_theme:" $config
        return 0
    end

    if cat $config | grep $dark_theme
        sed -i "s:$dark_theme:$light_theme:" $config
        return 0
    end
end
