# Hyprland Dots

Complete Hyprland configuration with themes and supporting tools.

> ⚠️ **Status**: Still in development, there may be some bugs.
> 
> 📋 **Installation**: Still manual, no automated `install.sh` script yet.
>
> 🟨 **Note**: This dotfiles partially uses UWSM (Universal Wayland Session Manager). If you don't use UWSM, you should remove it from pacman/aur packages or nix pkgs, and also remove "uwsm app --" related keybinds and shell scripts.

## Prerequisites

- **NixOS**: nixos-rebuild and flakes (optional)
- **Arch Linux**: pacman and AUR access
- Terminal and text editor

## Installation

### 1. Clone Repository

```bash
git clone https://github.com/despcodr/hyprland-dots.git
cd hyprland-dots
```

### 2. Install Dependencies

Choose according to your operating system:

#### NixOS

**⚠️ WARNING**: Before proceeding, check your existing NixOS configuration. If there are already packages or settings with the same name, be careful not to overwrite your working configuration.

**Add to your NixOS configuration:**

1. Copy `nixos-config-pkgs/sharland.nix` to `/etc/nixos/`
2. Review the file to ensure there are no conflicts with existing configuration
3. Import in `/etc/nixos/configuration.nix`:
   ```nix
   imports = [
     ./hardware-configuration.nix
     ./sharland.nix
   ];
   ```
4. Rebuild and apply configuration:
   ```bash
   sudo nixos-rebuild switch
   ```

**Tips:**
- If you get an error during rebuild, check for duplicate packages or options in other files
- Merge manually if necessary with caution
- Test with `nixos-rebuild dry-activate` first

#### Arch Linux

**Install Pacman Packages:**
```bash
sudo pacman -S $(cat arch-dependency/pacman.txt | tr '\n' ' ')
```

**Install AUR Packages:**
```bash
# Use AUR helper (e.g., yay or paru):
yay -S $(cat arch-dependency/aur.txt | tr '\n' ' ')

# Or view the package list first:
cat arch-dependency/aur.txt
```

**Install Momoisay:**
(For NixOS, already included in `sharland.nix`)
For Arch Linux, install from: https://github.com/Mon4sm/momoisay


### 3. Manual Configuration

**⚠️ BACKUP FIRST:**
```bash
# Backup your old configuration
cp -r ~/.config ~/.config.backup
```

**Copy all configuration:**
```bash
# Copy all dots files to .config
cp -r dots/* ~/.config/
```

**Setup Wallpaper:**
```bash
# Make sure Pictures folder exists
mkdir -p ~/Pictures

# Copy wallpaper to Pictures folder
cp -r wallpapers/* ~/Pictures/
```

Done! Restart Hyprland or log in again to apply the configuration.

## Contributing

Report bugs or suggest features via Issues.

## License

According to the original license of each project.
