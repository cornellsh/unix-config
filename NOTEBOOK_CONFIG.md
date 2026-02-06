# Arch Linux Notebook Optimization Config (Intel 12th Gen)

**Target Hardware:** Intel Core i7-12700H (Alder Lake), Iris Xe Graphics, 16GB RAM.
**Platform:** Arch Linux (Wayland/Niri).

## 1. Thermal Management (`thermald`)
**Purpose:** Prevents crude thermal throttling by utilizing Intel's Dynamic Platform and Thermal Framework (DPTF).
**Status:** Active/Enabled.
**Configuration:** Default adaptive mode (`--adaptive`).

## 2. Power Management (`tlp`)
**Purpose:** Granular control over CPU states and battery thresholds. Replaces `power-profiles-daemon`.
**Configuration:** `/etc/tlp.d/99-optimization.conf`
- **Battery:**
  - Turbo Boost: **DISABLED** (Major battery saver).
  - CPU Governor: `powersave`.
  - EPP: `balance_power`.
  - Charge Thresholds: Start 75% / Stop 80% (Battery health preservation).
- **AC:**
  - Turbo Boost: **ENABLED**.
  - CPU Governor: `performance`.
  - EPP: `balance_performance`.

## 3. Memory Optimization (`zram`)
**Purpose:** Increases effective memory capacity and system responsiveness under load.
**Configuration:** `/etc/systemd/zram-generator.conf`
- **Size:** 8GB (Previous default: 4GB).
- **Compression:** `zstd`.
- **Priority:** 100.

## 4. Hardware Acceleration (VA-API)
**Purpose:** Offloads video decoding to the iGPU (Iris Xe) to save CPU cycles and power.
**Configuration:** `~/.config/environment.d/hw-accel.conf`
- `LIBVA_DRIVER_NAME=iHD` (Intel Media Driver).
- `VDPAU_DRIVER=va_gl`.
- `MESA_LOADER_DRIVER_OVERRIDE=iris`.

## Service Status
Check status with:
```bash
systemctl status thermald tlp systemd-zram-setup@zram0
tlp-stat -b   # Battery stats
tlp-stat -p   # Processor stats
zramctl       # ZRAM stats
intel_gpu_top # GPU usage (requires intel-gpu-tools)
```
