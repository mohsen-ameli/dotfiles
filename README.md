Have to run these to get wireless mouse to work.
sudo echo N> /sys/module/drm_kms_helper/parameters/poll
sudo echo "options drm_kms_helper poll=N">/etc/modprobe.d/local.conf

Secure Boot:
If dual booting, make sure to have windows's Bitlock password.
Then go to bios and remove secure boot keys (aka put into setup mode)
Then do the following:
sudo pacman -S sbctl
sudo sbctl status - Make sure you are in setup mode
sudo sbctl create-keys
sudo sbctl enroll-keys -m
sudo sbctl sign -s -o /usr/lib/systemd/boot/efi/systemd-bootx64.efi.signed /usr/lib/systemd/boot/efi/systemd-bootx64.efi
sudo sbctl sign -s <path-to-kernel> - path to kernel for me was: /boot/vmlinuz-linux-lts
sudo sbctl sign -s <path-to-boot-manager> - path to boot manager for me was: /boot/efi/EFI/GRUB/grubx64.EFI
sudo sbctl verify - make sure it's all green

Natural scrolling and tapping for Xorg.
Add the following to /etc/X11/xorg.conf.d/30-touchpad.conf
Section "InputClass"
Identifier "touchpad"
Driver "libinput"
MatchIsTouchpad "on"
Option "Tapping" "on"
Option "NaturalScrolling" "true"
EndSection

Set default browser:
xdg-settings set default-web-browser brave-browser.desktop

start samba/smb service (also remember to turn off ufw)
sudo systemctl start smb

To add themes to SDDM login manager, add theme name to the themes parameter
in /usr/lib/sddm/sddm.conf.d/default.conf (e.g tokyo-night-sddm)

Run this command to get gparted to work properly on wayland:
xhost +SI:localuser:root

Nvidia drivers on wayland: https://comfy.guide/client/nvidia/

Screen sharing on hyprland:
https://gist.github.com/brunoanc/2dea6ddf6974ba4e5d26c3139ffb7580

latex:
https://mathjiajia.github.io/vscode-and-latex/

To force an app to use wayland, add this line to the "exec" option of the app
found in either /usr/share/applications or /usr/share/local/applications
--enable-features=UseOzonePlatform --ozone-platform=wayland

If clock is messed up, run the following to enable network based time:
sudo timedatectl set-ntp 1

If starting apps with sudo, use
xhost | DISPLAY=:0 sudo command

fonts
Downloads fonts into either /usr/share/fonts or .local/share/fonts
use sudo fc-cache -fv to install all fonts
use fc-list to list the installed fonts
fc-list : family style
edit .config/fontconfig/fonts.conf to use different fonts
https://www.baeldung.com/linux/configure-multilingual-fonts

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
control + h|l --> go between editor and file manager
control + b --> toggle file manager
control + j --> open terminal
tab --> switch between tabs

TODO:
DONE: fix firefox crashing with hardware accelaration turned on + switched to brave
DONE: fix vscode python syntax highliting not working + removed env = GBM_BACKEND,nvidia-drm from hyprland config + installed the "syntax highlighter" extension + firefox videos playing, after a while, activates hypridle
clicking twice to bring up hyprlock (hypridle)
waybar doesn't restart when logging in after locking device
thunar not opening terminal with proper emulator
DONE: arch freezing randomly + switched to linux-lts kernel
configure qtile
when opening apps (mainly from waybar), they open in different workplaces
