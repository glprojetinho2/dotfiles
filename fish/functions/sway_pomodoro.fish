function sway_pomodoro
    set stat $(i3-gnome-pomodoro status --format=waybar --show-seconds)
    if test -z $stat
        echo '{"text": "Pomodoro"}'

    else
        echo $stat
    end
end
