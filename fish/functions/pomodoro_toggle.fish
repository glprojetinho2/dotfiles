function pomodoro_toggle
    if test -z $(i3-gnome-pomodoro status)
        i3-gnome-pomodoro start
    else
        i3-gnome-pomodoro toggle
    end
end
