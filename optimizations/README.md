# ASUS Zenbook UX5401Z Optimizations

This repository contains configurations for my ASUS Zenbook UX5401Z running Arch Linux. I've tuned these specifically for Intel 12th Gen hardware.

## Hardware

Intel i7-12700H, Intel Iris Xe graphics, MediaTek MT7922 WiFi, Samsung PM9A1 954GB NVMe, 16GB RAM, OLED display.

## Installation

Automated setup with prompts:

```bash
cd ~/Work/unix-config
./setup_notebook.sh
```

Direct install without prompts:

```bash
cd ~/Work/unix-config/optimizations
sudo ./setup.sh
```

## What gets installed

Thermal management via `thermald` to handle the DPTF framework. Power management through `tlp` with configuration in `/etc/tlp.d/99-zenbook.conf`. Battery mode disables Turbo Boost, uses `schedutil` governor, `balance_power` EPP, and caps charging at 75-80%. AC mode enables Turbo Boost, switches to `performance` governor and `balance_performance` EPP.

Memory tweaks in `/etc/sysctl.d/99-vm.conf`: swappiness at 10 (down from 60), vfs_cache_pressure at 50, dirty_ratio at 5, dirty_background_ratio at 10. ZRAM adds 8GB compressed swap using zstd with priority 100.

Hardware acceleration sets `LIBVA_DRIVER_NAME=iHD`, `VDPAU_DRIVER=va_gl`, `MESA_LOADER_DRIVER_OVERRIDE=iris`. Intel GPU configuration loads GuC/HuC firmware, enables frame buffer compression, disables panel self-refresh for OLED, and uses kernel mode setting. NVMe uses 'none' scheduler with 32 queue depth. WiFi power saving switches on/off based on AC/battery state.

Power profiles switch automatically: AC enables Turbo Boost and `performance` EPP, battery disables Turbo Boost and uses `balance_power`.

## Checking status

```bash
systemctl status thermald tlp power-profile-switcher.service
tlp-stat -b -p
zramctl intel_gpu_top
htop bpytop sensors powertop
```

## Results

Battery lasts 4-6 hours instead of 3-4. Swap usage dropped significantly. System feels more responsive under heavy load. NVMe I/O and GPU performance show improvements. The 80% charge cap should extend battery lifespan from 2-3 years to 5-7 years.

## Verification commands

```bash
tlp-stat -s
cat /proc/cmdline
sudo journalctl -b | grep -i "guc\|huc"
cat /sys/class/power_supply/BAT0/charge_control_end_threshold
cat /sys/devices/system/cpu/cpufreq/policy0/energy_performance_preference
cat /sys/block/nvme0n1/queue/scheduler
sensors
```

## Updates

After pulling updates, run setup again:

```bash
cd ~/Work/unix-config
./setup_notebook.sh
```

Calibrate PowerTop occasionally for best results:

```bash
sudo powertop --calibrate
```

## Troubleshooting

If TLP settings don't stick: `sudo systemctl restart tlp.service`

If power profiles don't switch: `sudo systemctl restart power-profile-switcher.service` then `sudo /usr/local/bin/power-profile-switcher.sh`

If GPU seems slow, check GuC/HuC loading with `sudo journalctl -b | grep -i "guc\|huc"`, verify VA-API with `vainfo`, or monitor GPU frequency with `intel_gpu_top`.

## Notes

These configs target my specific hardware. Similar systems will work with minor adjustments.
