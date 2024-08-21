#!/bin/bash

curr_dir=$(dirname "$0")
browser="brave-bin"
emulator="alacritty"
shell="zsh dash"
editor="code nano vim gedit"
file_explorer="thunar lc tumbler ffmpegthumbnailer"
image_viewer="loupe swappy"
themes="breeze-icons arc-gtk-theme papirus-icon-theme bibata-cursor-theme-bin"
fonts="noto-fonts noto-fonts-emoji ttf-jetbrains-mono-nerd vazirmatn-fonts"
media_player="mpv vlc amberol rhythmbox"
network="networkmanager net-tools"
bluetooth="bluez bluez-utils bluez-obex"
audio="pamixer pipewire wireplumber pipewire-audio pipewire-alsa pipewire-pulse"
login_manager="ly"
rofi="rofi-wayland rofi-calc-git"
extra="usbimager"

notify() {
	echo -e "\n-----------------------------------------------"
	echo -e "$1"
	echo -e "-----------------------------------------------\n"
}

confirm() {
  printf "%b" "\n:: $1 [Y/n]: "
  read choice
  if [ "$choice" = "y" ] || [ "$choice" = "Y" ] || [ "$choice" = "" ]; then
    return 0 # success
  fi
  return 1 # exit
}

setup_aur() {
  cd
  printf ":: Choose an AUR helper (1) yay (2) paru: "
  read choice
  if [ $choice -eq 1 ]; then
    pkg_manager="yay"
    if which yay &> /dev/null; then
      echo ":: yay already installed"
    else
      echo ":: $pkg_manager selected"
      git clone https://aur.archlinux.org/yay.git
      cd yay
      makepkg -si
      cd ..
    fi
  elif [ $choice -eq 2 ]; then
    pkg_manager="paru"
    if which paru &> /dev/null; then
      echo ":: paru already installed"
    else
      echo ":: $pkg_manager selected"
      git clone https://aur.archlinux.org/paru.git
      cd paru
      makepkg -si
      cd ..
    fi
  else
    echo "Invalid choice"
    exit 1
  fi
}

setup_packages() {
  confirm "Do you want to install the main packages?" || return
	notify ":: Installing packages."
	$pkg_manager --noconfirm -Syyu base-devel git $network $themes $login_manager $shell $file_explorer $image_viewer \
	  $media_player $browser $emulator $editor $fonts $bluetooth $audio $app_launcher $extra \
	  dunst htop asusctl rog-control-center nwg-look libva-nvidia-driver hyprland hyprpicker python-pywal eww swww swaybg \
    zenity pacman-contrib ffmpeg wget jq grim slurp cliphist glmark2 brightnessctl ntfs-3g socat inotify-tools xdg-ninja \
    pass pass-otp browserpass browserpass-chromium \
    # AUR below
    $rofi hyprlock hypridle vesktop bluetuith xdg-desktop-portal-hyprland-git python-pulsectl-asyncio
}

setup_amdgpu() {
  confirm "Do you have an AMD GPU?" || return
  notify ":: Setting up AMD GPU"
  $pkg_manager -S mesa lib32-mesa xf86-video-amdgpu vulkan-radeon libva-mesa-driver lib32-libva-mesa-driver
}

setup_extra_optional() {
  confirm "Do you want to install packages that are usefull?" || return
  notify ":: Installing extra packages"
  $pkg_manager -S eza btop yt-dlp fastfetch neofetch bat tldr cowsay pipes.sh unimatrix lolcat cava
}

setup_pentest() {
  confirm "Do you want to install pentesting applications?" || return
  $pkg_manager -S nmap wireshark aircrack-ng burpsuite
}

setup_vm() {
  confirm "Do you want to install QEMU and Virt Manager?" || return
  notify ":: Installing QEMU and Virt Manager"
  $pkg_manager -S qemu virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat libguestfs swtpm
  echo -e """
  unix_sock_group = \"libvirt\"
  unix_sock_ro_perms = \"0777\"
  unix_sock_rw_perms = \"0770\"
  """ >> sudo tee /etc/libvirt/libvirtd.conf
}

setup_qtile() {
  confirm "Do you want to install XORG and some utilities for it?" || return
  notify ":: Installing XORG and utilities"
	$pkg_manager xorg xclip mutter-x11-scaling lxappearance clipcat scrot
  echo """[Desktop Entry]
          Encoding=UTF-8
          Name=dwm
          Comment=Dynamic window manager
          Exec=dwm
          Icon=dwm
          Type=XSession""" > /usr/share/xsessions/dwm.desktop
  ln -s .xinitrc .xsession
  ln -s .xinitrc .xprofile
}

setup_latex() {
  confirm "Do you want to install latex?" || return
  notify ":: Setting up latex"
  $pkg_manager texlive-doc texlive-latexrecommended texlive-latexextra texlive-latex texlive-basic texlive-binary
}

