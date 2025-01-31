function random_theme
    set random_theme (find ~/.config/alacritty/colors -type f -print | shuf -n1)
    sed -i "s:import = \[ \".*\":import = [ \"$random_theme\":" ~/.config/alacritty/alacritty.toml
end
