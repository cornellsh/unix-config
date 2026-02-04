# config

Minimalistic config for **Zsh**, **Tmux**, and **Starship**.

## Setup

```bash
git clone https://github.com/cornellsh/config.git ~/work/config
cd ~/work/config
./install.sh
```

## Setup
- **Shell:** Zsh + Autosuggestions + Syntax Highlighting
- **Prompt:** Starship (Custom text-based config)
- **Multiplexer:** Tmux (3.0+)
- **Utils:** `eza`, `bat`, `zoxide`, `fzf`, `ripgrep`

## WSL2 Optimizations
The setup includes a `wsl-setup.sh` script that automatically:
- Disables `systemd-timesyncd` to prevent time drift lags.
- Configures `/etc/wsl.conf` for better filesystem performance.
- creates `.wslconfig` in your Windows User Profile to limit RAM/CPU usage.

## Controls

### Tmux (`Ctrl+a` Prefix)
| Key | Action |
| :--- | :--- |
| `r` | Reload config |
| `b` | Toggle status bar |
| `v` / `s` | Split Vertical / Horizontal |
| `h` `j` `k` `l` | Navigate panes |
| `H` `J` `K` `L` | Resize panes |
| `C-l` | Clear screen & scrollback |

### Shell
| Alias | Command |
| :--- | :--- |
| `l` / `ll` | List files (detailed) |
| `g` / `gs` | Git / Git Status |
| `cp` / `mv` | Copy/Move (Interactive) |
| `G` | Global grep (`| grep`) |
| `L` | Global pager (`| less`) |
