#!/bin/bash
# Notebook Setup Script for Arch Linux (Intel 12th Gen)
# Author: System Administrator
# Description: Installs and configures full system optimizations.

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}Notebook Configuration Setup${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Check for ASUS Zenbook optimizations
if [ -f "$SCRIPT_DIR/optimizations/setup.sh" ]; then
    echo -e "${YELLOW}[INFO] ASUS Zenbook optimizations found.${NC}"
    echo ""
    echo "Install comprehensive ASUS Zenbook UX5401Z optimizations?"
    echo "  - CPU optimization (Intel i7-12700H)"
    echo "  - GPU optimization (Intel Iris Xe)"
    echo "  - Power management (TLP + thermald)"
    echo "  - Battery care (80% charge limit)"
    echo "  - NVMe optimization (Samsung PM9A1)"
    echo "  - WiFi automation (MediaTek MT7922)"
    echo "  - Performance monitoring tools"
    echo ""
    read -p "Install ASUS Zenbook optimizations? (y/n) " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo ""
        echo -e "${BLUE}[INFO] Installing ASUS Zenbook optimizations...${NC}"
        echo ""
        sudo bash "$SCRIPT_DIR/optimizations/setup.sh"
        echo ""
        echo -e "${GREEN}[OK] ASUS Zenbook optimizations installed.${NC}"
        echo -e "${YELLOW}[INFO] Please reboot to apply all kernel parameters.${NC}"
        echo ""
    else
        echo -e "${YELLOW}[INFO] Skipping ASUS Zenbook optimizations.${NC}"
        echo ""
    fi
else
    echo -e "${YELLOW}[INFO] No ASUS Zenbook optimizations found in $SCRIPT_DIR/optimizations/${NC}"
    echo ""
fi

echo -e "${BLUE}=========================================${NC}"
echo -e "${GREEN}Notebook Setup Complete!${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""
echo -e "Next Steps:"
echo -e "  1. ${YELLOW}Reboot${NC} if ASUS Zenbook optimizations were installed"
echo -e "  2. Run ${YELLOW}tlp-stat -s${NC} to verify power management"
echo -e "  3. Run ${YELLOW}sensors${NC} to check thermal status"
echo ""
