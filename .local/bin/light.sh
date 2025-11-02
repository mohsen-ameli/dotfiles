#!/bin/bash

echo "light" | sudo tee /etc/theme
# refresh nvim
nvim --headless +PlugClean +PlugInstall +qall

# plasma-apply-desktoptheme breeze-light
# plasma-apply-colorscheme BreezeLight
# gsettings set org.gnome.desktop.interface gtk-theme 'Arc-Lighter'
# /usr/lib/plasma-changeicons Papirus-Light
