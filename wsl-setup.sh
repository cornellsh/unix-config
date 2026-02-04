#!/bin/bash

# WSL2 Optimization & Setup Script

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

CONFIG_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo -e "${BLUE}Starting WSL2 Optimization...${NC}"

# 1. Systemd Timesyncd Fix
echo -e "${BLUE}Applying systemd-timesyncd fix...${NC}"
if systemctl is-active --quiet systemd-timesyncd; then
    sudo systemctl disable systemd-timesyncd
    sudo systemctl stop systemd-timesyncd
    echo -e "${GREEN}✓ systemd-timesyncd disabled${NC}"
else
    echo -e "${GREEN}✓ systemd-timesyncd already disabled or not present${NC}"
fi

# 2. Configure /etc/wsl.conf
echo -e "${BLUE}Updating /etc/wsl.conf...${NC}"
sudo cp "$CONFIG_DIR/wsl/wsl.conf" /etc/wsl.conf
echo -e "${GREEN}✓ /etc/wsl.conf updated${NC}"

# 3. Configure .wslconfig (Windows Side)
echo -e "${BLUE}Attempting to configure .wslconfig on Windows host...${NC}"

# Try to detect Windows Username via cmd.exe
WIN_USER=$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')

if [ -n "$WIN_USER" ]; then
    WIN_HOME="/mnt/c/Users/$WIN_USER"
    if [ -d "$WIN_HOME" ]; then
        echo -e "Found Windows User Home: $WIN_HOME"
        cp "$CONFIG_DIR/wsl/.wslconfig" "$WIN_HOME/.wslconfig"
        echo -e "${GREEN}✓ .wslconfig copied to Windows User Profile${NC}"
    else
        echo -e "${YELLOW}Could not find Windows home directory at $WIN_HOME${NC}"
    fi
else
    echo -e "${YELLOW}Could not detect Windows username. Please manually copy wsl/.wslconfig to %UserProfile% on Windows.${NC}"
fi

echo -e "\n${GREEN}WSL Setup Complete!${NC}"
echo -e "${YELLOW}IMPORTANT: Restart WSL by running 'wsl --shutdown' in PowerShell for changes to take effect.${NC}"
