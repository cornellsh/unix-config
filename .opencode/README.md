# OpenCode

This directory has OpenCode configuration files for `~/.config/opencode`.

## Files

- `opencode.json` - Main configuration
- `themes/cornell.sh.json` - Pastel theme for OLED displays

## Install

Run the script:
```bash
./install.sh
```

It installs OpenCode config and theme.

## Theme: cornell.sh

A pastel theme for OLED screens:

- Background: Black (#000000)
- Text: Dimmed white (#e0e0e0)
- Accent colors at 90% brightness
- Matches Starship prompt colors

## Manual install

Copy the files directly:

```bash
# Install theme
cp .opencode/themes/cornell.sh.json ~/.config/opencode/themes/cornell.sh.json

# Install config
mv ~/.config/opencode/opencode.json ~/.config/opencode/opencode.json.backup
cp opencode.json ~/.config/opencode/opencode.json
```
