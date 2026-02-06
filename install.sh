#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}[INFO] Starting Config Setup...${NC}"

# 1. Function to check and install dependencies
check_dependency() {
    if ! command -v $1 &> /dev/null; then
        echo -e "${YELLOW}[WARN] $1 is not installed.${NC}"
        if [ -f /etc/debian_version ]; then
            echo "[INFO] Attempting to install $1 via apt..."
            sudo apt-get update && sudo apt-get install -y $1
elif [ -f /etc/arch-release ]; then
            echo "[INFO] Attempting to install $1 via pacman..."
            sudo pacman -S --noconfirm $1
else
            echo -e "${YELLOW}[WARN] Please install $1 manually.${NC}"
        fi
    else
        echo -e "${GREEN}[OK] $1 is installed${NC}"
    fi
}

# Check common tools
check_dependency "git"
check_dependency "tmux"
check_dependency "zsh"
check_dependency "curl"
check_dependency "ghostty" # Added Ghostty dependency check

# 1.1 Install Zsh Plugins (Autosuggestions & Syntax Highlighting)
echo -e "${BLUE}[INFO] Checking Zsh plugins...${NC}"
if [ -f /etc/debian_version ]; then
    # Debian/Ubuntu
    if ! dpkg -s zsh-autosuggestions &> /dev/null; then
        echo "[INFO] Installing zsh-autosuggestions..."
        sudo apt-get install -y zsh-autosuggestions
    fi
    if ! dpkg -s zsh-syntax-highlighting &> /dev/null; then
        echo "[INFO] Installing zsh-syntax-highlighting..."
        sudo apt-get install -y zsh-syntax-highlighting
    fi
elif [ -f /etc/arch-release ]; then
    # Arch Linux
    if ! pacman -Qi zsh-autosuggestions &> /dev/null; then
        echo "[INFO] Installing zsh-autosuggestions..."
        sudo pacman -S --noconfirm zsh-autosuggestions
    fi
    if ! pacman -Qi zsh-syntax-highlighting &> /dev/null; then
        echo "[INFO] Installing zsh-syntax-highlighting..."
        sudo pacman -S --noconfirm zsh-syntax-highlighting
    fi
fi

# 2. Install Starship if missing
if ! command -v starship &> /dev/null; then
    echo -e "${BLUE}[INFO] Installing Starship prompt...${NC}"
    curl -sS https://starship.rs/install.sh | sh -s -- -y
else
    echo -e "${GREEN}[OK] Starship is installed${NC}"
fi

# 3. Backup and Symlink Function
backup_and_link() {
    src="$1"
    dest="$2"
    filename=$(basename "$dest")

    # Create destination directory if it doesn't exist
    mkdir -p "$(dirname "$dest")"

    if [ -f "$dest" ] || [ -L "$dest" ]; then
        # Check if it's already the correct link
        if [ "$(readlink -f "$dest")" == "$(readlink -f "$src")" ]; then
            echo -e "${GREEN}[OK] $filename is already linked correctly.${NC}"
            return
        fi
        
        echo -e "${YELLOW}[WARN] Backing up existing $filename to ${filename}.backup${NC}"
        mv "$dest" "${dest}.backup"
    fi

    echo -e "${BLUE}[INFO] Linking $filename...${NC}"
    ln -s "$src" "$dest"
}

# Get the directory where this script is located
CONFIG_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# 4. Perform Links
backup_and_link "$CONFIG_DIR/.tmux.conf" "$HOME/.tmux.conf"
backup_and_link "$CONFIG_DIR/.zshrc" "$HOME/.zshrc"
backup_and_link "$CONFIG_DIR/starship.toml" "$HOME/.config/starship.toml"

# 4.1. Ghostty Configuration
echo -e "\n${BLUE}[INFO] Configuring Ghostty terminal...${NC}"
mkdir -p "$HOME/.config/ghostty/themes"

backup_and_link "$CONFIG_DIR/ghostty/config" "$HOME/.config/ghostty/config"
backup_and_link "$CONFIG_DIR/ghostty/themes/cornellsh" "$HOME/.config/ghostty/themes/cornellsh"

# 4.2. DankMaterialShell Configuration
echo -e "\n${BLUE}[INFO] Configuring DankMaterialShell...${NC}"
mkdir -p "$HOME/.config/DankMaterialShell"
mkdir -p "$HOME/Documents/DankMaterialShell" # For custom theme file

backup_and_link "$CONFIG_DIR/dankmaterialshell/settings.json" "$HOME/.config/DankMaterialShell/settings.json"
cp "$CONFIG_DIR/dankmaterialshell/cornellsh.json" "$HOME/Documents/DankMaterialShell/cornellsh.json"
echo -e "${GREEN}[OK] DankMaterialShell custom theme copied.${NC}"

# 5. OpenCode Configuration (optional)
if [ -f "$CONFIG_DIR/opencode.json" ]; then
    echo -e "\n${BLUE}[INFO] OpenCode config found.${NC}"
    read -p "Install OpenCode theme and config? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        mkdir -p "$HOME/.config/opencode/themes"

        if [ -f "$CONFIG_DIR/.opencode/themes/cornell.sh.json" ]; then
            cp "$CONFIG_DIR/.opencode/themes/cornell.sh.json" "$HOME/.config/opencode/themes/cornell.sh.json"
            echo -e "${GREEN}[OK] OpenCode theme installed${NC}"
        fi

        if [ -f "$HOME/.config/opencode/opencode.json" ]; then
            mv "$HOME/.config/opencode/opencode.json" "$HOME/.config/opencode/opencode.json.backup"
            echo -e "${YELLOW}[WARN] Backed up existing opencode.json${NC}"
        fi

        cp "$CONFIG_DIR/opencode.json" "$HOME/.config/opencode/opencode.json"
        echo -e "${GREEN}[OK] OpenCode config installed${NC}"
    fi
fi

# 6. WSL Specific Setup
if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null ; then
    echo -e "\n${BLUE}[INFO] WSL Environment Detected...${NC}"
    read -p "Do you want to apply WSL2-specific optimizations (time sync fix, memory limits)? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "[INFO] Running WSL optimizations..."
        bash "$CONFIG_DIR/wsl-setup.sh"
    else
        echo -e "[INFO] Skipping WSL optimizations."
    fi
fi

echo -e "\n${GREEN}[OK] Setup Complete!${NC}"
echo -e "Please restart your shell or run: ${BLUE}source ~/.zshrc${NC}"
