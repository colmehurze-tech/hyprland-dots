#!/usr/bin/env bash

# 1. Pastikan PATH mencakup lokasi umum (penting untuk NixOS)
export PATH="$PATH:/run/current-system/sw/bin:/usr/bin:/bin"

# 2. Bersihkan instance lama dengan lebih presisi
# Menggunakan pgrep -a agar tidak membunuh shell itu sendiri secara tidak sengaja
curr_pid=$$
pgrep -f "WaybarCava.sh" | grep -v "$curr_pid" | xargs kill -9 2>/dev/null || true

# Matikan cava yang mungkin nyangkut
pkill -x cava 2>/dev/null || true
sleep 0.2

# 3. Cek apakah cava ada
if ! command -v cava >/dev/null 2>&1; then
    echo "Error: 'cava' tidak ditemukan. Pastikan sudah terinstall."
    exit 1
fi

# 4. Setup Bar (Karakter visual)
bar=" ▂▃▄▅▆▇█"
dict="s/;//g"
for i in {0..7}; do 
    dict+=";s/$i/${bar:$i:1}/g"
done

# 5. Buat config temp yang aman di /tmp
config_file="/tmp/cava_$(id -u).conf"
cat > "$config_file" <<EOF
[general]
bars = 10
[input]
method = pulse
source = auto
[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
EOF

# 6. Jalankan dengan stdbuf agar outputnya 'live' ke Waybar
# Kita gunakan path absolut atau env untuk memastikan sed dan cava terpanggil
exec cava -p "$config_file" | stdbuf -oL sed -u "$dict"