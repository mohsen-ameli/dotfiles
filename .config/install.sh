#!/bin/bash

curr_dir=$(dirname "$0")
browser="firefox"
emulator="alacritty"
shell="zsh"
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
setup_latex
setup_zsh
setup_autocpufreq
setup_cursor
setup_shell
setup_firewall
setup_bluetooth
setup_printer

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
	asusctl rog-control-center nwg-look hyprland python-pywal swaybg waybar zenity pacman-contrib \
  btop htop yt-dlp ffmpeg wget neofetch eza jq grim slurp cliphist net-tools glmark2 brightnessctl \
  cowsay ntfs-3g powertop
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

