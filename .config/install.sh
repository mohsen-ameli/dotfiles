#!/bin/bash

curr_dir=$(dirname "$0")
browser="firefox"
emulator="alacritty"
shell="zsh dash"
editor="code nano vim gedit"
file_explorer="thunar tumbler ffmpegthumbnailer"
image_viewer="loupe swappy"
themes="breeze-icons arc-gtk-theme papirus-icon-theme"
cursor_theme="bibata-cursor-theme-bin"
fonts="noto-fonts ttf-jetbrains-mono-nerd noto-fonts-emoji"
other_fonts="vazirmatn-fonts"
music_player="amberol"
media_player="vlc"
network="networkmanager net-tools"
bluetooth="bluez bluez-utils bluez-obex"
audio="pamixer pavucontrol pulseaudio pipewire wireplumber"
firewall="ufw"
login_manager="ly"
app_launcher="rofi-wayland"
rofi_plugins="rofi-calc-git"

setup_pacman
setup_yay
setup_extra_optional
# setup_qtile
setup_vm
setup_latex
setup_zsh
setup_autocpufreq
setup_cursor
setup_shell
setup_firewall
setup_bluetooth
setup_printer
setup_udev

notify "Installation complete! Please reboot your system"

function notify() {
	echo -e "\n-----------------------------------------------"
	echo -e $1
	echo -e "-----------------------------------------------\n"
}

function setup_pacman() {
	notify "Installing pacman packages.\nMake sure multilib and g14 repos in /etc/pacman.conf"
	sudo pacman -Syu
	sudo pacman -S base-devel git $themes $login_manager $shell $file_explorer $image_viewer \
	$media_player $browser $emulator $editor $fonts $bluetooth $audio $firewall $app_launcher \
	asusctl rog-control-center nwg-look hyprland hyprpicker python-pywal swaybg waybar zenity pacman-contrib \
  	btop htop yt-dlp ffmpeg wget eza jq grim slurp cliphist net-tools glmark2 brightnessctl ntfs-3g powertop socat inotify-tools
}

function setup_yay() {
	notify "Installing yay"
	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si
	cd ..

	notify "Installing AUR packages"
	yay -S $music_player $cursor_theme $rofi_plugins $other_fonts swaync hyprlock hypridle vesktop\
	trizen bluetuith auto-cpufreq xdg-desktop-portal-hyprland-git python-pulsectl-asyncio
}

function setup_extra_optional() {
  notify "Installing extra packages that are fun"
  yay -S fastfetch bat tldr cowsay pipes.sh unimatrix lolcat cava
}

function setup_vm() {
  notify "Installing QEMU and Virt Manager"
  sudo pacman -S qemu virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat libguestfs swtpm
  echo """
  unix_sock_group = \"libvirt\"
  unix_sock_ro_perms = \"0777\"
  unix_sock_rw_perms = \"0770\"
  """ >> sudo tee /etc/libvirt/libvirtd.conf
}

function setup_qtile() {
  notify "Installing qtile and XORG"
	sudo pacman -S qtile xorg maim xclip
}

function setup_latex() {
  sudo pacman -S texlive-doc texlive-latexrecommended texlive-latexextra texlive-latex texlive-basic texlive-binary
}

function setup_zsh() {
	notify "Confirguring ZSH and oh-my-zsh"
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
	chsh -s $(which zsh)
	cp $HOME/dotfiles/.zshrc $HOME
}

function setup_autocpufreq() {
	notify "Enabling auto-cpufreq for better battery"
	sudo auto-cpufreq --install
}

function setup_cursor() {
	notify "Setting cursor theme"
	mkdir $HOME/.icons
	tar -xf Bibata-Modern-Ice.tar.xz
	mv Bibata-Modern-Ice $HOME/.icons
}

function setup_shell() {
	notify "Installng starship (Shell prompt)"
	curl -sS https://starship.rs/install.sh | sh
}

function setup_firewall() {
	notify "Setting up firewall"
	sudo ufw enable
	sudo systemctl enable ufw
}

function setup_bluetooth() {
	notify "Final touches"
	cp -r $HOME/dotfiles/* $HOME/.config/
	sudo systemctl start bluetooth
}

function setup_samba() {
	notify "Confirguring samba"
	sudo pacman -S samba avahi
	sudo systemctl enable --now smb
	sudo systemctl enable --now avahi-daemon
}

function setup_printer() {
  sudo pacman -S cups cups-pdf hplip
  sudo systemctl enable cups
  sudo hp-setup -i
}

function setup_udev() {
	# For power and usb plug/unplug notifications
	echo -e """
	=="change", SUBSYSTEM=="power_supply", ATTR{type}=="Mains", ATTR{online}=="0", ENV{DISPLAY}=":0", ENV{XAUTHORITY}="/home/USERNAME/.Xauthority" RUN+="/usr/bin/su USERNAME -c '/home/USERNAME/.local/bin/battery-charging discharging'"
	ACTION=="change", SUBSYSTEM=="power_supply", ATTR{type}=="Mains", ATTR{online}=="1", ENV{DISPLAY}=":0", ENV{XAUTHORITY}="/home/USERNAME/.Xauthority" RUN+="/usr/bin/su USERNAME -c '/home/USERNAME/.local/bin/battery-charging charging'"
	""" > /etc/udev/rules.d/power.rules

	echo -e """
	ACTION=="add",SUBSYSTEM=="usb",ENV{DISPLAY}=":0", ENV{XAUTHORITY}="/home/USERNAME/.Xauthority" RUN+="/usr/bin/su USERNAME -c '/home/USERNAME/.local/bin/usb-notify 1 %E{DEVNAME}'"
	ACTION=="remove",SUBSYSTEM=="usb",ENV{DISPLAY}=":0", ENV{XAUTHORITY}="/home/USERNAME/.Xauthority" RUN+="/usr/bin/su USERNAME -c '/home/USERNAME/.local/bin/usb-notify 0 %E{DEVNAME}'"
	""" > /etc/udev/rules.d/usb.rules
}
