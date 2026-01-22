# Config

Minimalist configuration for **Zsh**, **Tmux**, and **Starship**.

![Preview](https://i.imgur.com/A2KgzQe.png)

## Install

```bash
git clone https://github.com/cornellsh/config.git ~/.config/cfg
cd ~/.config/cfg && chmod +x install.sh && ./install.sh
```

## Dependencies
- `zsh`, `tmux`, `starship`, `git`, `curl`
- *Optional:* `eza`, `bat`, `zoxide`, `fzf`, `ripgrep`

## Keybinds

### Tmux (`Ctrl+a` Prefix)
| Key | Action |
| :--- | :--- |
| `r` | Reload config |
| `v` / `s` | Split Vertical / Horizontal |
| `h/j/k/l` | Navigate panes |
| `Arrows` | Resize panes (repeatable) |
| `c` | New window |
| `z` | Zoom pane |
| `x` / `X` | Kill pane / window |
| `[` | Copy mode (Vim keys) |

### Zsh Aliases
| Alias | Command |
| :--- | :--- |
| `l` | `ls -lah` (or `eza`) |
| `..` | `cd ..` |
| `gs` | `git status` |
| `ga` | `git add` |
| `gc` | `git commit -m` |
| `gp` | `git push` |
| `gl` | `git pull` |
| `t` | `tmux` |
| `ta` | `tmux attach -t` |

### Zsh Shortcuts
| Key | Action |
| :--- | :--- |
| `Ctrl + →` | Forward word |
| `Ctrl + ←` | Backward word |
| `Home` / `End` | Start / End of line |