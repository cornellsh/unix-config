# OpenCode Integration

This repository includes OpenCode AI assistant integration with a custom theme that matches the vibrant pastel aesthetic of the unix-config setup.

## Theme: cornell.sh

The `cornell.sh` theme is optimized for OLED displays and matches the color scheme used throughout the unix-config:

- **Background**: Pure black (#000000) - OLED optimal (pixels OFF)
- **Text**: Dimmed white (#e0e0e0) - Reduces OLED burn-in risk
- **Accent Colors**: Vibrant pastels at 90% brightness
  - Pink (#e6638a) - Active elements, borders
  - Purple (#ab84e0) - Git branches, host info
  - Cyan (#75b5e6) - Username, directory, primary
  - Green (#3bab5b) - Success indicators
  - Red (#e64d4d) - Errors, git status
  - Yellow (#e6d26f) - Warnings, timing

## Configuration

The `opencode.json` file in the repository root configures OpenCode with:

- Custom commands for testing shell scripts and config files
- Shell script linting with shellcheck
- Zsh and tmux syntax validation
- Shfmt for shell script formatting
- Bash language server for IntelliSense

## Usage

When working in this repository, OpenCode will automatically use the `cornell.sh` theme and the repository-specific configuration.

To apply the theme globally:
```bash
opencode config set theme cornell.sh
```

## Theme Location

The theme is available in two locations:
1. Project-specific: `.opencode/themes/cornell.sh.json` (this repository)
2. Global: `~/.config/opencode/themes/cornell.sh.json`

The project-specific theme takes precedence when working in this directory.
