#!/usr/bin/env bash

# --- Konfigurasi Direktori ---
# SESUAIKAN: ganti dengan path folder tempat kamu menyimpan folder-folder tema
THEMES_DIR="$HOME/.config/waybar/themes"
WAYBAR_CONFIG="$HOME/.config/waybar/config"
WAYBAR_STYLE="$HOME/.config/waybar/style.css"
SCRIPTSDIR="$HOME/.config/hypr/scripts"
ROFI_CONFIG="$HOME/.config/rofi/config-rofi-search.rasi"

msg='Choose Waybar Theme:'

apply_theme() {
    local theme_name=$1
    local theme_path="$THEMES_DIR/$theme_name"

    # 1. Cari file CSS (Style)
    # Mencari file dengan ekstensi .css di dalam folder tema
    local css_file=$(find "$theme_path" -maxdepth 1 -type f -name "*.css" | head -n 1)

    # 2. Cari file Config (Layout)
    # Mencari file yang BUKAN .css dan bukan folder
    local conf_file=$(find "$theme_path" -maxdepth 1 -type f ! -name "*.css" | head -n 1)

    # Eksekusi Link jika file ditemukan
    if [[ -n "$conf_file" ]]; then
        ln -sf "$conf_file" "$WAYBAR_CONFIG"
        echo "Config linked: $conf_file"
    fi

    if [[ -n "$css_file" ]]; then
        ln -sf "$css_file" "$WAYBAR_STYLE"
        echo "Style linked: $css_file"
    fi

    # Refresh Waybar
    "${SCRIPTSDIR}/Refresh.sh" &
}

main() {
    if [[ ! -d "$THEMES_DIR" ]]; then
        notify-send "Error" "Direktori $THEMES_DIR tidak ditemukan."
        exit 1
    fi

    # Ambil daftar folder (Sharland, dll)
    mapfile -t options < <(find "$THEMES_DIR" -maxdepth 1 -mindepth 1 -type d -exec basename {} \; | sort)

    if [[ ${#options[@]} -eq 0 ]]; then
        echo "Tidak ada folder tema ditemukan di $THEMES_DIR"
        exit 1
    fi

    # Tentukan row aktif di Rofi
    current_target=$(readlink -f "$WAYBAR_CONFIG")
    current_theme=$(basename "$(dirname "$current_target")")

    default_row=0
    MARKER="👉"
    for i in "${!options[@]}"; do
        if [[ "${options[i]}" == "$current_theme" ]]; then
            options[i]="$MARKER ${options[i]}"
            default_row=$i
            break
        fi
    done

    choice=$(printf '%s\n' "${options[@]}" | rofi -i -dmenu -config "$ROFI_CONFIG" -mesg "$msg" -selected-row "$default_row")

    [[ -z "$choice" ]] && exit 0

    choice=${choice#"$MARKER "}
    apply_theme "$choice"
}

if pgrep -x "rofi" >/dev/null; then
    pkill rofi
fi

main
