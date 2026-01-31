#!/usr/bin/env bash

# --- KONFIGURASI WARNA ---

COLOR_FILE="$HOME/.config/waybar/matugen/pomodoro-colors.sh"

[[ -f "$COLOR_FILE" ]] && source "$COLOR_FILE"

# Ubah warna di sini agar otomatis berubah di semua jendela
COLOR=$COLOR_PRIMARY
# BG_COLOR=$COLOR_BACKGROUND

# COLOR="#ffb088"
# BG_COLOR="#17161C"

# Fungsi untuk menutup semua jika sudah terbuka (Toggle)
if hyprctl clients | grep -q "class: matrix-floats"; then
    pkill -f momoisay & 
    hyprctl dispatch closewindow class:cava-float & 
    hyprctl dispatch closewindow class:clock-floating & 
    hyprctl dispatch closewindow class:matrix-floats & 
    hyprctl keyword decoration:dim_inactive true
    exit 0
fi


hyprctl keyword decoration:dim_inactive false
# --- MENJALANKAN APLIKASI ---

# 1. Momoisay
kitty --class momoisay-float -o "foreground=$COLOR" -e momoisay -f &

# kitty --class momoisay-float -o "foreground=$COLOR" -e sh -c "cat /home/sharland/.config/waybar/ScriptModules/linux.txt; read" &
# kitty --class momoisay-float \
#   -o "initial_window_width=800" \
#   -o "initial_window_height=600" \
#   -o "font_size=36" \
#   -o "window_padding_width=20" \
#   -o "foreground=$COLOR" \
#   -e sh -c "cat /home/sharland/.config/waybar/ScriptModules/linux.txt; read" &

# 2. TTY-Clock
kitty --class clock-floating -o "color5=$COLOR" -e tty-clock -c -s -C 5 &

# 3. CMatrix (Matrix Effect)
# Kita pakai flag -C red atau warna lain, dan foreground terminal kita paksa ke COLOR
kitty --class matrix-floats -o "foreground=$COLOR" -o "background=$BG_COLOR" -e sh -c "printf '\e]11;$BG_COLOR\a'; cmatrix -a -b" &

# 4. Cava (Visualizer)
kitty --class cava-float -o "foreground=$COLOR" -e cava &


# kitty --class momoisay-float -o \"foreground=#ffb088\" -e momoisay -a & 
# kitty --class clock-floating -o \"color5=#ffb088\" -e tty-clock -c -s -C 5 & 

# kitty --class matrix-floats -o \"color1=#ffb088\" -o \"background=#000000\" -e sh -c \"printf '\\e]11;#17161C\\a'; cmatrix -a -b -C red\" & 

# kitty --class cava-float -o \"foreground=#ffb088\" -e cava
