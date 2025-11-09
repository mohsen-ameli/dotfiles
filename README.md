## Screenshot

![Image](.config/desktop.png)

## TODO
Laggy when selecting .desktop files on desktop: https://bugs.kde.org/show_bug.cgi?id=493376

## Dotfiles inspired from:

https://github.com/JaKooLit/Ja_HyprLanD-dots

https://github.com/linkfrg/dotfiles

https://discord.com/channels/961691461554950145/1230259386535120926

## Github

To add ssh support for ease of use to login and use github, first do the following.
`ssh-keygen -t ed25519 -C "your_email@example.com"`
This will generate an id_rsa and id_rsa.pub files in the ~/.ssh folder.
Then run these two commands:
`eval "$(ssh-agent -s)"`
`ssh-add ~/.ssh/whatever-you-named-id_rsa`
Then copy the public `~/.ssh/id_rsa.pub` and open a browser and go to github.com > settings > ssh and gpg keys > new ssh key and paste the
public id rsa in there.
Now you can clone and use any repos you have.

NOTE: when cloning, use the ssh option when you press on "Code".
NOTE: If you have multiple ssh keys, make a "config" file (just name it config in ~/.ssh), and put the following per account

```
# Personal
Host github.com
HostName github.com
PreferredAuthentications publickey
IdentityFile ~/.ssh/id_rsa_personal
```

### Remote origin url

To view the origin url of a git directory run:
`git remote -v`

To change the origin url run:
`git remote set-url origin new-url`

## Secure Boot

If dual booting, make sure to have windows's Bitlock password.
Then go to bios and remove secure boot keys (Put the secure boot into setup mode)

Install sbctl.
`sudo pacman -S sbctl`

Then run:

```shell
sudo grub-install --target=x86_64-efi --efi-directory=<path-to-efi> --bootloader-id=GRUB --modules="tpm" --disable-shim-lock # path to efi for me is /boot/efi
sudo sbctl status
sudo sbctl create-keys
sudo sbctl enroll-keys -m
sudo sbctl sign -s -o /usr/lib/systemd/boot/efi/systemd-bootx64.efi.signed /usr/lib/systemd/boot/efi/systemd-bootx64.efi
sudo sbctl sign -s <path-to-kernel> # path to kernel for me was /boot/vmlinuz-linux-lts
sudo sbctl sign -s <path-to-boot-manager> # path to boot manager for me was /boot/efi/EFI/GRUB/grubx64.efi
sudo bootctl install
```

Restart and you will get a new GRUB boot entry when you boot up. Select that as your main way to boot up.

Run this and make sure it says "setup mode disabled" and "secure boot enabled" and everything is green:

```shell
sudo sbctl verify
```

## Xorg

Article for configuring HiDPI displays on high-end laptops.
https://wiki.archlinux.org/title/HiDPI

Add the following to /etc/X11/xorg.conf.d/30-touchpad.conf for natural scrolling

```
Section "InputClass"
    Identifier "touchpad"
    Driver "libinput"
    MatchIsTouchpad "on"
    Option "Tapping" "on"
    Option "NaturalScrolling" "true"
EndSection
```

## Default apps

Set in `~/.local/bin/apply-settings`

```
xdg-settings set default-web-browser brave-browser.desktop
xdg-mime default $file_explorer.desktop inode/directory
xdg-mime default org.gnome.Loupe.desktop image/png
xdg-mime default org.gnome.Loupe.desktop image/jpg
xdg-mime default org.gnome.Loupe.desktop image/jpeg
sudo ln -s /usr/bin/$emulator /usr/bin/xdg-terminal-exec
gsettings set org.gnome.desktop.default-applications.terminal exec $terminal
```

## Wireguard
On server use the pivpn tool to setup wireguard:
`curl -L https://install.pivpn.io | bash`

For every client you need to add a user by running the following on the server:
`pivpn -a`

Then their profile can be shared either via QR-code or by accessing it in `~/configs/something.conf`

On a client then, either scan the QR-code or share the config file and have them imported.

### Linux Client
IMPORTANT: I don't know why but put the raw ip address of the server in the config file, not the domain name.
For some reason I had my duckdns domain and it didn't work. 

