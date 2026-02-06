# ASUS Zenbook UX5401Z - Quick Start Guide

## 🚀 Installation (3 Steps)

### Step 1: Install Optimizations
```bash
cd /tmp
sudo bash install-zenbook-optimizations.sh
```

### Step 2: Add Kernel Parameters (CRITICAL)

Edit your bootloader config:
```bash
sudo nano /boot/loader/entries/arch.conf
```

Find the `options` line and append these parameters:
```
processor.max_cstate=1 nowatchdog nmi_watchdog=0 i915.enable_guc=3 i915.enable_fbc=1 i915.enable_psr=0 i915.modeset=1 nvme_core.default_ps_max_latency_us=0 pcie_aspm.policy=powersupersave intel_iommu=on transparent_hugepage=always
```

Update bootloader:
```bash
sudo bootctl update
```

### Step 3: Reboot
```bash
sudo reboot
```

---

## ✅ Verification (After Reboot)

```bash
# Check TLP
tlp-stat -s

# Check battery limit
cat /sys/class/power_supply/BAT0/charge_control_end_threshold

# Check CPU EPP
cat /sys/devices/system/cpu/cpufreq/policy0/energy_performance_preference

# Check power profile switcher
systemctl status power-profile-switcher.service
```

---

## 📊 Optional: Install Monitoring Tools

```bash
sudo bash /tmp/install-monitoring-tools.sh
```

---

## 🔍 Quick Commands

```bash
# Temperature
sensors

# CPU usage
htop

# GPU usage
intel_gpu_top

# Power usage
powertop

# Battery
cat /sys/class/power_supply/BAT0/capacity
```

---

## 📚 Full Documentation

See: `/tmp/OPTIMIZATION_SUMMARY.md`

---

**Done!** Your ASUS Zenbook is now optimized for balanced productivity usage.
