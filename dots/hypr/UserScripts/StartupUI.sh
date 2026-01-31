#!/usr/bin/env bash

# ===== Paths =====
SCRIPTS_DIR="$HOME/.config/hypr/scripts"

# ===== Session apps (safe, idempotent) =====
# uwsm app -- swww-daemon --format argb || true
# uwsm app -- "$SCRIPTS_DIR/Polkit.sh" || true
uwsm app -- nm-applet --indicator || true
uwsm app -- swaync || true
uwsm app -- waybar || true
uwsm app -- wl-paste --type text --watch cliphist store || true
uwsm app -- wl-paste --type image --watch cliphist store || true
uwsm app -- hypridle || true
