# Minimalist Linux Config (Tmux + Zsh + Starship)

A highly optimized, aesthetic configuration for Linux environments. Features a "Vibrant Pastel / OLED Black" theme for Tmux and a minimalist high-performance prompt via Starship.

## Preview

**Tmux Theme:**
- **Style:** OLED Black bar with vibrant pastel accents (Pink/Lavender/Mint).
- **Interactive:**
    - Prefix (`Ctrl+a`) turns the session indicator **Pink**.
    - Zoomed panes display a **Star (★)**.
    - Active windows are highlighted as solid Lavender tabs.

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/cornellsh/config.git ~/work/config
   ```

2. Run the setup script:
   ```bash
   cd ~/work/config
   chmod +x install.sh
   ./install.sh
   ```

## Dependencies
The script will attempt to install these, but you should ensure you have:
- `zsh`
- `tmux` (>= 3.0)
- `curl`
- `git`
- `starship` (installed automatically by script if missing)

## Keybindings (Tmux)

| Key | Action |
| :--- | :--- |
| `Ctrl+a` | **Prefix** |
| `r` | Reload Config |
| `v` | Split Vertical |
| `s` | Split Horizontal |
| `h/j/k/l` | Navigate Panes (Vim style) |
| `z` | Zoom Pane |
| `[` | Copy Mode |
