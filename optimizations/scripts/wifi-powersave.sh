#!/bin/bash
# Automated WiFi power save based on AC/battery status
# For MediaTek MT7922 WiFi on ASUS Zenbook UX5401Z

# Get power source
POWER_SOURCE=$(cat /sys/class/power_supply/AC0/online 2>/dev/null || echo "1")
WIFI_INTERFACE="wlo1"

if [ "$POWER_SOURCE" = "1" ]; then
    # On AC - disable power save for better performance
    echo "On AC - Disabling WiFi power save"
    /usr/bin/iw dev $WIFI_INTERFACE set power_save off 2>/dev/null
else
    # On Battery - enable power save for battery life
    echo "On Battery - Enabling WiFi power save"
    /usr/bin/iw dev $WIFI_INTERFACE set power_save on 2>/dev/null
fi

exit 0
