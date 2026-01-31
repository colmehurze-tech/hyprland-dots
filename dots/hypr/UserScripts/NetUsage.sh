#!/bin/bash

# Mengambil data hari ini, hapus spasi di awal/akhir
USAGE=$(vnstat --oneline | cut -d';' -f6 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

if [[ -z "$USAGE" || "$USAGE" == *"No data."* ]]; then
    echo "0 KiB"
else
    echo "$USAGE"
fi
