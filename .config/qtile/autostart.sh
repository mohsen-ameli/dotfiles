#!/bin/bash

$HOME/.local/bin/wallpaper --random
polybar &
$HOME/.local/bin/apply-themes
dunst &
picom &
nm-applet &
blueman-applet &
asusctl profile --profile-set Quiet
asusctl --chg-limit 80
$HOME/.local/bin/battery-alert &
sudo $HOME/.local/bin/manage-cpu powersave &
