#!/bin/bash
# ASUS Zenbook UX5401Z Complete Optimization Setup
# Intel i7-12700H (Alder Lake), Intel Iris Xe, MediaTek MT7922 WiFi, Samsung PM9A1 NVMe
# Optimized for balanced productivity usage
#
# Usage: ./setup.sh
# This script is part of unix-config repository

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}ASUS Zenbook UX5401Z Optimization Setup${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${YELLOW}This script requires root privileges. Please run with sudo.${NC}"
    exit 1
fi

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/configs"
SCRIPTS_DIR="$SCRIPT_DIR/scripts"

# Backup directory
BACKUP_DIR="/tmp/zenbook-opt-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"
echo -e "${BLUE}Backup directory: $BACKUP_DIR${NC}"

# ============================================================
# Phase 1: Install Dependencies
# ============================================================
echo ""
echo -e "${BLUE}=== Phase 1: Installing Dependencies ===${NC}"
echo "Installing required packages..."

pacman -S --needed \
    tlp \
    thermald \
    powertop \
    lm_sensors \
    cpupower \
    x86_energy_perf_policy \
    intel-gpu-tools \
    nvtop \
    htop \
    bpytop \
    glances \
    iotop \
    smartmontools \
    --noconfirm

echo -e "${GREEN}✓ Dependencies installed${NC}"

# Configure sensors (non-interactive)
sensors-detect --auto > /dev/null 2>&1 || true

# ============================================================
# Phase 2: System Configuration
# ============================================================
echo ""
echo -e "${BLUE}=== Phase 2: System Configuration ===${NC}"

# Backup existing configs
[ -f /etc/sysctl.d/99-vm.conf ] && cp /etc/sysctl.d/99-vm.conf "$BACKUP_DIR/"

# Install sysctl configuration
echo "Installing sysctl configuration..."
cp "$CONFIG_DIR/99-vm.conf" /etc/sysctl.d/99-vm.conf
sysctl --system
echo -e "${GREEN}✓ Memory management configured${NC}"

# ============================================================
# Phase 3: TLP Enhancement
# ============================================================
echo ""
echo -e "${BLUE}=== Phase 3: TLP Enhancement ===${NC}"

# Install enhanced TLP config
echo "Installing enhanced TLP configuration..."
cp "$CONFIG_DIR/99-tlp-enhanced.conf" /etc/tlp.d/99-zenbook.conf
echo -e "${GREEN}✓ TLP configuration installed${NC}"

# ============================================================
# Phase 4: Kernel Modules
# ============================================================
echo ""
echo -e "${BLUE}=== Phase 4: Kernel Modules ===${NC}"

# Install Intel GPU module config
echo "Installing Intel GPU module configuration..."
cp "$CONFIG_DIR/99-intel-gpu.conf" /etc/modprobe.d/99-intel-gpu.conf
echo -e "${GREEN}✓ Intel GPU configuration installed${NC}"

# ============================================================
# Phase 5: NVMe Optimization
# ============================================================
echo ""
echo -e "${BLUE}=== Phase 5: NVMe Optimization ===${NC}"

echo "Installing NVMe optimization rules..."
cp "$CONFIG_DIR/99-nvme-optimization.rules" /etc/udev/rules.d/99-nvme-optimization.rules
udevadm control --reload-rules
udevadm trigger
echo -e "${GREEN}✓ NVMe optimization configured${NC}"

# ============================================================
# Phase 6: WiFi Power Management
# ============================================================
echo ""
echo -e "${BLUE}=== Phase 6: WiFi Power Management ===${NC}"

echo "Installing WiFi power save scripts..."
cp "$SCRIPTS_DIR/wifi-powersave.sh" /usr/local/bin/wifi-powersave.sh
chmod +x /usr/local/bin/wifi-powersave.sh

cp "$CONFIG_DIR/99-wifi-powersave.rules" /etc/udev/rules.d/99-wifi-powersave.rules
udevadm control --reload-rules
echo -e "${GREEN}✓ WiFi power management configured${NC}"

# ============================================================
# Phase 7: Power Profile Switcher
# ============================================================
echo ""
echo -e "${BLUE}=== Phase 7: Power Profile Switcher ===${NC}"

echo "Installing power profile switcher..."
cp "$SCRIPTS_DIR/power-profile-switcher.sh" /usr/local/bin/power-profile-switcher.sh
chmod +x /usr/local/bin/power-profile-switcher.sh

# Create systemd service
cat > /etc/systemd/system/power-profile-switcher.service << 'EOF'
[Unit]
Description=Comprehensive power profile switcher
After=multi-user.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/power-profile-switcher.sh

[Install]
WantedBy=multi-user.target
EOF

# Install udev rule for power profile switching
cp "$CONFIG_DIR/99-power-profile.rules" /etc/udev/rules.d/99-power-profile.rules
udevadm control --reload-rules

echo -e "${GREEN}✓ Power profile switcher configured${NC}"

# ============================================================
# Phase 8: Services & Battery
# ============================================================
echo ""
echo -e "${BLUE}=== Phase 8: Services & Battery ===${NC}"

# Set battery charge limit to 80%
echo "Setting battery charge limit to 80%..."
if [ -w /sys/class/power_supply/BAT0/charge_control_end_threshold ]; then
    echo 80 > /sys/class/power_supply/BAT0/charge_control_end_threshold
    echo -e "${GREEN}✓ Battery limit set to 80%${NC}"
else
    echo -e "${YELLOW}⚠ Battery limit not supported by hardware/BIOS${NC}"
fi

# Enable and restart TLP
echo "Restarting TLP service..."
systemctl restart tlp.service

# Enable and start power profile switcher
systemctl enable --now power-profile-switcher.service

echo -e "${GREEN}✓ Services enabled and started${NC}"

# ============================================================
# Phase 9: Bootloader Configuration
# ============================================================
echo ""
echo -e "${BLUE}=== Phase 9: Bootloader Configuration ===${NC}"

BOOTLOADER_ENTRIES="/boot/loader/entries"
if [ -d "$BOOTLOADER_ENTRIES" ]; then
    # Find the arch bootloader entry
    ARCH_ENTRY=$(ls "$BOOTLOADER_ENTRIES" | grep -E "arch|linux" | head -1)
    if [ -n "$ARCH_ENTRY" ]; then
        BACKUP_BOOT="$BACKUP_DIR/$(basename "$ARCH_ENTRY")"
        cp "$BOOTLOADER_ENTRIES/$ARCH_ENTRY" "$BACKUP_BOOT"

        # Read current config and add kernel parameters
        CURRENT_OPTIONS=$(grep "^options" "$BOOTLOADER_ENTRIES/$ARCH_ENTRY" | cut -d' ' -f2-)

        # Kernel parameters to add
        KERNEL_PARAMS="processor.max_cstate=1 nowatchdog nmi_watchdog=0 i915.enable_guc=3 i915.enable_fbc=1 i915.enable_psr=0 i915.modeset=1 nvme_core.default_ps_max_latency_us=0 pcie_aspm.policy=powersupersave intel_iommu=on transparent_hugepage=always"

        # Check if parameters already exist
        if echo "$CURRENT_OPTIONS" | grep -q "processor.max_cstate=1"; then
            echo -e "${YELLOW}Kernel parameters already applied${NC}"
        else
            # Add parameters to options line
            NEW_OPTIONS="$CURRENT_OPTIONS $KERNEL_PARAMS"
            sed -i "s|^options .*$|options $NEW_OPTIONS|" "$BOOTLOADER_ENTRIES/$ARCH_ENTRY"

            # Update bootloader
            bootctl update
            echo -e "${GREEN}✓ Bootloader configuration updated${NC}"
        fi
    else
        echo -e "${YELLOW}⚠ Could not find bootloader entry${NC}"
    fi
else
    echo -e "${YELLOW}⚠ Bootloader not found (using systemd-boot)${NC}"
fi

# ============================================================
# Phase 10: Verification
# ============================================================
echo ""
echo -e "${BLUE}=== Phase 10: Verification ===${NC}"
echo ""

echo "Checking system status..."
echo ""
echo "TLP Status:"
systemctl is-active tlp.service && echo -e "  ${GREEN}✓ TLP is running${NC}" || echo -e "  ${YELLOW}✗ TLP is not running${NC}"

echo ""
echo "Thermal Daemon:"
systemctl is-active thermald.service && echo -e "  ${GREEN}✓ Thermald is running${NC}" || echo -e "  ${YELLOW}✗ Thermald is not running${NC}"

echo ""
echo "Power Profile Switcher:"
systemctl is-active power-profile-switcher.service && echo -e "  ${GREEN}✓ Power profile switcher is running${NC}" || echo -e "  ${YELLOW}✗ Power profile switcher is not running${NC}"

echo ""
echo "Battery Charge Limit:"
cat /sys/class/power_supply/BAT0/charge_control_end_threshold 2>/dev/null | xargs -I {} echo "  Current limit: {}%"

echo ""
echo "CPU EPP Settings:"
cat /sys/devices/system/cpu/cpufreq/policy0/energy_performance_preference 2>/dev/null | xargs -I {} echo "  Current EPP: {}"

echo ""
echo "NVMe Scheduler:"
cat /sys/block/nvme0n1/queue/scheduler 2>/dev/null

# ============================================================
# Complete
# ============================================================
echo ""
echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN}✓ Installation Complete!${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""
echo -e "Backup directory: ${YELLOW}$BACKUP_DIR${NC}"
echo ""
echo -e "${BLUE}Next Steps:${NC}"
echo -e "1. Review bootloader configuration in: ${YELLOW}/boot/loader/entries/${NC}"
echo -e "2. ${YELLOW}Reboot${NC} to apply kernel parameter changes"
echo -e "3. After reboot, run: ${YELLOW}tlp-stat -s${NC} to verify settings"
echo ""
echo -e "${BLUE}Documentation:${NC}"
echo -e "  - ${GREEN}OPTIMIZATION_SUMMARY.md${NC} - Complete documentation"
echo -e "  - ${GREEN}VERIFICATION_REPORT.md${NC} - Verification status"
echo -e "  - ${GREEN}QUICKSTART.md${NC} - Quick start guide"
echo ""
