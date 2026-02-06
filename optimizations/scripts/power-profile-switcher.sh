#!/bin/bash
# Comprehensive power profile switcher for ASUS Zenbook UX5401Z
# Automatically switches between performance and power-save profiles

# Get power source
POWER_SOURCE=$(cat /sys/class/power_supply/AC0/online 2>/dev/null || echo "1")

if [ "$POWER_SOURCE" = "1" ]; then
    # On AC - Performance Profile
    echo "=== AC MODE - Performance Profile ==="

    # CPU: Balance performance
    if [ -w /sys/devices/system/cpu/cpufreq/policy*/energy_performance_preference ]; then
        echo balance_performance | sudo tee /sys/devices/system/cpu/cpufreq/policy*/energy_performance_preference > /dev/null 2>&1
    fi

    # Enable CPU boost
    echo 1 | sudo tee /sys/devices/system/cpu/cpufreq/boost > /dev/null 2>&1

    # Disable HWP dynamic boost for consistent performance
    echo 1 | sudo tee /sys/devices/system/cpu/intel_pstate/hwp_dynamic_boost > /dev/null 2>&1

    # WiFi: Disable power save
    /usr/bin/iw dev wlo1 set power_save off 2>/dev/null

    echo "✓ Performance profile activated"

else
    # On Battery - Power Save Profile
    echo "=== BATTERY MODE - Power Save Profile ==="

    # CPU: Balance power
    if [ -w /sys/devices/system/cpu/cpufreq/policy*/energy_performance_preference ]; then
        echo balance_power | sudo tee /sys/devices/system/cpu/cpufreq/policy*/energy_performance_preference > /dev/null 2>&1
    fi

    # Disable CPU boost on battery
    echo 0 | sudo tee /sys/devices/system/cpu/cpufreq/boost > /dev/null 2>&1

    # Enable HWP dynamic boost
    echo 0 | sudo tee /sys/devices/system/cpu/intel_pstate/hwp_dynamic_boost > /dev/null 2>&1

    # WiFi: Enable power save
    /usr/bin/iw dev wlo1 set power_save on 2>/dev/null

    echo "✓ Power save profile activated"
fi

exit 0
