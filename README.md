Have to run these to get wireless mouse to work.
sudo echo N> /sys/module/drm_kms_helper/parameters/poll
sudo echo "options drm_kms_helper poll=N">/etc/modprobe.d/local.conf

To add themes to SDDM login manager, add theme name to the themes parameter
in /usr/lib/sddm/sddm.conf.d/default.conf (e.g tokyo-night-sddm)

Run this command to get gparted to work properly on wayland:
xhost +SI:localuser:root

Nvidia drivers on wayland: https://comfy.guide/client/nvidia/

Screen sharing on hyprland:
https://gist.github.com/brunoanc/2dea6ddf6974ba4e5d26c3139ffb7580

If an app is blury, add this line to the "exec" option of the app
found in either /usr/share/applications or /usr/share/local/applications
--enable-features=UseOzonePlatform --ozone-platform=wayland

If clock is messed up, run the following to enable network based time:
sudo timedatectl set-ntp 1

If starting apps with sudo, use
xhost | DISPLAY=:0 sudo command

wifi icons
https://www.figma.com/file/eJgx1YTG2WdQ41B1fZ2wd8/Wifi?type=design&node-id=0%3A1&mode=design&t=Rfg5ME7eZDOHPh7k-1

Good icons
https://icons8.com/icon/86864/audio

Cursor theme from KDE Store
Bibata-Modern-Ice https://store.kde.org/p/1197198

nice rices from hyprland's discord:
https://discord.com/channels/961691461554950145/1230259386535120926

Dotfiles inspired from:
https://github.com/JaKooLit/Ja_HyprLanD-dots

nvim stuff:
control + h|l   --> go between editor and file manager
control + b     --> toggle file manager
control + j     --> open terminal
tab             --> switch between tabs

TODO:
DONE: fix firefox crashing with hardware accelaration turned on
    + switched to brave
DONE: fix vscode python syntax highliting not working
    + installed the "syntax highlighter" extension
fix hypridle issues
    clicking twice to bring up hyprlock
    firefox videos playing, after a while, activates hypridle
    waybar doesn't restart
fix thunar not opening terminal with proper emulator

