Personal dotfiles and Linux configuration for Arch Linux on Intel 12th Gen (ASUS Zenbook UX5401Z) and WSL2. This repository provides a reproducible setup with:

Shell Configuration
- Zsh with shared history, auto-cd, and modern tool aliases (eza, bat, ripgrep)
- Starship prompt with git status, language versions, command duration
- Tmux terminal multiplexer with Ctrl+a prefix and OLED-friendly colors

Terminal Emulator
- Ghostty terminal with cornellsh theme (OLED-optimized #000000 backgrounds, pastel accents)
- Custom font configuration and keybindings

Wayland Shell
- DankMaterialShell with cornellsh theme integration
- Control center with volume, brightness, WiFi, Bluetooth widgets
- Workspace switcher, system tray, weather, and clock

Theme System
- GTK themes: Mojave-Dark (macOS-inspired, dark)
- Icon themes: Papirus-Dark (OLED-optimized, true black backgrounds)
- Cursor themes: macOS-Tahoe (exact macOS cursor clone)
- SDDM login theme: where-is-my-sddm-theme (minimalist)
- Theme configuration via gsettings and nwg-look (Wayland)
- Automatic installation and setup via themes-setup.sh

Developer Tools
- OpenCode AI coding assistant configuration
- Git and terminal workflow optimizations
- Development environment setup

Power Management
- TLP for granular CPU power control and battery care
- Thermald for CPU thermal management
- ZRAM for compressed swap (8GB, zstd)
- VA-API hardware acceleration for Intel Iris Xe
- Automated AC/battery power profile switching
- 80% battery charge limit for OLED longevity
- Bluetooth unblock service to prevent TLP blocking on startup

WSL2 Optimizations
- Time sync fix to prevent clock drift with Windows
- Windows drive auto-mounting with proper permissions
- systemd enablement
- Custom .wslconfig for memory/CPU limits

Hardware Support
- Intel i7-12700H (Alder Lake, 14 cores/20 threads)
- Intel Iris Xe Graphics (Alder Lake-P)
- MediaTek MT7922 WiFi
- Samsung PM9A1 NVMe (954GB)
- 16GB RAM
- OLED display

All configurations use the cornellsh design philosophy: true black (#000000) backgrounds with pastel accent colors. This provides excellent OLED contrast while reducing burn-in risk and saving battery power.