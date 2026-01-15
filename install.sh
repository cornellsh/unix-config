#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}Starting Config Setup...${NC}"

# 1. Function to check and install dependencies
check_dependency() {
    if ! command -v $1 &> /dev/null; then
        echo -e "${YELLOW}$1 is not installed.${NC}"
        if [ -f /etc/debian_version ]; then
            echo "Attempting to install $1 via apt..."
            sudo apt-get update && sudo apt-get install -y $1
elif [ -f /etc/arch-release ]; then
            echo "Attempting to install $1 via pacman..."
            sudo pacman -S --noconfirm $1
else
            echo -e "${YELLOW}Please install $1 manually.${NC}"
        fi
    else
        echo -e "${GREEN}✓ $1 is installed${NC}"
    fi
}

# Check common tools
check_dependency "git"
check_dependency "tmux"
check_dependency "zsh"
check_dependency "curl"

# 2. Install Starship if missing
if ! command -v starship &> /dev/null; then
    echo -e "${BLUE}Installing Starship prompt...${NC}"
    curl -sS https://starship.rs/install.sh | sh -s -- -y
else
    echo -e "${GREEN}✓ Starship is installed${NC}"
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
            echo -e "${GREEN}✓ $filename is already linked correctly.${NC}"
            return
        fi
        
        echo -e "${YELLOW}Backing up existing $filename to ${filename}.backup${NC}"
        mv "$dest" "${dest}.backup"
    fi

    echo -e "${BLUE}Linking $filename...${NC}"
    ln -s "$src" "$dest"
}

# Get the directory where this script is located
CONFIG_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# 4. Perform Links
backup_and_link "$CONFIG_DIR/.tmux.conf" "$HOME/.tmux.conf"
backup_and_link "$CONFIG_DIR/.zshrc" "$HOME/.zshrc"
backup_and_link "$CONFIG_DIR/starship.toml" "$HOME/.config/starship.toml"

echo -e "\n${GREEN}Setup Complete!${NC}"
echo -e "Please restart your shell or run: ${BLUE}source ~/.zshrc${NC}"
