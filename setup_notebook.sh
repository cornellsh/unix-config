#!/bin/bash
# Optimization Setup Script for Arch Linux Notebook (Intel 12th Gen)
# Author: System Administrator
# Description: Installs and configures thermald, tlp, zram, and hardware acceleration.

set -e

echo "Starting optimization setup..."

# 1. Install Packages
echo "Installing required packages..."
if ! pacman -Qi thermald tlp powertop &>/dev/null; then
    sudo pacman -S --noconfirm thermald tlp powertop
else
    echo "Packages already installed."
fi

# 2. Configure TLP (Power Management)
echo "Configuring TLP..."
sudo mkdir -p /etc/tlp.d
sudo bash -c 'cat > /etc/tlp.d/99-optimization.conf <<EOF
# Optimized TLP configuration for Intel 12th Gen (Alder Lake)

# CPU Power Management
CPU_DRIVER_OPMODE_ON_AC=active
CPU_DRIVER_OPMODE_ON_BAT=active

CPU_SCALING_GOVERNOR_ON_AC=performance
CPU_SCALING_GOVERNOR_ON_BAT=powersave

CPU_ENERGY_PERF_POLICY_ON_AC=balance_performance
CPU_ENERGY_PERF_POLICY_ON_BAT=balance_power

# Disable Turbo on Battery to save significant power
CPU_BOOST_ON_AC=1
CPU_BOOST_ON_BAT=0

# Platform Profiles (ACPI)
PLATFORM_PROFILE_ON_AC=performance
PLATFORM_PROFILE_ON_BAT=low-power

# Battery Care (Charge Thresholds)
START_CHARGE_THRESH_BAT0=75
STOP_CHARGE_THRESH_BAT0=80

# Runtime Power Management
RUNTIME_PM_ON_AC=auto
RUNTIME_PM_ON_BAT=auto
EOF'

# 3. Configure ZRAM (Memory)
echo "Configuring ZRAM..."
sudo bash -c 'cat > /etc/systemd/zram-generator.conf <<EOF
[zram0]
zram-size = min(ram, 8192)
compression-algorithm = zstd
swap-priority = 100
EOF'

# 4. Configure Hardware Acceleration (User level)
echo "Configuring VA-API Environment Variables..."
mkdir -p ~/.config/environment.d
cat > ~/.config/environment.d/hw-accel.conf <<EOF
LIBVA_DRIVER_NAME=iHD
VDPAU_DRIVER=va_gl
MESA_LOADER_DRIVER_OVERRIDE=iris
EOF

# 5. Enable and Restart Services
echo "Enabling and restarting services..."
sudo systemctl enable --now thermald tlp
sudo systemctl restart tlp
sudo systemctl daemon-reload
sudo systemctl restart systemd-zram-setup@zram0

echo "Optimization complete!"
echo "Status Check:"
echo "----------------------------------------"
zramctl
echo "----------------------------------------"
systemctl is-active thermald tlp
