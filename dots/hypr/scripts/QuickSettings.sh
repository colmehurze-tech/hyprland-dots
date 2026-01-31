#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Rofi menu for KooL Hyprland Quick Settings (SUPER SHIFT E)
# Updated for configs/configs separation

# Modify this config file for default terminal and EDITOR
config_file="$HOME/.config/hypr/configs/01-UserDefaults.conf"

tmp_config_file=$(mktemp)
sed 's/^\$//g; s/ = /=/g' "$config_file" > "$tmp_config_file"
source "$tmp_config_file"
# ##################################### #

# variables
configs="$HOME/.config/hypr/configs"
rofi_theme="$HOME/.config/rofi/config-rofi-search.rasi"
msg='Settings Menu: Select an option to edit or configure'
iDIR="$HOME/.config/swaync/images"
scriptsDir="$HOME/.config/hypr/scripts"
UserScripts="$HOME/.config/hypr/UserScripts"

# Function to show info notification
show_info() {
    notify-send -i "$iDIR/info.png" "Info" "$1"
}

# Function to display the menu options without numbers
menu() {
    cat <<EOF
Edit Keybinds
Edit Startup Apps
Edit Window Rules
Edit Settings
Choose Wallpaper
Choose Waybar Theme
Choose Kitty Terminal Theme
Configure Monitors (nwg-displays)
Configure Workspace Rules (nwg-displays)
GTK Settings (nwg-look)
Search for Keybinds
EOF
}

# Main function to handle menu selection
main() {
    choice=$(menu | rofi -i -dmenu -config $rofi_theme -mesg "$msg")
    
    # Map choices to corresponding files
    case "$choice" in
        "Edit Keybinds") file="$configs/Keybinds.conf" ;;
        "Edit Startup Apps") file="$configs/Startup_Apps.conf" ;;
        "Edit Window Rules") file="$configs/WindowRules.conf" ;;
        "Edit Settings") file="$configs/SystemSettings.conf" ;;
        "Choose Kitty Terminal Theme") $scriptsDir/Kitty_themes.sh ;;
        "Choose Wallpaper") $UserScripts/WallpaperSelect.sh ;;
        "Choose Waybar Theme") $scriptsDir/WaybarThemes.sh ;;
        "Configure Monitors (nwg-displays)") 
            if ! command -v nwg-displays &>/dev/null; then
                notify-send -i "$iDIR/error.png" "E-R-R-O-R" "Install nwg-displays first"
                exit 1
            fi
            nwg-displays ;;
        "Configure Workspace Rules (nwg-displays)") 
            if ! command -v nwg-displays &>/dev/null; then
                notify-send -i "$iDIR/error.png" "E-R-R-O-R" "Install nwg-displays first"
                exit 1
            fi
            nwg-displays ;;
		"GTK Settings (nwg-look)") 
            if ! command -v nwg-look &>/dev/null; then
                notify-send -i "$iDIR/error.png" "E-R-R-O-R" "Install nwg-look first"
                exit 1
            fi
            nwg-look ;;
        "Search for Keybinds") $scriptsDir/KeyBinds.sh ;;
        *) return ;;  # Do nothing for invalid choices
    esac

    if [ -n "$file" ]; then
        $term -e $edit "$file"
    fi
}

# Check if rofi is already running
if pidof rofi > /dev/null; then
  pkill rofi
fi

main
