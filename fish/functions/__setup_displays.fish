function __setup_displays
    set primary (swaymsg -t get_outputs | jq -r 'max_by(.rect.width) | .name')
    xrandr --output $primary --primary
    for workspace in $argv
        set cmd "workspace $workspace output $primary"
        echo $cmd >>~/setup_displays.log
        swaymsg "$cmd"
    end
end