On a linux client you can install wireguid from `https://github.com/UnnoTed/wireguird`.

For a more command line approach, install `wireguard-tools` if on arch.
Then put the config file in `/etc/wireguard/something.conf`
To connect run:
`wg-quick up <name-of-vpn>`

and to disconnect run:
`wg-quick down <name-of-vpn>`

You could also just keep the original .conf file handy and run:
`wg-quick up /path/to/file.conf`

## General Notes

To check which apps are running on XWayland, run `xlsclients` or `xeyes`

To force an app to use wayland, add this line to the "exec" option of the app
found in either `/usr/share/applications` or `/usr/share/local/applications`:\
`--enable-features=UseOzonePlatform --ozone-platform=wayland`

If the system clock is messed up, run the following to enable network based time
`sudo timedatectl set-ntp 1`

Run apps as sudo on hyprland\
`xhost si:localuser:root`\
`xhost | DISPLAY=:0 sudo command`

Use `kitten themes` to change kitty themes

Use `sudo systemctl poweroff --when="+60min"` to schedule shutdown in X minutes

### WiFi Connectivity

Connect to WiFi automatically with nmcli
`nmcli connection modify SSID connection.autoconnect yes`

Connecting to eduroam:
go to https://cat.eduroam.org/
select the university/college you go to and download the executable python script.
run it, and try to connect now (I had success with nmtui).

If the WiFi is disconnecting randomly, I turned off powersave by adding the following to `/etc/NetworkManager/NetworkManager.conf`

```
[connection]
wifi.powersave = 2
```

Also see: https://unix.stackexchange.com/questions/269661/how-to-turn-off-wireless-power-management-permanently

### Pacman

If having issues with updating packages with pacman, or if you're getting keyring/"unkown trust" issues,
do the following
`sudo pacman-key --init`
`sudo pacman-key --populate`
`sudo pacman -S archlinux-keyring`

If there's a dependancy issue with 2 conflicting packages,
you could either add the packages involved to the "IgnorePkg=" list in `/etc/pacman.conf`.
Or you could try installing both conflicting packages with `sudo pacman -S pkg1 pkg2`.
Or you could downgrade (not a very good option).
Or perhaps wait for the arch team to resolve the issu.

If you want to update mirrorlist, either run the script at `.local/bin/manage-pacman --update-mirrorlist`
or use `rate-mirrors` to get the fastest mirrors.

### Cleaning system (Arch)

Run `pacman-mange --clear-cache` inside `~/.local/bin/`.
Run `gdu / -i /media,/run/timeshift` to get file sizes.
`/opt` usually has external programs, maybe check that out.
`~/.cache` might have some things to clean up.
`~/.local` is where all the steam games are, so check that out.

### Gnome

Good extensions:

- systray: AppIndicator and KStatus NotifierItem Support
- Dash to Dock
- Desktop Icons NG (DING)
- Weather O'Clock

Run the following to enable experimental fractional scaling:
`gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"`

### Cool Things

Use `fbgrab <image>.png` to take a picture of the tty

Use `mpv <video or image or url>` to view videos or images (this works on the tty as well).
Can use `timg` if tty is iffy.

Use `yt-dlp <url>` to download any video online (including YouTube).

Use `curl -F'file=@FILE.EXT' https://0x0.st` to upload any file temporarily online.

Koi for automatic dark/white theme switching
https://github.com/baduhai/Koi

Use `zbar image.jpg` for QR-code decode

Use `gdu / -i /media,/run/timeshift` to get disk space usage #storage.

Use `df -h` to get a general disk space size.

### Screen sharing on hyprland

https://gist.github.com/brunoanc/2dea6ddf6974ba4e5d26c3139ffb7580

### Latex

https://mathjiajia.github.io/vscode-and-latex/

## Wallpaper Engine on Linux

<!-- Go here and download and install it: -->
<!-- `https://github.com/slynobody/SteamOS-wallpaper-engine-kde-plugin` -->

<!-- This is the main github used for this plugin, but installing it from here didn't work for me: -->
Go here and download and install it:
`https://github.com/catsout/wallpaper-engine-kde-plugin`
Then install the wallpaper engine plugin from kde store.