setup_zsh() {
  confirm "Do you want to install ZSH and oh-my-zsh?" || return
	notify ":: Configuring ZSH and oh-my-zsh"
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
	chsh -s $(which zsh)
	cp $HOME/dotfiles/.zshrc $HOME
  echo -e """
    prefix=${XDG_DATA_HOME}/npm
    cache=${XDG_CACHE_HOME}/npm
    init-module=${XDG_CONFIG_HOME}/npm/config/npm-init.js
  """ | sudo tee /etc/npmrc
  
  mkdir $HOME/.local/share/python

  echo """
def is_vanilla() -> bool:
    import sys
    return not hasattr(__builtins__, '__IPYTHON__') and 'bpython' not in sys.argv[0]


def setup_history():
    import os
    import atexit
    import readline
    from pathlib import Path

    if state_home := os.environ.get('XDG_STATE_HOME'):
        state_home = Path(state_home)
    else:
        state_home = Path.home() / '.local' / 'state'

    history: Path = state_home / 'python_history'

    readline.read_history_file(str(history))
    atexit.register(readline.write_history_file, str(history))


if is_vanilla():
    setup_history()
  """ > $HOME/.local/share/python/pythonrc
}

setup_cursor() {
  confirm "Do you want to install a cursor theme?" || return
	notify ":: Setting cursor theme"
	mkdir $HOME/.local/share/icons
	tar -xf Bibata-Modern-Ice.tar.xz
	mv Bibata-Modern-Ice $HOME/.local/share/icons
}

setup_shell() {
  confirm "Do you want to install the starship shell prompt?" || return
	notify ":: Installng starship"
	curl -sS https://starship.rs/install.sh | sh
}

setup_firewall() {
  confirm "Do you want to enable the UFW firewall?" || return
	notify ":: Setting up UFW firewall"
  $pkg_manager ufw
	sudo ufw enable
	sudo systemctl enable --now ufw
}

setup_dotfiles() {
  confirm "Do you want to copy the dotfiles?" || return
	notify ":: Copying over dotfiles"
  mv .config config-old
  mv .local local-old
	cp -r $HOME/dotfiles/.config $HOME/.config
  cp -r $HOME/dotfiles/.local $HOME/.local
}

setup_samba() {
  confirm "Do you want to enable SAMBA?" || return
	notify ":: Confirguring SAMBA"
	$pkg_manager samba avahi
	sudo systemctl enable --now smb
	sudo systemctl enable --now avahi-daemon
}

setup_printer() {
  confirm "Do you want to enable printing?" || return
  notify ":: Setting up printing"
  $pkg_manager cups cups-pdf hplip
  sudo systemctl enable --now cups
  sudo hp-setup -i
}

setup_other() {
  # Enabling bluetooth
  sudo systemctl enable --now bluetooth

  # Setting default terminal emulator
  sudo ln -s /usr/bin/$emulator /usr/bin/xdg-terminal-exec
  gsettings set org.gnome.desktop.default-applications.terminal exec $terminal

  # Setting default file explorer
  xdg-settings set default-web-browser brave-browser.desktop
  xdg-mime default $file_explorer.desktop inode/directory
  xdg-mime default org.gnome.Loupe.desktop image/png
  xdg-mime default org.gnome.Loupe.desktop image/jpg
  xdg-mime default org.gnome.Loupe.desktop image/jpeg

	# For power and usb plug/unplug notifications
	echo -e """
	==\"change\", SUBSYSTEM==\"power_supply\", ATTR{type}==\"Mains\", ATTR{online}==\"0\", ENV{DISPLAY}=\":0\", ENV{XAUTHORITY}=\"/home/USERNAME/.Xauthority\" RUN+=\"/usr/bin/su USERNAME -c '/home/USERNAME/.local/bin/battery-charging discharging'\"
	ACTION==\"change\", SUBSYSTEM==\"power_supply\", ATTR{type}==\"Mains\", ATTR{online}==\"1\", ENV{DISPLAY}=\":0\", ENV{XAUTHORITY}=\"/home/USERNAME/.Xauthority\" RUN+=\"/usr/bin/su USERNAME -c '/home/USERNAME/.local/bin/battery-charging charging'\"
	""" > sudo tee /etc/udev/rules.d/power.rules
	echo -e """
	ACTION==\"add\",SUBSYSTEM==\"usb\",ENV{DISPLAY}=\":0\", ENV{XAUTHORITY}=\"/home/USERNAME/.Xauthority\" RUN+=\"/usr/bin/su USERNAME -c '/home/USERNAME/.local/bin/usb-notify 1 %E{DEVNAME}'\"
	ACTION==\"remove\",SUBSYSTEM==\"usb\",ENV{DISPLAY}=\":0\", ENV{XAUTHORITY}=\"/home/USERNAME/.Xauthority\" RUN+=\"/usr/bin/su USERNAME -c '/home/USERNAME/.local/bin/usb-notify 0 %E{DEVNAME}'\"
	""" > sudo tee /etc/udev/rules.d/usb.rules
}

setup_aur
setup_packages
setup_dotfiles
setup_amdgpu
setup_latex
setup_zsh
setup_cursor
setup_shell
setup_firewall
setup_pentest
setup_vm
setup_qtile
setup_samba
setup_printer
setup_extra_optional
setup_other

notify ":: Installation complete! Please reboot your system"
