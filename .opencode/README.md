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

## MCP Servers

OpenCode is configured with Model Context Protocol (MCP) server support for enhanced functionality.

### Context7

Purpose: AI-powered documentation query and code analysis.

**Setup**:

1. Get an API key from https://context7.com
2. Add to your `.zshrc`:

```bash
export CONTEXT7_API_KEY="your-api-key-here"
```

3. Reload shell: `source ~/.zshrc`

**Configuration**: Automatically configured via `opencode.json` with remote server connection to `https://mcp.context7.com/mcp`.

## Manual install

Copy the files directly:

```bash
# Install theme
cp .opencode/themes/cornell.sh.json ~/.config/opencode/themes/cornell.sh.json

# Install config
mv ~/.config/opencode/opencode.json ~/.config/opencode/opencode.json.backup
cp opencode.json ~/.config/opencode/opencode.json
```
