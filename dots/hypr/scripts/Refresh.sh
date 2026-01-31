#!/usr/bin/env bash

echo "Memulai Refresh UI..."

# Momoisay
if hyprctl clients | grep -q "class: matrix-floats"; then
    WAS_OPEN=true
    "$HOME/.config/waybar/waybar_scripts/Momoisay.sh" &
else
    WAS_OPEN=false
fi

# 1. Fungsi untuk mematikan proses dengan aman
terminate_process() {
    local name=$1
    # Jika dijalankan sebagai systemd service (NixOS style)
    if systemctl --user is-active --quiet "$name.service" 2>/dev/null; then
        echo "Restarting $name via systemd..."
        systemctl --user restart "$name.service"
        return 0
    fi
    
    # Jika manual (Arch style), kill prosesnya
    if pidof "$name" > /dev/null; then
        echo "Killing manual process: $name"
        pkill -x "$name"
        return 1
    fi
    return 1
}


# 2. Restart Waybar (Logika Anti-Numpuk NixOS)
pkill -9 waybar
pkill -9 .waybar-wrapped 
if systemctl --user list-unit-files | grep -q waybar.service; then
    echo "Restarting via Systemd..."
    systemctl --user restart waybar.service
    WAYBAR_AUTO_STARTED=true
else
    WAYBAR_AUTO_STARTED=false
fi

# 3. Matikan aplikasi lain
_apps=(rofi swaybg)
for app in "${_apps[@]}"; do
    pkill -x "$app"
done

# 4. Refresh SwayNC
if pidof swaync > /dev/null; then
    swaync-client --reload-config
    swaync-client --reload-css
else
    # Gunakan uwsm jika ada, jika tidak panggil langsung
    if command -v uwsm > /dev/null; then
        uwsm app -- swaync &
    else
        swaync &
    fi
fi

sleep 0.3

# 5. Jalankan ulang Waybar HANYA jika tidak pakai systemd
if [ "$WAYBAR_AUTO_STARTED" = false ]; then
    if command -v uwsm > /dev/null; then
        uwsm app -- waybar -c "$HOME/.config/waybar/config" &
    else
        waybar -c "$HOME/.config/waybar/config" &
    fi
fi

# 6. Momoisay

sleep 0.67
if [ "$WAS_OPEN" = true ]; then
    "$HOME/.config/waybar/waybar_scripts/Momoisay.sh" &
fi


# 7. Notifikasi (Gunakan notify-send agar universal dan tidak error)
if command -v notify-send > /dev/null; then
    notify-send "System Refresh" "UI components reloaded successfully" -i utilities-terminal
elif command -v swaync-client > /dev/null; then
    # Jika terpaksa pakai swaync-client, gunakan toggle untuk memberi tanda
    swaync-client -t
fi
echo "Refresh selesai!"
