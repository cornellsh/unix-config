# Theme Configuration
Documentation for the theme setup configured by themes-setup.sh.

## GTK Settings

The script configures these themes via gsettings:

GTK Theme: Mojave-Dark (from AUR package mojave-gtk-theme)
- Set with: gsettings set org.gnome.desktop.interface gtk-theme "Mojave-Dark"

Icon Theme: Papirus-Dark (from official papirus-icon-theme package)
- Set with: gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
- Uses #000000 backgrounds for OLED displays

Cursor Theme: macOS_Tahoe (from AUR package macos-tahoe-cursor)
- Set with: gsettings set org.gnome.desktop.interface cursor-theme "macos-tahoe-cursor"

## SDDM Login Screen

Theme: where-is-my-sddm-theme (from where-is-my-sddm-theme-git AUR package)
- Configured in /etc/sddm.conf.d/theme.conf:
  [Theme]
  Current=where_is_my_sddm_theme

The script also fixes an issue with niri compositors where keybindings appear on the login screen. It removes CompositorCommand=niri from /etc/sddm.conf.d/niri.conf automatically.

## Optional Tools

nwg-look provides a GUI to change GTK themes, icons, and cursors in Wayland. Install from AUR and run with nwg-look.

## Applying Changes

For GTK themes: restart your session or run nwg-look
For SDDM: restart with sudo systemctl restart sddm or reboot

## Manual Installation

yay -S mojave-gtk-theme papirus-icon-theme macos-tahoe-cursor where-is-my-sddm-theme-git nwg-look

## Troubleshooting

If GTK themes don't apply:
- Verify gsettings is installed: pacman -Qi gsettings-desktop-schemas
- Check the theme exists: ls /usr/share/themes/Mojave-Dark
- Try nwg-look for graphical switching

If SDDM theme doesn't load:
- Check if SDDM is running: systemctl status sddm
- Verify the config: cat /etc/sddm.conf.d/theme.conf
- Check for errors: journalctl -u sddm -b

If niri keybindings appear on the login screen:
- Verify the fix was applied: cat /etc/sddm.conf.d/niri.conf
- It should not contain CompositorCommand=niri
- Remove the line if present and restart SDDM
