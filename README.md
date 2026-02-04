# unix-config

My personal dotfiles for Zsh, Tmux, and Starship.

I built this to make setting up new machines less painful. It's a structured, opinionated setup that just works, with a heavy focus on fixing common WSL2 problems out of the box.

**What's inside:**
*   **WSL2 Fixes:** Automatically patches `systemd-timesyncd` (time drift), and optimizes I/O settings.
    *   *Note:* It installs a default `.wslconfig` limiting VM memory to **8GB**. You should adjust this in `%UserProfile%\.wslconfig` if your machine has different specs.
*   **Starship:** A prompt config that is readable and fast (tuned timeouts for git scanning).
*   **Tmux:** Clean status bar and sensible keybindings.
*   **Scripts:** Install scripts that you can run safely multiple times.

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
