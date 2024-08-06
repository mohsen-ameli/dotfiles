## Screenshot

![Image](.config/desktop.png)
![Image](.config/desktop2.png)

# TODO

- Thunar doesn't open terminal with proper emulator
- Finish configuring qtile

## Dotfiles inspired from:

https://github.com/JaKooLit/Ja_HyprLanD-dots

https://github.com/linkfrg/dotfiles

https://discord.com/channels/961691461554950145/1230259386535120926

## Secure Boot

If dual booting, make sure to have windows's Bitlock password.
Then go to bios and remove secure boot keys (aka put into setup mode)
Then do the following:

```shell
sudo pacman -S sbctl
sudo sbctl status # Make sure you are in setup mode
sudo sbctl create-keys
sudo sbctl enroll-keys -m
sudo sbctl sign -s -o /usr/lib/systemd/boot/efi/systemd-bootx64.efi.signed /usr/lib/systemd/boot/efi/systemd-bootx64.efi
sudo sbctl sign -s <path-to-kernel> # path to kernel for me was /boot/vmlinuz-linux-lts
sudo sbctl sign -s <path-to-boot-manager> # path to boot manager for me was /boot/efi/EFI/GRUB/grubx64.EFI
sudo sbctl verify # make sure it's all green
```

## Natural scrolling and tapping for Xorg

Add the following to /etc/X11/xorg.conf.d/30-touchpad.conf

```
Section "InputClass"
    Identifier "touchpad"
    Driver "libinput"
    MatchIsTouchpad "on"
    Option "Tapping" "on"
    Option "NaturalScrolling" "true"
EndSection
```

## Default browser

`xdg-settings set default-web-browser brave-browser.desktop`

Start samba/smb service (also remember to turn off ufw)\
`sudo ufw disable`\
`sudo systemctl start smb`

## Screen sharing on hyprland

https://gist.github.com/brunoanc/2dea6ddf6974ba4e5d26c3139ffb7580

## latex

https://mathjiajia.github.io/vscode-and-latex/

## General Notes

To force an app to use wayland, add this line to the "exec" option of the app
found in either `/usr/share/applications` or `/usr/share/local/applications`:\
`--enable-features=UseOzonePlatform --ozone-platform=wayland`

If clock is messed up, run the following to enable network based time
`sudo timedatectl set-ntp 1`

Run apps as sudo on hyprland\
`xhost si:localuser:root`\
`xhost | DISPLAY=:0 sudo command`

# fonts and icons

Downloads fonts into either /usr/share/fonts or .local/share/fonts
use sudo fc-cache -fv to install all fonts
use fc-list to list the installed fonts
fc-list : family style
edit .config/fontconfig/fonts.conf to use different fonts:
https://www.baeldung.com/linux/configure-multilingual-fonts

wifi icons:
https://www.figma.com/file/eJgx1YTG2WdQ41B1fZ2wd8/Wifi?type=design&node-id=0%3A1&mode=design&t=Rfg5ME7eZDOHPh7k-1
https://www.iconfinder.com/search?q=wifi&iconset=phosphor-bold-vol-4

volume icons:
https://www.iconfinder.com/search?q=volume&family=ionicons-fill

Good icons:
https://icons8.com/icon/86864/audio

Cursor theme from KDE Store
Bibata-Modern-Ice https://store.kde.org/p/1197198

## GRUB

Download the aesthetic file and use grub-customizer to load it
https://www.gnome-look.org/p/2142488

Add windows 11 to grub
https://askubuntu.com/questions/1425637/how-can-i-add-windows-11-to-grub-menu

## nvim stuff

control + h|l --> go between editor and file manager
control + b --> toggle file manager
control + j --> open terminal
tab --> switch between tabs

## Graphics/nvidia

Switching between integrated and hybrid in nvidia:
https://www.reddit.com/r/rogflow/comments/ri9mf5/making_dgpu_enablingdisabling_on_linux_work_on/

Nvidia drivers on wayland:
https://comfy.guide/client/nvidia/

Apps (chromuim and electron based usually) openening slowly:
https://wiki.archlinux.org/title/Vulkan#AMDGPU_-_Vulkan_applications_launch_slowly

## Games

Plants Vs Zombies
https://www.protondb.com/app/3590#dYYLZr30F2

Games with easy anti-cheat
https://www.reddit.com/r/linux_gaming/comments/1cvrvyg/psa_easy_anticheat_eac_failed_to_initialize/

## udev rules

Go in /etc/udev/rules.d and create two files. (replace USERNAME with your username). This will make sure to give notifications whenever a device is plugged or unplugged in (as well as charging/discharging).

power.rules:

```properties
ACTION=="change", SUBSYSTEM=="power_supply", ATTR{type}=="Mains", ATTR{online}=="0", ENV{DISPLAY}=":0", ENV{XAUTHORITY}="/home/USERNAME/.Xauthority" RUN+="/usr/bin/su USERNAME -c '/home/USERNAME/.local/bin/battery-charging discharging'"
ACTION=="change", SUBSYSTEM=="power_supply", ATTR{type}=="Mains", ATTR{online}=="1", ENV{DISPLAY}=":0", ENV{XAUTHORITY}="/home/USERNAME/.Xauthority" RUN+="/usr/bin/su USERNAME -c '/home/USERNAME/.local/bin/battery-charging charging'"
```

usb.rules:

```properties
ACTION=="add",SUBSYSTEM=="usb",ENV{DISPLAY}=":0", ENV{XAUTHORITY}="/home/USERNAME/.Xauthority" RUN+="/usr/bin/su USERNAME -c '/home/USERNAME/.local/bin/usb-notify 1 %E{DEVNAME}'"
ACTION=="remove",SUBSYSTEM=="usb",ENV{DISPLAY}=":0", ENV{XAUTHORITY}="/home/USERNAME/.Xauthority" RUN+="/usr/bin/su USERNAME -c '/home/USERNAME/.local/bin/usb-notify 0 %E{DEVNAME}'"
```
