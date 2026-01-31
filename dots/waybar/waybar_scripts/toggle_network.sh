#!/bin/bash


STATE_FILE="/tmp/waybar_net_state"
DATA_FILE="/tmp/waybar_net_data"

[ ! -f "$STATE_FILE" ] && echo 1 > "$STATE_FILE"
STATE=$(cat "$STATE_FILE")

# Handle click
case "$1" in
  next)
    [ "$STATE" -eq 1 ] && echo 2 > "$STATE_FILE" \
    || { [ "$STATE" -eq 2 ] && echo 3 > "$STATE_FILE" || echo 1 > "$STATE_FILE"; }
    exit
    ;;
  both)
    echo 3 > "$STATE_FILE"
    exit
    ;;
esac

# Interface default (fisik / VPN aman)
IFACE=$(ip route | awk '/default/ {print $5; exit}')

# Ambil counter sekarang
read RX TX < <(awk -v dev="$IFACE:" '$1==dev {print $2, $10}' /proc/net/dev)
NOW=$(date +%s%N)

# Init
if [ ! -f "$DATA_FILE" ]; then
    echo "$RX $TX $NOW" > "$DATA_FILE"
    DOWN=0
    UP=0
else
    read RX0 TX0 T0 < "$DATA_FILE"
    DT=$((NOW - T0))

    # Proteksi
    [ "$DT" -le 0 ] && DT=1

    DOWN=$(( (RX - RX0) * 1000000000 / DT / 1024 ))
    UP=$(( (TX - TX0) * 1000000000 / DT / 1024 ))

    echo "$RX $TX $NOW" > "$DATA_FILE"
fi

# Output
case $STATE in
  1) TEXT=" ${DOWN}K" ;;
  2) TEXT=" ${UP}K" ;;
  3) TEXT=" ${DOWN}K  ${UP}K" ;;
esac

echo "{\"text\":\"$TEXT\",\"class\":\"custom-network\"}"

