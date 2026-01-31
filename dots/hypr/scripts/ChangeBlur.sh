#!/usr/bin/env bash

notif="$HOME/.config/swaync/images"

# Mengambil status 'enabled' (hasilnya biasanya 0 untuk OFF, atau 1 untuk ON)
STATE=$(hyprctl -j getoption decoration:blur:enabled | jq ".int")

if [ "$STATE" -eq 1 ]; then
    # Jika sekarang AKTIF (1), maka MATIKAN
    hyprctl keyword decoration:blur:enabled false
    notify-send -e -u low -i "$notif/note.png" "Blur: OFF"
else
    # Jika sekarang MATI (0), maka NYALAKAN
    hyprctl keyword decoration:blur:enabled true
    hyprctl keyword decoration:blur:size 8
    hyprctl keyword decoration:blur:passes 3
    notify-send -e -u low -i "$notif/ja.png" "Blur: ON (High)"
fi
