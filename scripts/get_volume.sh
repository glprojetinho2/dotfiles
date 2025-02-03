#!/bin/sh
volume_decimal="$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d' ' -f2)"
volume=$(echo 100*$volume_decimal | bc | cut -d'.' -f1)

if [[ $volume -lt 10 ]]; then
        echo [⡇____]
elif [[ $volume -lt 20 ]]; then
        echo [⣿____]
elif [[ $volume -lt 30 ]]; then
        echo [⣿⡇___]
elif [[ $volume -lt 40 ]]; then
        echo [⣿⣿___]
elif [[ $volume -lt 50 ]]; then
        echo [⣿⣿⡇__]
elif [[ $volume -lt 60 ]]; then
        echo [⣿⣿⣿__]
elif [[ $volume -lt 70 ]]; then
        echo [⣿⣿⣿⡇_]
elif [[ $volume -lt 80 ]]; then
        echo [⣿⣿⣿⣿_]
elif [[ $volume -lt 90 ]]; then
        echo [⣿⣿⣿⣿⡇]
elif [[ $volume -le 100 ]]; then
        echo [⣿⣿⣿⣿⣿]
fi
