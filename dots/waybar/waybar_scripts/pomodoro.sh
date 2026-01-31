#!/usr/bin/env bash
set -euo pipefail

# ================= CONFIG =================
STATE_FILE="/tmp/pomodoro.state"
LOG_FILE="$HOME/Documents/pomodoro_log.txt"
COLOR_FILE="$HOME/.config/waybar/matugen/pomodoro-colors.sh"

# Default colors
COLOR_FOCUS="#B8174A"
COLOR_BREAK="#F37079"
COLOR_TEXT="#eeeeee"
COLOR_PAUSED="#13303D"

[[ -f "$COLOR_FILE" ]] && source "$COLOR_FILE"

# ================= INIT =================
if [[ ! -f $STATE_FILE ]]; then
cat > "$STATE_FILE" <<EOF
state=stopped
mode=focus
timer=1500
break_base=300
task=Idle
start_time=
EOF
fi

# ================= LOAD STATE =================
# shellcheck source=/tmp/pomodoro.state
source "$STATE_FILE"

# ================= SAVE STATE (SAFE FOR SPACES) =================
save_state() {
cat > "$STATE_FILE" <<EOF
state=$state
mode=$mode
timer=$timer
break_base=$break_base
task=$(printf '%q' "$task")
start_time=$start_time
EOF
}

# ================= HELPERS =================
fmt_time() { printf "%02d:%02d" $((timer / 60)) $((timer % 60)); }
notify() { notify-send "Pomodoro" "$1"; }
# sound() { paplay "$1" &>/dev/null & }
sound() {
    if command -v pw-play >/dev/null 2>&1; then
        pw-play "$1" &>/dev/null &
    elif command -v paplay >/dev/null 2>&1; then
        paplay "$1" &>/dev/null &
    elif command -v play >/dev/null 2>&1; then
        play "$1" -q &>/dev/null &
    else
        echo "Warning: No audio player found (pw-play, paplay, or play)" >&2
    fi
}

# ================= COMMANDS =================
case "${1:-}" in
update)
    if [[ $state == running && "${2:-}" != task ]]; then
        if (( timer > 0 )); then
            ((timer--))
        else
            if [[ $mode == focus ]]; then
        
                # -------- LOG --------
                end_time=$(date +"%H.%M.%S")
                today=$(date +"%d / %m / %Y")

                # [[ -f $LOG_FILE ]] || echo "Session 0" > "$LOG_FILE"
                [[ -f "$LOG_FILE" ]] || (mkdir -p "$(dirname "$LOG_FILE")" && touch "$LOG_FILE" && echo "Session 1 Create Pomodoro Log" > "$LOG_FILE")
                grep -q "$today" "$LOG_FILE" || echo -e "\n$today" >> "$LOG_FILE"

                sesi=$(( $(grep -c '^Session' "$LOG_FILE" 2>/dev/null) + 1 ))
                echo "Session $sesi $task $start_time - $end_time" >> "$LOG_FILE"

                # -------- SWITCH TO BREAK --------
                mode=break
                timer=$break_base
                notify "Focus completed — Break $((break_base / 60)) minutes"
                sound "$HOME/.config/waybar/freedesktop/stereo/complete.oga"
            else
                # -------- RESET --------
                mode=focus
                timer=1500
                break_base=300
                task=Idle
                notify "Back to default 25:5"
                sound "$HOME/.config/waybar/freedesktop/stereo/alarm-clock-elapsed.oga"
            fi
        fi
        save_state
    fi

    time_str=$(fmt_time)

    if [[ $state == paused ]]; then
        color=$COLOR_PAUSED icon="󰏤"
    elif [[ $mode == focus ]]; then
        color=$COLOR_FOCUS icon="󱎫"
    else
        color=$COLOR_BREAK icon="󱏐"
    fi

    if [[ "${2:-}" == task ]]; then
        [[ $state == paused ]] && text="Paused ($task)" \
        || [[ $mode == focus ]] && text="Focus ($task)" \
        || text="Break"
        echo "{\"text\":\"<span color='$COLOR_TEXT'>$text</span>\",\"class\":\"$mode\"}"
    else
        echo "{\"text\":\"<span color='$color'>$icon $time_str</span>\",\"class\":\"$mode\"}"
    fi
;;

add)
    if [[ $mode == focus ]]; then
        ((timer += 300))
        ((break_base += 60))
        notify "Focus +5m (Break $((break_base / 60))m)"
    else
        ((timer += 60))
        notify "Break +1m"
    fi
    save_state
;;

sub)
    if [[ $mode == focus ]]; then
        ((timer = timer > 300 ? timer - 300 : 0))
        ((break_base = break_base > 60 ? break_base - 60 : 60))
        notify "Focus -5m (Break $((break_base / 60))m)"
    else
        ((timer = timer > 60 ? timer - 60 : 0))
        notify "Break -1m"
    fi
    save_state
;;

toggle)
    if [[ $state != running ]]; then
        if [[ $mode == focus && $task == Idle ]]; then
            task=$(zenity --entry \
                --title="Pomodoro" \
                --text="What is your focus target?" \
                --entry-text="Coding" \
                2>/dev/null || echo "Focus Session")

            [[ -z $task ]] && task="Focus Session"
            start_time=$(date +"%H.%M.%S")
        fi
        state=running
    else
        state=paused
    fi
    save_state
;;

reset)
    state=stopped
    mode=focus
    timer=1500
    break_base=300
    task=Idle
    start_time=
    notify "Reset to 25:5"
    save_state
;;
esac
