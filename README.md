# unix-config

Dotfiles and configuration files for my Linux setup. I run this on Arch Linux (Intel 12th Gen notebook) and WSL2.

## What's Here

- **Zsh** (.zshrc): Shell config with shared history, auto-cd, and aliases for eza, bat, ripgrep
- **Starship Prompt** (starship.toml): Single-line prompt showing git branch, language versions, command time
- **Tmux** (.tmux.conf): Terminal multiplexer with Ctrl+a prefix, Vim-style keybindings, OLED-friendly colors
- **Ghostty Terminal** (~/.config/ghostty): Terminal config with cornellsh theme, 12pt font
- **DankMaterialShell** (~/.config/DankMaterialShell): Wayland shell with cornellsh theme
- **OpenCode** (~/.config/opencode): AI coding assistant config with cornell.sh theme, auto-permissions
- **Themes** (themes-setup.sh): GTK, icons, cursor, and SDDM theme setup
- **Notebook Setup** (setup_notebook.sh): Power management for Intel 12th Gen (TLP, thermald, ZRAM)
- **WSL2 Setup** (wsl-setup.sh): WSL2 optimizations

Everything uses the cornellsh theme: true black (#000000) backgrounds with pastel colors. Works well on OLED displays.

## Installing

```bash
git clone https://github.com/cornellsh/unix-config ~/my_dotfiles
cd ~/my_dotfiles
./install.sh
```

The script detects your OS (Arch or Debian/Ubuntu) and installs dependencies via apt/pacman. It backs up existing configs to `.backup` files before creating symlinks. Installs: git, tmux, zsh, curl, ghostty, zsh-autosuggestions, zsh-syntax-highlighting, starship.

You'll get prompts for:
- WSL2 optimizations (if running in WSL)
- OpenCode theme installation
- GTK/SDDM theme installation

After installing, reload your shell or run `source ~/.zshrc`.

## Theme Setup (themes-setup.sh)

Optional script for GTK, icons, cursors, and login screen:

```bash
./themes-setup.sh
```

Requires yay (AUR helper) and Arch Linux. Installs Mojave GTK theme, Papirus icons (dark variant), macOS-Tahoe cursors, and where-is-my-sddm-theme. Configures via gsettings and sets up SDDM. Also removes niri compositor from SDDM config to prevent keybinding overlay on login screen.

Restart session or run `nwg-look` to apply GTK changes. Restart SDDM with `sudo systemctl restart sddm` for login theme.

## Components

### Zsh

History holds 50,000 lines, shared across sessions. Ignores duplicates and commands starting with space. Autocomplete is case-insensitive with fuzzy matching. Uses Emacs keybindings (Ctrl+Left/Right for word navigation). Aliases: g=git, t=tmux, ls=eza, cat=bat, cd=z (via zoxide). Plugins: zsh-autosuggestions, zsh-syntax-highlighting (commented out).

### Starship Prompt

Single line showing username@hostname (SSH only), directory (3 levels deep), git branch and status (modified, stashed, deleted, untracked, conflicted), language versions (node, rust, go, python), command duration (if >2 seconds), and background jobs. Memory module disabled. Colors from cornellsh palette: pink (#ff66b2), cyan (#00bfff), green (#00cc00), purple (#9932cc), yellow (#ffff00), red (#ff0000).

### Tmux

Prefix: Ctrl+a. Vim-style navigation: h/j/k/l for panes, Ctrl+h/j/k/l for smart pane switching. v=horizontal split, s=vertical split, H/J/K/L to resize. c=new window, z=zoom pane, x=kill pane, X=kill window. Status bar at bottom updates every second. Reload config with Prefix+r. Mouse enabled for pane selection and resizing. Colors: black background, pink prefix indicators, purple active window.

### Ghostty Terminal

Config: `~/.config/ghostty/config`

12pt font (Inter Variable for UI, Cascadia Code NF for monospace). No window decorations, 12px padding, 32px blur. Block cursor with blinking. Scrollback: 3023 lines. cornellsh theme. Keybindings: Ctrl+Shift+N (new window), Ctrl+T (new tab), Ctrl+Plus/Minus (font size). Shell integration auto-detected.

### DankMaterialShell

Config: `~/.config/DankMaterialShell/settings.json`

Wayland shell for Niri and Hyprland. Copies cornellsh.json theme to `~/Documents/DankMaterialShell/cornellsh.json`. Control center has volume, brightness, WiFi, Bluetooth. Also has workspace switcher, system tray, weather, clock. Material 3 colors, 90% transparency. Dock disabled.

### OpenCode

Config: `~/.config/opencode/opencode.json`

Plugins: `opencode-gemini-auth`, `@zenobius/opencode-skillful`. Theme: `cornell.sh.json`. Permissions: all operations allowed. Optional install during main setup.

#### MCP Servers

Model Context Protocol (MCP) server support for extended OpenCode functionality.

**Context7**: AI-powered documentation query and code analysis server. Requires `CONTEXT7_API_KEY` environment variable set in `.zshrc`. Obtain API key from https://context7.com. Configuration uses remote server connection at `https://mcp.context7.com/mcp`. See `.opencode/README.md` for detailed setup instructions.

### Themes (themes-setup.sh)

Installs from AUR: mojave-gtk-theme, papirus-icon-theme, macOS-Tahoe cursors, where-is-my-sddm-theme. Optionally installs nwg-look (GTK theme switcher). gsettings configures Mojave-Dark GTK theme, Papirus-Dark icons, macOS-Tahoe cursors. SDDM uses where-is-my-sddm-theme. Removes `CompositorCommand=niri` from `/etc/sddm.conf.d/niri.conf` to avoid keybinding conflicts on login.

### Notebook Setup (setup_notebook.sh)

For Intel 12th Gen (Alder Lake) laptops.

Installs: thermald, tlp, powertop. Configures TLP for performance on AC, powersave on battery, no turbo on battery, 75-80% charge threshold. TLP Bluetooth config prevents blocking on startup. ZRAM uses zstd compression, up to 8GB or RAM size. VA-API configures Intel iGPU hardware acceleration.

Services: thermald, tlp, systemd-zram-setup, system-bluetooth-unblock.

TLP blocks Bluetooth by default to save power. The config prevents this and adds a systemd service to keep Bluetooth unblocked across reboots.

### WSL2 Setup (wsl-setup.sh)

Disables systemd-timesyncd (WSL2 syncs with Windows). Configures /etc/wsl.conf for auto-mounting Windows drives with metadata (chmod/chown work), systemd, auto-generated hosts/resolv.conf. Sets up ~/.wslconfig with 8GB memory, 4 CPUs, 2GB swap.

Script tries to detect Windows username and copy .wslconfig automatically. If that fails, copy `wsl/.wslconfig` to `%UserProfile%\.wslconfig` on Windows.

Run `wsl --shutdown` in PowerShell after the script to apply changes.

## Notes

Config files are symlinks, so changes in the repo take effect after reload. Both `~/.tmux.conf` and `~/.config/tmux/tmux.conf` point to the repo's `.tmux.conf` (tmux 3.0+ prefers XDG path). zsh syntax highlighting is commented out. Starship git metrics and memory modules are disabled. Ghostty uses a 16-color palette. Notebook setup is for Intel 12th Gen only. Other hardware needs different TLP/VA-API configs.

## Requirements

Arch Linux or Debian/Ubuntu. Ghostty terminal. Zsh as default shell. Starship. Optional: niri or Hyprland for DankMaterialShell. Theme setup needs Arch and yay. Notebook setup is Intel 12th Gen specific.