If kde crashes, run `~/.local/bin/recover-from-crash`

## PostgreSQL

If you're having trouble try restarting postgresql, or reininstalling it.
You can also nuke the folders containing postgres (WARNING: this will remove everything!!!).
`sudo rm -rf /var/lib/postgres/`

Switch to the postgres user
`sudo su postgres`
Then make a new user (call it the same as your main user's name)
`createuser --interactive`
Exit

To make a new database:
`createdb <db-name>`
You can also use -h <server>
-p <port>

Connect to it:
`psql -d boomerang`

## fonts and icons

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

## neovim

control + h or control + l -> switch between editor and file manager

control + b -> toggle file manager

control + j -> open terminal

tab -> switch between tabs

## Graphics (Nvidia)

If the drivers are not working, make a file `/etc/modprobe.d/nvidia.conf`
and put the following in it:

```
options nvidia_drm modeset=1 fbdev=1
options nvidia NVreg_PreserveVideoMemoryAllocations=1 NVreg_TemporaryFilePath=/var/tmp
```

and `/etc/modprobe.d/blacklist.conf`

```
blacklist nouveau
options nouveau modeset=0
```

Suspense issues: Run the script at `.local/bin/nvidia-suspense`

Switching between integrated and hybrid in nvidia:
https://www.reddit.com/r/rogflow/comments/ri9mf5/making_dgpu_enablingdisabling_on_linux_work_on/

Nvidia drivers on wayland:
https://comfy.guide/client/nvidia/

Apps (chromuim and electron based usually) openening slowly:
https://wiki.archlinux.org/title/Vulkan#AMDGPU_-_Vulkan_applications_launch_slowly

Installing (older) drivers
https://github.com/Frogging-Family/nvidia-all.git

### GPU Passthrough

Run `lspci -nn` you can also use grep to filter. `lspci -nn | grep NVIDIA`.
Note the values inside brackets [] at the end.
Grab the card's id as well as the video device's id associated with it.
Go to `/etc/modprobe.d/` and make a file `vfio.conf` (or whatever else you'd like)
Paste the following into it:

```
options vfio-pci ids=10de:2520,10de:228e
softdep nvidia pre: vfio-pci
```
Replaces ids with your card's ids.

Add the following to the MODULE line in `/etc/mkinitcpio.conf`

`MODULES=(... vfio_pci vfio vfio_iommu_type1)`
Run `sudo mkinitcpio -P`

To check if you're in vfio mode, run `lspci -k | grep NVIDIA -A3`
And see if the "kernel in use" is set to "vfio-pci"

Next go in virtual manager and open the configuration for the vm. Add hardware and select "PCI Host device".
Then select your graphics card to add it, then finish.

### Looking Glass
https://looking-glass.io/
https://www.reddit.com/r/VFIO/comments/qyju69/nvidia_optimus_muxless_laptop_gpu_passthrough_and/
https://wiki.archlinux.org/title/QEMU/Guest_graphics_acceleration
https://asus-linux.org/guides/vfio-guide/#using-looking-glass-with-a-virtual-display-driver

### Windows VM
After installing windows, install the virtio drivers from here:
`https://github.com/virtio-win/virtio-win-pkg-scripts`

### Games

To better run games on steam, the following settings can be changed located in `(gear icon in any game) > properties > general > launch options`

Generally I use gamescope and gamemoderun to solve common issues:

`gamescope -W 1920 -H 1080 -r 144 -- gamemoderun %command%`

Games with easy anti-cheat
https://www.reddit.com/r/linux_gaming/comments/1cvrvyg/psa_easy_anticheat_eac_failed_to_initialize/

Plants Vs Zombies:
Fix for slow animation during plant select
https://www.protondb.com/app/3590#dYYLZr30F2

Overwatch 2:
Proton 9.0-4
`gamemoderun %command% LD_PRELOAD="" DXVK_HUD=compiler PULSE_LATENCY_MSEC=60`

The Witcher 3:
Experimental
`gamemoderun %command% --launcher-skip`

Marvel Rivals:
Proton GE
`gamemoderun %command% LD_PRELOAD="" force_vk_vendor=-1 -dx12 -ngxdisableota`

Limbo (Controls don't work because of screen being 144hz):
`gamescope -W 1920 -H 1080 -r 60 -- gamemoderun %command%`

Red dead redemption 2
Just works with no tinkering
This link is for best graphics. I chose level 2 for ~60fps
https://docs.google.com/spreadsheets/d/11rvsM0p9aWZb2_QwQToYvrOjPXR7BJes2586uo4Dxuw/edit?gid=402472305#gid=402472305

Baldur's Gate 3
`prime-run %command%`
Proton GE
Use directX option. vulkan doesn't work.

## udev rules

This is to have notifications when the battery hits a certain percent, to tell you to plug the power.

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

## Unix Password Manager

Install pass

`sudo pacman -S pass pass-otp`

### Setup for firefox

`sudo pacman -S passff-host`

`curl -sSL https://codeberg.org/PassFF/passff-host/releases/download/latest/install_host_app.sh | bash -s -- librewolf`

### Setup for chrome

Download extention: https://chromewebstore.google.com/detail/chrome-pass-zx2c4/oblajhnjmknenodebpekmkliopipoolo

Github page for the host python package: https://github.com/hsanson/chrome-pass

`pipx install chrome-pass==1.0.1`

`chrome_pass install`

### Export GPG keys

Run this to first see a list of keys
`gpg --list-keys`
Then find the one that you need (usually the email you used to make the keys)
Then copy the line under pub.
Eeport public key.
`gpg --export -a KEY_HERE > subkey.pub`
Export private key
`gpg --export-secret-subkeys -a KEY_HERE > subkey`

## Tor Browser

To connect to a specific country, you must specify it in the "ExitNodes" like this:

```
EntryNodes {ca}
ExitNodes {it},{de}
StrictNodes 1
```

Add this to "torrc" file, in windows it is located in the default tor folder
and in linux it is in /etc/tor/torrc-defaults

1 means it is forced

0 means it can also use other nodes, if they one specified does not work.

In windows go to internet options > connections > LAN settings > Advanced and make sure "Use the same proxy server ..."
is checked off, then delete everything and add this to socks (last option):
socks: localhost port: 9050

## Get current country and city based on IP
`curl http://ip-api.com/json\?fields\=country,city`

## Colours

Nord

```
--nord0: #2e3440;
--nord1: #3b4252;
--nord2: #434c5e;
--nord3: #4c566a;
--nord4: #d8dee9;
--nord5: #e5e9f0;
--nord6: #eceff4;
--nord7: #8fbcbb;
--nord8: #88c0d0;
--nord9: #81a1c1;
--nord10: #5e81ac;
--nord11: #bf616a;
--nord12: #d08770;
--nord13: #ebcb8b;
--nord14: #a3be8c;
--nord15: #b48ead;
```

Nord modified by me

```
$nord0: #2e3440;
$nord1: #3b4252;
$nord2: #434c5e;
$nord3: #4c566a;
$nord4: #d8dee9;
$nord5: #e5e9f0;
$nord6: #eceff4;
$nord7: #8fbcbb;
$nord8: #88c0d0;
$nord9: #81a1c1;
$nord10: #5e81ac;
$nord11: #bf616a;
$nord12: #d08770;
$nord13: #ebcb8b;
$nord14: #a3be8c;
$nord15: #b48ead;
```

One dark

```
[colors]
# special
foreground      = #abb2bf
foreground_bold = #abb2bf
# cursor          = #111111
background      = rgba(16, 16, 16, 0.9)
# black
color0  = #282c34
color8  = #5c6370
# red
color1  = #e06c75
color9  = #be5046
# green
color2  = #98c379
color10 = #7a9f60
# yellow
color3  = #e5c07b
color11 = #d19a66
# blue
color4  = #61afef
color12 = #3b84c0
# magenta
color5  = #c678dd
color13 = #9a52af
# cyan
color6  = #56b6c2
color14 = #3c909b
# white
color7  = #abb2bf
color15 = #828997
```
