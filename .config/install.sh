#!/bin/bash

curr_dir=$(dirname "$0")
emulator="gnome-console"
shell="zsh"
editor="code nano vim gedit"
file_explorer="thunar lc tumbler ffmpegthumbnailer"
image_viewer="qimgv"
themes="breeze-icons arc-gtk-theme papirus-icon-theme bibata-cursor-theme-bin"
fonts="noto-fonts noto-fonts-emoji ttf-jetbrains-mono-nerd vazirmatn-fonts"
media_player="mpv vlc amberol rhythmbox"
network="networkmanager net-tools"
bluetooth="bluez bluez-utils bluez-obex"
audio="pamixer pipewire wireplumber pipewire-audio pipewire-alsa pipewire-pulse pavucontrol"
rofi="rofi rofi-calc"

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
	$pkg_manager --noconfirm -Syyu base-devel git $network $themes $shell $file_explorer $image_viewer \
	  $media_player $emulator $editor $fonts $bluetooth $audio $app_launcher $rofi \
	  zip dunst htop asusctl rog-control-center nwg-look libva-nvidia-driver hyprland hyprpicker hyprutils hyprwayland-scanner python-pywal eww swww swaybg \
    zenity pacman-contrib ffmpeg jq grim slurp cliphist brightnessctl ntfs-3g socat inotify-tools discord \
    # AUR below
    hyprlock hypridle bluetuith xdg-desktop-portal-hyprland-git python-pulsectl-asyncio python-beautifulsoup4 envycontrol koi localsend

  sudo pacman-key --delete dragonn@op.pl
  sudo pacman-key --recv-keys 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
  sudo pacman-key --finger 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
  sudo pacman-key --lsign-key 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
  sudo pacman-key --finger 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
  wget "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x8b15a6b0e9a3fa35" -O g14.sec
  sudo pacman-key -a g14.sec
  rm g14.sec
  echo """
  [g14]
  Server = https://arch.asus-linux.org
  """ >> sudo tee /etc/pacman.conf
  
  sh -c "$(curl -sS https://raw.githubusercontent.com/Vendicated/VencordInstaller/main/install.sh)"
}

setup_amdgpu() {
  confirm "Do you have an AMD GPU?" || return
  notify ":: Setting up AMD GPU"
  $pkg_manager -S mesa lib32-mesa xf86-video-amdgpu vulkan-radeon libva-mesa-driver lib32-libva-mesa-driver
}

setup_extra_optional() {
  confirm "Do you want to install packages that are usefull?" || return
  notify ":: Installing extra packages"
  $pkg_manager -S eza btop yt-dlp fastfetch neofetch bat tldr cowsay pipes.sh unimatrix \
    lolcat cava usbimager speedtest wget glmark2 xdg-ninja termdown
}

setup_pentest() {
  confirm "Do you want to install pentesting applications?" || return
  $pkg_manager -S nmap wireshark aircrack-ng burpsuite postman-bin
}

setup_vm() {
  confirm "Do you want to install QEMU and Virt Manager?" || return
  notify ":: Installing QEMU and Virt Manager"
  $pkg_manager -S qemu virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat libguestfs swtpm
  echo -e """unix_sock_group = \"libvirt\"
unix_sock_ro_perms = \"0777\"
unix_sock_rw_perms = \"0770\"""" >> sudo tee /etc/libvirt/libvirtd.conf
}

setup_office() {
  confirm "Do you want to install onlyoffice?" || return
  notify ":: Installing onlyoffice"
  $pkg_manager -S onlyoffice-bin
}

setup_xorg() {
  confirm "Do you want to install i3 Window Manger?" || return
  notify ":: Installing Xorg and i3"
	$pkg_manager xorg xclip mutter-x11-scaling i3-wm i3-swallow-git betterlockscreen \
    lxappearance clipmenu maim xcolor autotiling xidlehook
  echo """[Desktop Entry]
Encoding=UTF-8
Name=i3
Comment=i3 window manager
Exec=i3
Icon=i3
Type=XSession""" > /usr/share/xsessions/i3.desktop
  ln -s .xinitrc .xsession
  ln -s .xinitrc .xprofile
  sudo systemctl enable betterlockscreen@$USER --now
}

setup_latex() {
  confirm "Do you want to install latex?" || return
  notify ":: Setting up latex"
  $pkg_manager texlive-doc texlive-latexrecommended texlive-latexextra texlive-latex texlive-basic \
    texlive-binary texlive-binextra texlive-mathscience texlive-fontsrecommended 
}

setup_zsh() {
  confirm "Do you want to install ZSH and oh-my-zsh?" || return
	notify ":: Configuring ZSH and oh-my-zsh"
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
	chsh -s $(which zsh)
	cp $HOME/dotfiles/.zshrc $HOME
  echo -e """prefix=${XDG_DATA_HOME}/npm
cache=${XDG_CACHE_HOME}/npm
init-module=${XDG_CONFIG_HOME}/npm/config/npm-init.js""" | sudo tee /etc/npmrc
  
  mkdir $HOME/.local/share/python

  echo """def is_vanilla() -> bool:
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
    setup_history()""" > $HOME/.local/share/python/pythonrc
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

  sudo ufw limit 22/tcp
  sudo ufw allow 80/tcp
  sudo ufw allow 443/tcp
  sudo ufw deny incoming
  sudo ufw default deny incoming
  sudo ufw default allow outgoing
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

setup_browser() {
  notify ":: Setting up the browser"
  printf "Which browser do you want to install: (1) Brave (2) Librewolf"
  read choice
  if [ $choice -eq 1 ]; then
    $pkg_manager brave-bin 
  elif [ $choice -eq 2 ]; then
    $pkg_manager librewolf
  fi
}

setup_gaming() {
  confirm "Do you want to install steam and some gaming components?" || return
  notify ":: Setting up gaming environment"
  $pkg_manager steam lutris gamescope gamemoderun heroic-games-launcher-bin
}

setup_other() {
  default_browser="brave-browser.desktop"
  default_terminal="alacritty"
  default_explorer="thunar.desktop"
  default_imageviewer="qimgv.desktop"

  xdg-settings set default-web-browser $default_browser
  sudo ln -s /usr/bin/$default_terminal /usr/bin/xdg-terminal-exec
  gsettings set org.gnome.desktop.default-applications.terminal exec $default_terminal
  xdg-mime default $default_explorer inode/directory
  xdg-mime default $default_imageviewer image/png
  xdg-mime default $default_imageviewer image/jpg
  xdg-mime default $default_imageviewer image/jpeg

  # Enabling bluetooth
  sudo systemctl enable --now bluetooth

	# For power and usb plug/unplug notifications
	echo -e """
ACTION==\"change\", SUBSYSTEM==\"power_supply\", ATTR{type}==\"Mains\", ATTR{online}==\"0\", ENV{DISPLAY}=\":0\", ENV{XAUTHORITY}=\"/home/USERNAME/.Xauthority\" RUN+=\"/usr/bin/su USERNAME -c '/home/USERNAME/.local/bin/battery-charging discharging'\"
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
setup_office
setup_zsh
setup_cursor
setup_shell
setup_firewall
setup_pentest
setup_vm
setup_xorg
setup_samba
setup_printer
setup_browser
setup_extra_optional
setup_other

notify ":: Installation complete! Please reboot your system"
